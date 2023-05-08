import platform
import os

print(platform.system())

if platform.system() == "Linux":
    os.system("python ./build.py linux zip")
elif platform.system() == "Darwin":
    os.system("python ./build.py mac")
elif platform.system() == "Windows":
    os.system("python ./build.py win32")

