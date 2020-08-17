




namespace EasyUI.Web.Mvc.Infrastructure
{
    using System;
    using System.Reflection;

    public interface IAuthorizeAttributeBuilder
    {
        ConstructorInfo Build(Type parentType);
    }
}