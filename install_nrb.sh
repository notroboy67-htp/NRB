#!/bin/bash

set -e

cd /root

rm -rf NRB

git clone https://github.com/notroboy67-htp/NRB.git NRB

cd /root/NRB

if [ -f "NRB.zip" ]; then
    unzip -o NRB.zip
fi

echo "Searching for requirements.txt..."

REQ=$(find /root/NRB -type f -name "requirements.txt" | head -n 1)

if [ -z "$REQ" ]; then
    echo "ERROR: requirements.txt was not found."
    find /root/NRB -maxdepth 3 -type f | sort
    exit 1
fi

PROJECT_DIR=$(dirname "$REQ")

echo "Project directory: $PROJECT_DIR"

cd "$PROJECT_DIR"

python3 -m venv venv

source venv/bin/activate

python3 -m pip install --upgrade pip

python3 -m pip install -r requirements.txt

if [ -f "start.sh" ]; then
    chmod +x start.sh
    ./start.sh
else
    echo "ERROR: start.sh was not found in $PROJECT_DIR"
    find /root/NRB -type f -name "start.sh"
    exit 1
fi
