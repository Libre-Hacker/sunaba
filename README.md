#  Sunaba

a 3D sandbox game with user-generated map support. Powered by Godot 4.

 [Sunaba is a Japanese word that means Sandbox](https://en.wiktionary.org/wiki/%E7%A0%82%E5%A0%B4#Japanese)

[Discord Server](https://discord.gg/cbKbJtvKPd)

[Lemmy Community](https://lemmy.world/c/sunaba)

![Screenshot](https://github.com/TheSunabaProject/sunaba/blob/main/assets/screenshot.png?raw=true)

## Features

* User-generated map support
* Play in first and third person prespectives
* Quake-style map editing using TrenchBroom

## Status

The game is stil under active development and what you see is not representative of the final product. As such, compatibility may change between versions.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to build the software

* [Godot 4.0 ( Mono Build )](https://github.com/godotengine/godot/releases/tag/4.0.2-stable)

* [.NET SDK 6.0](https://dotnet.microsoft.com/en-us/download/dotnet/6.0)

* [Python 3.10 (Used for build scripts)](https://www.python.org/downloads/release/python-3100/)

* [Inno Setup (Only needed for building the installer for the Windows version)](https://jrsoftware.org/isinfo.php)

### Opening the Project

Inport the project.godot file into the Godot editor

## Running the project

Run the game by pressing F5

## Deployment

To Build the game, use one of the following commands


```pwsh

python ./build.py linux [ADDITIONAL_ARGUMENT] [GODOT_PATH] # Linux

python ./build.py win32 [ADDITIONAL_ARGUMENT] [GODOT_PATH] # Windows 

python ./build.py mac [GODOT_PATH] # MacOS 

```

[GODOT_PATH] is used to specify a path to the Godot executable, if one isn't specified, it will default to the one provided by the system path

Additional arguments

Windows
```

innosetup

```

Linux
```

zip

targz

install

deb

```

## Built With

* [Godot Engine](https://godotengine.org/) - The game engine used
* [TrenchBroom](https://trenchbroom.github.io/) - Level Editor
* [Qodot](https://github.com/QodotPlugin/Qodot) - Used to import .map files

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Authors

* **mintkat** - *Initial work* - [m1ntkat](https://github.com/m1ntkat)

See also the list of [contributors](https://github.com/m1ntkat/sunaba/contributors) who participated in this project.

## License

This project is licensed under the MIT And CC-BY-NC 4.0 Licenses - see the [LICENSE.md (GPL-3.0) ](LICENSE.md) and [assets/LICENSE.md (CC-BY 4.0) ](assets/LICENSE.md) files for details
