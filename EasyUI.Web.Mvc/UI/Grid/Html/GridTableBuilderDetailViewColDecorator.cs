namespace EasyUI.Web.Mvc.UI.Html
{
    using System.Linq;
    using Infrastructure;

    class GridTableBuilderDetailViewColDecorator : IGridTableBuilderDecorator
    {
        private readonly bool hasDetails;

        public GridTableBuilderDetailViewColDecorator(bool hasDetails)
        {
            this.hasDetails = hasDetails;
        }

        public void Decorate(IHtmlNode table)
        {
            var colGroup = table.Children.FirstOrDefault();
            if (colGroup != null && hasDetails)
            {
                var td = CreateCol();
                colGroup.Children.Insert(0, td);
            }
        }

        private IHtmlNode CreateCol()
        {
            return new HtmlElement("col").AddClass(UIPrimitives.Grid.HierarchyCol);
        }
    }
}