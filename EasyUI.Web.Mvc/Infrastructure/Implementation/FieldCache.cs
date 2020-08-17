




namespace EasyUI.Web.Mvc.Infrastructure.Implementation
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Reflection;

    internal class FieldCache : IFieldCache
    {
        private const BindingFlags Flags = BindingFlags.Public | BindingFlags.Instance | BindingFlags.GetField | BindingFlags.SetField;

        private readonly ICache cache;
        
        public FieldCache(ICache cache)
        {
            this.cache = cache;
        }

        public IEnumerable<FieldInfo> GetFields(Type type)
        {
            return cache.Get(type.AssemblyQualifiedName, () => type.GetFields(Flags).Where(field => !field.IsInitOnly));
        }
    }
}