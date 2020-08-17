﻿// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI.Html
{
    using System;
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.Infrastructure;

    public class GridEditFormBuilder : IGridEditFormBuilder
    {
        private readonly IGridFormBuilder formBuilder;

        private readonly Func<IHtmlNode> editorBuilder;

        private readonly IEnumerable<Func<IHtmlNode>> buttonBuilders;

        public GridEditFormBuilder(IGridFormBuilder formBuilder, Func<IHtmlNode> editorBuilder, IEnumerable<Func<IHtmlNode>> buttonBuilders)
        {
            this.buttonBuilders = buttonBuilders;
            this.editorBuilder = editorBuilder;
            this.formBuilder = formBuilder;
        }

        public IHtmlNode CreateForm()
        {
            var form = formBuilder.CreateForm();

            AppendEditor(form);

            return form;
        }

        private void AppendButtons(IHtmlNode form)
        {
            foreach (var buttonBuilder in buttonBuilders)
            {
                var button = buttonBuilder();

                button.AppendTo(form);
            }
        }

        private void AppendEditor(IHtmlNode form)
        {
            var container = new HtmlElement("div").AddClass(UIPrimitives.Grid.InFormContainer);
            container.AppendTo(form);

            var editor = editorBuilder();

            editor.AppendTo(container);

            AppendButtons(container);
        }
    }
}
