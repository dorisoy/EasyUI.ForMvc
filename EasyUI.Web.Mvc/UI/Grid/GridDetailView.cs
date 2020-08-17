﻿




namespace EasyUI.Web.Mvc.UI
{
    using System.Web;

    public class GridDetailView<TModel> : IGridDetailView<TModel>
        where TModel : class
    {
        public GridDetailView()
        {
            Template = new HtmlTemplate<TModel>();
        }

        private string clientTemplate;

        public string ClientTemplate
        {
            get
            {
                return clientTemplate;
            }
            set
            {
                clientTemplate = HttpUtility.HtmlDecode(value);
            }
        }

        public HtmlTemplate<TModel> Template
        {
            get;
            private set;
        }
    }
}
