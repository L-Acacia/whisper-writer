@echo off
setlocal enabledelayedexpansion

cd /D "%~dp0"

echo Cloning the repository...
git clone https://github.com/L-Acacia/whisper-writer.git

cd .\whisper-writer\

for /f "delims=" %%a in ('python3.11 --version 2^>^&1 ^| findstr /r "Python 3.11"') do (
    set "version=%%a"
)

if not defined version (
    echo Python 3.11 not found. Please install Python 3.11.
) else (
    echo %version% is installed. Continuing... 
)

echo Creating a virtual environment...
python3.11 -m venv venv

echo Activating the virtual environment...
call venv\Scripts\activate

echo Installing requirements...
pip install -r requirements.txt

echo Checking if CUDA compatible GPU is available...
for /f "tokens=5 delims= " %%i in ('nvcc --version ^| findstr /C:"release"') do (
    set "cuda_version=%%i"
    set "cuda_version=!cuda_version:.=!"
    set "cuda_version=!cuda_version:,=!"
)
if defined cuda_version (
    echo Installing PyTorch for CUDA %cuda_version%...
    pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu%cuda_version%/
) else (
    echo CUDA incompatible => CPU only installation
)

echo Installation Complete.
:end
endlocal