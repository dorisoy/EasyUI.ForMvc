namespace EasyUI.Web.Mvc.Examples.Areas.Razor
{
    using System.Web.Mvc;
    public class AspxAreaRegistration : AreaRegistration
    {
        public const string AspxViewToken = "IsAspxView";

        public override string AreaName
        {
            get
            {
                return "Aspx";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {
            var aspxRoute = context.MapRoute(
                "Aspx_default",
                "aspx/{controller}/{action}/{id}",
                //new { controller = "Home", action = "FirstLook", id = "" }
                 new { controller = "Home", action = "FirstLook", area = "Razor", id = "" }
                );


            // The 'UseNamespaceFallback' token will allow the runtime to use the controllers defined outside the area
            aspxRoute.DataTokens["UseNamespaceFallback"] = true;
            aspxRoute.DataTokens[AspxViewToken] = true;           
        }
    }
}
