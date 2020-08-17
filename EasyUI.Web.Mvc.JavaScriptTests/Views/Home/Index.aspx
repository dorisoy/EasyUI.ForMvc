<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests.Extensions" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>QUnit test runner :: EasyUI Extensions for ASP.NET MVC</title>
    <link href="<%= Url.Content("~/content/qunit.css") %>" rel="stylesheet" type="text/css" />
    <link href="<%= Url.Content("~/content/qunit-runner.css") %>" rel="stylesheet" type="text/css" />
 
    <%= Html.EasyUI().ScriptRegistrar()
            .DefaultGroup(defaultGroup => defaultGroup
             .Add("jquery-1.6.4.min.js")
                .Add("qunit.js")
                .Add("qunit-runner.js"))
    %>

    <%--
    <!-- globalization tests -->

    <script type="text/javascript">
        var cultures = [];
    </script>

    <%
        Response.Write("<script type='text/javascript'>");

        foreach (System.Globalization.CultureInfo ci in System.Globalization.CultureInfo.GetCultures(System.Globalization.CultureTypes.AllCultures))
        {
            if (!ci.IsNeutralCulture)
            {
                Response.Write("cultures.push(\"" + ci.Name + "\");");
            }
        }

        Response.Write("</script>");
    %>

    <script type="text/javascript">
        function suite() {
            var allTests = new top.jsUnitTestSuite();
            var suite = new top.jsUnitTestSuite();

            for (var i = 0; i < cultures.length; i++) {
                suite.addTestPage("Core/DateFormatting?culture=" + cultures[i]);
                suite.addTestPage("Core/NumberFormatting?culture=" + cultures[i]);
                suite.addTestPage("Core/TimeParsing?culture=" + cultures[i]);
            }

            allTests.addTestSuite(suite);
            return allTests;
        }
    </script>--%>
    
    <script type="text/javascript">

        var tests = [
                <% 
                    foreach (var controller in (IEnumerable<Type>)ViewData["Controllers"]) {
                        foreach (var actionName in controller.GetActions()) { %>
                            { page: '<%= Url.Action(actionName, controller.GetName()) %>', title: '<%= controller.GetName() %> / <%= actionName %>' },
                <%
                        }
                    }
                %>
                {}
            ],
            sequential = true, // false to run tests simultaneously
            runnerDone = function(failures, total) {
                $('<p id="qunit-testresult" class="result" />')
                    .html(["Tests completed in ", (+new Date()) - start, " milliseconds.<br />",
                           "<span class='passed'>", total-failures, "</span> tests of <span class='total'>", total,
                           "</span> passed, <span class='failed'>", failures, "</span> failed."
                        ].join(''))
                    .appendTo("body > div");
            }

        tests.pop();

        var start = +new Date();
        QUnit.run(tests, sequential, runnerDone);
    </script>
</head>
<body>
    <div>
        <h1 id="qunit-header">TEST RUNNER</h1>
        <h2 id="qunit-banner"></h2>
        <h2 id="qunit-runner-userAgent"></h2>
        <div id="runner-test-page-container"></div>
    </div>
</body>
</html>