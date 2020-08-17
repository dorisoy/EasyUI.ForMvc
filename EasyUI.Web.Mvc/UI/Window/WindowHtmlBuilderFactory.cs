




namespace EasyUI.Web.Mvc.UI
{
    public class WindowHtmlBuilderFactory : IWindowHtmlBuilderFactory
    {
        public IWindowHtmlBuilder Create(Window window)
        {
            return new WindowHtmlBuilder(window);
        }
    }
}
