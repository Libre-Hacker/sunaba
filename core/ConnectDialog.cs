using Godot;
using System;

namespace Sunaba.Runtime
{
	public partial class ConnectDialog : Window
	{
		[Export]
		public NodePath netman_path;

		public void Connect()
		{
			var netman = GetNode(netman_path);
			var address = GetNode("TabBar").GetNode("TabContainer").GetNode("Online").GetNode("LineEdit").Get("text");
			GD.Print(address);
		}
	}
}

/*

*/