<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>

<%: Html.EasyUI().DropDownList()
    .Name(ViewData.TemplateInfo.GetFullHtmlFieldName(""))
    .BindTo((SelectList)ViewData[ViewData.TemplateInfo.GetFullHtmlFieldName("") + "_Data"])
%>