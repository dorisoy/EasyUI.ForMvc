<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage"%>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<%

    string culture = Request.QueryString["culture"] ?? "en-US";
    System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo(culture);

    Response.Write("<script type='text/javascript'>var culture='");
    Response.Write(culture);
    Response.Write("';</script>");
%>
    <h2>
        DateFormatting</h2>

    <script type="text/javascript">
        var $t;

        function date(year, month, day, hour, minute, second, millisecond) {
            var d = new Date();
            d.setFullYear(year);
            d.setMonth(month - 1);
            d.setDate(day);
            d.setHours(hour ? hour : 0, minute ? minute : 0, second ? second : 0, millisecond ? millisecond : 0);
            return d;
        }        
    
    
    </script>

    <ul>
        <li>Current culture:
            <%= System.Threading.Thread.CurrentThread.CurrentCulture.Name %></li>
        <li>Current UI culture:
            <%= System.Threading.Thread.CurrentThread.CurrentUICulture.Name %></li>
        <li>ShortDatePattern:
            <%= System.Globalization.DateTimeFormatInfo.CurrentInfo.ShortDatePattern %></li>
        <li>LongDatePattern:
            <%= System.Globalization.DateTimeFormatInfo.CurrentInfo.LongDatePattern%></li>
        <li>FullDateTimePattern:
            <%= System.Globalization.DateTimeFormatInfo.CurrentInfo.FullDateTimePattern%></li>
        <li>MonthDayPattern:
            <%= System.Globalization.DateTimeFormatInfo.CurrentInfo.MonthDayPattern%></li>
        <li>RFC1123:
            <%= System.Globalization.DateTimeFormatInfo.CurrentInfo.RFC1123Pattern%></li>
        <li>Sortable:
            <%= System.Globalization.DateTimeFormatInfo.CurrentInfo.SortableDateTimePattern%></li>
        <li>LongTimePattern:
            <%= System.Globalization.DateTimeFormatInfo.CurrentInfo.LongTimePattern%></li>
        <li>ShortTimePattern:
            <%= System.Globalization.DateTimeFormatInfo.CurrentInfo.ShortTimePattern%></li>

        <li>
            YearMonth:
            <%= System.Globalization.DateTimeFormatInfo.CurrentInfo.YearMonthPattern%>
        </li>
    </ul>
    <%
        Html.EasyUI().ScriptRegistrar().Globalization(true)
                            .DefaultGroup(group => group
                                .Add("easyui.common.js")
                                .Add("easyui.calendar.js")
                                .Add("easyui.datepicker.js")
                                .Add("easyui.grid.js"));

    %>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



        QUnit.testStart = function() {
            $t = $.easyui;
        }

        test('date formatting supports short date format', function() {
            var d = date(2000, 1, 30);

            equal($t.formatString("{0:d}", d), '<%= (new DateTime(2000, 1, 30)).ToString("d")  %>', culture);
        });
        
        test('date formatting supports long time pattern', function() {
            var d = date(2000, 1, 30);

            equal($t.formatString("{0:T}", d), '<%= (new DateTime(2000, 1, 30)).ToString("T")  %>', culture);
        });

        test('date formatting supports short time pattern', function() {
            var d = date(2000, 1, 30);

            equal($t.formatString("{0:t}", d), '<%= (new DateTime(2000, 1, 30)).ToString("t")  %>', culture);
        });

        test('date formatting supports long date format', function() {
            var d = date(2000, 1, 30);

            equal($t.formatString("{0:D}", d), '<%= (new DateTime(2000, 1, 30)).ToString("D")  %>', culture);
        });

        test('date formatting supports full date long time format', function() {
            var d = date(2000, 1, 30, 13, 9, 9);

            equal($t.formatString("{0:F}", d), '<%= (new DateTime(2000, 1, 30, 13, 9, 9)).ToString("F")  %>', culture);
        });


        test('date formatting supports zero padded days', function() {
            var d = date(2000, 1, 1);

            equal($t.formatString("{0:M/dd/yyyy}", d), '<%= (new DateTime(2000, 1, 1)).ToString("M/dd/yyyy")  %>', culture);
        });

        test('date formatting supports zero padded months', function() {
            var d = date(2000, 1, 1);

            equal($t.formatString("{0:MM/dd/yyyy}", d), '<%= (new DateTime(2000, 1, 1)).ToString("MM/dd/yyyy")  %>', culture);
        });

        test('date formatting supports abbr day names', function() {
            var d = date(2000, 1, 1);

            equal($t.formatString("{0:MM/ddd/yyyy}", d), '<%= (new DateTime(2000, 1, 1)).ToString("MM/ddd/yyyy")  %>', culture);
        });

        test('date formatting supports day names', function() {
            var d = date(2000, 1, 1);

            equal($t.formatString("{0:MM/dddd/yyyy}", d), '<%= (new DateTime(2000, 1, 1)).ToString("MM/dddd/yyyy")  %>', culture);
        });

        test('date formatting supports abbr month names', function() {
            var d = date(2000, 1, 1);
            equal($t.formatString("{0:MMM/dddd/yyyy}", d), '<%= (new DateTime(2000, 1, 1)).ToString("MMM/dddd/yyyy")  %>', culture);
        });

        test('date formatting supports month names', function() {
            var d = date(2000, 1, 1);
            equal($t.formatString("{0:MMMM/dddd/yyyy}", d), '<%= (new DateTime(2000, 1, 1)).ToString("MMMM/dddd/yyyy")  %>', culture);
        });

        test('date formatting supports yy', function() {
            var d = date(2000, 1, 1);
            equal($t.formatString("{0:MMMM/dddd/yy}", d), '<%= (new DateTime(2000, 1, 1)).ToString("MMMM/dddd/yy")  %>', culture);
        });

        test('date formatting supports h before 12', function() {
            var d = date(2000, 1, 1, 1);
            equal($t.formatString("({0:h})", d), '<%= (new DateTime(2000, 1, 1, 1, 0, 0)).ToString("(h)")  %>', culture);
        });

        test('date formatting supports h after 12', function() {
            var d = date(2000, 1, 1, 13);
            equal($t.formatString("({0:h})", d), '<%= (new DateTime(2000, 1, 1, 13, 0, 0)).ToString("(h)")  %>', culture);
        });

        test('date formatting supports hh before 12', function() {
            var d = date(2000, 1, 1, 1);
            equal($t.formatString("({0:hh})", d), '<%= (new DateTime(2000, 1, 1, 1, 0, 0)).ToString("(hh)")  %>', culture);
        });

        test('date formatting supports hh after 12', function() {
            var d = date(2000, 1, 1, 13);
            equal($t.formatString("({0:hh})", d), '<%= (new DateTime(2000, 1, 1, 13, 0, 0)).ToString("(hh)")  %>', culture);
        });

        test('date formatting supports minutes', function() {
            var d = date(2000, 1, 1, 1);
            equal($t.formatString("({0:hh:m})", d), '<%= (new DateTime(2000, 1, 1, 1, 0, 0)).ToString("(hh:m)")  %>', culture);
        });

        test('date formatting supports zero padded minutes', function() {
            var d = date(2000, 1, 1, 1, 1);
            equal($t.formatString("({0:hh:mm})", d), '<%= (new DateTime(2000, 1, 1, 1, 1, 0)).ToString("(hh:mm)")  %>', culture);
        });

        test('date formatting supports seconds', function() {
            var d = date(2000, 1, 1, 1, 1, 1);
            equal($t.formatString("({0:hh:mm:s})", d), '<%= (new DateTime(2000, 1, 1, 1, 1, 1)).ToString("(hh:mm:s)")  %>', culture);
        });

        test('date formatting supports zero padded seconds', function() {
            var d = date(2000, 1, 1, 1, 1, 1);
            equal($t.formatString("({0:hh:mm:ss})", d), '<%= (new DateTime(2000, 1, 1, 1, 1, 1)).ToString("(hh:mm:ss)")  %>', culture);
        });

        test('date formatting supports tt before 12', function() {
            var d = date(2000, 1, 1, 1, 1, 1);
            equal($t.formatString("({0:tt})", d), '<%= (new DateTime(2000, 1, 1, 1, 1, 1)).ToString("(tt)")  %>', culture);
        });

        test('date formatting supports tt after 12', function() {
            var d = date(2000, 1, 1, 13, 1, 1);
            equal($t.formatString("({0:tt})", d), '<%= (new DateTime(2000, 1, 1, 13, 1, 1)).ToString("(tt)")  %>', culture);
        });

        test('date formatting supports f more than 99', function() {
            var d = date(2000, 1, 1, 1, 1, 1, 100);
            equal($t.formatString("{0:hh:mm:f}", d), '<%= (new DateTime(2000, 1, 1, 1, 1, 1, 100)).ToString("hh:mm:f")  %>', culture);
        });

        test('date formatting supports f less than 100', function() {
            var d = date(2000, 1, 1, 1, 1, 1, 99);
            equal($t.formatString("{0:hh:mm:f}", d), '<%= (new DateTime(2000, 1, 1, 1, 1, 1, 99)).ToString("hh:mm:f")  %>', culture);
        });

        test('date formatting supports ff', function() {
            var d = date(2000, 1, 1, 1, 1, 1, 129);
            equal($t.formatString("{0:hh:mm:ff}", d), '<%= (new DateTime(2000, 1, 1, 1, 1, 1, 129)).ToString("hh:mm:ff")  %>', culture);
        });

        test('date formatting supports fff', function() {
            var d = date(2000, 1, 1, 1, 1, 1, 129);
            equal($t.formatString("({0:fff})", d), '<%= (new DateTime(2000, 1, 1, 1, 1, 1, 129)).ToString("(fff)")  %>', culture);
        });

        test('date formatting supports H', function() {
            var d = date(2000, 1, 1, 1);
            equal($t.formatString("({0:H})", d), '<%= (new DateTime(2000, 1, 1, 1, 1, 0)).ToString("(H)")  %>', culture);
        });

        test('date formatting supports HH less than 10', function() {
            var d = date(2000, 1, 1, 9);
            equal($t.formatString("({0:HH})", d), '<%= (new DateTime(2000, 1, 1, 9, 1, 0)).ToString("(HH)")  %>', culture);
        });

        test('date formatting supports single quote literals', function() {
            var d = date(2000, 1, 1, 9);
            equal($t.formatString("({0:'literal'})", d), '<%= (new DateTime(2000, 1, 1, 9, 1, 0)).ToString("(\'literal\')")  %>', culture);
        });

        test('date formatting supports quote literals', function() {
            var d = date(2000, 1, 1, 9);
            equal($t.formatString("({0:\"literal\"})", d), '<%= (new DateTime(2000, 1, 1, 9, 1, 0)).ToString("(\"literal\")")  %>', culture);
        });

        test('date formatting supports g format', function() {
            var d = date(2000, 12, 30, 9, 1);
            equal($t.formatString("{0:g}", d), '<%= (new DateTime(2000, 12, 30, 9, 1, 0)).ToString("g") %>', culture);
        });

        test('date formatting supports G format', function() {
            var d = date(2000, 12, 30, 9, 1);
            equal($t.formatString("{0:G}", d), '<%= (new DateTime(2000, 12, 30, 9, 1, 0)).ToString("G") %>', culture);
        });

        test('date formatting supports m format', function() {
            var d = date(2000, 12, 30, 9, 1);
            equal($t.formatString("{0:m}", d), '<%= (new DateTime(2000, 12, 30, 9, 1, 0)).ToString("m") %>', culture);
        });

        test('date formatting supports M format', function() {
            var d = date(2000, 12, 30, 9, 1);
            equal($t.formatString("{0:M}", d), '<%= (new DateTime(2000, 12, 30, 9, 1, 0)).ToString("M") %>', culture);
        });

        test('date formatting supports s format', function() {
            var d = date(2000, 12, 30, 9, 1);
            equal($t.formatString("{0:s}", d), '<%= (new DateTime(2000, 12, 30, 9, 1, 0)).ToString("s") %>', culture);
        });
        
        test('date formatting supports u format', function() {
            var d = date(2000, 12, 30, 9, 1);
            equal($t.formatString("{0:u}", d), '<%= (new DateTime(2000, 12, 30, 9, 1, 0)).ToString("u") %>', culture);
        });
        
        test('date formatting supports y format', function() {
            var d = date(2000, 12, 30, 9, 1);
            equal($t.formatString("{0:y}", d), '<%= (new DateTime(2000, 12, 30, 9, 1, 0)).ToString("y") %>', culture);
        });
        
        test('date formatting supports Y format', function() {
            var d = date(2000, 12, 30, 9, 1);
            equal($t.formatString("{0:Y}", d), '<%= (new DateTime(2000, 12, 30, 9, 1, 0)).ToString("y") %>', culture);
        });

</script>

</asp:Content>