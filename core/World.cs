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

namespace Sunaba.Core
{
	public partial class World : Node3D
	{
		private Node3D mapManager;
		private NavigationRegion3D navRegion;
		private Main main;
		private Global global;
		private Timer respawnTimer;

		private static bool spectatorMode = false;
		
		// Called when the node enters the scene tree for the first time.
		public override void _Ready()
		{
			navRegion = GetNode<NavigationRegion3D>("NavigationRegion3D");
			mapManager = navRegion.GetNode<Node3D>("MapManager");
			respawnTimer = GetNode<Timer>("RespawnTimer");

			main = GetParent<Main>();
			global = GetNode<Global>("/root/Global");

            Console console = GetNode<Console>("/root/PConsole");
            console.Register(Name, this);

        }

		public void LoadMapPath(string path)
		{
			PackedScene mapHolderPath = GD.Load<PackedScene>("res://core/MapHolder.tscn");
			MapHolder mapHolder = mapHolderPath.Instantiate<MapHolder>();
			AddChild(mapHolder);
			mapHolder.map = path;
			GD.Print(path);

            //PackedScene player = GD.Load<PackedScene>("res://actors/player.tscn");
            //CharacterBody3D playerInstance = player.Instantiate<CharacterBody3D>();
            //playerInstance.Name = GD.VarToStr(id);
            //AddChild(playerInstance);
        }

		public void LoadMap(string path)
		{
			if (path != null)
			{
				main.LogToChat("Loading Map");
				mapManager.Set("map_file", path);
				mapManager.Call("verify_and_build");
			}
		}

		[Rpc(MultiplayerApi.RpcMode.AnyPeer)]
		private void SetMap(String path)
		{
            if (Multiplayer.GetUniqueId() == 1)
			{
				Rpc("SetMap", path);
			}
		}

		public void PrepForRespawn()
		{
			GetNode<Timer>("RespawnTimer").Start();
            main.LogToChat("Respawning in 5 seconds");
        }

        [Rpc(MultiplayerApi.RpcMode.AnyPeer)]
        public void LoadMapRemote()
		{
			LoadMap(GetNode<MapHolder>("MapHolder").map);
		}

        public void OnRespawnTimerTimeout()
		{
            //main.LogToChat("Respawning Player");
            if ( global.flyMode == false )
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
            else
            {
	            SpawnCamera();
            }
		}

		[Rpc(MultiplayerApi.RpcMode.AnyPeer)]
		private void InstancePlayer(int id)
		{
			//GetNode<Camera3D>("Camera3D").Current = false;
			PackedScene player = GD.Load<PackedScene>("res://actors/player.tscn");
			CharacterBody3D playerInstance = player.Instantiate<CharacterBody3D>();
			playerInstance.Name = GD.VarToStr(id);
			AddChild(playerInstance);
            if (id ==  Multiplayer.GetUniqueId())
			{
				global.player = playerInstance;
			}

            String gameMode = global.Get("game_mode").As<string>();

			Vector3 spawnpoint = global.GetSpawnpoints();
            playerInstance.GlobalPosition = spawnpoint;
        }

		public void PlayerJoined(int id)
		{
			RpcId(id, "LoadMapRemote");
		}

		private void AddBots()
		{
			bool botsEnabled = global.Get("bots_enabled").As<bool>();
            int botAmount = global.Get("bot_amount").As<int>();
            String gameMode = global.Get("game_mode").As<string>();
        }

		private void AddBot()
        {
			PackedScene bot = GD.Load<PackedScene>("res://actors/dm_bot.tscn");
			CharacterBody3D botInstance = bot.Instantiate<CharacterBody3D>();
			AddChild(botInstance);
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

			respawnTimer.Start();
		}

		public void SpawnCamera()
		{
			//GetNode<Camera3D>("Camera3D").Current = false;
			PackedScene cameraScene = GD.Load<PackedScene>("res://core/Camera.tscn");
			Camera3D camera = cameraScene.Instantiate<Camera3D>();
			AddChild(camera);
			camera.Current = true;
			Vector3 spawnpoint = global.GetSpawnpoints();
			camera.GlobalPosition = spawnpoint;
		}

		public void SetSpectatorMode(bool enabled)
		{
			global.flyMode = enabled;
			spectatorMode = global.flyMode;
		}

		public void SetVoxelGi(bool _bool)
		{
			VoxelGI voxelGi = GetNode<VoxelGI>("VoxelGI");
			if (_bool == true)
			{
				voxelGi.Show();
			}
			else
			{
				voxelGi.Hide();
			}
		}
    }
}