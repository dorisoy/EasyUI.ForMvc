<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>FormatString</h2>
    <script type="text/javascript">
      var $t;

    </script>
    <% Html.EasyUI().ScriptRegistrar()
                            .DefaultGroup(group => group
                                    .Add("easyui.common.js")
                                    .Add("easyui.textbox.js")
        );
    %>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



        QUnit.testStart = function() {
            $t = $.easyui;
        }

        test('string format with less arguments', function() {
            equal($t.formatString('foo {0}'), 'foo {0}');
        });
        
        test('string format with more arguments', function() {
            equal($t.formatString('foo', 1), 'foo');
        });
        
        test('string format with missing format argument', function() {
            equal($t.formatString('foo {1} {2}', 1, 2, 3), 'foo 2 3');
        });

</script>

</asp:Content>