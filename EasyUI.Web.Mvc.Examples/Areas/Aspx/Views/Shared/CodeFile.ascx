<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<string>" %>
<pre><%:Model.Replace("\t", "    ")%></pre>
