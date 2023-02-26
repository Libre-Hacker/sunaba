using Godot;
using System;

namespace Sunaba.Runtime
{
    public partial class BuildFlags : Resource
    {
        [Export]
        public bool multiplayerEnabled = false;

        [Export]
        public String versionNumber = null;

        [Export]
        public String buildDate = null;
    }
}

/*

*/