




namespace EasyUI.Web.Mvc.Infrastructure.Implementation
{
    using System;

    internal class ReflectedAuthorizeAttributeCache : IReflectedAuthorizeAttributeCache
    {
        private readonly IAuthorizeAttributeBuilder builder;
        private readonly ICache cache;

        public ReflectedAuthorizeAttributeCache(ICache cache, IAuthorizeAttributeBuilder builder)
        {
            this.cache = cache;
            this.builder = builder;
        }

        public IAuthorizeAttribute GetAttribute(Type attributeType)
        {
            var ctor = cache.Get(attributeType.AssemblyQualifiedName, () => builder.Build(attributeType));
            
            return ctor.Invoke(new object[0]) as IAuthorizeAttribute;
        }
    }
}