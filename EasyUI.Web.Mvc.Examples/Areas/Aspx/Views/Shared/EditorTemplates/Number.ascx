<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<double?>" %>

<%: Html.EasyUI().NumericTextBoxFor(m => m)
        .InputHtmlAttributes(new { style = "width:100%" })
%>
