using Godot;
using System;

namespace OpenSBX.Tools
{
	public partial class Tool : Node3D
	{
		[Export]
		public int damage = 15;

		[Export]
		public int spread = 10;

		[Export]
		public double cooldownTime = 0.1;

		[Export]
		public int maxAmmo = 7;

		[Export]
		public String toolType = "Semi";


		[Export]
		public String toolObjectPath = null;

		[Export]
		public String decalPath = null;

		public Resource getToolObject()
		{
			return GD.Load<Resource>(toolObjectPath);
		}

		public Resource getDecal()
		{
			return GD.Load<Resource>(decalPath);
		}
	}
}
