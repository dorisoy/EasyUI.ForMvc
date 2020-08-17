<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Date by token</h2>

    <script type="text/javascript">
        var $t;

        function compareDates(expected, returned) {
            var isValid = true;

            if (expected.getFullYear() != returned.year())
                isValid = false;
            else if (expected.getMonth() != returned.month())
                isValid = false;
            else if (expected.getDate() != returned.date())
                isValid = false;

            return isValid;
        }

        //short names
       
    </script>
    
    
    
    <%= Html.EasyUI().DatePicker()
            .Name("DatePicker")
            .Min(new DateTime(1900, 01, 01))
            .Max(new DateTime(2100, 01, 01))
    %>
    
    <% Html.EasyUI().ScriptRegistrar()
           .Scripts(scripts => scripts
               .Add("easyui.common.js")
               .Add("easyui.calendar.js")
               .Add("easyui.datepicker.js")); %>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



        QUnit.testStart = function() {
            $t = $.easyui;
        }

        test('parseByToken should return today date token today', function() {
           
            var expectedDate = new Date();

            var returnedDate = $t.datetime.parseByToken("today");

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return yesterday date token yesterday', function() {
            var expectedDate = new Date();
            expectedDate.setDate(expectedDate.getDate() -1);

            var returnedDate = $t.datetime.parseByToken("yesterday");

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return tomorrow date token tomorrow', function() {
            var expectedDate = new Date();
            expectedDate.setDate(expectedDate.getDate() + 1);

            var returnedDate = $t.datetime.parseByToken("tomorrow");

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return monday of current week', function() {

            var tmpDate = new $.easyui.datetime(2009, 10, 27); //friday
            var expectedDate = new Date(2009, 10, 27); //friday

            var returnedDate = $t.datetime.parseByToken("monday", tmpDate);

            expectedDate.setDate(expectedDate.getDate() - 4); //set the expected date

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return friday of current week', function() {
            var tmpDate = new $.easyui.datetime(2009, 10, 27); //friday
            var expectedDate = new Date(2009, 10, 27); //friday

            var returnedDate = $t.datetime.parseByToken("friday", tmpDate);

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return sunday of current week', function() {

            var tmpDate = new $.easyui.datetime(2009, 10, 27); //friday
            var expectedDate = new Date(2009, 10, 27); //friday

            var returnedDate = $t.datetime.parseByToken("sunday", tmpDate);

            expectedDate.setDate(expectedDate.getDate() + 2); //set the expected date

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return march of current year', function() {
            var tmpDate = new $.easyui.datetime(2009, 10, 27); //November
            var expectedDate = new Date(2009, 10, 27); //friday

            var returnedDate = $t.datetime.parseByToken("March", tmpDate);

            expectedDate.setMonth(expectedDate.getMonth() - 8);

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return December of current year', function() {
            var tmpDate = new $.easyui.datetime(2009, 10, 27); //November
            var expectedDate = new Date(2009, 10, 27); //friday

            var returnedDate = $t.datetime.parseByToken("december", tmpDate);

            expectedDate.setMonth(expectedDate.getMonth() + 1);

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return November of current year', function() {
            var tmpDate = new $.easyui.datetime(2009, 10, 27); //November
            var expectedDate = new Date(2009, 10, 27); //friday

            var returnedDate = $t.datetime.parseByToken("november", tmpDate);

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return next friday', function() {

            var tmpDate = new $.easyui.datetime(2009, 10, 27); //November
            var expectedDate = new Date(2009, 10, 27); //friday

            var returnedDate = $t.datetime.parseByToken("next friday", tmpDate);

            expectedDate.setDate(expectedDate.getDate() + 7);

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return last friday', function() {
            var tmpDate = new $.easyui.datetime(2009, 10, 27); //November
            var expectedDate = new Date(2009, 10, 27); //friday

            var returnedDate = $t.datetime.parseByToken("last friday", tmpDate);

            expectedDate.setDate(expectedDate.getDate() - 7);

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return next monday', function() {
            var tmpDate = new $.easyui.datetime(2009, 10, 27); //November
            var expectedDate = new Date(2009, 10, 27); //friday

            var returnedDate = $t.datetime.parseByToken("next monday", tmpDate);

            expectedDate.setDate(expectedDate.getDate() + 3);

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return last monday', function() {
            var tmpDate = new $.easyui.datetime(2009, 10, 27); //November
            var expectedDate = new Date(2009, 10, 27); //friday

            var returnedDate = $t.datetime.parseByToken("last monday", tmpDate);

            expectedDate.setDate(expectedDate.getDate() - 11);

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return next sunday', function() {
            var tmpDate = new $.easyui.datetime(2009, 10, 27); //November
            var expectedDate = new Date(2009, 10, 27); //friday

            var returnedDate = $t.datetime.parseByToken("next sunday", tmpDate);

            expectedDate.setDate(expectedDate.getDate() + 9);

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return next November', function() {
            var tmpDate = new $.easyui.datetime(2009, 10, 27); //November
            var expectedDate = new Date(2009, 10, 27); //November

            var returnedDate = $t.datetime.parseByToken("next november", tmpDate);

            expectedDate.setMonth(expectedDate.getMonth() + 12);

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return last november', function() {
            var tmpDate = new $.easyui.datetime(2009, 10, 27); //November
            var expectedDate = new Date(2009, 10, 27); //November

            var returnedDate = $t.datetime.parseByToken("last november", tmpDate);

            expectedDate.setMonth(expectedDate.getMonth() - 12);

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return next february', function() {
            var tmpDate = new $.easyui.datetime(2009, 10, 27); //November
            var expectedDate = new Date(2009, 10, 27); //November

            var returnedDate = $t.datetime.parseByToken("next february", tmpDate);

            expectedDate.setMonth(expectedDate.getMonth() + 3);
            
            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return last february', function() {
            var tmpDate = new $.easyui.datetime(2009, 10, 27); //November
            var expectedDate = new Date(2009, 10, 27); //November

            var returnedDate = $t.datetime.parseByToken("last february", tmpDate);

            expectedDate.setMonth(expectedDate.getMonth() - 21);

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return next december', function() {
            var tmpDate = new $.easyui.datetime(2009, 10, 27); //November
            var expectedDate = new Date(2009, 10, 27); //November

            var returnedDate = $t.datetime.parseByToken("next december", tmpDate);

            expectedDate.setMonth(expectedDate.getMonth() + 13);

            ok(compareDates(expectedDate, returnedDate));
        });
        test('parseByToken should return next fri', function() {
            var tmpDate = new $.easyui.datetime(2009, 10, 27); //November
            var expectedDate = new Date(2009, 10, 27); //friday

            var returnedDate = $t.datetime.parseByToken("next fri", tmpDate);

            expectedDate.setDate(expectedDate.getDate() + 7);

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return last fri', function() {
            var tmpDate = new $.easyui.datetime(2009, 10, 27); //November
            var expectedDate = new Date(2009, 10, 27); //friday

            var returnedDate = $t.datetime.parseByToken("last fri", tmpDate);

            expectedDate.setDate(expectedDate.getDate() - 7);

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return next mon', function() {
            var tmpDate = new $.easyui.datetime(2009, 10, 27); //November
            var expectedDate = new Date(2009, 10, 27); //friday

            var returnedDate = $t.datetime.parseByToken("next mon", tmpDate);

            expectedDate.setDate(expectedDate.getDate() + 3);

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return last mon', function() {
            var tmpDate = new $.easyui.datetime(2009, 10, 27); //November
            var expectedDate = new Date(2009, 10, 27); //friday

            var returnedDate = $t.datetime.parseByToken("last mon", tmpDate);

            expectedDate.setDate(expectedDate.getDate() - 11);

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return next sun', function() {

            var tmpDate = new $.easyui.datetime(2009, 10, 27); //November
            var expectedDate = new Date(2009, 10, 27); //friday

            var returnedDate = $t.datetime.parseByToken("next sun", tmpDate);

            expectedDate.setDate(expectedDate.getDate() + 9);

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return next Nov', function() {
            var tmpDate = new $.easyui.datetime(2009, 10, 27); //November
            var expectedDate = new Date(2009, 10, 27); //November

            var returnedDate = $t.datetime.parseByToken("next Nov", tmpDate);

            expectedDate.setMonth(expectedDate.getMonth() + 12);

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return last Nov', function() {
            var tmpDate = new $.easyui.datetime(2009, 10, 27); //November
            var expectedDate = new Date(2009, 10, 27); //November

            var returnedDate = $t.datetime.parseByToken("last Nov", tmpDate);

            expectedDate.setMonth(expectedDate.getMonth() - 12);

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return next feb', function() {
            var tmpDate = new $.easyui.datetime(2009, 10, 27); //November
            var expectedDate = new Date(2009, 10, 27); //November

            var returnedDate = $t.datetime.parseByToken("next feb", tmpDate);

            expectedDate.setMonth(expectedDate.getMonth() + 3);

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return last feb', function() {
            var tmpDate = new $.easyui.datetime(2009, 10, 27); //November
            var expectedDate = new Date(2009, 10, 27); //November

            var returnedDate = $t.datetime.parseByToken("last feb", tmpDate);

            expectedDate.setMonth(expectedDate.getMonth() - 21);

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return next dec', function() {
            var tmpDate = new $.easyui.datetime(2009, 10, 27); //November
            var expectedDate = new Date(2009, 10, 27); //November

            var returnedDate = $t.datetime.parseByToken("next dec", tmpDate);

            expectedDate.setMonth(expectedDate.getMonth() + 13);

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return next year', function() {

            var tmpDate = new $.easyui.datetime(2009, 10, 27);
            var expectedDate = new Date(2009, 10, 27);

            var returnedDate = $t.datetime.parseByToken("next year", tmpDate);

            expectedDate.setFullYear(expectedDate.getFullYear() + 1, expectedDate.getMonth(), expectedDate.getDate());

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return last year', function() {
            var tmpDate = new $.easyui.datetime(2009, 10, 27);
            var expectedDate = new Date(2009, 10, 27);

            var returnedDate = $t.datetime.parseByToken("last year", tmpDate);

            expectedDate.setFullYear(expectedDate.getFullYear() - 1, expectedDate.getMonth(), expectedDate.getDate());

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return next month', function() {

            var tmpDate = new $.easyui.datetime(2009, 10, 27);
            var expectedDate = new Date(2009, 10, 27);

            var returnedDate = $t.datetime.parseByToken("next month", tmpDate);

            expectedDate.setFullYear(expectedDate.getFullYear(), expectedDate.getMonth() + 1, expectedDate.getDate());

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return last month', function() {

            var tmpDate = new $.easyui.datetime(2009, 10, 27);
            var expectedDate = new Date(2009, 10, 27);

            var returnedDate = $t.datetime.parseByToken("last month", tmpDate);

            expectedDate.setFullYear(expectedDate.getFullYear(), expectedDate.getMonth() - 1, expectedDate.getDate());

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return next week', function() {

            var tmpDate = new $.easyui.datetime(2009, 10, 27);
            var expectedDate = new Date(2009, 10, 27);

            var returnedDate = $t.datetime.parseByToken("next week", tmpDate);

            expectedDate.setFullYear(expectedDate.getFullYear(), expectedDate.getMonth(), expectedDate.getDate() + 7);

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return last week', function() {

            var tmpDate = new $.easyui.datetime(2009, 10, 27);
            var expectedDate = new Date(2009, 10, 27);

            var returnedDate = $t.datetime.parseByToken("last week", tmpDate);

            expectedDate.setFullYear(expectedDate.getFullYear(), expectedDate.getMonth(), expectedDate.getDate() - 7);

            ok(compareDates(expectedDate, returnedDate));
        });

        test('parseByToken should return next day', function() { //like tomorrow

            var tmpDate = new $.easyui.datetime(2009, 10, 27);
            var expectedDate = new Date(2009, 10, 27);

            var returnedDate = $t.datetime.parseByToken("next day", tmpDate);

            expectedDate.setFullYear(expectedDate.getFullYear(), expectedDate.getMonth(), expectedDate.getDate() + 1);

            ok(compareDates(expectedDate, returnedDate));
        });


        test('parseByToken should return last day', function() { //like tomorrow

            var tmpDate = new $.easyui.datetime(2009, 10, 27);
            var expectedDate = new Date(2009, 10, 27);

            var returnedDate = $t.datetime.parseByToken("last day", tmpDate);

            expectedDate.setFullYear(expectedDate.getFullYear(), expectedDate.getMonth(), expectedDate.getDate() - 1);

            ok(compareDates(expectedDate, returnedDate));
        });
        
        test('parseByToken should return null if cannot parse first token', function() {
            var returnedDate = $t.datetime.parseByToken("undefined");
            ok(null === returnedDate);
        });

        test('parseByToken should return null if second token is not provided', function() {
            var returnedDate = $t.datetime.parseByToken("next ");
            ok(null === returnedDate);
        });

        test('parseByToken should return null if second token is not correct', function() {
            var returnedDate = $t.datetime.parseByToken("next undeffined");
            ok(null === returnedDate);
        });

</script>

</asp:Content>