using Godot;
using System;

namespace OpenSBX.Runtime
{
	public partial class Build : Node
	{
		public bool multiplayerEnabled = false;
		public String versionNumber = "0.4.0dev";
		public String buildDate = "March 2, 2023";

	}
}


// var use_native_fd : bool
// var online_play_enabled : bool
// var version_number : String
// var build_date : String
//
// var flags = preload("res://flags.tres")
//
// func _ready():
// use_native_fd = flags.use_native_fd
//
// online_play_enabled = flags.online_play_enabled
//
//version_number = flags.version_number
//
 //   build_date = flags.build_date