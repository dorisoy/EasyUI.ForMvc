// (c) Copyright 2002-2009 EasyUI 



namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.UI.Html;
    
    public class EditorCustomTool : IEditorTool
    {
        public EditorCustomTool()
        {
            HtmlAttributes = new Dictionary<string, object>();
            Template = new HtmlTemplate();
        }

        public HtmlTemplate Template
        {
            get;
            private set;
        }

        public IDictionary<string, object> HtmlAttributes
        {
            get;
            private set;
        }
        
        public IHtmlBuilder CreateHtmlBuilder()
        {
            return new EditorCustomToolHtmlBuilder(this);
        }
    }
}
