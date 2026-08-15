#!/bin/bash

set -e

cd /root

rm -rf NRB

git clone https://github.com/notroboy67-htp/NRB.git NRB

cd NRB

if [ -f "NRB.zip" ]; then
    unzip -o NRB.zip
fi

python3 -m venv venv

source venv/bin/activate

python3 -m pip install --upgrade pip

python3 -m pip install -r requirements.txt

chmod +x start.sh

./start.sh
