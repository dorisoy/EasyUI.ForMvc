




namespace EasyUI.Web.Mvc.UI
{

    public interface IDropDownHtmlBuilder
    {
        IHtmlNode Build();

        IHtmlNode InnerContentTag();

        IHtmlNode HiddenInputTag();
    }
}