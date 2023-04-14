import sys
import os
import shutil
import xml.etree.ElementTree as ET
import zipfile

def get_version():
    tree = ET.parse("./Sunaba.csproj")
    root = tree.getroot()
    
    return root[0][3].text

def unspecified(reason):
    print(str(reason))
    print("Please specify one of the following build targets")
    print("")
    print("win32")
    print("mac")
    print("linux")
    print("")
    exit(1)

print("")

if len(sys.argv) == 1:
    unspecified("Build target not specified.")

target = sys.argv[1]
godot_path = "godot"

if (target != "win32") and (target != "mac") and (target != "linux"):
    unspecified("Build target not valid")

version = get_version()

print("Sunaba")
print("")

print("Version : ", version)

print("Build Target : ", target)

if len(sys.argv) == 3:
    godot_path = sys.argv[2]

    print("Godot binary : ", godot_path)
else:
    print("Godot binary : Using binary from path")

print("")

bin_path = ""

def mkdir(dirname):
    if not os.path.exists(dirname):
        os.makedirs(dirname)

if target == "win32":
    bin_path = "./binWin32/Sunaba.exe"
    mkdir("./binWin32")
elif target == "mac":
    bin_path = "./bin/Sunaba-" + str(version) + "-Mac.zip"
    mkdir("./bin")
elif target == "linux":
    bin_path = "./bin/linux/sunaba.x86_64"
    mkdir("./bin")
    mkdir("./bin/linux")

command = godot_path + " --export-release " + '"' + target + '"' + " --headless " + bin_path

print("Exporting Project")

export = os.system(command)

if export == 0:
    print("Godot Export ran successfully")
else:
    print("Godot Export ran with exit code %d" % export)
    exit(2)

print("")

if target == "win32":
    mkdir("./bin")
    
    print("Generating Windows Installer")
    makensis = os.system("makensis installer.nsi")

    if makensis == 0:
        print("makensis ran successfully")

        nsisout = "./bin/output.exe"
        if os.path.exists(nsisout):
            newname = "./bin/Sunaba-" + str(version) + "-Win32.exe"
            output = os.path.abspath(nsisout)
            destination = os.path.abspath(str(newname))
            os.replace(output, destination)
    else:
        print("makensis ran with exit code %d" % makensis)
    
elif target == "mac":
    outputzip = "./bin/macoutput.zip"
    zipname = "./bin/Sunaba-" + str(version) + "-Mac.zip"
    
    print("Copying map files to game directory")

    map_path = "./maps"
    build_path = "./bin/linux"

    for map in os.scandir(map_path):
        if map.is_file():
            if (".map" in str(map)):
                if not ".import" in str(map):
                    #print("Copying map file '", map.path, "' to '", build_path, "'")
                    #shutil.copy(map, build_path)
                    pass
    
elif target == "linux":
    print("Copying map files to game directory")

    map_path = "./maps"
    build_path = "./bin/linux"

    for map in os.scandir(map_path):
        if map.is_file():
            if (".map" in str(map)):
                if not ".import" in str(map):
                    print("Copying map file '", map.path, "' to '", build_path, "'")
                    shutil.copy(map, build_path)
    
    print("")

    zipname = "./bin/Sunaba-" + str(version) + "-Linux.zip"
    
    print("Packing Build into Zip : " + zipname)

    with zipfile.ZipFile(zipname, mode="w") as zip:
        for f in os.scandir(build_path):
            print("Adding " + f.name + " to " + zipname)
            zip.write(f, arcname=f.name)
            if f.is_dir():
                for file in os.scandir(f):
                    fl = f.name + "/" + file.name
                    print("Adding " + fl + " to " + zipname)
                    fp = os.path.abspath(build_path + "/" + fl)
                    zip.write(fp, arcname=fl)
    

print("")
exit()
