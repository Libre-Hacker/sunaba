using Godot;
using System;
using Sunaba.Core;

namespace Sunaba.Actors
{
	public partial class PlayerModel : Node3D
	{
		int faceMaterial = 1;
        int torsoMaterial = 2;
        int armsMaterial = 3;
		int handsMaterial = 4;
		int pantsMaterial = 5;
		int footMaterial = 6;
		int headMaterial = 0;

        [Export]
        public String headwear = "brown_male_hair";
        [Export]
        public String skinColor = "pale";
        [Export]
        public String faceTexture = "face_grey";
        [Export]
        public String torsoTexture = "generic_male";
        [Export]
        public String armsTexture = "generic_male";
        [Export]
        public String handsTexture = "generic_male";
        [Export]
        public String pantsTexture = "generic_male";
        [Export]
        public String shoesTexture = "generic_male";

        MeshInstance3D baseMesh = null;
		BoneAttachment3D headwearAttachment = null;
		Global global;

		[Export]
		public bool isPartOfActor = false;

        public override void _EnterTree()
        {
            if (isPartOfActor) return;

            string nameString = GetParent<Player>().Name.ToString();
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
            ChangeTexture(headMaterial, "res://Godime/textures/" + skinColor + ".png");
            ChangeFaceTexture(faceTexture);
            ChangeTexture(torsoMaterial, GetClothingTexture(torsoTexture));
            ChangeTexture(armsMaterial, GetClothingTexture(armsTexture));
            ChangeTexture(handsMaterial, GetClothingTexture(handsTexture));
            ChangeTexture(pantsMaterial, GetClothingTexture(pantsTexture));
            ChangeTexture(footMaterial, GetClothingTexture(shoesTexture));
        }

		public String GetHeadwearModelPath(String name)
		{
			String path = "res://Godime/headwear/" + name + ".tscn";
			return path;
		}
		
		public PackedScene GetHeadwearModel(String name)
		{
			PackedScene model = GD.Load<PackedScene>(GetHeadwearModelPath(name));
			return model;
		}

        public String GetFaceTexture(String name)
        {
            String path = "res://Godime/textures/face/" + skinColor + "/" + name + ".png";
            return path;
        }

        public String GetClothingTexture(String name)
        {
            String path = "res://Godime/textures/clothes/" + skinColor + "/" + name + ".png";
			if (name == "skin")
			{
                Global global = GetNode<Global>("/root/Global");
                path = "res://Godime/textures/" + skinColor + ".png";
            }
            return path;
        }

		public void ChangeTexture(int material, String texturePath)
		{
			Resource texture = GD.Load(texturePath);
			Material mat = baseMesh.GetSurfaceOverrideMaterial(material);
			mat.Set("albedo_texture", texture);

        }

		public void ChangeFaceTexture(String texture)
		{
			ChangeTexture(faceMaterial, GetFaceTexture(texture));
		}

		public void ChangeHeadwear(String headwearName)
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