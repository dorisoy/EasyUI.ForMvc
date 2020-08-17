<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:content contentplaceholderid="MainContent" runat="server">

<div class="section">
    <%: Html.EasyUI().NumericTextBox()
            .Name("NumericTextBox")
            .Value(1234.12)
            .MinValue(-10000)
            .MaxValue(10000)
    %>

    <%: Html.EasyUI().CurrencyTextBox()
            .Name("CurrencyTextBox")
            .Value(1234.12m)
            .MinValue(-10000)
            .MaxValue(10000)
    %>

    <%: Html.EasyUI().PercentTextBox()
            .Name("PercentTextBox")
            .Value(87.12)
            .MinValue(-10000)
            .MaxValue(10000)
    %>
</div>

<% Html.RenderPartial("CulturePicker"); %>

<% Html.EasyUI().ScriptRegistrar().Globalization(true); %>

</asp:content>

<asp:content contentplaceholderid="HeadContent" runat="server">
    <style type="text/css">
        .section,
        .configurator
        {
            float: left;
            margin: 0 200px 1.3em 0;
            width: 200px;
        }
        
        .example .t-numerictextbox
        {
            margin-bottom: 1.3em;
        }
    </style>
</asp:content>
