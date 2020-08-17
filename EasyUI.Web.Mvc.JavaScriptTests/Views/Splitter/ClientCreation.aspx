<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <% Html.RegisterSplitterScripts(); %>

</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">
        
        module("Splitter / ClientCreation");

        test("constructor adds classes to container", function() {
            var splitter = $(getSplitterHtml(1)).tSplitter();

            ok(splitter.hasClass("t-widget"));
            ok(splitter.hasClass("t-splitter"));

            splitter = $(getSplitterHtml(1)).tSplitter({ orientation: "vertical" });

            ok(splitter.hasClass("t-splitter"));
        });

        test("constructor interprets erronious orientation as horizontal", function() {
            var splitter = $(getSplitterHtml(1)).tSplitter({ orientation: "diagonal" });

            ok(splitter.hasClass("t-splitter"));
        });

        test("init adds classes to child elements", function() {
            var splitter = $(getSplitterHtml(1)).tSplitter();
            
            equals(splitter.find(".t-pane").length, 1);
        });

        test("init adds splitbars between panes", function() {
            var splitter = $(getSplitterHtml(3)).tSplitter(),
                splitbars = splitter.find(".t-splitbar");

            equals(splitbars.length, 2);
            equals(splitbars.eq(0).index(), 1);
            equals(splitbars.eq(1).index(), 3);
        });

        test("splitbars have collapse button for collapsible panes", function() {
            var splitter = $(getSplitterHtml(3)).tSplitter({
                    panes: [
                        { collapsible: true },
                        {},
                        { collapsible: true }
                    ]
                }),
                splitbars = splitter.find(".t-splitbar");

            equals(splitbars.eq(0).find(".t-icon.t-collapse-prev").length, 1);
            equals(splitbars.eq(1).find(".t-icon.t-collapse-next").length, 1);
        });

        test("splitbars have resize handle between resizable panes", function() {
            var splitter = $(getSplitterHtml(3))
                .tSplitter({
                    panes: [
                        { resizable: false },
                        {},
                        {}
                    ]
                }),
                splitbars = splitter.find(".t-splitbar");

            equals(splitbars.eq(0).find(".t-icon.t-resize-handle").length, 0);
            equals(splitbars.eq(1).find(".t-icon.t-resize-handle").length, 1);
        });

        test("collapsed panes render expand arrow beside them", function() {
            var splitter = $(getSplitterHtml())
                .tSplitter({
                    panes: [
                        { collapsible: true, collapsed: true },
                        {}
                    ]
                });

            equals(splitter.find(".t-expand-prev").length, 1);
        });

        test("splibars next to initially collapsed panes are not draggable", function() {
            var splitter = $(getSplitterHtml())
                .tSplitter({
                    panes: [
                        { collapsible: true, collapsed: true },
                        {}
                    ]
                });

            ok(!splitter.find(".t-splitbar").hasClass("t-splitbar-draggable-horizontal"));
        });

        test("panes get t-scrollable class if they are scrollable", function() {
            var splitter = $(getSplitterHtml())
                .tSplitter({
                    panes: [
                        { scrollable: false },
                        {}
                    ]
                }),
                panes = splitter.find(".t-pane");

            ok(!panes.eq(0).hasClass("t-scrollable"));
            ok(panes.eq(1).hasClass("t-scrollable"));
        });

    </script>

</asp:Content>
