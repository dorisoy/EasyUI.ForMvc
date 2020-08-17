<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<TextBoxFirstLookModelView>" %>
<asp:content contentPlaceHolderID="MainContent" runat="server">

<div class="t-rtl">
    <%: Html.EasyUI().NumericTextBox()
            .Name("NumericTextBox")
            .HtmlAttributes(new { @class = "t-numerictextbox-rtl" })
            .Value(42) 
    %>
    <br /><br />
    <%: Html.EasyUI().CurrencyTextBox()
            .Name("CurrencyTextBox")
            .HtmlAttributes(new { @class = "t-numerictextbox-rtl" })
            .Value(42)
    %>
    <br /><br />
    <%: Html.EasyUI().PercentTextBox()
            .Name("PercentTextBox")
            .HtmlAttributes(new { @class = "t-numerictextbox-rtl" })
            .Value(42)
    %>
    <br /><br />
    <%: Html.EasyUI().IntegerTextBox()
            .Name("IntegerTextBox")
            .HtmlAttributes(new { @class = "t-numerictextbox-rtl" })
            .Value(42)
%>
</div>

</asp:content>

<asp:content contentPlaceHolderID="HeadContent" runat="server">
</asp:content>