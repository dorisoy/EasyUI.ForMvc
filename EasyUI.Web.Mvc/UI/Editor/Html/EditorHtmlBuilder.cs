﻿




namespace EasyUI.Web.Mvc.UI.Html
{
    using System.Linq;
    using EasyUI.Web.Mvc.Infrastructure;
    using EasyUI.Web.Mvc.UI;

    public class EditorHtmlBuilder : HtmlBuilderBase
    {
        private readonly Editor editor;

        public EditorHtmlBuilder(Editor component)
        {
            this.editor = component;
        }

        public IHtmlNode CreateEditor()
        {
            return new HtmlElement("table")
                    .Attributes(new { id = editor.Id, cellspacing = "4", cellpadding = "0" })
                    .Attributes(editor.HtmlAttributes)
                    .PrependClass(UIPrimitives.Widget, "t-editor", UIPrimitives.Header);
        }

        public IHtmlNode CreateTextArea()
        {
            var content = new HtmlElement("textarea")
                            .Attributes(new
                            {
                                cols = "20",
                                rows = "5",
                                name = editor.Name,
                                id = editor.Id + "-value"
                            })
                            .Attributes(editor.GetUnobtrusiveValidationAttributes())
                            .PrependClass(UIPrimitives.Content, UIPrimitives.Editor.RawContent);

            var value = editor.GetValue<string>(editor.Value);

            if (!string.IsNullOrEmpty(value))
            {
                content.Text(value);
            }
            else if (editor.Content != null)
            {
                editor.Template.Apply(content);
            }
            else if (editor.Template.InlineTemplate != null)
            {
                content.Text(editor.Template.InlineTemplate(null).ToString());
            }

            return content;
        }

        private IHtmlNode CreateToolBar()
        {
            return new EditorToolGroupHtmlBuilder(editor.DefaultToolGroup)
                .Build();
        }
        
        protected override IHtmlNode BuildCore()
        {
            var root = CreateEditor();

            var toolbarRow = new HtmlElement("tr").AppendTo(root);

            if (editor.DefaultToolGroup.Tools.Any())
            {
                CreateToolBar().AppendTo(new HtmlElement("td").AddClass("t-editor-toolbar-wrap").AppendTo(toolbarRow));
            }

            var editableCell = new HtmlElement("td")
                .AddClass("t-editable-area")
                .ToggleClass("input-validation-error", !editor.IsValid())
                .AppendTo(new HtmlElement("tr").AppendTo(root));

            var textarea = CreateTextArea();
            textarea.AppendTo(editableCell);
            
            var script = new HtmlElement("script")
                            .Attribute("type", "text/javascript")
                            .Html("document.getElementById('" + textarea.Attribute("id") + "').style.display='none'");

            script.AppendTo(editableCell);

            return root;
        }
    }
}
