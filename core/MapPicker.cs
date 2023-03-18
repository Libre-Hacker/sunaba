using Godot;
using System;

namespace Sunaba.Runtime
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
                String file = dir.GetNext();
                if (string.IsNullOrEmpty(file))
                {
                    break;
                }
                else if ((!file.EndsWith(".import")) && (file.EndsWith(".map")))
                {
                    var mapName = file.GetBaseName();
                    GD.Print(mapName);
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
