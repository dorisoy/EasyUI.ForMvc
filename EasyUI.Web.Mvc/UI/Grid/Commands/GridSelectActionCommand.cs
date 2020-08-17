




namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.UI.Html;

    public class GridSelectActionCommand : GridActionCommandBase
    {
        public override string Name
        {
            get { return "select"; }
        }

        public override IEnumerable<IGridButtonBuilder> CreateDisplayButtons(IGridLocalization localization, IGridUrlBuilder urlBuilder, IGridHtmlHelper htmlHelper)
        {
            var button = CreateButton<GridLinkButtonBuilder>(localization.Select, UIPrimitives.Grid.Select);
            
            button.SpriteCssClass = "t-select";
            button.Url = urlBuilder.SelectUrl;

            return new[] { button };
        }
    }
}
