<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" Culture="da-DK" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2>Globalization</h2>
    
    <script type="text/javascript">

        function getDateTimePicker() {
            return $('#DateTimePicker').data('tDateTimePicker');
        }

    </script>
    
    <%= Html.EasyUI().DateTimePicker()
            .Name("DateTimePicker")
            .HtmlAttributes(new { style = "width:300px" })
            .Effects(e => e.Toggle()) 
    %>

    <% Html.EasyUI().ScriptRegistrar().Globalization(true); %>

</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

        test('timeFormat property should be set to cultureInfo.shortTime by default', function() {
            var dateTimePicker = getDateTimePicker();
            equal(dateTimePicker.timeFormat, $.easyui.cultureInfo.shortTime, 'timeFormat');
        });

</script>

</asp:Content>