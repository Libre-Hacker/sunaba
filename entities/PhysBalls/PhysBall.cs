using Godot;
using System;

public partial class PhysBall : RigidBody3D
{
	public override void _EnterTree()
	{
		SetMultiplayerAuthority(1);
	}

	public override void _Ready()
	{
		Console console = GetNode<Console>("/root/PConsole");
		console.Print("Hello, I'm " + Name);
		console.Print(Multiplayer.GetUniqueId().ToString() + " : Owns " + Name + " : " + IsMultiplayerAuthority().ToString());
	}
}
