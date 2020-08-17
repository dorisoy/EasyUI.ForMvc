




namespace EasyUI.Web.Mvc.UI
{
    using System;
    using System.Web.Mvc;
    using System.Web.Routing;
    using System.Collections.Generic;

    using EasyUI.Web.Mvc.Resources;
    using EasyUI.Web.Mvc.Extensions;


    public class InputBoxBase<T> : ViewComponentBase, IInputBox<T>, IInputComponent<T> where T : struct
    {
        internal readonly IInputBoxBaseHtmlBuilderFactory<T> rendererFactory;

        public InputBoxBase(ViewContext viewContext, IClientSideObjectWriterFactory clientSideObjectWriterFactory, IInputBoxBaseHtmlBuilderFactory<T> rendererFactory)
            : base(viewContext, clientSideObjectWriterFactory)
        {
            this.rendererFactory = rendererFactory;

            InputHtmlAttributes = new RouteValueDictionary();

            ClientEvents = new TextBoxBaseClientEvents();

            Enabled = true;
        }

        /// <summary>
        /// Gets the id.
        /// </summary>
        /// <value>The id.</value>
        public new string Id
        {
            get
            {
                // Return from htmlattributes if user has specified
                // otherwise build it from name
                return InputHtmlAttributes.ContainsKey("id") ?
                       InputHtmlAttributes["id"].ToString() :
                       (!string.IsNullOrEmpty(Name) ? Name.Replace(".", HtmlHelper.IdAttributeDotReplacement) : null);
            }
        }

        public IDictionary<string, object> InputHtmlAttributes
        {
            get;
            private set;
        }

        public T? Value
        {
            get;
            set;
        }

        public T IncrementStep
        {
            get;
            set;
        }

        public T? MinValue
        {
            get;
            set;
        }

        public T? MaxValue
        {
            get;
            set;
        }

        public int NegativePatternIndex
        {
            get;
            set;
        }

  
        public TextBoxBaseClientEvents ClientEvents
        {
            get;
            private set;
        }

        public bool Enabled
        {
            get;
            set;
        }


        public override void VerifySettings()
        {
            if (MinValue.HasValue && MaxValue.HasValue && Nullable.Compare<T>(MinValue, MaxValue) == 1)
            {
                throw new ArgumentException(TextResource.MinPropertyMustBeLessThenMaxProperty.FormatWith("MinValue", "MaxValue"));
            }

            base.VerifySettings();
        }

    }
}
