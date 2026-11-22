// Minimal raw 26.3 client: handshake -> login -> configuration -> play, stays connected, logs packet ids / disconnect reasons.
const net = require('net'), zlib = require('zlib')
const PROTO = 777
const vi = n => { const b = []; do { let t = n & 0x7f; n >>>= 7; if (n) t |= 0x80; b.push(t) } while (n); return Buffer.from(b) }
const str = s => { const b = Buffer.from(s, 'utf8'); return Buffer.concat([vi(b.length), b]) }
const readVi = (buf, o) => { let r = 0, s = 0, b; do { if (o >= buf.length) return null; b = buf[o++]; r |= (b & 0x7f) << s; s += 7 } while (b & 0x80); return [r, o] }
let state = 'login', compression = -1, acc = Buffer.alloc(0), t0 = Date.now(), playPackets = 0, joined = false
const log = (...a) => console.log(((Date.now() - t0) / 1000).toFixed(1) + 's', ...a)
const sock = net.connect(25565, '127.0.0.1')
const send = (id, payload = Buffer.alloc(0)) => {
  let body = Buffer.concat([vi(id), payload])
  if (compression >= 0) body = Buffer.concat([vi(0), body])
  sock.write(Buffer.concat([vi(body.length), body]))
}
sock.on('connect', () => {
  const hs = Buffer.concat([vi(PROTO), str('127.0.0.1'), Buffer.from([0x63, 0xdd]), vi(2)])
  let body = Buffer.concat([vi(0), hs]); sock.write(Buffer.concat([vi(body.length), body]))
  const uuid = Buffer.alloc(16, 7)
  send(0x00, Buffer.concat([str('RawBot'), uuid]))
  log('sent handshake+login_start')
})
function handle(id, data) {
  if (state === 'login') {
    if (id === 0x03) { compression = readVi(data, 0)[0]; log('set_compression', compression) }
    else if (id === 0x02) { log('login success'); send(0x03); state = 'config'; log('-> config')
      send(0x00, Buffer.concat([str('en_us'), Buffer.from([8]), vi(0), Buffer.from([1]), Buffer.from([0x7f]), vi(1), Buffer.from([0]), Buffer.from([1]), vi(0)])) }
    else if (id === 0x00) log('LOGIN DISCONNECT', data.toString('utf8').slice(0, 300))
    else log('login packet', id)
  } else if (state === 'config') {
    if (id === 0x03) { log('finish_configuration -> ack'); send(0x03); state = 'play'; log('-> play') }
    else if (id === 0x0f) { log('select_known_packs -> reply (none known)'); send(0x07, vi(0)) }
    else if (id === 0x04) { send(0x04, data); log('config keepalive') }
    else if (id === 0x09) {
      const uuid = data.subarray(0, 16); const [ul, uo] = readVi(data, 16); const url = data.subarray(uo, uo + ul).toString(); log('add_resource_pack url=', url)
      require('http').get(url, r => { let n = 0; r.on('data', c => n += c.length); r.on('end', () => log('PACK DOWNLOAD http', r.statusCode, n, 'bytes')) }).on('error', e => log('pack dl error', e.message))
      send(0x06, Buffer.concat([uuid, vi(3)])); log('pack ACCEPTED')
      setTimeout(() => { send(0x06, Buffer.concat([uuid, vi(0)])); log('pack SUCCESSFULLY_LOADED') }, 1500) }
    else if (id === 0x05) { send(0x05, data); log('config ping -> pong') }
    else if (id === 0x02) log('CONFIG DISCONNECT', data.toString('utf8').slice(0, 400))
    else if (id === 0x07) log('registry_data', data.length)
    else log('config packet', id, data.length, data.subarray(0,40).toString('hex'), JSON.stringify(data.subarray(0,40).toString('latin1').replace(/[^ -~]/g,'.')))
  } else {
    playPackets++
    if (playPackets <= 3 || id === 0x1d || id === 0x1c) log('play packet', id, data.length)
    if (!joined && playPackets === 1) { joined = true; log('FIRST PLAY PACKET (login) received') }
  }
}
sock.on('data', d => {
  acc = Buffer.concat([acc, d])
  while (true) {
    const l = readVi(acc, 0); if (!l) break
    const [len, o] = l; if (acc.length < o + len) break
    let frame = acc.subarray(o, o + len); acc = acc.subarray(o + len)
    if (compression >= 0) { const [dl, o2] = readVi(frame, 0); frame = dl === 0 ? frame.subarray(o2) : zlib.inflateSync(frame.subarray(o2)) }
    const [id, o3] = readVi(frame, 0)
    try { handle(id, frame.subarray(o3)) } catch (e) { log('handler error', e.message) }
  }
})
sock.on('close', () => { log('SOCKET CLOSED; play packets received:', playPackets); process.exit(playPackets > 0 ? 0 : 3) })
sock.on('error', e => log('socket error', e.message))
setTimeout(() => { log('STILL CONNECTED after 27s; play packets:', playPackets); sock.destroy() }, 27000)
