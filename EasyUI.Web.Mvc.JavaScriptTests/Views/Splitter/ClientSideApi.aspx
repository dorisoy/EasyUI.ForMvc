﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <% Html.RegisterSplitterScripts(); %>

</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">
        
        module("Splitter / ClientSideApi", {
            teardown: function() {
                $('.t-splitter').remove();
            }
        });

        test("toggle(false) toggles pane state", function() {
            var splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { collapsible: true }, {} ]
                    }),
                pane = splitter.find(".t-pane:first");

            splitter.data("tSplitter").toggle(pane, false);

            ok(pane.data("pane").collapsed);
            
            splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ {}, { collapsible: true } ]
                    });

            pane = splitter.find(".t-pane:last")

            splitter.data("tSplitter").toggle(pane, false);

            ok(pane.data("pane").collapsed);
        });

        test("toggle(false) triggers resize", function() {
            var triggered = false,
                splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { collapsible: true }, {} ]
                    })
                    .bind("resize", function() {
                        triggered = true;
                    });

            splitter.data("tSplitter").toggle(".t-pane:last", false);

            ok(triggered);
        });

        test("toggle(false) converts associated arrow to expand arrow", function() {
            var splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { collapsible: true }, {} ]
                    }),
                previousArrow = splitter.find(".t-collapse-prev");

            splitter.data("tSplitter").toggle(".t-pane:first", false);

            ok(previousArrow.is(".t-expand-prev"));
            ok(previousArrow.is(":not(.t-collapse-prev)"));
        });

        test("toggle(false) disables splitbar resize", function() {
            var splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { collapsible: true }, {} ]
                    });
                    
            splitter.data("tSplitter").toggle(".t-pane:first", false);

            ok(!splitter.find(".t-splitbar").hasClass("t-splitbar-draggable-horizontal"));
        });
        
        test("toggle(true) removes splibar hover style", function() {
            var splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { collapsible: true, collapsed: true }, {} ]
                    });
            
            splitter.find(".t-splitbar").addClass("t-splitbar-horizontal-hover");

            splitter.data("tSplitter").toggle(".t-pane:first", false);

            ok(!splitter.find(".t-splitbar").hasClass("t-splitbar-horizontal-hover"));
        });

        test("toggle(true) toggles pane state", function() {
            var splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { collapsible: true, collapsed: true }, {} ]
                    }),
                pane = splitter.find(".t-pane:first");

            splitter.data("tSplitter").toggle(pane, true);

            ok(!pane.data("pane").collapsed);
            
            splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ {}, { collapsible: true, collapsed: true } ]
                    });

            pane = splitter.find(".t-pane:last")

            splitter.data("tSplitter").toggle(pane, true);

            ok(!pane.data("pane").collapsed);
        });
        
        test("toggle(true) triggers resize", function() {
            var triggered = false,
                splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { collapsible: true, collapsed: true }, {} ]
                    })
                    .bind("resize", function() {
                        triggered = true;
                    });

            splitter.data("tSplitter").toggle(".t-pane:first", true);

            ok(triggered);
        });
        
        test("toggle(true) converts associated arrow to collapse arrow", function() {
            var splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { collapsible: true, collapsed: true }, {} ]
                    }),
                previousArrow = splitter.find(".t-expand-prev");

            splitter.data("tSplitter").toggle(".t-pane:first", true);

            ok(previousArrow.is(".t-collapse-prev"));
            ok(previousArrow.is(":not(.t-expand-prev)"));
        });
        
        test("toggle(true) enables splitbar resize", function() {
            var splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { collapsible: true, collapsed: true }, {} ]
                    });
                    
            splitter.data("tSplitter").toggle(".t-pane:first", true);

            ok(splitter.find(".t-splitbar").hasClass("t-splitbar-draggable-horizontal"));
        });
        
        test("toggle(true) does not add splibar hover style", function() {
            var splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { collapsible: true, collapsed: true }, {} ]
                    });
                    
            splitter.data("tSplitter").toggle(".t-pane:first", true);

            ok(!splitter.find(".t-splitbar").hasClass("t-splitbar-horizontal-hover"));
        });
        
        test("toggle() without arguments toggles pane collapsed state", function() {
            var splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { collapsible: true, collapsed: true }, {} ]
                    });
                    
            splitter.data("tSplitter").toggle(".t-pane:first");
            ok(!splitter.find(".t-pane:first").data("pane").collapsed);
                    
            splitter.data("tSplitter").toggle(".t-pane:first");
            ok(splitter.find(".t-pane:first").data("pane").collapsed);

            splitter.remove();
            splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { collapsible: true }, {} ]
                    });
                    
            splitter.data("tSplitter").toggle(".t-pane:first");
            ok(splitter.find(".t-pane:first").data("pane").collapsed);
                    
            splitter.data("tSplitter").toggle(".t-pane:first");
            ok(!splitter.find(".t-pane:first").data("pane").collapsed);
        });

        test("collapse() calls toggle(false)", function() {
            var args,
                splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { collapsible: true }, {} ]
                    }).data("tSplitter");

            splitter.toggle = function() {
                args = arguments;
            };

            splitter.collapse(".t-pane:last");

            ok(args);
            equal(args.length, 2);
            equal(args[0], ".t-pane:last");
            equal(args[1], false);
        });

        test("expand() calls toggle(true)", function() {
            var args,
                splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { collapsible: true }, {} ]
                    }).data("tSplitter");

            splitter.toggle = function() {
                args = arguments;
            };

            splitter.expand(".t-pane:last");

            ok(args);
            equal(args.length, 2);
            equal(args[0], ".t-pane:last");
            equal(args[1], true);
        });

        test("size() gets/sets pane size", function() {
            var splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { size: "110px" }, {} ]
                    }).data("tSplitter"),
                firstPane = $(".t-pane:first", splitter.element);

            equals(splitter.size(firstPane), "110px");

            splitter.size(firstPane, "120px");
            
            equals(splitter.size(firstPane), "120px");
        });

        test("minSize() gets/sets pane minSize", function() {
            var splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { minSize: "110px", size: "200px" }, {} ]
                    }).data("tSplitter"),
                firstPane = $(".t-pane:first", splitter.element);

            equals(splitter.minSize(firstPane), "110px");

            splitter.minSize(firstPane, "120px");
            
            equals(splitter.minSize(firstPane), "120px");
        });

        test("maxSize() gets/sets pane maxSize", function() {
            var splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { maxSize: "200px", size: "110px" }, {} ]
                    }).data("tSplitter"),
                firstPane = $(".t-pane:first", splitter.element);

            equals(splitter.maxSize(firstPane), "200px");

            splitter.maxSize(firstPane, "120px");
            
            equals(splitter.maxSize(firstPane), "120px");
        });

        test("size(value) triggers resize", function() {
            var triggered = false,
                splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        panes: [ { size: "110px" }, {} ]
                    })
                    .bind("resize", function() {
                        triggered = true;
                    })
                    .data("tSplitter");

            splitter.size(".t-pane:first", "120px");

            ok(triggered);
        });

    </script>

</asp:Content>
