using Godot;
using System;

namespace Sunaba.Runtime
{
	public partial class VersionLabel : Label
	{
		// Called when the node enters the scene tree for the first time.
		public override void _Ready()
		{
            Build build = GetNode<Build>("/root/Build");
            
			Text = "v" + build.versionNumber + "dev";
		}
	}
}

/*

*/