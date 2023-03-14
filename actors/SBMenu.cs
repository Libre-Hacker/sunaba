using Godot;
using System;

namespace Toonbox.Actors
{
	public partial class SBMenu : Panel
	{
		Tree toolTree;
		
		// Called when the node enters the scene tree for the first time.
		public override void _Ready()
		{
			toolTree = GetNode<TabBar>("TabBar").GetNode<TabContainer>("TabContainer").GetNode<Control>("Tools").GetNode<Tree>("Tree");

			var ttRoot = toolTree.CreateItem();

			ttRoot.SetText(0, "tools");
			GetTools();
		}

		private void GetTools()
		{
            DirAccess dir = DirAccess.Open("res://tools");

            dir.ListDirBegin();

            while (true)
            {
                String file = dir.GetNext();
                if (string.IsNullOrEmpty(file))
                {
                    break;
                }
                else if ((!file.EndsWith(".import")) && (file.EndsWith(".tscn")))
                {
                    var toolName = file.GetBaseName();
                    AddToolToTree(toolName);
                }
            }

            dir.ListDirEnd();
        }

		private void AddToolToTree(String toolName)
		{
			var item = toolTree.CreateItem();
			item.SetText(0, toolName);
		}
	}
}
