




namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.UI.Html;

    public class GridDeleteActionCommand : GridActionCommandBase
    {
        public override string Name
        {
            get { return "delete"; }
        }

        public override IEnumerable<IGridButtonBuilder> CreateDisplayButtons(IGridLocalization localization, IGridUrlBuilder urlBuilder, IGridHtmlHelper htmlHelper)
        {
            var deleteButton = CreateButton<GridFormButtonBuilder>(localization.Delete, UIPrimitives.Grid.Delete);

            deleteButton.Url = urlBuilder.DeleteUrl;

            deleteButton.HtmlHelper = htmlHelper;

            deleteButton.SpriteCssClass = "t-delete";

            return new[] { deleteButton };
        }
    }
}
