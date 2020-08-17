﻿<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<string>" %>

    <%: Html.EasyUI().Editor()
            .Name(ViewData.TemplateInfo.GetFullHtmlFieldName(string.Empty))
            .Value(Model)
            .Tools(tools => tools
                .Clear()
                .Bold().Italic().Underline()
                .Separator()
                .CreateLink().Unlink()
            )
    %>