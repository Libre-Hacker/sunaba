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

            var console = GetNode("/root/Console");
            console.Call("register_env", "netman", this);
			
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
			global.Set("game_started", true);
            global.Set("is_networked_game", true);

			LogToChat("Room Created");
			//get_parent().log_to_chat("Room created")

			mainNode.Call("import_world");
        }

        public void JoinRoom(string address)
		{
			enetPeer.CreateClient(address, 8070);
            Multiplayer.MultiplayerPeer = enetPeer;
            var global = GetNode("/root/Global");
            global.Set("game_started", true);
            global.Set("is_networked_game", true);
        }

		public void PlayerJoined(int id)
		{
            var global = GetNode("/root/Global");
            global.Set("game_started", true);
			LogToChat($"Player {id} has joined");
			world.PlayerJoined(id);
        }
    }
}

/*
func _player_joined(id):
	Global.game_started = true
	get_parent().log_to_chat(var_to_str(id) + " has joined")
	get_parent().enable_chat()
	world.PlayerJoined(id)


func _on_player_status_changed():
	pass

@rpc("any_peer") 
func chat(id , chatstring):
	get_parent().chat(id, chatstring)

func get_address():
	var addresses = IP.get_local_addresses()
	var address = addresses[1]
	return address

func start_http_server():
	pass#server.register_router("/", HttpFileRouter.new("user://server"))

func get_map_file():
	pass

*/