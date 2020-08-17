




namespace EasyUI.Web.Mvc.Infrastructure
{
    using System;

    public interface IReflectedAuthorizeAttributeCache
    {
        IAuthorizeAttribute GetAttribute(Type attributeType);
    }
}