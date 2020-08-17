// (c) Copyright 2002-2009 EasyUI 



namespace EasyUI.Web.Mvc.UI.Html
{
    public class GridDataRowBuilderDecorator : GridRowBuilderDecoratorBase
    {
        public override bool ShouldDecorate(GridItem gridItem)
        {
            return gridItem.Type != GridItemType.DetailRow && gridItem.Type != GridItemType.GroupRow;
        }

        protected override void ApplyDecoration(IHtmlNode htmlNode)
        {
            htmlNode.Attributes(CurrentGridItem.HtmlAttributes);
        }
    }
}