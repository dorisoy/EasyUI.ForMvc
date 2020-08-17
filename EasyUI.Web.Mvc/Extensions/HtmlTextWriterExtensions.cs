




namespace EasyUI.Web.Mvc.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.UI;
    using EasyUI.Web.Mvc.Infrastructure;

    public static class HtmlTextWriterExtensions
    {
        public static void AddAttributes(this HtmlTextWriter writer, IDictionary<string, object> attributes)
        {
            Guard.IsNotNull(writer, "writer");

            if (attributes.Any())
            {
                foreach (KeyValuePair<string, object> attribute in attributes)
                {
                    writer.AddAttribute(attribute.Key, attribute.Value.ToString(), true);
                }
            }
        }
    }
}