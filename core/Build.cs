using Godot;
using System;

public partial class Build : Node
{
	public bool multiplayerEnabled = false;
	public String versionNumber = "0.3.0";
	public String buildDate = "Febuary 26, 2023";

	private Resource flags = null;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		flags = GD.Load<Resource>("res://flags.tres");
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