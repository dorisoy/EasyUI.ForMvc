// (c) Copyright 2002-2011 EasyUI 




namespace EasyUI.Web.Mvc.UI.Html
{
    public interface IGridFormatableCellBuilder
    {
        string Format
        {
            get;
            set;
        }

        bool Encoded
        {
            get;
            set;
        }
    }
}