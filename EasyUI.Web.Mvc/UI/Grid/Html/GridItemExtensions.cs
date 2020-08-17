// (c) Copyright 2002-2009 EasyUI 



namespace EasyUI.Web.Mvc.UI.Html
{
    internal static class GridItemExtensions
    {
        public static void AsAlternating(this GridItem item)
        {
            if (item.Index % 2 != 0)
            {
                item.State |= GridItemStates.Alternating;
            }
        }
    }
}