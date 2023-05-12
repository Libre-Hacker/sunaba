using Godot;
using MoonSharp.Interpreter;
using System;

namespace Sunaba.Core
{
    public partial class NetworkManager : Node
	{
		private String matchId = null;

		private ENetMultiplayerPeer enetPeer = new ENetMultiplayerPeer();
        Upnp upnp = new Upnp();

		private World world;
		private UI ui;

        [Export]
        public String protocol = "ENet";

        public Main main;

        // Called when the node enters the scene tree for the first time.
        public override void _Ready()
		{
            main = GetParent<Main>();
            world = main.GetNode<World>("World");
            ui = main.GetNode<UI>("UI");
            
            
			Multiplayer.MultiplayerPeer = null;

            Console console = GetNode<Console>("/root/PConsole");
            console.Register(Name, this);
        }

        public void CreateRoom()
		{
            if (protocol == "ENet")
            {
                CreateENetRoom();
            }
        }

        public void CreateENetRoom()
        {
            enetPeer.CreateServer(8070);
            Multiplayer.MultiplayerPeer = enetPeer;
            Multiplayer.PeerConnected += PlayerJoined;

            var global = GetNode("/root/Global");
            global.Set("gameStarted", true);
            global.Set("isNetworkedGame", true);
            upnp.Discover();
            upnp.AddPortMapping(8070);

            main.LogToChat("Room Created");
            //get_parent().log_to_chat("Room created")

            main.ImportMap();
        }

        public void JoinENetRoom(string address)
        {
            enetPeer.CreateClient(address, 8070);
            Multiplayer.MultiplayerPeer = enetPeer;
            var global = GetNode("/root/Global");
            global.Set("gameStarted", true);
            global.Set("isNetworkedGame", true);
        }

        public void JoinRoom(string access_code)
		{
            if (protocol == "ENet")
            {
                JoinENetRoom(access_code);
            }
        }

		public void PlayerJoined(long id)
		{
            var global = GetNode("/root/Global");
            global.Set("gameStarted", true);
			main.LogToChat($"Player {id} has joined");
			world.PlayerJoined((int)id);
        }
    }
}