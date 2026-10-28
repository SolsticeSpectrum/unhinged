#!/usr/bin/env python3
import os
import socket
import base64
import json

HOST = os.environ.get("WS_HOST", "127.0.0.1")
PORT = int(os.environ.get("WS_PORT", "8082"))

def recv_exact(sock, n):
    buf = b""
    while len(buf) < n:
        chunk = sock.recv(n - len(buf))
        if not chunk:
            return None
        buf += chunk
    return buf

def main():
    s = socket.socket()
    s.connect((HOST, PORT))
    key = base64.b64encode(os.urandom(16)).decode()
    req = (
        "GET / HTTP/1.1\r\n"
        f"Host: {HOST}:{PORT}\r\n"
        "Upgrade: websocket\r\n"
        "Connection: Upgrade\r\n"
        f"Sec-WebSocket-Key: {key}\r\n"
        "Sec-WebSocket-Version: 13\r\n\r\n"
    )
    s.sendall(req.encode())
    resp = s.recv(1024)
    if b"101" not in resp:
        raise SystemExit("handshake failed")
    msg = json.dumps({"type": "ping"}).encode()
    mask = os.urandom(4)
    masked = bytes(b ^ mask[i % 4] for i, b in enumerate(msg))
    frame = bytes([0x81, 0x80 | len(msg)]) + mask + masked
    s.sendall(frame)
    hdr = recv_exact(s, 2)
    if not hdr:
        raise SystemExit("no response")
    length = hdr[1] & 0x7F
    if length == 126:
        length = int.from_bytes(recv_exact(s, 2), "big")
    elif length == 127:
        length = int.from_bytes(recv_exact(s, 8), "big")
    payload = recv_exact(s, length)
    print(payload.decode())
    s.close()

if __name__ == "__main__":
    main()
