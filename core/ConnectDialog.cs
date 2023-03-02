using Godot;
using System;

namespace Toonbox.Runtime
{
	public partial class ConnectDialog : Window
	{
		[Export]
		public NetworkManager netman;

		public void Connect()
		{
			String address = GetNode<TabBar>("TabBar").GetNode<TabContainer>("TabContainer").GetNode<Control>("Online").GetNode<LineEdit>("LineEdit").Text;
			netman.JoinRoom(address);
			GetParent<UI>().GetNode<Control>("MainMenu").Hide();
			Hide();
		}
	}
}
