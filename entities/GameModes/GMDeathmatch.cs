using Godot;
using System;
using Sunaba.Core;

namespace Sunaba.Entities
{
	public partial class GMDeathmatch : Node
	{
		// Called when the node enters the scene tree for the first time.
		public override void _Ready()
		{
            Global global = GetNode<Global>("/root/Global");

			global.gameMode = "Deathmatch";
        }
	}
}
