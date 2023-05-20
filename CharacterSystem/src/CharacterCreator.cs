using Godot;
using System;
using Sunaba.Actors;
using Sunaba.Core;

namespace Sunaba.CharacterSystem
{
	public partial class CharacterCreator : Control
	{
		int faceMaterial = 1;
		int torsoMaterial = 2;
		int armsMaterial = 3;
		int handsMaterial = 4;
		int pantsMaterial = 5;
		int footMaterial = 6;
		int headMaterial;

		[Export] public String headwear = "brown_male_hair";
		[Export] public String skinColor = "pale";
		[Export] public String faceTexture = "face_grey";
		[Export] public String torsoTexture = "generic_male";
		[Export] public String armsTexture = "generic_male";
		[Export] public String handsTexture = "generic_male";
		[Export] public String pantsTexture = "generic_male";
		[Export] public String shoesTexture = "generic_male";

		[Export] public PlayerModel playerModel;

		[Export] public Tree skinTree;
		[Export] public Tree hwTree;
		[Export] public Tree faceTree;
		[Export] public Tree torsoTree;
		[Export] public Tree armsTree;
		[Export] public Tree handsTree;
		[Export] public Tree pantsTree;
		[Export] public Tree shoesTree;

		[Export] public BoneAttachment3D headwearAttachment;

		// Called when the node enters the scene tree for the first time.
		public override void _Ready()
		{
			playerModel.ChangeHeadwear(headwear);
			playerModel.ChangeTexture(headMaterial, "res://CharacterSystem/textures/" + skinColor + ".png");
			playerModel.ChangeFaceTexture(faceTexture);
			playerModel.ChangeTexture(torsoMaterial, playerModel.GetClothingTexture(torsoTexture));
			playerModel.ChangeTexture(armsMaterial, playerModel.GetClothingTexture(armsTexture));
			playerModel.ChangeTexture(handsMaterial, playerModel.GetClothingTexture(handsTexture));
			playerModel.ChangeTexture(pantsMaterial, playerModel.GetClothingTexture(pantsTexture));
			playerModel.ChangeTexture(footMaterial, playerModel.GetClothingTexture(shoesTexture));
			
			CreateItem(skinTree, "skin");
			CreateItem(skinTree, "pale");
			CreateItem(skinTree, "brown");
			
			CreateItem(faceTree, "face");
			
			CreateItem(torsoTree, "torso");
		}

		// Called every frame. 'delta' is the elapsed time since the previous frame.
		public override void _Process(double delta)
		{
		}

		private void CreateItem(Tree tree, String name)
		{
			TreeItem item = tree.CreateItem();
			item.SetText(0, name);
		}

		private void AddItem(String item)
		{
			CreateItem(torsoTree, item);
			CreateItem(armsTree, item);
			CreateItem(handsTree, item);
			CreateItem(pantsTree, item);
			CreateItem(shoesTree, item);
		}
	}
}