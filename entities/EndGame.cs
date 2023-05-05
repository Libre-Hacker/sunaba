using Godot;
using System;
using Sunaba.Actors;
using Sunaba.Core;

namespace Sunaba.Entities;

public partial class EndGame : Area3D
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		BodyEntered += OnEnter;
	}

	void OnEnter(Node3D node3D)
	{
		if (node3D is Player)
		{
			Console console = GetNode<Console>("/root/PConsole");
			console.Print("Player collided with EndGame");
		}
	}
}
