using Godot;
using System;

namespace Toonbox.Runtime
{
	public partial class NetworkManager : Node
	{
		private String matchId = null;

		private ENetMultiplayerPeer enetPeer = new ENetMultiplayerPeer();
		
		[Export]
		public World world;

		[Export]
		public UI ui;

        public Main main;

        // Called when the node enters the scene tree for the first time.
        public override void _Ready()
		{
            main = GetParent<Main>();

			Multiplayer.MultiplayerPeer = null;

            var console = GetNode("/root/Console");
            console.Call("register_env", "netman", this);
        }

        public void CreateRoom()
		{
			enetPeer.CreateServer(8070);
			Multiplayer.MultiplayerPeer = enetPeer;
			//Multiplayer.PeerConnected += PlayerJoined;
            var global = GetNode("/root/Global");
			global.Set("gameStarted", true);
            global.Set("isNetworkedGame", true);

			main.LogToChat("Room Created");
			//get_parent().log_to_chat("Room created")

			main.ImportMap();
        }

        public void JoinRoom(string address)
		{
			enetPeer.CreateClient(address, 8070);
            Multiplayer.MultiplayerPeer = enetPeer;
            var global = GetNode("/root/Global");
            global.Set("gameStarted", true);
            global.Set("isNetworkedGame", true);
        }

		public void PlayerJoined(int id)
		{
            var global = GetNode("/root/Global");
            global.Set("gameStarted", true);
			main.LogToChat($"Player {id} has joined");
			world.PlayerJoined(id);
        }
    }
}