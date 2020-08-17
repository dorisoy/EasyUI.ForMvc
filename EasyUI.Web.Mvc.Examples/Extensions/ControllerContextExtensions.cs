namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;

    public static class ControllerContextExtensions
    {
        public static bool IsAspxView(this ControllerContext executingContext)
        {
#if MVC3
            var aspxViewToken = executingContext.RouteData.DataTokens[Areas.Razor.AspxAreaRegistration.AspxViewToken];
            return aspxViewToken != null && aspxViewToken.Equals(true);
#else
            return false;
#endif
        }
    }
}