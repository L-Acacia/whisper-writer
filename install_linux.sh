#!/bin/bash

cd "$(dirname "$0")"

echo "Cloning the repository..."
git clone https://github.com/L-Acacia/whisper-writer.git

cd whisper-writer/

if ! python3.11 --version 2>&1 | grep -q "Python 3.11"; then
    echo "Python 3.11 not found. Please install Python 3.11."
    exit 1
fi

echo "Python 3.11 is installed. Continuing..."

echo "Creating a virtual environment..."
python3.11 -m venv venv

echo "Activating the virtual environment..."
source venv/bin/activate

echo "Installing requirements..."
pip3 install -r requirements.txt

echo "Checking if CUDA compatible GPU is available..."
cuda_version=$(nvcc --version | awk -F' ' '/release/{print $5}' | tr -d '.,' | tr '\n' ' ')
if [ -n "$cuda_version" ]; then
    echo "Installing PyTorch for CUDA $cuda_version..."
    pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu$cuda_version/
else
    echo "CUDA incompatible => CPU only installation"
fi

echo "Installation Complete."

deactivate