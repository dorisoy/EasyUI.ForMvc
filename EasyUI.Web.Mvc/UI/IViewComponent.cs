// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI
{
    using System.Web.Mvc;

    public interface IViewComponent
    {
        string Id { get; }

        string Name { get; }

        ViewContext ViewContext { get; }
    }
}
