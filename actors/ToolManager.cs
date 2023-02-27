using Godot;
using System;

namespace Toonbox.Actors
{
    public partial class ToolManager : Node3D
    {
        public int currentTool;
        public String toolToSpawn;
        public String toolToDrop;
        public String tool1;
        public String tool2;
        public String tool3;
        public String tool4;

        public override void _Input(InputEvent @event)
        {
            if (Input.IsActionJustPressed("interact"))
            {
                if (toolToSpawn != null)
                {
                    //
                }
            }
        }

        public void addTool(String tool)
        {
            if (tool1 == null)
            {
                tool1 = tool;
                currentTool = 1;
                GD.Print(tool1);
            }
            else if (tool2 == null)
            {
                tool2 = tool;
                currentTool = 2;
                GD.Print(tool2);
            }
            else if (tool3 == null)
            {
                tool3 = tool;
                currentTool = 3;
                GD.Print(tool1);
            }
            else if (tool4 == null)
            {
                tool4 = tool;
                currentTool = 4;
                GD.Print(tool1);
            }
        }
    }
}
