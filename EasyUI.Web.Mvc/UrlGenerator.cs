namespace EasyUI.Web.Mvc
{
    using System;
    using System.Linq;
    using System.Web.Mvc;
    using System.Web.Routing;
    using EasyUI.Web.Mvc.Extensions;
    using EasyUI.Web.Mvc.Infrastructure;

    public class UrlGenerator : IUrlGenerator
    {
        public string Generate(RequestContext requestContext, string url)
        {
            return new UrlHelper(requestContext).Content(url);
        }

        public string Generate(RequestContext requestContext, INavigatable navigationItem, RouteValueDictionary routeValues)
        {
            Guard.IsNotNull(requestContext, "requestContext");
            Guard.IsNotNull(navigationItem, "navigationItem");

            UrlHelper urlHelper = new UrlHelper(requestContext);
            string generatedUrl = null;

            if (!string.IsNullOrEmpty(navigationItem.RouteName))
            {
                generatedUrl = urlHelper.RouteUrl(navigationItem.RouteName, routeValues);
            }
            else if (!string.IsNullOrEmpty(navigationItem.ControllerName) && !string.IsNullOrEmpty(navigationItem.ActionName))
            {
                generatedUrl = urlHelper.Action(navigationItem.ActionName, navigationItem.ControllerName, routeValues, null, null);
            }
            else if (!string.IsNullOrEmpty(navigationItem.Url))
            {
                generatedUrl = navigationItem.Url.StartsWith("~/", StringComparison.Ordinal) ?
                               urlHelper.Content(navigationItem.Url) :
                               navigationItem.Url;
            }
            else if (routeValues.Any())
            {
                generatedUrl = urlHelper.RouteUrl(routeValues);
            }

            return generatedUrl;

        }
        public string Generate(RequestContext requestContext, INavigatable navigationItem)
        {
            RouteValueDictionary routeValues = new RouteValueDictionary();

            if (navigationItem.RouteValues.Any())
            {
                routeValues.Merge(navigationItem.RouteValues);
            }

            return Generate(requestContext, navigationItem, routeValues);
        }
    }
}