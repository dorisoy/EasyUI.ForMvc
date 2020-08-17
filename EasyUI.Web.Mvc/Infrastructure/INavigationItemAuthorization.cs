




namespace EasyUI.Web.Mvc.Infrastructure
{
    using System.Web.Routing;

    public interface INavigationItemAuthorization
    {
        bool IsAccessibleToUser(RequestContext requestContext, INavigatable navigationItem);
    }
}