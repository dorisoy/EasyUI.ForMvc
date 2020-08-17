<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

  <%= Html.EasyUI().Calendar()
          .Name("Calendar")
          .ClientEvents(e => e.OnLoad("onLoad"))
  %>
    <script type="text/javascript">

        var onLoadCalendar;

        function onLoad() {
            onLoadCalendar = $(this).data('tCalendar');
        }
    </script>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



        test('client object is available in on load', function() {
            ok(null !== onLoadCalendar);
            ok(undefined !== onLoadCalendar);
        });

</script>

</asp:Content>