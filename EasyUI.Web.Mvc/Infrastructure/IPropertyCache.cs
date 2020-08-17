




namespace EasyUI.Web.Mvc.Infrastructure
{
    using System;
    using System.Collections.Generic;
    using System.Reflection;

    public interface IPropertyCache
    {
        IEnumerable<PropertyInfo> GetProperties(Type type);

        IEnumerable<PropertyInfo> GetReadOnlyProperties(Type type);

        IEnumerable<PropertyInfo> GetWriteOnlyProperties(Type type);
    }
}