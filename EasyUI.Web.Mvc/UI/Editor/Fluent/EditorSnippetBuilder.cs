﻿// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI.Fluent
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using EasyUI.Web.Mvc.Extensions;
    using EasyUI.Web.Mvc.Infrastructure;

    public class EditorSnippetBuilder : IHideObjectMembers
    {
        private readonly IList<DropDownItem> items;
        private readonly IVirtualPathProvider provider;

        public EditorSnippetBuilder(IList<DropDownItem> items, IVirtualPathProvider provider)
        {
            Guard.IsNotNull(items, "items");
            this.provider = provider;
            this.items = items;
        }

        public EditorSnippetBuilder Add(string title, string snippet)
        {
            items.Add(new DropDownItem { Text = title, Value = snippet });

            return this;
        }

        public EditorSnippetBuilder AddFromFile(string title, string pathToSnippet)
        {
            items.Add(new DropDownItem { Text = title, Value = ReadFile(pathToSnippet) });

            return this;
        }

        private string ReadFile(string fileName)
        {
            if (fileName.IndexOf("://") < 0)
            {
                fileName = fileName.StartsWith("~/", StringComparison.OrdinalIgnoreCase) ? fileName : PathHelper.CombinePath(WebAssetDefaultSettings.StyleSheetFilesPath, fileName);
            }

            if (!fileName.StartsWith("~"))
            {
                fileName = string.Format("~/Content/{0}", fileName);
            }

            if (!provider.FileExists(fileName))
            {
                throw new FileNotFoundException(Resources.TextResource.SpecifiedFileDoesNotExist.FormatWith(fileName));
            }

            return provider.ReadAllText(fileName);
        }
    }
}