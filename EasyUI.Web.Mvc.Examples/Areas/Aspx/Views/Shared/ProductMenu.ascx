<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%@ Import Namespace="EasyUI.Web.Mvc" %>
<% 
    Html.EasyUI().Menu()
          .Name("Menu")
          .BindTo("examples")
          .Render();
%>
