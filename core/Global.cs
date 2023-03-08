using Godot;
using Godot.Collections;
using System;
using System.Linq;

namespace Sunaba.Runtime
{
	public partial class Global : Node
	{
		public bool gameStarted = false;
		public bool gamePaused = false;
		public bool isNetworkedGame = false;
		public Vector3 spawnpoint;
        public Array<Vector3> spawnpoints = new Array<Vector3>();
        public String gameMode = "";
		public String playerModel = "custom";
		public CharacterBody3D player;
		public bool botsEnabled;
		public int botAmount = 0;

		public String headwear = "black_long_hair";
        public String skinColor = "pale";
        public String faceTexture = "face_lightblue";
        public String torsoTexture = "lunar_blue";
        public String armsTexture = "lunar_blue";
        public String handsTexture = "lunar_blue";
        public String pantsTexture = "lunar_blue";
        public String shoesTexture = "lunar_blue";

        public override void _Ready()
        {
            SetToDefault();
        }

		public void SetToDefault()
		{
			gameStarted = false;
			gamePaused = false;
			gameMode = "";
			spawnpoints.Clear();
		}

		public Vector3 GetSpawnpoints()
		{
			Vector3 sp = spawnpoints.PickRandom();
			return sp;
		}

		public void AddSpawnpoint(Vector3 sp) 
		{ 
			spawnpoints.Add(sp);
		}
    }
}


/*

func _physics_process(_delta):
	if !player == null:
		get_tree().call_group("enemy", "update_target_location", player.global_transform.origin)

 */