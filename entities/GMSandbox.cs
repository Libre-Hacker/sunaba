using Godot;
using System;
using Toonbox.Runtime;

namespace Toonbox.Entities
{
	public partial class GMSandbox : Node
	{
		// Called when the node enters the scene tree for the first time.
		public override void _Ready()
		{
            Global global = GetNode<Global>("/root/Global");

			global.gameMode = "Sandbox";
        }
	}
}

/*
extends Node3D


func _ready():
	Global.game_mode = "Sandbox"
*/