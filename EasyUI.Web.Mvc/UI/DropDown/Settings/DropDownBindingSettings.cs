// (c) Copyright 2002-2011 EasyUI 



namespace EasyUI.Web.Mvc.UI
{
    public class DropDownBindingSettings : IDropDownBindingSettings
    {
        public DropDownBindingSettings()
        {
            Select = new RequestSettings();
        }

        public bool Enabled
        {
            get;
            set;
        }

        public INavigatable Select
        {
            get;
            private set;
        }
    }
}
