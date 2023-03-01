/*

This is a C# script that is used in the Sunaba game engine. The script represents the World class and contains methods that handle loading maps, respawning players, and adding bots to the game.

The World class inherits from the Node3D class, which is a built-in class in the Godot game engine. The script initializes some member variables, such as mapManager, navRegion, and mainNode, in the _Ready method, which is called when the node enters the scene tree for the first time.

The LoadMap method takes a path to a map file and sets the map_file property of the mapManager node to that path. It then calls the verify_and_build method of the mapManager node to load and build the map.

The SetMap method is an RPC method that is called on the server by a client to set the map. It checks if the calling client has a unique ID of 1, which indicates that it is the server. If the calling client is not the server, it calls the SetMap method on the server via RPC.

The PrepForRespawn method starts a timer that counts down from 5 seconds and then calls the OnRespawnTimerTimeout method.

The OnRespawnTimerTimeout method is called when the timer started in PrepForRespawn expires. It either calls the InstancePlayer method on the server (if the local client has a unique ID of 1) or sends an RPC to the server to call the InstancePlayer method.

The InstancePlayer method instantiates a CharacterBody3D node from a packed scene and adds it as a child of the World node. It also sets the GlobalPosition of the node based on the game mode and spawn point settings.

The AddBots and AddBot methods are not fully implemented and are left as exercises for the reader.

 */

using Godot;
using System;

namespace OpenSBX.Runtime
{
	public partial class World : Node3D
	{
		public Node3D mapManager;
		public NavigationRegion3D navRegion;
		public Node mainNode;

		public static bool spectatorMode = false;
		
		// Called when the node enters the scene tree for the first time.
		public override void _Ready()
		{
			navRegion = GetNode<NavigationRegion3D>("NavigationRegion3D");
			mapManager = navRegion.GetNode<Node3D>("MapManager");

            var console = GetNode("/root/Console");

			console.Call("register_env", "world", this);
        }

		public void LoadMapPath(string path)
		{
			//PackedScene mapHolderPath = GD.Load<PackedScene>("res://core/map_holder.tscn");
			//MapHolder mapHolder = mapHolderPath.Instantiate<MapHolder>();
			//AddChild(mapHolder);
			//mapHolder.map = path;
		}

		public void LoadMap(string path)
		{
			if (path != null)
			{
				LogToChat("Loading Map");
				mapManager.Set("map_file", path);
				mapManager.Call("verify_and_build");
			}
		}

		[Rpc(MultiplayerApi.RpcMode.AnyPeer)]
		public void SetMap(String path)
		{
            if (Multiplayer.GetUniqueId() == 1)
			{
				Rpc("SetMap", path);
			}
		}

		public void PrepForRespawn()
		{
			GetNode<Timer>("RespawnTimer").Start();
            LogToChat("Respawning in 5 seconds");
        }

		public void LoadMapRemote()
		{
			LoadMap(GetNode<MapHolder>("Map").map);
		}

        [Rpc(MultiplayerApi.RpcMode.AnyPeer)]
        public void LoadMapRemote(String path)
        {
            LoadMap(GetNode<Node>("map_holder").Get("map").ToString());
        }

        public void LogToChat(string msg)
        {
            if (mainNode != null)
            {
                mainNode.Call("log_to_chat", msg);
            }
        }

        public void OnRespawnTimerTimeout()
		{
			LogToChat("Respawning Player");
			int id = Multiplayer.GetUniqueId(); 
			if (id != 1)
			{
				RpcId(1, "InstancePlayer", id);
			}
			else
			{
				InstancePlayer(id);
			}
		}

		[Rpc(MultiplayerApi.RpcMode.AnyPeer)]
		public void InstancePlayer(int id)
		{
			PackedScene player = GD.Load<PackedScene>("res://actors/player.tscn");
			CharacterBody3D playerInstance = player.Instantiate<CharacterBody3D>();
			playerInstance.Name = GD.VarToStr(id);
			AddChild(playerInstance);
            var global = GetNode("/root/Global");
            if (id ==  Multiplayer.GetUniqueId())
			{
				global.Set("player", playerInstance);
			}

            String gameMode = global.Get("game_mode").As<string>();

            if ((gameMode == "") || (gameMode == "Sandbox"))
            {
                var spawnpoint = global.Get("spawnpoint").As<Vector3>();
                playerInstance.GlobalPosition = spawnpoint;
            }
			else if (gameMode == "Deathmatch")
			{
				var spVar = global.Call("get_spawnpoint");
				
				var spawnpoint = spVar.As<Vector3>();
                playerInstance.GlobalPosition = spawnpoint;
            }


        }

		public void PlayerJoined(int id)
		{
			RpcId(id, "InstancePlayer", id);
		}

		public void AddBots()
		{
            var global = GetNode("/root/Global");
			bool botsEnabled = global.Get("bots_enabled").As<bool>();
            int botAmount = global.Get("bot_amount").As<int>();
            String gameMode = global.Get("game_mode").As<string>();
        }

        public void AddBot()
        {
			PackedScene bot = GD.Load<PackedScene>("res://actors/dm_bot.tscn");
			CharacterBody3D botInstance = bot.Instantiate<CharacterBody3D>();
			AddChild(botInstance);
            var global = GetNode("/root/Global");
            String gameMode = global.Get("game_mode").As<string>();
            if (gameMode == "Deathmatch")
			{
                var spVar = global.Call("get_spawnpoint");

                var spawnpoint = spVar.As<Vector3>();
                botInstance.GlobalPosition = spawnpoint;
            }
			int botAmount = global.Get("bot_amount").As<int>();
			if (botAmount != 0)
			{
				AddBot();
			}
        }

		public void OnMapManagerBuildComplete()
		{
			mapManager.Call("unwrap_uv2");
			navRegion.BakeNavigationMesh();

			if ( !spectatorMode )
			{
				int id = Multiplayer.GetUniqueId();
				if (id != 1)
				{
					RpcId(1, "InstancePlayer", id);
				}
				else
				{
					InstancePlayer(id);
				}
			}
		}

		public static void setSpectatorMode(bool enabled)
		{
			spectatorMode = enabled;
        }
    }
}