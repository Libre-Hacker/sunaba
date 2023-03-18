using Godot;
using System;
using System.Globalization;
using System.IO;
using System.Reflection;

namespace Sunaba.Runtime
{
	public partial class Build : Node
	{
		public bool multiplayerEnabled = false;
		public String versionNumber = "0";
		public String buildDate = "March 2, 2023";

		public BuildFlags buildFlags = new BuildFlags();

        public override void _Ready()
        {
			multiplayerEnabled = buildFlags.multiplayerEnabled;
			versionNumber = Assembly.GetExecutingAssembly().GetName().Version.ToString();
            buildDate = GetCompDate();
        }
        


        public String GetCompDate()
        {
            String compDate = GetBuildDate(Assembly.GetExecutingAssembly()).ToString();//Date.GetLinkerTimestampUtc(Assembly.GetExecutingAssembly()).ToString();

            return compDate;
        }

        private static DateTime GetBuildDate(Assembly assembly)
        {
            const string BuildVersionMetadataPrefix = "+build";

            var attribute = assembly.GetCustomAttribute<AssemblyInformationalVersionAttribute>();
            if (attribute?.InformationalVersion != null)
            {
                var value = attribute.InformationalVersion;
                var index = value.IndexOf(BuildVersionMetadataPrefix);
                if (index > 0)
                {
                    value = value.Substring(index + BuildVersionMetadataPrefix.Length);
                    if (DateTime.TryParseExact(value, "yyyyMMddHHmmss", CultureInfo.InvariantCulture, DateTimeStyles.None, out var result))
                    {
                        return result;
                    }
                }
            }

            return default;
        }
    }
}

