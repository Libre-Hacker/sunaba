import os
import sys

godot_path = "godot"

if len(sys.argv) == 2:
    godot_path = sys.argv[1]

build_linux = os.system("python ./build.py linux " + godot_path)

if build_linux == 0:
    build_win32 = os.system("python ./build.py win32 " + godot_path)
    
    if build_win32 == 1:
        exit()
    else:
        exit(1)
else:
    exit(1)