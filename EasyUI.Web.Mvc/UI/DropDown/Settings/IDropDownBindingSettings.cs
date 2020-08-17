// (c) Copyright 2002-2011 EasyUI 



namespace EasyUI.Web.Mvc.UI
{
    public interface IDropDownBindingSettings
    {
        bool Enabled
        {
            get;
            set;
        }

        INavigatable Select
        {
            get;
        }
    }
}
