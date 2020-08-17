




namespace EasyUI.Web.Mvc.Infrastructure.Implementation
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Reflection;

    internal class PropertyCache : IPropertyCache
    {
        private readonly ICache cache;

        public PropertyCache(ICache cache)
        {
            this.cache = cache;
        }

        public IEnumerable<PropertyInfo> GetProperties(Type type)
        {
            Func<PropertyInfo, bool> canInclude = property => CreateMatchingGet(property)() && CreateMatchingSet(property)();

            return GetInternalProperties(type).Where(canInclude);
        }

        public IEnumerable<PropertyInfo> GetReadOnlyProperties(Type type)
        {
            Func<PropertyInfo, bool> canInclude = property => CreateMatchingGet(property)();

            return GetInternalProperties(type).Where(canInclude);
        }

        public IEnumerable<PropertyInfo> GetWriteOnlyProperties(Type type)
        {
            Func<PropertyInfo, bool> canInclude = property => CreateMatchingSet(property)();

            return GetInternalProperties(type).Where(canInclude);
        }

        private IEnumerable<PropertyInfo> GetInternalProperties(Type type)
        {
            Func<PropertyInfo, bool> canInclude = property => CreateMatchingGet(property)() || CreateMatchingSet(property)();

            return cache.Get(type.AssemblyQualifiedName, () => type.GetProperties(BindingFlags.Public | BindingFlags.Instance).Where(canInclude));
        }

        private static Func<bool> CreateMatchingGet(PropertyInfo property)
        {
            Func<bool> hasGet = () =>
                                {
                                    MethodInfo method = property.GetGetMethod();

                                    return (method != null) && (method.GetParameters().Length == 0);
                                };

            Func<bool> validGet = () => property.CanRead && hasGet();

            return validGet;
        }

        private static Func<bool> CreateMatchingSet(PropertyInfo property)
        {
            Func<bool> hasSet = () =>
                                {
                                    MethodInfo method = property.GetSetMethod();

                                    return (method != null) && (method.GetParameters().Length == 1);
                                };

            Func<bool> validSet = () => property.CanWrite && hasSet();

            return validSet;
        }
    }
}