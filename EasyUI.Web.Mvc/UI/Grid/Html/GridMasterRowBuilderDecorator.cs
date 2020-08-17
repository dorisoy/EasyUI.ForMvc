// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI.Html
{
    public class GridMasterRowBuilderDecorator : GridRowBuilderDecoratorBase
    {
        public override bool ShouldDecorate(GridItem gridItem)
        {
            return gridItem.Type != GridItemType.EmptyRow &&
                   gridItem.Type != GridItemType.GroupRow &&
                   gridItem.Type != GridItemType.DetailRow &&
                   (gridItem.State & GridItemStates.Master) == GridItemStates.Master;
        }

        protected override void ApplyDecoration(IHtmlNode htmlNode)
        {
            htmlNode.AddClass("t-master-row");
        }
    }
}