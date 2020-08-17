<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <% Html.RegisterSplitterScripts(); %>

</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">
        
        module("Splitter / ClientEvents", {
            teardown: function() {
                $('.t-splitter').remove();
            }
        });

        test("initialization triggers load", function() {
            var triggered = false;

            $(getSplitterHtml())
                .appendTo(document.body)
                .bind("load", function() {
                    triggered = true;
                })
                .tSplitter();
            
            ok(triggered);
        });

        test("initialization triggers resize", function() {
            var triggered = false;

            $(getSplitterHtml())
                .appendTo(document.body)
                .bind("resize", function() {
                    triggered = true;
                })
                .tSplitter();
            
            ok(triggered);
        });

    </script>

</asp:Content>
