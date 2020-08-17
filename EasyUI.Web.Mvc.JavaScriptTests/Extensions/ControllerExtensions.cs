namespace EasyUI.Web.Mvc.JavaScriptTests.Extensions
{
    using System;
    using System.Linq;
    using System.Web.Mvc;

    public static class ControllerExtensions
    {
        static public string[] GetActions(this Type controllerType)
        {
            return controllerType.GetMethods()
                .Where(x => x.ReturnType == typeof(ActionResult) && x.Name != "Index" && x.GetCustomAttributes(true).Length == 0)
                .OrderBy(x => x.Name)
                .Select(x => x.Name)
                .ToArray();
        }

        public static string GetName(this Type controllerType)
        {
            return controllerType.Name.Replace("Controller", "");
        }
    }
}