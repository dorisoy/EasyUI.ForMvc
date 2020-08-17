




namespace EasyUI.Web.Mvc.UI
{
    public interface ITextBoxBaseHtmlBuilderFactory<T> where T : struct
    {
        ITextBoxBaseHtmlBuilder Create(TextBoxBase<T> input);
    }
}