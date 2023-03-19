using Godot;
using System;
using Sunaba.Runtime;

namespace Sunaba.Entities
{
	public partial class PlayerStart : Node3D
	{
		// Called when the node enters the scene tree for the first time.
		public override void _Ready()
		{
			Global global = GetNode<Global>("/root/Global");
			
			Vector3 spawnpoint  = GlobalPosition + new Vector3 (0, 1, 0);
			
			global.spawnpoint = spawnpoint;
			GD.Print(spawnpoint);

			global.AddSpawnpoint (spawnpoint);
		}
	}
}