using Godot;
using System;
using System.Reflection;

namespace Toonbox.Runtime
{
    public partial class BuildFlags : Resource
    {
        [Export]
        public bool multiplayerEnabled = false;

        [Export]
        public String versionNumber = "0.4.0";

        [Export]
        public String buildDate = "March 6th 2023";

        public String GetBuildDate()
        {
            var version = Assembly.GetExecutingAssembly().GetName().Version;
            DateTime date = new DateTime(2000, 1, 1)
                .AddDays(version.Build)
                .AddSeconds(version.Revision * 2);

            return date.ToString();
        }
    }
}