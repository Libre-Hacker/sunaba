#  Sunaba

a 3D sandbox game with user-generated map support. Powered by Godot 4.

 [Sunaba is a Japanese word that means Sandbox](https://en.wiktionary.org/wiki/%E7%A0%82%E5%A0%B4#Japanese)

[Discord Server](https://discord.gg/McfgW6Kx)

## Features

* User-generated map support
* Play in first and third person prespectives
* Quake-style map editing using TrenchBroom

## Status

The game is stil under active development and what you see is not representative of the final product. As such, compatibility may change between versions.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install the software and how to install them

* Godot 4.0 ( Mono Build )

* .NET SDK 6.0

* Python 3.10 (Used for build scripts)

* NSIS 3.x

* Git LFS

### Opening the Project

Inport the project.godot file into the Godot editor

## Running the project

Run the game by pressing F5

## Deployment

To Build the game, use one of the following commands


```pwsh

python ./build.py linux [GODOT_PATH] # Linux

python ./build.py win32 [GODOT_PATH] # Windows

```

[GODOT_PATH] is used to specify a path to the Godot executable, if one isn't specified, it will default to the one provided by the system path

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

This project is licensed under the BSD-3 License - see the [LICENSE.md](LICENSE.md) file for details
