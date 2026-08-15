#!/bin/bash

set -e

echo "======================================"
echo "        NRB PANEL INSTALLER"
echo "======================================"

cd /root

echo "[1/8] Installing dependencies..."
apt update
apt install -y git unzip python3 python3-pip python3-venv

echo "[2/8] Removing old NRB..."
rm -rf /root/NRB

echo "[3/8] Cloning NRB..."
git clone https://github.com/notroboy67-htp/NRB.git /root/NRB

cd /root/NRB

echo "[4/8] Extracting NRB.zip..."

if [ ! -f "NRB.zip" ]; then
    echo "ERROR: NRB.zip not found!"
    exit 1
fi

mkdir -p /root/NRB_EXTRACTED
rm -rf /root/NRB_EXTRACTED/*
unzip -o NRB.zip -d /root/NRB_EXTRACTED

echo "[5/8] Finding project files..."

REQ=$(find /root/NRB_EXTRACTED -type f -name "requirements.txt" -print -quit)

if [ -z "$REQ" ]; then
    echo "ERROR: requirements.txt was not found inside NRB.zip"
    find /root/NRB_EXTRACTED -maxdepth 4 -type f | sort
    exit 1
fi

PROJECT_DIR=$(dirname "$REQ")

echo "Project directory:"
echo "$PROJECT_DIR"

echo "[6/8] Creating virtual environment..."

cd "$PROJECT_DIR"

python3 -m venv venv

source venv/bin/activate

echo "[7/8] Installing requirements..."

python3 -m pip install --upgrade pip
python3 -m pip install -r requirements.txt

echo "[8/8] Starting NRB..."

START=$(find "$PROJECT_DIR" -maxdepth 2 -type f -name "start.sh" -print -quit)

if [ -z "$START" ]; then
    echo "ERROR: start.sh was not found!"
    find /root/NRB_EXTRACTED -type f -name "start.sh"
    exit 1
fi

chmod +x "$START"

cd "$(dirname "$START")"

echo "======================================"
echo "          STARTING NRB PANEL"
echo "======================================"

./start.sh
