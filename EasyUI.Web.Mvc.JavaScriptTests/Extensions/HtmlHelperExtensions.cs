namespace EasyUI.Web.Mvc.JavaScriptTests.Extensions
{
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.UI;

    public static class HtmlHelperExtensions
    {
        static public HtmlHelper RegisterSplitterScripts(this HtmlHelper helpers)
        {
            helpers.EasyUI().ScriptRegistrar()
                .DefaultGroup(defaultGroup => defaultGroup
                    .Add("easyui.common.js")
                    .Add("easyui.draganddrop.js")
                    .Add("easyui.splitter.js")
                    .Add("splitterTestHelper.js")
                );

            return helpers;
        }
    }
}