<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>

<%: Html.EasyUI().DropDownList()
        .Name("Employee")
        .BindTo(new SelectList((IEnumerable)ViewData["employees"], "Id", "Name"))
%>