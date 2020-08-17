




namespace EasyUI.Web.Mvc.UI
{
    using System;

    public class InputBoxBaseClientEvents
    {

        public InputBoxBaseClientEvents()
        {
            OnLoad = new ClientEvent();
            OnClick = new ClientEvent();
        }

        public ClientEvent OnLoad { get; private set; }

        public ClientEvent OnClick { get; private set; }

        public void SerializeTo(IClientSideObjectWriter writer)
        {
            writer.AppendClientEvent("onLoad", OnLoad);
            writer.AppendClientEvent("onClick", OnClick);
        }
    }
}
