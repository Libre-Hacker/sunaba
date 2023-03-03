using Godot;
using System;
using Toonbox.Runtime;

namespace Toonbox.Actors
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

		MeshInstance3D baseMesh = null;
		BoneAttachment3D headwearAttachment = null;
		Global global;

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
			ChangeHeadwear(global.headwear);
            ChangeTexture(headMaterial, "res://addons/toonroid/textures/" + global.skinColor + ".png");
            ChangeFaceTexture(global.faceTexture);
			ChangeTexture(torsoMaterial, GetClothingTexture(global.torsoTexture));
            ChangeTexture(armsMaterial, GetClothingTexture(global.armsTexture));
            ChangeTexture(handsMaterial, GetClothingTexture(global.handsTexture));
            ChangeTexture(pantsMaterial, GetClothingTexture(global.pantsTexture));
            ChangeTexture(footMaterial, GetClothingTexture(global.shoesTexture));
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
            String path = "res://addons/toonroid/textures/face/" + global.skinColor + "/" + name + ".png";
            return path;
        }

        private String GetClothingTexture(String name)
        {
            String path = "res://addons/toonroid/textures/clothes/" + global.skinColor + "/" + name + ".png";
			if (name == "skin")
			{
                Global global = GetNode<Global>("/root/Global");
                path = "res://addons/toonroid/textures/" + global.skinColor + ".png";
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