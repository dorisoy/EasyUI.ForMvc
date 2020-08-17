<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div style="position:relative; z-index: 10">
      <%= Html.EasyUI().DatePicker()
              .Name("DatePicker1")
      %>
    </div>

    <%= Html.EasyUI().DatePicker()
        .Name("DatePicker2") 
        .HtmlAttributes(new { style="position: relative"})
            %>

    <script type="text/javascript">
    </script>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



    test('popup inherits zIndex from component', function () {
        var datepicker = $('#DatePicker2').data('tDatePicker');
        var $wrapper = datepicker.$wrapper.css('z-index', 42);

        datepicker.open();

        var popupZIndex = $('.t-datepicker-calendar').parent().css('z-index');

        equal(parseInt(popupZIndex, 10), 43);

        $wrapper.css('z-index', 'auto');
    });

        test('popup inherits zIndex from parent container when component zIndex is not set', function() {
            var datepicker = $('#DatePicker1').data('tDatePicker');

            datepicker.showPopup();

            var popupZIndex = $('.t-datepicker-calendar').parent().css('z-index');

            equal(parseInt(popupZIndex, 10), 11);
        });

</script>

</asp:Content>