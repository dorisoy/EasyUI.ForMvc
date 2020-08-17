




namespace EasyUI.Web.Mvc.Infrastructure
{
    using System;
    using System.Collections.Generic;
    using System.Reflection;
    using System.Web.Routing;

    public interface IControllerTypeCache
    {
        Func<IEnumerable<Assembly>> ReferencedAssemblies
        {
            get;
            set;
        }

        IList<Type> GetControllerTypes(RequestContext requestContext, string controllerName);
    }
}