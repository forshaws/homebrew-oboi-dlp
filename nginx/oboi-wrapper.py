#!/usr/bin/env python3
from flask import Flask, request, Response, send_file
import os, subprocess, datetime, mimetypes, urllib.parse, html

env = os.environ.copy()
#env["OBOI_DLP_APIKEY"] = "YOUR_API_KEY_GOES_HERE"
#env["OBOI_DLP_TOPIC"] = "your_topic_name_here"

app = Flask(__name__)

BASE_PATH = "/var/www/html"
OBOI_BINARY = "/home/linuxbrew/.linuxbrew/bin/oboi-dlp"
OBOI_ARGS = ["--mode=output"]

@app.route("/", defaults={"path": ""}, methods=["GET"])
@app.route("/<path:path>", methods=["GET"])
def serve_and_filter(path):
    now = datetime.datetime.now().isoformat()
    client = request.remote_addr or "-"
    print(f"[{now}] {client} {request.method} {request.path}")

	# -----------------------------------------------------------------
    # BAsic directory traversal protection
    full_path = os.path.join(BASE_PATH, path)
    full_path = os.path.realpath(full_path)  # normalize to absolute path
    base_realpath = os.path.realpath(BASE_PATH)
    if not full_path.startswith(base_realpath):
        print(f"[WARN] Directory traversal attempt blocked: {path}")
        return Response("Forbidden\n", status=403, mimetype="text/plain")
    # -----------------------------------------------------------------

    # Handle directories
    if os.path.isdir(full_path):
        # Try to serve index.html or index.htm
        for index_file in ["index.html", "index.htm"]:
            index_path = os.path.join(full_path, index_file)
            if os.path.isfile(index_path):
                full_path = index_path
                break
        else:
            # No index file → generate HTML directory listing
            try:
                files = sorted(os.listdir(full_path))
                listing_html = f"<html><head><title>Index of /{html.escape(path)}</title></head><body>"
                listing_html += f"<h1>Index of /{html.escape(path)}</h1><ul>"
                # Parent directory link if not root
                if path:
                    parent = os.path.dirname(path.rstrip("/"))
                    listing_html += f'<li><a href="/{html.escape(parent)}">..</a></li>'
                for f in files:
                    f_path = os.path.join(path, f)
                    f_url = urllib.parse.quote(f_path)
                    listing_html += f'<li><a href="/{f_url}">{html.escape(f)}</a></li>'
                listing_html += "</ul></body></html>"
                return Response(listing_html, status=200, mimetype="text/html")
            except Exception as e:
                print(f"[ERROR] Cannot list directory {full_path}: {e}")
                return Response("Directory not readable\n", status=403, mimetype="text/plain")

    # Handle files
    if os.path.isfile(full_path):
        try:
            # Read file bytes
            with open(full_path, "rb") as fh:
                body_bytes = fh.read()

            # Call oboi-dlp with the file contents
            proc = subprocess.run(
                [OBOI_BINARY] + OBOI_ARGS,
                input=body_bytes,
                capture_output=True,
                timeout=4,
                env=env
            )
            output = proc.stdout.decode("utf-8", errors="replace").strip()
            print(f"[INFO] Ran oboi-dlp on {path}, rc={proc.returncode}")

            if output == "Access Blocked":
                print(f"[WARN] BLOCKED: {path}")
                return Response("Access Blocked\n", status=403, mimetype="text/plain")

            # Otherwise return original file with correct Content-Type
            guessed_type = mimetypes.guess_type(full_path)[0] or "application/octet-stream"
            print(f"[INFO] Served file: {full_path} as {guessed_type}")
            return Response(body_bytes, status=200, mimetype=guessed_type)

        except Exception as e:
            print(f"[ERROR] Failed processing {full_path}: {e}")
            return Response(f"Error reading file: {e}\n", status=500, mimetype="text/plain")

    # File does not exist
    print(f"[WARN] File not found: {full_path}")
    return Response("File not found\n", status=404, mimetype="text/plain")


if __name__ == "__main__":
    print("[*] OBOI-DLP proxy running at http://127.0.0.1:8081")
    app.run(host="127.0.0.1", port=8081)