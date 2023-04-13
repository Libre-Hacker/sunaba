import xml.etree.ElementTree as ET

def get_version():
    tree = ET.parse("./Sunaba.csproj")
    root = tree.getroot()
    
    return root[0][3].text

print(get_version())

# value - AssemblyVersion

exit()