<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

  <%= Html.EasyUI().Calendar()
          .Name("Calendar")
  %>
  
<script type="text/javascript">
    function getCalendar() {
        return $("#Calendar").data('tCalendar');
    }
</script>
</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

    test('Value method should put in range viewedMonth if focusedDate is out of range', function () {
        var today = new Date();
        today.setDate(today.getDate());
        var calendar = getCalendar();
        //calendar.maxDate = today;
        calendar.value(2018,3,17);
        equal(calendar.viewedMonth.year(), today.getFullYear(), "viewedMonth is not defined correctly");
        equal(calendar.viewedMonth.month(),3, "viewedMonth is not defined correctly");
        equal(calendar.viewedMonth.date(), 1, "viewedMonth is not defined correctly");
    });

    test('isInRange 方法只对比日期,没有时间部分', function () {
        var min = new Date(1900,0,1);
        var max = new Date();
        var today = new Date();
        today.setHours(max.getHours() + 1);
        ok($.easyui.calendar.isInRange(today, min, max), "比较不正确");
        ok($.easyui.calendar.isInRange(new Date(2018, 3, 18), new Date(1900, 0, 1), new Date(2018, 5, 1)), "比较正确,指定日期在范围内");
    });
</script>

</asp:Content>