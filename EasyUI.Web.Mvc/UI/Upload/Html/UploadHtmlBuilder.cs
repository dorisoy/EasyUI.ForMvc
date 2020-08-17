﻿



using System.Web.Mvc;

namespace EasyUI.Web.Mvc.UI.Html
{
    /// <summary>
    /// An HTML Builder for the Upload component
    /// </summary>
    public class UploadHtmlBuilder : HtmlBuilderBase
    {
        private readonly Upload upload;

        /// <summary>
        /// Initializes a new instance of the <see cref="UploadHtmlBuilder" /> class.
        /// </summary>
        /// <param name="component">The Upload component.</param>
        public UploadHtmlBuilder(Upload component)
        {
            upload = component;
        }

        /// <summary>
        /// Creates the upload top-level div.
        /// </summary>
        /// <returns></returns>
        public IHtmlNode CreateUpload()
        {
            return new HtmlElement("div")
                .Attributes(upload.HtmlAttributes)
                .PrependClass(UIPrimitives.Widget, "t-upload");
        }

        public IHtmlNode CreateUploadButton()
        {
            return new HtmlElement("div")
                .AddClass(UIPrimitives.Upload.Button);
        }

        /// <summary>
        /// Creates the button text element.
        /// </summary>
        /// <returns></returns>
        public IHtmlNode CreateButtonText()
        {
            return new HtmlElement("span").Text(upload.Localization.Select);
        }

        /// <summary>
        /// Creates the file input element.
        /// </summary>
        /// <returns></returns>
        public IHtmlNode CreateFileInput()
        {
            var element = new HtmlElement("input", TagRenderMode.SelfClosing)
                .Attributes(new { type = "file", name = upload.Name, id = upload.Id });

            return element;
        }

        /// <summary>
        /// Builds the Upload component markup.
        /// </summary>
        /// <returns></returns>
        protected override IHtmlNode BuildCore()
        {
            var root = CreateUpload();
            var uploadButton = CreateUploadButton().AppendTo(root);
            CreateButtonText().AppendTo(uploadButton);
            CreateFileInput().AppendTo(uploadButton);

            return root;
        }
    }
}
