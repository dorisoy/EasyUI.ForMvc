// (c) Copyright 2002-2011 EasyUI 




namespace EasyUI.Web.Mvc.UI
{
    using System.Web.Mvc;
    
    class EditorUrlBuilder : IEditorUrlBuilder
    {
        private readonly IUrlGenerator urlGenerator;
        private readonly ViewContext viewContext;

        public EditorUrlBuilder(IUrlGenerator urlGenerator, ViewContext viewContext)
        {
            this.urlGenerator = urlGenerator;
            this.viewContext = viewContext;
        }

        public string PrepareUrl(INavigatable navigatable)
        {
            return navigatable.GenerateUrl(viewContext, urlGenerator);
        }
    }
}
