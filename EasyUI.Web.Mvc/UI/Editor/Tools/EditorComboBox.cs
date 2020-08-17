﻿




namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.Extensions;
    using EasyUI.Web.Mvc.UI.Html;
    

    public class EditorComboBox : IEditorListTool, IComboBoxRenderable
    {
        public EditorComboBox(string identifier, IList<DropDownItem> items, ViewContext viewContext)
        {
            Items = items;
            Identifier = identifier.ToCamelCase();
            HtmlAttributes = new Dictionary<string, object>() { { "class", "t-" + Identifier } };
            ViewContext = viewContext;
            Enabled = true;
            Encoded = true;
            InputHtmlAttributes = new Dictionary<string, object>();
            HiddenInputHtmlAttributes = new Dictionary<string, object>();
        }

        public string Identifier { get; private set; }

        public ViewContext ViewContext { get; private set; }

        public IDictionary<string, object> HtmlAttributes { get; private set; }

        string IViewComponent.Id { get { return ""; } }
        string IViewComponent.Name { get { return ""; } }
        public IDictionary<string, object> InputHtmlAttributes { get; private set; }
        public IDictionary<string, object> HiddenInputHtmlAttributes { get; private set; }

        public IList<DropDownItem> Items
        {
            get;
            private set;
        }

        public int SelectedIndex { get; set; }
        public string Value { get; set; }
        public bool Enabled { get; set; }
        public bool Encoded { get; set; }

        public IHtmlBuilder CreateHtmlBuilder()
        {
            if (ViewContext.HttpContext.Request.Browser.IsBrowser("IE"))
            {
                return new EditorSelectBoxHtmlBuilder(ToSelectBox());
            }

            return new EditorComboBoxHtmlBuilder(this);
        }
        
        private EditorSelectBox ToSelectBox()
        {
            return new EditorSelectBox(Identifier, Items);
        }
    }
}