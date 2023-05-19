using Godot;
using System;
using Sunaba.Core;

namespace Sunaba.Entities
{
    public partial class Water : Node3D
    {
        Timer timer;
	
        // Called when the node enters the scene tree for the first time.
        public override void _Ready()
        {
            timer = new Timer();
            timer.WaitTime = 0.5;
            timer.OneShot = true;
            AddChild(timer);
            timer.Timeout += Awake;
            timer.Start();
        }

        void Awake()
        {
            timer.QueueFree();
            Console console = GetNode<Console>("/root/PConsole");
            PrintTreePretty();
            foreach (Node node in GetChildren())
            {
                String nodeName = node.Name.ToString();
                String nodeType = node.GetType().ToString();
                
                console.Print("Name : " + nodeName + " Type : " + nodeType);
            }
        }
    }
}
