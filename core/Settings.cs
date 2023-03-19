using Godot;
using System;

public partial class Settings : Node
{
    public bool multiplayerEnabled = false;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
	{
        Console console = GetNode<Console>("/root/PConsole");
        console.Register(Name, this);
    }

	
}
