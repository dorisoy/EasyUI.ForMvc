<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<%
    string culture = Request.QueryString["culture"] ?? "en-US";
    System.Threading.Thread.CurrentThread.CurrentCulture = new System.Globalization.CultureInfo(culture);

    Response.Write("<script type='text/javascript'>var culture='");
    Response.Write(culture);
    Response.Write("';</script>");
%>
    
    <%= Html.EasyUI().DatePicker()
            .Name("DatePicker")
            .Min(new DateTime(1900, 01,01))
            .Max(new DateTime(2100, 01, 01))
    %>
    
    <% Html.EasyUI().ScriptRegistrar()
           .Scripts(scripts => scripts
               .Add("easyui.common.js")
               .Add("easyui.datepicker.js")
               .Add("easyui.calendar.js")); %>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">

        // Korean_long_date_format() { //Not supported!!!

        //              Turkish_long_date_format() { // not supported because of date name(dddd) after number day (dd)
        //            var dateFormat = "dd MMMM yyyy dddd";
        //            var result = getDatePicker().parse("3 December 2000 Saturday", dateFormat);
        //            ok(isValidDate(2000, 12, 3, result));
        //        }

        //        Georgian_long_date_format() { // not supported because of date name(dddd) after number day (dd)
        //            
        //            var dateFormat = "yyyy 'წლის' dd MM, dddd";
        //            var result = getDatePicker().parse("2000 წლის 3 12, Saturday", dateFormat);
        //            ok(isValidDate(2000, 12, 3, result));
        //        }

        function getDatePicker() {
            return $('#DatePicker').data('tDatePicker');
        }

        function isValidDate(year, month, day, date) {
            var isValid = true;

            if (year != date.getFullYear())
                isValid = false;
            else if (month != date.getMonth() + 1)
                isValid = false;
            else if (day != date.getDate())
                isValid = false;

            return isValid;
        }

        function isValidDateTime(date, year, month, day, hours, minutes, seconds, milliseconds) {
            var isValid = true;

            if (year != date.getFullYear())
                isValid = false;
            else if (month != date.getMonth() + 1)
                isValid = false;
            else if (day != date.getDate())
                isValid = false;
            else if (hours && hours != date.getHours())
                isValid = false;
            else if (minutes && minutes != date.getMinutes())
                isValid = false;
            else if (seconds && seconds != date.getSeconds())
                isValid = false;
            else if (milliseconds && milliseconds != date.getMilliseconds())
                isValid = false;

            return isValid;
        }

        test('parse G date format', function () { // ISO format

            var dateFormat = "G";
            var result = getDatePicker().parse("12/23/2000", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });

        test('parse short year 11 should return year 2011', function () { // ISO format

            var dateFormat = "G";
            var result = getDatePicker().parse("12/23/11", dateFormat);
            equal(result.getFullYear(), 2011);
        });

        test('parse short year 31 should return year 1931', function () { // ISO format

            var dateFormat = "G";
            var result = getDatePicker().parse("12/23/31", dateFormat);
            equal(result.getFullYear(), 1931);
        });

        test('parse G date format time parsing', function () { // ISO format

            var dateFormat = "G";
            var result = getDatePicker().parse("12/23/2000 8:12:22 pm", dateFormat);
            ok(new Date(2000, 11, 23, 20, 12, 22) - result == 0);
        });

        test('parse G date time at midnight', function () { // ISO format

            var dateFormat = "G";
            var result = getDatePicker().parse("10/23/2000 12:00:00 pm", dateFormat);
            ok(isValidDateTime(result, 2000, 10, 23, 12, 0, 0), result.toString());
        });

        test('parse G date time at noon', function () { // ISO format

            var dateFormat = "G";
            var result = getDatePicker().parse("10/23/2000 12:00:00 am", dateFormat);
            ok(isValidDateTime(result, 2000, 10, 23, 0, 0, 0), result.toString());
        });

        test('parse G date time without seconds', function () { // ISO format

            var dateFormat = "G";
            var result = getDatePicker().parse("10/23/2000 12:21 am", dateFormat);
            ok(isValidDateTime(result, 2000, 10, 23, 0, 21, 0), result.toString());
        });

        test('parse G date time with am without seconds and minutes', function () { // ISO format

            var dateFormat = "G";
            var result = getDatePicker().parse("10/23/2000 12 am", dateFormat);
            ok(isValidDateTime(result, 2000, 10, 23, 0, 0, 0), result.toString());
        });

        test('parse G date time with pm without seconds and minutes', function () { // ISO format

            var dateFormat = "G";
            var result = getDatePicker().parse("10/23/2000 12 pm", dateFormat);
            ok(isValidDateTime(result, 2000, 10, 23, 0, 0, 0), result.toString());
        });
        test('parse ISO date format', function () { // ISO format

            var dateFormat = "MM-dd-yyyy";
            var result = getDatePicker().parse("12-23-2000", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });
        test('parse Invariant Language date format', function () { // Also: Persian

            var dateFormat = "MM/dd/yyyy";
            var result = getDatePicker().parse("12/23/2000", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });

        test('parse Arabic date format', function () { // Also : Galician, Divehi 

            var dateFormat = "dd/MM/yy";
            var result = getDatePicker().parse("10/10/99", dateFormat);
            ok(isValidDate(1999, 10, 10, result));
        });

        test('parse Bulgarian Language date format', function () { //

            var dateFormat = "d.M.yyyy 'г.'";
            var result = getDatePicker().parse("23.12.2000", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });

        test('parse Bulgarian Language with literal date format', function () {

            var dateFormat = "d.M.yyyy 'г.'";
            var result = getDatePicker().parse("23.12.2000 г.", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });

        test('parse Catalan Language date format', function () { // Also : Vietnamese, Arabic 

            var dateFormat = "dd/MM/yyyy";
            var result = getDatePicker().parse("23/12/2000", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });

        test('parse Chinese Language date format', function () {

            var dateFormat = "yyyy/M/d";
            var result = getDatePicker().parse("2000/12/23", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });

        test('parse Czech Language date format', function () {

            var dateFormat = "d.M.yyyy";
            var result = getDatePicker().parse("23.12.2000", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });

        test('parse Danish Language date format', function () { // Also : Faroese, Hindi, Tamil, Marathi
            //Sanskrit, Konkani, Portuguese 

            var dateFormat = "dd-MM-yyyy";
            var result = getDatePicker().parse("23-12-2000", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });

        test('parse German Language date format', function () { //also : Norwegian, Romanian, Russian, Turkish
            // Ukrainian, Belarusian, Armenian, Azeri, Macedonian, Georgian, Kazakh, Tatar, Italian,Norwegian
            //Azeri, Uzbek, Austria

            var dateFormat = "dd.MM.yyyy";
            var result = getDatePicker().parse("23.12.2000", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });

        test('parse Greek Language date format', function () { // also : Portuguese, Thai, Hong Kong

            var dateFormat = "d/M/yyyy";
            var result = getDatePicker().parse("23/12/2000", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });

        test('parse English Language date format', function () { // Also : Kiswahili 

            var dateFormat = "M/d/yyyy";
            var result = getDatePicker().parse("12/23/2000", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });

        test('parse Finnish Language date format', function () { // also : Icelandic, Croatian, Slovenian
            // Serbian, Swedish, 

            var dateFormat = "d.M.yyyy";
            var result = getDatePicker().parse("23.12.2000", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });

        test('parse French Language date format', function () { // also : Hebrew, Italian, Urdu, Indonesian
            //Malay, Syriac, (United Kingdom), Spanish (Mexico), ms-BN, Arabic 

            var dateFormat = "dd/MM/yyyy";
            var result = getDatePicker().parse("23/12/2000", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });

        test('parse Hungarian Language date format', function () {

            var dateFormat = "yyyy. MM. dd.";
            var result = getDatePicker().parse("2000. 12. 23.", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });

        test('parse Japanese Language date format', function () { // Also : Basque, Afrikaans 

            var dateFormat = "yyyy/MM/dd";
            var result = getDatePicker().parse("2000/12/23", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });

        test('parse Korean Language date format', function () { // also : Polish, Albanian, Swedish

            var dateFormat = "yyyy-MM-dd";
            var result = getDatePicker().parse("2000-12-23", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });

        test('parse Dutch Language date format', function () {

            var dateFormat = "d-M-yyyy";
            var result = getDatePicker().parse("23-2-2008", dateFormat);
            ok(isValidDate(2008, 2, 23, result));
        });

        test('parse Norwegian Language date format', function () {

            var dateFormat = "d-M-yyyy";
            var result = getDatePicker().parse("23-2-2008", dateFormat);
            ok(isValidDate(2008, 2, 23, result));
        });

        test('parse Slovak Language date format', function () {

            var dateFormat = "d. M. yyyy";
            var result = getDatePicker().parse("23. 2. 2008", dateFormat);
            ok(isValidDate(2008, 2, 23, result));
        });

        test('parse Estonian Language date format', function () {

            var dateFormat = "d.MM.yyyy";
            var result = getDatePicker().parse("23.12.2008", dateFormat);
            ok(isValidDate(2008, 12, 23, result));
        });

        test('parse Latvian Language date format', function () {

            var dateFormat = "yyyy.MM.dd.";
            var result = getDatePicker().parse("2008.12.23.", dateFormat);
            ok(isValidDate(2008, 12, 23, result));
        });

        test('parse Lithuanian Language date format', function () {

            var dateFormat = "yyyy.MM.dd";
            var result = getDatePicker().parse("2008.12.23", dateFormat);
            ok(isValidDate(2008, 12, 23, result));
        });

        test('parse Kyrgyz Language date format', function () {
            var dateFormat = "dd.MM.yy";
            var result = getDatePicker().parse("5.3.08", dateFormat);
            ok(isValidDate(2008, 3, 5, result));
        });

        test('parse Uzbek Language date format', function () {
            var dateFormat = "dd/MM yyyy";
            var result = getDatePicker().parse("5/3 2008", dateFormat);
            ok(isValidDate(2008, 3, 5, result));
        });

        test('parse Punjabi Language date format', function () { // Also : Gujarati, Telugu, Kannada
            var dateFormat = "dd-MM-yy";
            var result = getDatePicker().parse("5-3-08", dateFormat);
            ok(isValidDate(2008, 3, 5, result));
        });

        test('parse Mongolian Language date format', function () {
            var dateFormat = "yy.MM.dd";
            var result = getDatePicker().parse("99.12.25", dateFormat);
            ok(isValidDate(1999, 12, 25, result));
        });

        test('parse Belgium Language date format', function () { // Also Dutch(Belgium ), English (Australia)
            var dateFormat = "d/MM/yyyy";
            var result = getDatePicker().parse("05/10/2009", dateFormat);
            ok(isValidDate(2009, 10, 5, result));
        });

        test('parse Yakut Language date format', function () {
            var dateFormat = "MM.dd.yyyy";
            var result = getDatePicker().parse("3.5.2008", dateFormat);
            ok(isValidDate(2008, 3, 5, result));
        });

        test('parse Croatian Language date format', function () {
            var dateFormat = "d.M.yyyy.";
            var result = getDatePicker().parse("5.3.2008", dateFormat);
            ok(isValidDate(2008, 3, 5, result));
        });
        test('parse Invariant Language long date format', function () { // Also: Persian

            var dateFormat = "dddd, dd MMMM yyyy";
            var result = getDatePicker().parse("Saturday, 23 December 2000", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });

        test('parse Arabic long date format', function () {

            var dateFormat = "dd/MMMM/yyyy";
            var result = getDatePicker().parse("10/September/2009", dateFormat);
            ok(isValidDate(2009, 9, 10, result));
        });

        test('parse Bulgarian long date format', function () {

            var dateFormat = "dd MMMM yyyy 'г.'";
            var result = getDatePicker().parse("10 September 2009 'г.'", dateFormat);
            ok(isValidDate(2009, 9, 10, result));
        });

        test('parse Catalan long date format', function () {

            var dateFormat = "dddd, d' / 'MMMM' / 'yyyy";
            var result = getDatePicker().parse("Saturday, 23 / December / 2000", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });

        test('parse Chinese long date format', function () {

            var dateFormat = "yyyy'年'M'月'd'日'";
            var result = getDatePicker().parse("2009年9月10日", dateFormat);
            ok(isValidDate(2009, 9, 10, result));
        });

        test('parse Czech long date format', function () { // also: Danish, Norwegian

            var dateFormat = "d. MMMM yyyy";
            var result = getDatePicker().parse("10. September 2009", dateFormat);
            ok(isValidDate(2009, 9, 10, result));
        });

        test('parse German long date format', function () {

            var dateFormat = "dddd, d. MMMM yyyy";
            var result = getDatePicker().parse("Saturday, 23. December 2000", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });

        test('parse Greek long date format', function () {

            var dateFormat = "dddd, d MMMM yyyy";
            var result = getDatePicker().parse("Saturday, 3 December 2000", dateFormat);
            ok(isValidDate(2000, 12, 3, result));
        });

        test('parse English long date format', function () {

            var dateFormat = "dddd, MMMM dd, yyyy";
            var result = getDatePicker().parse("Saturday, December 3, 2000", dateFormat);
            ok(isValidDate(2000, 12, 3, result));
        });

        test('parse Finnish long date format', function () {

            var dateFormat = "d. MMMM'ta 'yyyy";
            var result = getDatePicker().parse("23. Decemberta 2000", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });

        test('parse France long date format', function () {

            var dateFormat = "dddd d MMMM yyyy";
            var result = getDatePicker().parse("Saturday 3 December 2000", dateFormat);
            ok(isValidDate(2000, 12, 3, result));
        });

        test('parse Hebrew long date format', function () {

            var dateFormat = "dddd dd MMMM yyyy";
            var result = getDatePicker().parse("Saturday 3 December 2000", dateFormat);
            ok(isValidDate(2000, 12, 3, result));
        });

        test('parse Hungarian long date format', function () {

            var dateFormat = "yyyy. MMMM d.";
            var result = getDatePicker().parse("2000. December 23.", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });

        test('parse Icelandic long date format', function () {

            var dateFormat = "d. MMMM yyyy";
            var result = getDatePicker().parse("23. December 2000", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });

        test('parse Italian long date format', function () { // Also Dutch

            var dateFormat = "dddd d MMMM yyyy";
            var result = getDatePicker().parse("Saturday 3 December 2000", dateFormat);
            ok(isValidDate(2000, 12, 3, result));
        });

        test('parse Japanese long date format', function () {

            var dateFormat = "yyyy'年'M'月'd'日'";
            var result = getDatePicker().parse("2000年12月3日", dateFormat);
            ok(isValidDate(2000, 12, 3, result));
        });

        test('parse Norwegian long date format', function () {

            var dateFormat = "dddd d MMMM yyyy";
            var result = getDatePicker().parse("Saturday 3 December 2000", dateFormat);
            ok(isValidDate(2000, 12, 3, result));
        });

        test('parse Brazil long date format', function () {

            var dateFormat = "dddd, d' de 'MMMM' de 'yyyy";
            var result = getDatePicker().parse("Saturday, 3 de December de 2000", dateFormat);
            ok(isValidDate(2000, 12, 3, result));
        });

        test('parse Polish long date format', function () { //Also Romanian, Thailand, Belarusian

            var dateFormat = "d MMMM yyyy";
            var result = getDatePicker().parse("3 December 2000", dateFormat);
            ok(isValidDate(2000, 12, 3, result));
        });

        test('parse Russian long date format', function () {

            var dateFormat = "d MMMM yyyy 'г.'";
            var result = getDatePicker().parse("3 December 2000 'г.'", dateFormat);
            ok(isValidDate(2000, 12, 3, result));
        });

        test('parse Croatian long date format', function () { //Also Slovak

            var dateFormat = "d. MMMM yyyy";
            var result = getDatePicker().parse("3. December 2000", dateFormat);
            ok(isValidDate(2000, 12, 3, result));
        });

        test('parse Albanian long date format', function () {

            var dateFormat = "yyyy-MM-dd";
            var result = getDatePicker().parse("2000-12-23", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });

        test('parse Swedish long date format', function () {

            var dateFormat = "'den 'd MMMM yyyy";
            var result = getDatePicker().parse("den 23 December 2000", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });

        test('parse Ukrainian long date format', function () {

            var dateFormat = "'den 'd MMMM yyyy' р.'";
            var result = getDatePicker().parse("den 23 December 2000", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });

        test('parse Estonian long date format', function () {

            var dateFormat = "d. MMMM yyyy'. a.'";
            var result = getDatePicker().parse("3. December 2000. a.", dateFormat);
            ok(isValidDate(2000, 12, 3, result));
        });

        test('parse Latvian long date format', function () {

            var dateFormat = "dddd, yyyy'. gada 'd. MMMM";
            var result = getDatePicker().parse("Saturday, 2000. gada 3. December", dateFormat);
            ok(isValidDate(2000, 12, 3, result));
        });

        test('parse Lithuanian long date format', function () {

            var dateFormat = "yyyy 'm.' MMMM d 'd.'";
            var result = getDatePicker().parse("2000 m. December 23 d.", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });

        test('parse Basque long date format', function () {

            var dateFormat = "dddd, yyyy.'eko' MMMM'k 'd";
            var result = getDatePicker().parse("Saturday, 2000.eko Decemberk 3", dateFormat);
            ok(isValidDate(2000, 12, 3, result));
        });

        test('parse Tibetian long date format', function () {
            var dateFormat = "yyyy'ལོའི་ཟླ' M'ཚེས' d";
            var result = getDatePicker().parse("2000ལོའི་ཟླ 12ཚེས 23", dateFormat);
            ok(isValidDate(2000, 12, 23, result));
        });

        test('parse date not exactly matching date format M dd yyyy should return correct date', function () {

            var dateFormat = "M/dd/yyyy";

            var result = getDatePicker().parse("01012010", dateFormat);
            ok(isValidDate(2010, 1, 1, result));
        });

        test('parse date not exactly matching date format d M yyyy should return correct date', function () {

            var dateFormat = "d/M/yyyy";

            var result = getDatePicker().parse("29102010", dateFormat);
            ok(isValidDate(2010, 10, 29, result));
        });

        test('parse day and month should produce date with current year', function () {

            var dateFormat = "M/dd/yyyy";

            var date = new $.easyui.datetime();

            var result = getDatePicker().parse("1001", dateFormat);
            ok(isValidDate(date.year(), 10, 1, result));
        });
        test('parse date time format', function () { // ISO format
            var dateFormat = "dd/MMM/yyyy HH:mm:ss";
            var result = getDatePicker().parse("22/Aug/2006 06:30:07", dateFormat);
            ok(new Date(2006, 7, 22, 6, 30, 7) - result == 0);
        });

        test('parse invalid date should return null', function () {
            var dateFormat = "MM/dd/yyyy";

            var result = getDatePicker().parse("1//2100", dateFormat);
            equal(result, null);
        });

        test('parse should return null if only year is passed', function () {
            var dateFormat = "M/dd/yyyy";

            var result = getDatePicker().parse("2010", dateFormat);

            equal(result, null);
        });

</script>

</asp:Content>