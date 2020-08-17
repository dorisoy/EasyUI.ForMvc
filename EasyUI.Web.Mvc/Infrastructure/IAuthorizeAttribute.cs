




namespace EasyUI.Web.Mvc.Infrastructure
{
    using System.Web;

    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA1711:IdentifiersShouldNotHaveIncorrectSuffix", Justification = "Matching signature of the original authorize attribute.")]
    public interface IAuthorizeAttribute
    {
        int Order
        {
            get;
            set;
        }

        string Roles
        {
            get;
            set;
        }

        string Users
        {
            get;
            set;
        }

        bool IsAuthorized(HttpContextBase httpContext);
    }
}