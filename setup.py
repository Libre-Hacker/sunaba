import xml.etree.ElementTree as ET
import os
from urllib import request
import zipfile
import shutil

godot_version = "4.0.2-stable"

godot_zip_url = "https://github.com/godotengine/godot/releases/download/" + godot_version + "/Godot_v" + godot_version + "_mono_linux_x86_64.zip"

export_templates_url = "https://github.com/godotengine/godot/releases/download/" + godot_version + "/Godot_v" + godot_version + "_mono_export_templates.tpz"

temp_folder = "./tmp"

def mkdir(dirname):
    if not os.path.exists(dirname):
        os.makedirs(dirname)

mkdir(temp_folder)

godot_zip_location = temp_folder + "/godot.zip"

export_templates = temp_folder + "/templates.tpz"


print("Downloading file: " + godot_zip_url)
request.urlretrieve(godot_zip_url, godot_zip_location)

print("Downloading file: " + export_templates_url)
request.urlretrieve(export_templates_url, export_templates)

with zipfile.ZipFile(godot_zip_location, mode="r") as zip:
    print("Extracting File: " + godot_zip_location)
    zip.extractall(temp_folder)

godot_bin_path = temp_folder + "/godot"

if os.path.exists(godot_bin_path):
    print("Deleting existing directory: " + godot_bin_path)
    shutil.rmtree(godot_bin_path)

print("Renaming '" + temp_folder + "/Godot_v" + godot_version + "_mono_linux_x86_64' to '" + godot_bin_path + "'")
os.rename(temp_folder + "/Godot_v" + godot_version + "_mono_linux_x86_64", godot_bin_path)

godot_bin = godot_bin_path + "/godot"

print("Renaming '" + temp_folder + "/Godot_v" + godot_version + "_mono_linux.x86_64' to '" + godot_bin + "'")
os.rename(godot_bin_path + "/Godot_v" + godot_version + "_mono_linux.x86_64", godot_bin)

chmod = os.system("chmod +x " + godot_bin)

if chmod != 0:
    exit(1)

print("Installing export templates")