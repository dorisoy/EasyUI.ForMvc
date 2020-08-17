<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <%= Html.EasyUI().Calendar()
            .Name("Calendar1")
    %>

    <%= Html.EasyUI().Calendar()
            .Name("Calendar2")
            .MinDate(new DateTime(2010, 10, 1))
            .Value(new DateTime(2010, 10, 1))
    %>

    <%= Html.EasyUI().Calendar()
            .Name("Calendar3")
            .MaxDate(new DateTime(2010, 10, 30))
            .Value(new DateTime(2010, 10, 1))
    %>

    <script type="text/javascript">

        function getCalendar(selector) {
            return $(selector || "#Calendar1").data("tCalendar");
        }
    
    </script>

</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



        test('calendar should render previous button', function() {
            var calendar = getCalendar();
            
            ok($('.t-header .t-link', calendar.element).hasClass('t-nav-prev'));
        });

        test('calendar should render disable previous button', function() {
            var calendar = getCalendar("#Calendar2");

            ok($('.t-header .t-nav-prev', calendar.element).hasClass('t-state-disabled'));
        });

        test('calendar should render navigation button', function() {
            var calendar = getCalendar();

            ok($('.t-header .t-link', calendar.element).hasClass('t-nav-fast'));
        });

        test('calendar should render next button', function() {
            var calendar = getCalendar();

            ok($('.t-header .t-link', calendar.element).hasClass('t-nav-next'));
        });

        test('calendar should render disable next button', function() {
            var calendar = getCalendar("#Calendar3");

            ok($('.t-header .t-nav-next', calendar.element).hasClass('t-state-disabled'));
        });

</script>

</asp:Content>