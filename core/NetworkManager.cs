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

        public Node mainNode;

        // Called when the node enters the scene tree for the first time.
        public override void _Ready()
		{
            mainNode = GetParent<Node>();

			Multiplayer.MultiplayerPeer = null;
        }

        public void LogToChat(string msg)
        {
            if (mainNode != null)
            {
                mainNode.Call("log_to_chat", msg);
            }
        }

        public void CreateRoom()
		{
			enetPeer.CreateServer(8070);
			Multiplayer.MultiplayerPeer = enetPeer;
			//Multiplayer.PeerConnected += PlayerJoined;
            var global = GetNode("/root/Global");
			global.Set("gameStarted", true);
            global.Set("isNetworkedGame", true);

			LogToChat("Room Created");
			//get_parent().log_to_chat("Room created")

			mainNode.Call("import_world");
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
			LogToChat($"Player {id} has joined");
			world.PlayerJoined(id);
        }
    }
}