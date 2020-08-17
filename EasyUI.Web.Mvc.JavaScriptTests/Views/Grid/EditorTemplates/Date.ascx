<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<DateTime>" %>

<%= Html.EasyUI().DatePicker()
        .Name(ViewData.TemplateInfo.HtmlFieldPrefix)
        .Value(Model > DateTime.MinValue? Model : DateTime.Today)
%>