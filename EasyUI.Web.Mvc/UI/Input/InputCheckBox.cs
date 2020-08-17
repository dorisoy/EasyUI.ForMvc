using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Globalization;
using System.Web.Mvc;
using EasyUI.Web.Mvc.Extensions;
using EasyUI.Web.Mvc.Infrastructure;
using EasyUI.Web.Mvc.Resources;


namespace EasyUI.Web.Mvc.UI.Input
{
    public class InputCheckBox<T> : InputBoxBase<T> where T : struct
    {
        public InputCheckBox(ViewContext viewContext, IClientSideObjectWriterFactory clientSideObjectWriterFactory, IInputBoxBaseHtmlBuilderFactory<T> rendererFactory)
           : base(viewContext, clientSideObjectWriterFactory, rendererFactory)
        {
            ScriptFileNames.AddRange(new[] { "EasyUI.common.js", "EasyUI.textbox.js" });

        }
    }
}
