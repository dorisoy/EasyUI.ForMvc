<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage"%>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<%

    string culture = Request.QueryString["culture"] ?? "en-US";
    System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo(culture);

    Response.Write("<script type='text/javascript'>var culture='");
    Response.Write(culture);
    Response.Write("';</script>");
%>

<ul>
    <li><%= .5.ToString("#,###.00") %></li>
    <li><%= 0.5.ToString("#,###.00") %></li>
    <li><%= 0.ToString("#,###.00") %></li>
</ul>

    <h2>
        NumberFormatting</h2>

    <script type="text/javascript">
        var $t;

        //custom formating;
    </script>

    <ul>
        <li>Current culture:
            <%= System.Threading.Thread.CurrentThread.CurrentCulture.Name %></li>
        <li>Current UI culture:
            <%= System.Threading.Thread.CurrentThread.CurrentUICulture.Name %></li>
        <li>
            Currency info!
        </li>
        <li>CurrencyDecimalDigits:
            <%= System.Globalization.NumberFormatInfo.CurrentInfo.CurrencyDecimalDigits %></li>
        <li>CurrencyDecimalSeparator:
            <%= System.Globalization.NumberFormatInfo.CurrentInfo.CurrencyDecimalSeparator%></li>
        <li>CurrencyGroupSeparator:
            <%= System.Globalization.NumberFormatInfo.CurrentInfo.CurrencyGroupSeparator%></li>
        <li>CurrencyGroupSizes:
            <%= System.Globalization.NumberFormatInfo.CurrentInfo.CurrencyGroupSizes%></li>
        <li>CurrencyNegativePattern:
            <%= System.Globalization.NumberFormatInfo.CurrentInfo.CurrencyNegativePattern%></li>
        <li>CurrencyPositivePattern:
            <%= System.Globalization.NumberFormatInfo.CurrentInfo.CurrencyPositivePattern%></li>
        <li>
            CurrencySymbol:
            <%= System.Globalization.NumberFormatInfo.CurrentInfo.CurrencySymbol%>
        </li>
        <li>
            Number info!
        </li>
        <li>NumberDecimalDigits:
            <%= System.Globalization.NumberFormatInfo.CurrentInfo.NumberDecimalDigits %></li>
        <li>NumberDecimalSeparator:
            <%= System.Globalization.NumberFormatInfo.CurrentInfo.NumberDecimalSeparator%></li>
        <li>NumberGroupSeparator:
            <%= System.Globalization.NumberFormatInfo.CurrentInfo.NumberGroupSeparator%></li>
        <li>NumberGroupSizes:
            <%= System.Globalization.NumberFormatInfo.CurrentInfo.NumberGroupSizes%></li>
        <li>NumberNegativePattern:
            <%= System.Globalization.NumberFormatInfo.CurrentInfo.NumberNegativePattern%></li>
        <li>
            Percent info!
        </li>
        <li>PercentDecimalDigits:
            <%= System.Globalization.NumberFormatInfo.CurrentInfo.PercentDecimalDigits %></li>
        <li>PercentDecimalSeparator:
            <%= System.Globalization.NumberFormatInfo.CurrentInfo.PercentDecimalSeparator%></li>
        <li>PercentGroupSeparator:
            <%= System.Globalization.NumberFormatInfo.CurrentInfo.PercentGroupSeparator%></li>
        <li>PercentGroupSizes:
            <%= System.Globalization.NumberFormatInfo.CurrentInfo.PercentGroupSizes%></li>
        <li>PercentNegativePattern:
            <%= System.Globalization.NumberFormatInfo.CurrentInfo.PercentNegativePattern%></li>
        <li>PercentPositivePattern:
            <%= System.Globalization.NumberFormatInfo.CurrentInfo.PercentPositivePattern%></li>
        <li>
            PercentSymbol:
            <%= System.Globalization.NumberFormatInfo.CurrentInfo.PercentSymbol%>
        </li>
        </ul>
    <%
        Html.EasyUI().ScriptRegistrar().Globalization(true)
                            .DefaultGroup(group => group
                                .Add("easyui.common.js")
                                .Add("easyui.textbox.js"));

    %>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



        QUnit.testStart = function() {
            $t = $.easyui;
        }

        test('number formatting supports n0 format', function() { //D
            var number = 12123.12;
            equal($t.formatNumber(number, "n0"), '<%= (12123.12).ToString("n0") %>', culture);
        });

        test('number formatting supports decimal format', function() { //D
            var number = 12123.12;
            equal($t.formatNumber(number, "D"), '<%= (12123).ToString("D") %>', culture);
        });

        test('number formatting supports decimal format with small d', function() { //d
            var number = 12123.12;
            equal($t.formatNumber(number, "d"), '<%= (12123).ToString("d") %>', culture);
        });

        test('number formatting supports currency format', function() { //C
            var number = 12123.129;
            equal($t.formatNumber(number, "C"), '<%= (12123.13).ToString("C") %>', culture);
        });

        test('number formatting supports currency format with small c', function() { //C

            var number = 12123.129;
            equal($t.formatNumber(number, "c"), '<%= (12123.13).ToString("c") %>', culture);
        });

        test('number formatting supports Number format', function() { //N
            var number = 12123.129;
            equal($t.formatNumber(number, "N"), '<%= (12123.13).ToString("N") %>', culture);
        });

        test('number formatting supports Number format with small n', function() { //n
            var number = 12123.129;
            equal($t.formatNumber(number, "n"), '<%= (12123.13).ToString("n") %>', culture);
        });

        test('number formatting supports Percent format', function() { //P
            var number = 12123.129;
            equal($t.formatNumber(number, "P"), '<%= (12123.129).ToString("P") %>', culture);
        });

        test('number formatting supports Percent format with small p', function() { //p
            var number = 12123.129;
            equal($t.formatNumber(number, "p"), '<%= (12123.129).ToString("p") %>', culture);
        });

        test('number formatting supports decimal format used in String Format', function() { //D
            var number = 12123.12;
            equal($t.formatNumber(number, "{0:D}"), '<%= (12123).ToString("D") %>', culture);
        });

        test('number formatting supports decimal format with small d used in String Format', function() { //d
            var number = 12123.12;
            equal($t.formatNumber(number, "{0:d}"), '<%= (12123).ToString("d") %>', culture);
        });

        test('number formatting supports currency format used in String Format', function() { //C
            var number = 12123.129;
            equal($t.formatNumber(number, "{0:C}"), '<%= (12123.13).ToString("C") %>', culture);
        });

        test('number formatting supports currency format with small c used in String Format', function() { //C

            var number = 12123.129;
            equal($t.formatNumber(number, "{0:c}"), '<%= (12123.13).ToString("c") %>', culture);
        });

        test('number formatting supports Number format used in String Format', function() { //N
            var number = 12123.129;
            equal($t.formatNumber(number, "{0:N}"), '<%= (12123.13).ToString("N") %>', culture);
        });

        test('number formatting supports Number format with small n used in String Format', function() { //n
            var number = 12123.129;
            equal($t.formatNumber(number, "{0:n}"), '<%= (12123.13).ToString("n") %>', culture);
        });

        test('number formatting supports Percent format used in String Format', function() { //P
            var number = 12123.129;
            equal($t.formatNumber(number, "{0:P}"), '<%= (12123.129).ToString("P") %>', culture);
        });

        test('number formatting supports Percent format with small p used in String Format', function() { //p
            var number = 12123.129;
            equal($t.formatNumber(number, "{0:p}"), '<%= (12123.129).ToString("p") %>', culture);
        });
        test('custom number formatting with normal number format', function() {
            var number = 12123.12;
            equal($t.formatNumber(number, "###.##"), '<%= (12123.12).ToString("###.##") %>', culture);
        });

        test('custom number formatting with three digits after decimal point', function() {
            var number = 12123.12;
            equal($t.formatNumber(number, "###.##0"), '<%= (12123.12).ToString("###.##0") %>', culture);
        });

        test('custom number formatting with decimal digits and int number', function() {
            var number = 12123;
            equal($t.formatNumber(number, "###.##"), '<%= (12123).ToString("###.##") %>', culture);
        });

        test('custom number formatting with one decimal digits and double number', function() {
            var number = 12123.17;
            equal($t.formatNumber(number, "###.0"), '<%= (12123.17).ToString("###.0") %>', culture);
        });

        test('custom number formatting with one decimal digits and obligotory zeros', function() {
            var number = 23.17;
            equal($t.formatNumber(number, "#00##.0"), '<%= (23.17).ToString("#00##.0") %>', culture);
        });

        test('custom number formatting with currency symbol', function() {
            var number = 23.17;
            equal($t.formatNumber(number, "$ #00##.0"), '<%= (23.17).ToString("$ #00##.0") %>', culture);
        });

        test('custom number formatting with currency symbol and string format', function() {
            var number = 23.17;
            equal($t.formatNumber(number, "{0:$ #00##.0}"), '<%= String.Format("{0:$ #00##.0}", 23.17) %>', culture);
        });


        test('custom number formatting with other characteres', function() {
            var number = 23.17;
            equal($t.formatNumber(number, "(#) - ##"), '<%= (23.17).ToString("(#) - ##") %>', culture);
        });

        test('custom number formatting with other characteres and obligatory zeros', function() {
            var number = 23.17;
            equal($t.formatNumber(number, "(0) - 00"), '<%= (23.17).ToString("(0) - 00") %>', culture);
        });

        test('custom number formatting with negative pattern', function() {
            var number = -23.17;
            equal($t.formatNumber(number, "000.00; -###.00"), '<%= (-23.17).ToString("000.00; -###.00") %>', culture);
        });

        test('custom number formatting with negative pattern and string format', function() {
            var number = -23.17;
            equal($t.formatNumber(number, "{0:000.00;- 0###.00}"), '<%= String.Format("{0:000.00;- 0###.00}", -23.17) %>', culture);
        });

        test('custom number formatting with zero pattern', function() {
            var number = 0;
            equal($t.formatNumber(number, "000.00; -###.00;zero"), '<%= (0).ToString("000.00; -###.00;zero") %>', culture);
        });

        test('custom number formatting with one zero', function() {
            var number = 123.12;
            equal($t.formatNumber(number, "0$"), '<%= (123.12).ToString("0$") %>', culture);
        });

        test('custom number format with less digits than specified in format', function() {
            var value = $t.formatNumber(666, "#,###.00");
            equal(value, '<%= 666.ToString("#,###.00") %>', culture);
        });

        test('custom number format with less digits than specified in format1', function() {
            var value = $t.formatNumber(666, "#,##,###.00");
            equal(value, '<%= 666.ToString("#,##,###.00") %>', culture);
        });

        test('custom number format with less digits than specified in format which has more than two group separators', function() {
            var value = $t.formatNumber(6666, "#,##,###.00");
            equal(value, '<%= 6666.ToString("#,##,###.00") %>', culture);
        });

        test('custom number format exact digits count as format', function() {
            var value = $t.formatNumber(6666666, "#,###,###.00");
            equal(value, '<%= 6666666.ToString("#,###,###.00") %>', culture);
        });

        test('custom number format with less digits than specified in format less than zero', function() {
            var value = $t.formatNumber(.5, "#,###.00");
            equal(value, '<%= .5.ToString("#,###.00") %>', culture);
        });

        test('"n" format and zero length NumberGroupSize should not apply group separator', function () {
            var number = 12123.129;
            equal($t.formatNumber(number, "{0:n}", 2, '.', ' ', 0 /*group size*/), '12123.13', culture);
        });

</script>

</asp:Content>