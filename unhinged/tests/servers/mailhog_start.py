#!/usr/bin/env python3
import subprocess
import sys

NAME = "uh-mailhog"

def run(cmd):
    return subprocess.run(cmd, check=False, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

def main():
    res = run(["docker", "ps", "-a", "--format", "{{.Names}}"])
    if res.returncode != 0:
        print("docker not available")
        sys.exit(1)
    names = res.stdout.splitlines()
    if NAME in names:
        run(["docker", "rm", "-f", NAME])
    pull = run(["docker", "pull", "mailhog/mailhog"])
    if pull.returncode != 0:
        print(pull.stderr.strip())
        sys.exit(pull.returncode)
    up = run(["docker", "run", "-d", "--name", NAME, "-p", "1025:1025", "-p", "8025:8025", "mailhog/mailhog"])
    if up.returncode != 0:
        print(up.stderr.strip())
        sys.exit(up.returncode)
    print("MailHog started on smtp://127.0.0.1:1025 and http://127.0.0.1:8025")

if __name__ == "__main__":
    main()
