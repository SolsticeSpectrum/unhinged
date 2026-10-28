"""A fake SMTP server for trith/lib/tests/smtp.trh.

smtp_server.py PORT CONNECTIONS TRANSCRIPT [CERT KEY]: serve CONNECTIONS clients one
after the other, then exit, writing what each client sent to TRANSCRIPT (the Date header
is redacted). The file is created once the port is listening, so a runner can wait for
it. Given a certificate and key, the server offers STARTTLS. User "mailer" with
password "hunter2" may log in; RCPT TO an address at nowhere.invalid is refused.
"""
import base64
import socket
import ssl
import sys

port, count, path = int(sys.argv[1]), int(sys.argv[2]), sys.argv[3]
tls = None
if len(sys.argv) > 5:
    tls = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
    tls.load_cert_chain(sys.argv[4], sys.argv[5])
srv = socket.socket()
srv.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
srv.bind(("127.0.0.1", port))
srv.listen(4)
out = open(path, "w")
out.flush()
for n in range(count):
    conn, _ = srv.accept()
    f = conn.makefile("rb")
    say = lambda s: conn.sendall(s.encode() + b"\r\n")
    secure = False
    out.write("--- connection %d\n" % (n + 1))
    say("220 fake.invalid ESMTP")
    data = False
    while True:
        raw = f.readline()
        if not raw:
            break
        line = raw.decode().rstrip("\r\n")
        if data:
            if line == ".":
                data = False
                say("250 2.0.0 queued")
            elif not line.startswith("Date: "):
                out.write("| " + line + "\n")
            continue
        if line.startswith("EHLO "):
            out.write("EHLO (host)\n")
            offer = b"250-STARTTLS\r\n" if tls and not secure else b""
            conn.sendall(b"250-fake.invalid\r\n" + offer + b"250-AUTH PLAIN\r\n250 8BITMIME\r\n")
            continue
        out.write(line + "\n")
        if line == "STARTTLS" and tls and not secure:
            say("220 2.0.0 go ahead")
            conn = tls.wrap_socket(conn, server_side=True)
            f = conn.makefile("rb")
            secure = True
            out.write("(TLS %s)\n" % conn.version())
            continue
        if line.startswith("AUTH PLAIN "):
            creds = base64.b64decode(line[11:]).split(b"\0")
            ok = creds[1:] == [b"mailer", b"hunter2"]
            say("235 2.7.0 ok" if ok else "535 5.7.8 authentication failed")
        elif line.startswith("RCPT TO:") and "nowhere.invalid" in line:
            say("550 5.1.1 no such user")
        elif line == "DATA":
            data = True
            say("354 end with a dot")
        elif line == "QUIT":
            say("221 2.0.0 bye")
            break
        else:
            say("250 2.0.0 ok")
    conn.close()
out.close()
