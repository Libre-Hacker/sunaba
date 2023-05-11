using Godot;
using System;

namespace Sunaba.Entities
{
    public partial class EVDynamic : DirectionalLight3D
    {

        public float rotationSpeed = 0.5f;

        public override void _Process(double delta)
        {
            // Update rotation
            RotateX(Mathf.DegToRad(rotationSpeed * (float)delta));
        }

    }
}
