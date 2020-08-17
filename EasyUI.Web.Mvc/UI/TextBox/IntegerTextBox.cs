﻿




namespace EasyUI.Web.Mvc.UI
{
    using System;
    using System.Globalization;
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.Extensions;
    using EasyUI.Web.Mvc.Infrastructure;
    using EasyUI.Web.Mvc.Resources;

    public class IntegerTextBox : TextBoxBase<int>
    {
        public IntegerTextBox(ViewContext viewContext, IClientSideObjectWriterFactory clientSideObjectWriterFactory, ITextBoxBaseHtmlBuilderFactory<int> rendererFactory)
            : base(viewContext, clientSideObjectWriterFactory, rendererFactory)
        {
            ScriptFileNames.AddRange(new[] { "EasyUI.common.js", "EasyUI.textbox.js" });

            MinValue = int.MinValue;
            MaxValue = int.MaxValue;
            IncrementStep = 1;
            EmptyMessage = "Enter value";

            NumberGroupSize = CultureInfo.CurrentCulture.NumberFormat.NumberGroupSizes[0];
            NegativePatternIndex = CultureInfo.CurrentCulture.NumberFormat.NumberNegativePattern;
        }

        public override void WriteInitializationScript(System.IO.TextWriter writer)
        {
            IClientSideObjectWriter objectWriter = ClientSideObjectWriterFactory.Create(Id, "tTextBox", writer);

            objectWriter.Start();

            objectWriter.AppendObject("val", this.Value);
            objectWriter.Append("step", this.IncrementStep);
            objectWriter.AppendObject("minValue", this.MinValue);
            objectWriter.AppendObject("maxValue", this.MaxValue);
            objectWriter.Append("digits", 0);
            objectWriter.AppendNullableString("groupSeparator", this.NumberGroupSeparator);
            objectWriter.Append("groupSize", this.NumberGroupSize);
            objectWriter.Append("negative", this.NegativePatternIndex);
            objectWriter.Append("text", this.EmptyMessage);
            objectWriter.Append("type", "numeric");

            ClientEvents.SerializeTo(objectWriter);

            objectWriter.Complete();

            base.WriteInitializationScript(writer);
        }

        protected override void WriteHtml(System.Web.UI.HtmlTextWriter writer)
        {
            Guard.IsNotNull(writer, "writer");

            ITextBoxBaseHtmlBuilder renderer = rendererFactory.Create(this);

            IHtmlNode rootTag = renderer.Build("t-numerictextbox");

            rootTag.Children.Add(renderer.InputTag());

            if (Spinners)
            {
                rootTag.Children.Add(renderer.UpButtonTag());
                rootTag.Children.Add(renderer.DownButtonTag());
            }

            rootTag.WriteTo(writer);
            base.WriteHtml(writer);
        }

        public override void VerifySettings()
        {
            base.VerifySettings();

            if (NegativePatternIndex < 0 || NegativePatternIndex > 4)
            {
                throw new IndexOutOfRangeException(TextResource.PropertyShouldBeInRange.FormatWith("NegativePatternIndex", 0, 4));
            }
        }
    }
}