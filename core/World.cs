using Godot;
using System;

namespace Sunaba.Runtime
{
	public partial class World : Node
	{
		public Node3D mapManager;
		public NavigationRegion3D navRegion;
		public Node mainNode;
		
		// Called when the node enters the scene tree for the first time.
		public override void _Ready()
		{
			navRegion = GetNode<NavigationRegion3D>("NavigationRegion3D");
			mapManager = navRegion.GetNode<Node3D>("MapManager");
		}

		// Called every frame. 'delta' is the elapsed time since the previous frame.
		public override void _Process(double delta)
		{
		}
	}
}

/*

*/