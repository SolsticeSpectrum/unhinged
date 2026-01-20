#!/usr/bin/env python3
import subprocess
import sys

NAME = "uh-mailhog"

def main():
    res = subprocess.run(["docker", "rm", "-f", NAME], check=False, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if res.returncode != 0:
        print(res.stderr.strip())
        sys.exit(res.returncode)
    print("MailHog stopped")

if __name__ == "__main__":
    main()
