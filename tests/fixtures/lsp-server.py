"""Minimal stdio LSP server with a delayed initialization response."""

import json
import sys
import time

reader = sys.stdin.buffer
writer = sys.stdout.buffer
while True:
    headers = {}
    while True:
        line = reader.readline()
        if not line:
            sys.exit(0)
        if line == b"\r\n":
            break
        key, value = line.decode().split(":", 1)
        headers[key.lower()] = value.strip()
    message = json.loads(reader.read(int(headers["content-length"])))
    method = message.get("method")
    if method == "exit":
        break
    if method == "initialize":
        time.sleep(float(sys.argv[1]))
    if "id" in message:
        result = (
            {"capabilities": {"textDocumentSync": 1}}
            if method == "initialize"
            else None
        )
        body = json.dumps(
            {"jsonrpc": "2.0", "id": message["id"], "result": result}
        ).encode()
        writer.write(f"Content-Length: {len(body)}\r\n\r\n".encode() + body)
        writer.flush()
