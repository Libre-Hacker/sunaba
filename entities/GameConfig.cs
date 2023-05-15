using System.Collections.Generic;
using Godot;
using Godot.Collections;
using System;
using Sunaba.Core;

namespace Sunaba.Entities;

public partial class GameConfig : Node3D
{
    [Export]
    public Dictionary properties;

    private Global global;

    Timer timer;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        timer = new Timer();
        timer.WaitTime = 0.5;
        timer.OneShot = true;
        AddChild(timer);
        timer.Timeout += SetConfig;
        timer.Start();
    }

    void SetConfig()
    {
        timer.QueueFree();
        global = GetNode<Global>("/root/Global/");
        if (properties.ContainsKey("fly_mode"))
        {
            var flyModeValue = properties.GetValueOrDefault("fly_mode");
            if (flyModeValue.ToString() == "true")
            {
                bool flyMode = flyModeValue.AsBool();
                global.flyMode = flyMode;
            }
        }
    }
}