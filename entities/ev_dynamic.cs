using Godot;
using System;

public partial class ev_dynamic : DirectionalLight3D
{
    
    public float rotationSpeed = 0.5f;

    public override void _Process(double delta)
    {
        // Update rotation
        //RotateX(Mathf.Deg2Rad(rotationSpeed * delta));
        RotateX(Mathf.DegToRad(rotationSpeed * (float)delta));
    }

}
