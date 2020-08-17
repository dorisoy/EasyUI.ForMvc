﻿namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;

    public interface IDropDown : IDataBoundDropDown, IDropDownRenderable
    {
        IDictionary<string, object> DropDownHtmlAttributes { get; }

        Effects Effects { get; }

        DropDownClientEvents ClientEvents { get; }
    }
}
