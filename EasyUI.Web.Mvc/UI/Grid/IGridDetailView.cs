




namespace EasyUI.Web.Mvc.UI
{
    public interface IGridDetailView<TModel> 
        where TModel : class
    {
        HtmlTemplate<TModel> Template
        {
            get;
        }
        
        string ClientTemplate
        {
            get;
            set;
        }
    }
}
