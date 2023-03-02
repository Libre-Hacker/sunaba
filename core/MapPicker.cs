using Godot;
using System;

namespace Toonbox.Runtime
{
	public partial class MapPicker : Node
	{
		// Called when the node enters the scene tree for the first time.
		public override void _Ready()
		{
			DirAccess dir = DirAccess.Open("res://maps");

			dir.ListDirBegin();

			while (true)
			{
				var file = dir.GetNext();
				if (file == null)
				{
					break;
				}
				else if ((!file.EndsWith(".import")) && (file.EndsWith(".map")))
				{
					var mapName = file.Left(-4);
					var optButton = GetNode<OptionButton>("OptionButton");
					optButton.AddItem(mapName);
				}
			}

			dir.ListDirEnd();
		}
	}
}

/*

*/
