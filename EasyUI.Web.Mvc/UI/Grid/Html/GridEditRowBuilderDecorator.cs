// (c) Copyright 2002-2009 EasyUI 



namespace EasyUI.Web.Mvc.UI.Html
{
    public class GridEditRowBuilderDecorator : GridRowBuilderDecoratorBase
    {
        public override bool ShouldDecorate(GridItem item)
        {
            return item.Type == GridItemType.EditRow || item.Type == GridItemType.InsertRow;
        }

        protected override void ApplyDecoration(IHtmlNode htmlNode)
        {
            htmlNode.AddClass("t-grid-edit-row");
        }
    }
}