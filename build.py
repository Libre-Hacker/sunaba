import sys
import os
import shutil
import xml.etree.ElementTree as ET
import zipfile
import time
import tarfile
import stat

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

if (target != "win32") and (target != "mac") and (target != "linux") and (target != "linux32"):
    unspecified("Build target not valid")

version = get_version()

#print(r"""\
#              *******              
#        *******************.       
#     *******////////**********.    
#   *******/(((((/**///**********.  
#  *******#####/*&@@@@@@@@*/#(***** 
# *******(%#/***/@@@@@@@@@%*#(((****
#*********/@@@@@@@**#///%@**(((///**
#********%@@@@@@@@@(*@@@@@**((////**
#********#@@@@@@@@@//@@@@@@/*//*****
# *********@@@@@@&*#@@@@@@@(********
#  *******//(///#*/@@@@@@@********* 
#   ******///((((###(//**********.  
#     .****////((((/***********     
#         ******************        
#    """)
#
#print("")
#print("------------------------------------------------------------")

#print("")
print("Sunaba")
print("")

print("Version : ", version)

print("Build Target : ", target)

if len(sys.argv) == 4:
    godot_path = sys.argv[3]

    print("Godot binary : ", godot_path)
elif len(sys.argv) == 3:
    godot_path = sys.argv[2]

    print("Godot binary : ", godot_path)
else:
    print("Godot binary : Using binary from path")

print("")

time.sleep(5)

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
elif target == "linux32":
    bin_path = "./bin/linux32/sunaba.x86_32"
    mkdir("./bin")
    mkdir("./bin/linux32")

def export():
	command = godot_path + " --export-release " + '"' + target + '"' + " --headless " + bin_path

	print("Exporting Project")
	print(command)

	export = os.system(command)

	if export == 0:
		print("Godot Export ran successfully")
	else:
		print("Godot Export ran with exit code %d" % export)
		exit(2)

if godot_path == "skip":
    print("Skipping Godot Export")
else:
    export()

print("")

def copy_map_files(bpath):
    print("Copying map files to game directory")

    map_path = "./maps"
    for map in os.scandir(map_path):
        if map.is_file():
            if (".map" in str(map)):
                if not ".import" in str(map):
                    print("Copying map file '", map.path, "' to '", build_path, "'")
                    shutil.copy(map, bpath)
    print("")

def create_vroot(debname):
    print("Creating Virtual Root Folder")
    print("")
    mkdir("./vroot")
    vroot = "./vroot/" + str(debname)
    mkdir(vroot + "/usr")
    vroot_bin_folder = vroot + "/usr/bin"
    mkdir(vroot_bin_folder)

    print("Copying '", bin_path, "' to '", vroot_bin_folder, "'")
    shutil.copy(bin_path, vroot_bin_folder)
    vroot_data_folder = vroot_bin_folder + "/data_Sunaba_x86_64"
    mkdir(vroot_data_folder)
    data_folder = "./bin/linux/data_Sunaba_x86_64"
        
    for file in os.scandir(data_folder):
        print("Copying '", file.path, "' to '", vroot_data_folder, "'")
        shutil.copy(file, vroot_data_folder)

    vroot_share_folder = vroot + "/usr/share"
    mkdir(vroot_share_folder)
    vroot_pixmaps_folder = vroot_share_folder + "/pixmaps"
    mkdir(vroot_pixmaps_folder)
    vroot_desktop_folder = vroot_share_folder + "/desktop"
    mkdir(vroot_desktop_folder)

    desktop_icon = "./assets/sunaba.png"
    print("Copying '", desktop_icon, "' to '", vroot_pixmaps_folder, "'")
    shutil.copy(desktop_icon, vroot_pixmaps_folder)

    desktop_entry = "./sunaba.desktop"
    print("Copying '", desktop_entry, "' to '", vroot_desktop_folder, "'")
    shutil.copy(desktop_entry, vroot_desktop_folder)
                
    print("")
    
    return vroot

if target == "win32":
    mkdir("./bin")
    if len(sys.argv) != 2:
        if sys.argv[2] == "nsis":
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
    
    with zipfile.ZipFile(zipname, mode="a") as zip:
        for map in os.scandir(map_path):
            if map.is_file():
                if (".map" in str(map)):
                    if not ".import" in str(map):
                        print("Adding " + map.name + " to " + zipname)
                        zip.write(map, arcname=map.name)
                            
    
elif target == "linux":
    
    if len(sys.argv) != 2:
        if sys.argv[2] == "zip":
            build_path = "./bin/linux"

            copy_map_files(build_path)

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
        if sys.argv[2] == "targz":
            build_path = "./bin/linux"

            copy_map_files(build_path)

            tarballname = "./bin/Sunaba-" + str(version) + "-Linux.tar.gz"
    
            print("Packing Build into Tarball : " + tarballname)

            tarball = tarfile.open(tarballname, mode="w:gz")
            for f in os.scandir(build_path):
                print("Adding " + f.name + " to " + tarballname)
                tarball.add(f, arcname=f.name)
                if f.is_dir():
                    print("dir")
                    for file in os.scandir(f):
                        fl = f.name + "/" + file.name
                        print("Adding " + fl + " to " + tarballname)
                        fp = os.path.abspath(build_path + "/" + fl)
                        tarball.add(fp)

        if sys.argv[2] == "install":
            
            print("Running sudo make install")
    
            makensis = os.system("sudo make install")

            if makensis == 0:
                print("sudo make install ran successfully")
        if sys.argv[2] == "deb":
            debname = "sunaba-" + str(version) + "-Linux"
            vroot = create_vroot(debname)

            debfolder = vroot + "/DEBIAN"
            mkdir(debfolder)
            shutil.copy("./control", debfolder)
            
            print("Packing Build into Deb : " + debname)

            debfile = os.system("dpkg-deb --build " + vroot)
            shutil.copy(vroot + ".deb", "./bin")
            os.remove(vroot + ".deb")

    if len(sys.argv) > 4:
        if sys.argv[4] == "removedir":
            build_path = "./bin/linux"
            if os.path.exists(build_path):
                shutil.rmtree(build_path)
                print("Removed Linux Directory")


print("")
exit()
