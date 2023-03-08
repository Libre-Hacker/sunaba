using Godot;
using System;
using Sunaba.Runtime;

namespace Sunaba.Actors
{
	public partial class PlayerModel : Node
	{
		int faceMaterial = 1;
        int torsoMaterial = 2;
        int armsMaterial = 3;
		int handsMaterial = 4;
		int pantsMaterial = 5;
		int footMaterial = 6;
		int headMaterial = 0;

        [Export]
        public String headwear = "black_long_hair";
        [Export]
        public String skinColor = "pale";
        [Export]
        public String faceTexture = "face_lightblue";
        [Export]
        public String torsoTexture = "lunar_blue";
        [Export]
        public String armsTexture = "lunar_blue";
        [Export]
        public String handsTexture = "lunar_blue";
        [Export]
        public String pantsTexture = "lunar_blue";
        [Export]
        public String shoesTexture = "lunar_blue";

        MeshInstance3D baseMesh = null;
		BoneAttachment3D headwearAttachment = null;
		Global global;

		[Export]
		public bool isPartOfActor = false;

        public override void _EnterTree()
        {
            string nameString = GetParent<CharacterBody3D>().Name.ToString();
            string networkID = Multiplayer.GetUniqueId().ToString();

			if (nameString == networkID)
			{
				int nameInt = int.Parse(nameString);
				SetMultiplayerAuthority(nameInt);
			}
        }

        public override void _Ready()
        {
			baseMesh = GetNode<Node3D>("Akari").GetNode<Skeleton3D>("GeneralSkeleton").GetNode<MeshInstance3D>("Base Mesh");
			headwearAttachment = GetNode<Node3D>("Akari").GetNode<Skeleton3D>("GeneralSkeleton").GetNode<BoneAttachment3D>("Hair");
            global = GetNode<Global>("/root/Global");
        }

		/*
		 func _process(delta):
			change_headwear(Global.headwear)
			change_texture(head_material, "res://addons/toonroid/textures/" + Global.skinColor + ".png")
			change_face_texture(Global.faceTexture)
			change_texture(torso_material, get_clothing_texture(Global.torsoTexture))
			change_texture(arms_material, get_clothing_texture(Global.armsTexture))
			change_texture(hands_material, get_clothing_texture(Global.handsTexture))
			change_texture(pants_material, get_clothing_texture(Global.pantsTexture))
			change_texture(foot_material, get_clothing_texture(Global.shoesTexture))
		 */

		// Called every frame. 'delta' is the elapsed time since the previous frame.
		public override void _Process(double delta)
		{
			if (IsMultiplayerAuthority())
			{

                headwear = global.headwear;
				skinColor = global.skinColor;
				faceTexture = global.faceTexture;
				torsoTexture = global.torsoTexture;
				armsTexture = global.armsTexture;
				handsTexture = global.handsTexture;
				pantsTexture = global.pantsTexture;
				shoesTexture = global.shoesTexture;
    }

            ChangeHeadwear(headwear);
            ChangeTexture(headMaterial, "res://addons/toonroid/textures/" + skinColor + ".png");
            ChangeFaceTexture(faceTexture);
            ChangeTexture(torsoMaterial, GetClothingTexture(torsoTexture));
            ChangeTexture(armsMaterial, GetClothingTexture(armsTexture));
            ChangeTexture(handsMaterial, GetClothingTexture(handsTexture));
            ChangeTexture(pantsMaterial, GetClothingTexture(pantsTexture));
            ChangeTexture(footMaterial, GetClothingTexture(shoesTexture));
        }

		private String GetHeadwearModelPath(String name)
		{
			String path = "res://addons/toonroid/headwear/" + name + ".tscn";
			return path;
		}
		
		private PackedScene GetHeadwearModel(String name)
		{
			PackedScene model = GD.Load<PackedScene>(GetHeadwearModelPath(name));
			return model;
		}

        private String GetFaceTexture(String name)
        {
            String path = "res://addons/toonroid/textures/face/" + skinColor + "/" + name + ".png";
            return path;
        }

        private String GetClothingTexture(String name)
        {
            String path = "res://addons/toonroid/textures/clothes/" + skinColor + "/" + name + ".png";
			if (name == "skin")
			{
                Global global = GetNode<Global>("/root/Global");
                path = "res://addons/toonroid/textures/" + skinColor + ".png";
            }
            return path;
        }

		private void ChangeTexture(int material, String texturePath)
		{
			Resource texture = GD.Load(texturePath);
			Material mat = baseMesh.GetSurfaceOverrideMaterial(material);
			mat.Set("albedo_texture", texture);

        }

		private void ChangeFaceTexture(String texture)
		{
			ChangeTexture(faceMaterial, GetFaceTexture(texture));
		}

		private void ChangeHeadwear(String headwearName)
		{
			if (headwearAttachment.GetChildCount() > 0)
			{
				if (headwearAttachment.GetChild(0) != null)
				{
                    headwearAttachment.GetChild<Node3D>(0).QueueFree();
                }
			}

			PackedScene hw = GetHeadwearModel(headwearName);
			Node3D headwear = hw.Instantiate<Node3D>();
			headwearAttachment.AddChild(headwear);
			headwear.Position = new Vector3(0, (float)0.274, (float)0.009);
		}
    }
}