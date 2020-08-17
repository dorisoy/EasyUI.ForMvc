<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <% Html.RegisterSplitterScripts(); %>

</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">
        
        module("Splitter / Collapse", {
            teardown: function() {
                $(".t-splitter").remove();
            }
        });

        test("clicking collapse arrow triggers collapse event", function() {
            var triggered = false,
                splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { collapsible: true }, {} ]
                    })
                    .bind("collapse", function(e) {
                        triggered = e;
                    });

            splitter.find(".t-collapse-prev").trigger("click");

            ok(triggered);
            equals(triggered.pane, splitter.find(".t-pane:first")[0]);
        });

        test("collapse event can be prevented", function() {
            var splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { collapsible: true }, {} ]
                    })
                    .bind("collapse", function(e) {
                        e.preventDefault();
                    });

            splitter.find(".t-collapse-prev").trigger("click");

            ok(!splitter.find(".t-pane:first").data("pane").collapsed);
        });

        test("clicking collapse arrow calls splitter.collapse", function() {
            var called,
                splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { collapsible: true }, {} ]
                    });

            splitter.data("tSplitter").collapse = function(pane) {
                called = pane;
            }

            splitter.find(".t-collapse-prev").trigger("click");

            equals(called, splitter.find(".t-pane:first")[0]);
        });

        test("double-clicking splitbar next to an expanded collapsible pane should call splitter.collapse", function() {
            var called,
                splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { collapsible: true }, {} ]
                    });

            splitter.data("tSplitter").collapse = function(pane) {
                called = pane;
            }

            splitter.find(".t-splitbar").trigger("dblclick");

            equals(called, splitter.find(".t-pane:first")[0]);
        });

        test("double-clicking splitbar prev to an expanded collapsible pane should call splitter.collapse", function() {
            var called,
                splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ {}, { collapsible: true } ]
                    });

            splitter.data("tSplitter").collapse = function(pane) {
                called = pane;
            }

            splitter.find(".t-splitbar").trigger("dblclick");

            equals(called, splitter.find(".t-pane:last")[0]);
        });

        
        module("Splitter / Expand", {
            teardown: function() {
                $(".t-splitter").remove();
            }
        });

        test("clicking expand arrow triggers expand event", function() {
            var triggered = false,
                splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { collapsible: true, collapsed: true }, {} ]
                    })
                    .bind("expand", function(e) {
                        triggered = e;
                    });

            splitter.find(".t-expand-prev").trigger("click");

            ok(triggered);
            equals(triggered.pane, splitter.find(".t-pane:first")[0]);
        });

        test("expand event can be prevented", function() {
            var splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { collapsible: true, collapsed: true }, {} ]
                    })
                    .bind("expand", function(e) {
                        e.preventDefault();
                    });

            splitter.find(".t-expand-prev").trigger("click");

            ok(splitter.find(".t-pane:first").data("pane").collapsed);
        });

        test("clicking expand arrow calls splitter.expand", function() {
            var called,
                splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { collapsible: true, collapsed: true }, {} ]
                    });

            splitter.data("tSplitter").expand = function(pane) {
                called = pane;
            }

            splitter.find(".t-expand-prev").trigger("click");

            equals(called, splitter.find(".t-pane:first")[0]);
        });

        test("double-clicking splitbar next to an collapsed collapsible pane should call splitter.collapse", function() {
            var called,
                splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { collapsible: true, collapsed: true }, {} ]
                    });

            splitter.data("tSplitter").expand = function(pane) {
                called = pane;
            }

            splitter.find(".t-splitbar").trigger("dblclick");

            equals(called, splitter.find(".t-pane:first")[0]);
        });

        test("double-clicking splitbar prev to an collapsed collapsible pane should call splitter.collapse", function() {
            var called,
                splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { }, { collapsible: true, collapsed: true } ]
                    });

            splitter.data("tSplitter").expand = function(pane) {
                called = pane;
            }

            splitter.find(".t-splitbar").trigger("dblclick");

            equals(called, splitter.find(".t-pane:last")[0]);
        });

        test("double-clicking splitbar between two collapsible panes does not trigger collapse", function() {
            var called,
                splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { collapsible: true }, { collapsible: true } ]
                    });

            splitter.data("tSplitter").collapse = function(pane) {
                called = pane;
            }

            splitter.find(".t-splitbar").trigger("dblclick");

            ok(!called);
        });

        test("expanding a resizable pane adds draggable class", function() {
            var splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { collapsible: false }, { collapsible: true, collapsed: true } ]
                    });

            splitter.data("tSplitter").expand(".t-pane:last");

            ok(splitter.find(".t-splitbar").is(".t-splitbar-draggable-horizontal"))
        });

        test("expanding a non-resizable pane does not make it resizable", function() {
            var splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { resizable: false, collapsible: true, collapsed: true }, { collapsible: false } ]
                    });

            splitter.data("tSplitter").expand(".t-pane:first");

            ok(splitter.find(".t-splitbar").is(":not(.t-splitbar-draggable-horizontal)"))
        });

        test("expanding a non-resizable pane does not modify more splitbars than necessary", function() {
            var splitter = $(getSplitterHtml(3))
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { resizable: false, collapsible: true, collapsed: true }, { collapsible: false }, { collapsible: false } ]
                    });

            splitter.data("tSplitter").expand(".t-pane:first");

            ok(splitter.find(".t-splitbar:first").is(":not(.t-splitbar-draggable-horizontal)"));
            ok(splitter.find(".t-splitbar:last").is(".t-splitbar-draggable-horizontal"));
        });

    </script>

</asp:Content>
