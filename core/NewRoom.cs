using Godot;
using System;

namespace OpenSBX.Runtime
{
	public partial class NewRoom : Node
	{
        public void OnBotsToggled(bool buttonPressed)
		{
            var global = GetNode("/root/Global");

            global.Set("bots_enabled", buttonPressed);
            //global.bots_enabled = buttonPressed;
        }

        public void OnBotAmountChanged(double value)
        {
            var global = GetNode("/root/Global");

            global.Set("bot_amount", value);
            //global.bots_enabled = buttonPressed;
        }
    }
}

/*

*/