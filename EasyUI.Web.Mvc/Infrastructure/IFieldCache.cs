




namespace EasyUI.Web.Mvc.Infrastructure
{
    using System;
    using System.Collections.Generic;
    using System.Reflection;

    public interface IFieldCache
    {
        IEnumerable<FieldInfo> GetFields(Type type);
    }
}