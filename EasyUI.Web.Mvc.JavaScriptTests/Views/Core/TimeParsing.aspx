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
        NumberFormatting</h2>

    <script type="text/javascript">
        var $t;
        
        function isValidDate(expected, result) {
            var isValid = true;

            if (expected.year() != result.year())
                isValid = false;
            else if (expected.month() != result.month())
                isValid = false;
            else if (expected.date() != result.date())
                isValid = false;

            return isValid;
        }

    </script>

    <ul>
        <li>Current culture:
            <%= System.Threading.Thread.CurrentThread.CurrentCulture.Name %></li>
        <li>Current UI culture:
            <%= System.Threading.Thread.CurrentThread.CurrentUICulture.Name %></li>
        </ul>
    <%
        Html.EasyUI().ScriptRegistrar().Globalization(true)
                            .DefaultGroup(group => group
                                .Add("easyui.common.js"));

    %>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



        QUnit.testStart = function() {
            $t = $.easyui;
        }

        test('time parsing supports short time format', function() {
            var dateToModify = new $t.datetime(2000, 1, 20, 10, 0, 20);
            var value = '<%= new DateTime(2000, 1, 20, 22, 20, 20).ToString("t") %>';

            var result = $t.datetime.parse({ value: value, format: "t", baseDate: dateToModify });

            ok(isValidDate(dateToModify, result), 'date is not same');
            equal(result.hours(), 22, culture + "-hours");
            equal(result.minutes(), 20, culture + "-minutes");
            if($t.cultureInfo.shortTime.indexOf('ss') == -1)
                equal(result.seconds(), 0, culture + "-seconds");
        });

        test('time parsing should parse 12 PM with short time format', function() {
            var dateToModify = new $t.datetime(2000, 1, 10, 15, 15, 0);
            var value = '<%= new DateTime(2000, 1, 10, 12, 15, 0).ToString("t") %>';

            var result = $t.datetime.parse({ value: value, format: "t", baseDate: dateToModify });

            ok(isValidDate(dateToModify, result), 'date is not same');
            equal(result.hours(), 12, culture + "-hours");
            equal(result.minutes(), 15, culture + "-minutes");
        });

        test('time parsing should parse 12 AM with short time format', function() {
            var dateToModify = new $t.datetime(2000, 1, 10, 15, 15, 0);
            var value = '<%= new DateTime(2000, 1, 10, 0, 15, 0).ToString("t") %>';
            
            var result = $t.datetime.parse({ value: value, format: "t", baseDate: dateToModify });

            ok(isValidDate(dateToModify, result), 'date is not same');
            equal(result.hours(), 0, culture + "-hours");
            equal(result.minutes(), 15, culture + "-minutes");
        });

        test('time parsing supports long time format', function() {
            var dateToModify = new $t.datetime(2000, 1, 20, 10, 0, 20);
            var value = '<%= new DateTime(2000, 1, 20, 18, 0, 30).ToString("T") %>';

            var result = $t.datetime.parse({ value: value, format: "T", baseDate: dateToModify });

            ok(isValidDate(dateToModify, result), 'date is not same');
            equal(result.hours(), 18, culture + "-hours");
            equal(result.minutes(), 0, culture + "-minutes");
            equal(result.seconds(), 30, culture + "-seconds");
        });

        test('time parsing should parse morning hours using short time format', function() {
            var dateToModify = new $t.datetime(2000, 1, 20, 10, 0, 20);
            var value = '<%= new DateTime(2000, 1, 20, 9, 30, 0).ToString("t") %>';

            var result = $t.datetime.parse({ value: value, format: "t", baseDate: dateToModify });

            ok(isValidDate(dateToModify, result), 'date is not same');
            equal(result.hours(), 9, culture + "-hours");
            equal(result.minutes(), 30, culture + "-minutes");
            equal(result.seconds(), 0, culture + "-seconds");
        });

        test('time parsing should parse morning hours using long time format', function() {
            var dateToModify = new $t.datetime(2000, 1, 20, 10, 0, 20);
            var value = '<%= new DateTime(2000, 1, 20, 9, 0, 30).ToString("T") %>';

            var result = $t.datetime.parse({ value: value, format: "T", baseDate: dateToModify });

            ok(isValidDate(dateToModify, result), 'date is not same');
            equal(result.hours(), 9, culture + "-hours");
            equal(result.minutes(), 0, culture + "-minutes");
            equal(result.seconds(), 30, culture + "-seconds");
        });

        test('time parsing should parse 24 and return 0 hour', function() {
            var dateToModify = new $t.datetime(2000, 1, 20, 10, 0, 20);
            var value = "24:00"
            
            var result = $t.datetime.parse({ value: value, format: "H:mm", baseDate: dateToModify });

            equal(result, null, culture);
        });

        test('time parsing should parse 23 59', function() {
            var dateToModify = new $t.datetime(2000, 1, 20, 10, 0, 20);
            var value = "23:59"
            
            var result = $t.datetime.parse({ value: value, format: "H:mm", baseDate: dateToModify });

            ok(isValidDate(dateToModify, result), 'date is not same');
            equal(result.hours(), 23, culture + "-hours");
            equal(result.minutes(), 59, culture + "-minutes");
            equal(result.seconds(), 0, culture + "-seconds");
        });

        test('time parsing should parse using H mm', function() {
            var dateToModify = new $t.datetime(2000, 1, 20, 10, 0, 20);
            var value = "13:22";

            var result = $t.datetime.parse({ value: value, format: "H:mm", baseDate: dateToModify });

            ok(isValidDate(dateToModify, result), 'date is not same');
            equal(result.hours(), 13, culture + "-hours");
            equal(result.minutes(), 22, culture + "-minutes");
            equal(result.seconds(), 0, culture + "-seconds");
        });

        test('time parsing should parse with seconds using H mm tt', function() {
            var dateToModify = new $t.datetime(2000, 1, 20, 10, 0, 20);
            var value = "4:22:22 PM";

            var result = $t.datetime.parse({ value: value, format: "H:mm tt", baseDate: dateToModify });

            ok(isValidDate(dateToModify, result), 'date is not same');
            equal(result.hours(), 16, culture + "-hours");
            equal(result.minutes(), 22, culture + "-minutes");
            equal(result.seconds(), 0, culture + "-seconds");
        });

        test('time parsing should parse without seconds using H mm tt', function() {
            var dateToModify = new $t.datetime(2000, 1, 20, 10, 0, 20);
            var value = "4:22 PM";

            var result = $t.datetime.parse({ value: value, format: "H:mm tt", baseDate: dateToModify });

            ok(isValidDate(dateToModify, result), 'date is not same');
            equal(result.hours(), 16, culture + "-hours");
            equal(result.minutes(), 22, culture + "-minutes");
            equal(result.seconds(), 0, culture + "-seconds");
        });

        test('time parsing should parse with seconds using H mm ss tt', function() {
            var dateToModify = new $t.datetime(2000, 1, 20, 10, 0, 20);
            var value = "4:22:22 PM";

            var result = $t.datetime.parse({ value: value, format: "H:mm:ss tt", baseDate: dateToModify });

            ok(isValidDate(dateToModify, result), 'date is not same');
            equal(result.hours(), 16, culture + "-hours");
            equal(result.minutes(), 22, culture + "-minutes");
            equal(result.seconds(), 22, culture + "-seconds");
        });

        test('time parsing should parse without seconds using H mm ss tt', function() {
            var dateToModify = new $t.datetime(2000, 1, 20, 10, 0, 20);
            var value = "4:22 " + $t.cultureInfo.pm;

            var result = $t.datetime.parse({ value: value, format: "H:mm:ss tt", baseDate: dateToModify });

            ok(isValidDate(dateToModify, result), 'date is not same');
            equal(result.hours(), 16, culture + "-hours");
            equal(result.minutes(), 22, culture + "-minutes");
            equal(result.seconds(), 0, culture + "-seconds");
        });

        test('time parsing should parse H mm ss', function() {
            var dateToModify = new $t.datetime(2000, 1, 20, 10, 0, 20);
            var value = "22:10:22";
            
            var result = $t.datetime.parse({ value: value, format: "H:mm:ss", baseDate: dateToModify });

            ok(isValidDate(dateToModify, result), 'date is not same');
            equal(result.hours(), 22, culture + "-hours");
            equal(result.minutes(), 10, culture + "-minutes");
            equal(result.seconds(), 22, culture + "-seconds");
        });

        test('time parsing not fully typed hours and minutes', function() {
            var dateToModify = new $t.datetime(2000, 1, 20, 10, 0, 20);
            var value = "::22";

            var result = $t.datetime.parse({ value: value, format: "H:mm:ss", baseDate: dateToModify });

            ok(isValidDate(dateToModify, result), 'date is not same');
            equal(result.hours(), 0, culture + "-hours");
            equal(result.minutes(), 0, culture + "-minutes");
            equal(result.seconds(), 22, culture + "-seconds");
        });

        test('time parsing should parse using H mm ss f time format', function() {
            var dateToModify = new $t.datetime(2000, 1, 20, 10, 0, 20);
            var value = "10:10:22.6";

            var result = $t.datetime.parse({ value: value, format: "H:mm:ss.f", baseDate: dateToModify });

            ok(isValidDate(dateToModify, result), 'date is not same');
            equal(result.hours(), 10, culture + "-hours");
            equal(result.minutes(), 10, culture + "-minutes");
            equal(result.seconds(), 22, culture + "-seconds");
            equal(result.milliseconds(), 6, culture + "-milliseconds");
        });

        test('time parsing should parse using H mm ss ff time format', function() {
            var dateToModify = new $t.datetime(2000, 1, 20, 10, 0, 20);
            var value = "10:10:22.67";

            var result = $t.datetime.parse({ value: value, format: "H:mm:ss.ff", baseDate: dateToModify });

            ok(isValidDate(dateToModify, result), 'date is not same');
            equal(result.hours(), 10, culture + "-hours");
            equal(result.minutes(), 10, culture + "-minutes");
            equal(result.seconds(), 22, culture + "-seconds");
            equal(result.milliseconds(), 67, culture + "-milliseconds");
        });

        test('time parsing should parse using H mm ss fff time format', function() {
            var dateToModify = new $t.datetime(2000, 1, 20, 10, 0, 20);
            var value = "10:10:22.6741";

            var result = $t.datetime.parse({ value: value, format: "H:mm:ss.fff", baseDate: dateToModify });

            ok(isValidDate(dateToModify, result), 'date is not same');
            equal(result.hours(), 10, culture + "-hours");
            equal(result.minutes(), 10, culture + "-minutes");
            equal(result.seconds(), 22, culture + "-seconds");
            equal(result.milliseconds(), 674, culture + "-milliseconds");
        });

</script>

</asp:Content>