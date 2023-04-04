using Godot;
using System;

namespace Sunaba.Core
{
	public partial class ConnectDialog : Window
	{
		[Export]
		public NetworkManager networkManager;

		String address = "127.0.0.1";


        public void Connect()
		{
            networkManager.JoinRoom(address);
			GetParent<UI>().GetNode<Control>("MainMenu").Hide();
			Hide();
		}
	}
}
