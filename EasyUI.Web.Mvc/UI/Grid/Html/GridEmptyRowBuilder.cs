// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI.Html
{
    using Infrastructure;

    public class GridEmptyRowBuilder : IGridRowBuilder
    {
        public GridEmptyRowBuilder(int colspan, HtmlTemplate noRecordsTemplate)
        {
            Colspan = colspan;
            NoRecordsTemplate = noRecordsTemplate;
        }

        public int Colspan
        {
            get;
            private set;
        }

        public HtmlTemplate NoRecordsTemplate
        {
            get;
            set;
        }

        public IHtmlNode CreateRow()
        {
            var tr = new HtmlElement("tr").AddClass("t-no-data");

            var td = new HtmlElement("td")
                .Attribute("colspan", Colspan.ToString())
                .AppendTo(tr);

            NoRecordsTemplate.Apply(td);

            return tr;
        }
    }
}