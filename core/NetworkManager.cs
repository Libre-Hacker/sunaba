using Godot;
using System;

namespace Toonbox.Runtime
{
	public partial class NetworkManager : Node
	{
		private String matchId = null;

		private ENetMultiplayerPeer enetPeer = new ENetMultiplayerPeer();

		[Export]
		public NodePath world;

        // Called when the node enters the scene tree for the first time.
        public override void _Ready()
		{
        }

		// Called every frame. 'delta' is the elapsed time since the previous frame.
		public override void _Process(double delta)
		{
		}
	}
}

/*

*/