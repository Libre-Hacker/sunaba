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

        public override void _Ready()
        {
			baseMesh = GetNode<Node3D>("Akari").GetNode<Skeleton3D>("GeneralSkeleton").GetNode<MeshInstance3D>("Base Mesh");
			headwearAttachment = GetNode<Node3D>("Akari").GetNode<Skeleton3D>("GeneralSkeleton").GetNode<BoneAttachment3D>("Hair");
        }

        // Called every frame. 'delta' is the elapsed time since the previous frame.
        public override void _Process(double delta)
		{

		}

		private String GetHeadwearModel(String name)
		{
			String path = "res://addons/toonroid/headwear/" + name + ".tscn";
			return path;
		}

        private String GetFaceTexture(String name)
        {
            String path = "res://addons/toonroid/textures/face/" + name + ".png";
            return path;
        }

        private String GetClothingTexture(String name)
        {
            String path = "res://addons/toonroid/textures/clothes/" + name + ".png";
			if (name == "skin")
			{
                Global global = GetNode<Global>("/root/Global");
                path = "res://addons/toonroid/textures/" + global.skinColor + ".png";
            }
            return path;
        }

		private void changeTexture(int material, String texturePath)
		{
			Resource texture = GD.Load(texturePath);
			Material mat = baseMesh.GetSurfaceOverrideMaterial(material);
			

        }
    }
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

func change_texture(material, texture_path):
	var texture = load(texture_path)
	base_mesh.get_surface_override_material(material).albedo_texture = texture


func change_face_texture(texture):
	change_texture(face_material, get_face_texture(texture))

func change_headwear(headwear_name):
	if hw_attachment.get_child_count() > 0:
		if hw_attachment.get_child(0) != null:
			hw_attachment.get_child(0).queue_free()
	var hw = load(get_headwear_model(headwear_name)).instantiate()
	hw_attachment.add_child(hw)
	hw.position.y = 0.274
	hw.position.z = 0.009

 */