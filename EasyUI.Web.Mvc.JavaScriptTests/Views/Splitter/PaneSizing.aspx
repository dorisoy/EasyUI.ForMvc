﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <% Html.RegisterSplitterScripts(); %>
    
</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">
        
        module("Horizontal sizing", {
            teardown: function() {
                $('.t-splitter').remove();
            }
        });

        test("fluid resizable panes get equal sizes and a splitbar between them", function() {
            var splitter = $(getSplitterHtml()).width(307).appendTo(document.body).tSplitter(),
                panes = splitter.find(".t-pane");

            equals(panes.eq(0).width(), 150);
            equals(panes.eq(1).width(), 150);
            equals(panes.eq(1).offset().left - panes.offset().left, 157);
            equals(splitter.find(".t-splitbar").offset().left - panes.offset().left, 150);
        });

        test("fluid panes get their size after allocating space for fixed panes", function() {
            var splitter = $(getSplitterHtml()).width(307).appendTo(document.body).tSplitter({
                    panes: [
                        { size: "100px" },
                        {}
                    ]
                }),
                panes = splitter.find(".t-pane");

            equals(panes.eq(0).width(), 100);
            equals(panes.eq(1).width(), 200);
        });

        test("fluid panes get their size after allocating space for percentage panes", function() {
            var splitter = $(getSplitterHtml(3)).width(314).appendTo(document.body).tSplitter({
                    panes: [
                        { size: "10%" },
                        {},
                        { size: "30%" }
                    ]
                }),
                panes = splitter.find(".t-pane");

            equals(panes.eq(0).width(), 30);
            equals(panes.eq(1).width(), 180);
            equals(panes.eq(2).width(), 90);
        });
        
        test("sizes of percentage panes get properly rounded", function() {
            var splitter = $(getSplitterHtml()).width(208).appendTo(document.body).tSplitter({
                    panes: [
                        { size: "10%" },
                        {}
                    ]
                }),
                panes = splitter.find(".t-pane");

            equals(panes[0].style.width, "20px");
        });

        test("sizes of fluid panes get properly rounded", function() {
            var splitter = $(getSplitterHtml()).width(208).appendTo(document.body).tSplitter(),
                panes = splitter.find(".t-pane");

            equals(panes.eq(0).width(), 100);
            equals(panes.eq(1).width(), 101);
        });
        
        module("Vertical sizing", {
            teardown: function() {
                $('.t-splitter').remove();
            }
        });

        test("fluid resizable panes get equal sizes and a splitbar between them", function() {
            var splitter = $(getSplitterHtml()).height(307).appendTo(document.body).tSplitter({ orientation: "vertical" }),
                panes = splitter.find(".t-pane");

            equals(panes.eq(0).height(), 150);
            equals(panes.eq(1).height(), 150);
            equals(panes.eq(1).offset().top - panes.offset().top, 157);
            equals(splitter.find(".t-splitbar").offset().top - panes.offset().top, 150);
        });

        test("fluid panes get their size after allocating space for fixed panes", function() {
            var splitter = $(getSplitterHtml()).height(307).appendTo(document.body).tSplitter({
                    orientation: "vertical",
                    panes: [
                        { size: "100px" },
                        {}
                    ]
                }),
                panes = splitter.find(".t-pane");

            equals(panes.eq(0).height(), 100);
            equals(panes.eq(1).height(), 200);
        });

        test("fluid panes get their size after allocating space for percentage panes", function() {
            var splitter = $(getSplitterHtml(3)).height(314).appendTo(document.body).tSplitter({
                    orientation: "vertical",
                    panes: [
                        { size: "10%" },
                        {},
                        { size: "30%" }
                    ]
                }),
                panes = splitter.find(".t-pane");

            equals(panes.eq(0).height(), 30);
            equals(panes.eq(1).height(), 180);
            equals(panes.eq(2).height(), 90);
        });
        
        test("sizes of percentage panes get properly rounded", function() {
            var splitter = $(getSplitterHtml()).height(208).appendTo(document.body).tSplitter({
                    orientation: "vertical",
                    panes: [
                        { size: "10%" },
                        {}
                    ]
                }),
                panes = splitter.find(".t-pane");

            equals(panes[0].style.height, "20px");
        });

        test("sizes of fluid panes get properly rounded", function() {
            var splitter = $(getSplitterHtml()).height(208).appendTo(document.body).tSplitter({ orientation: "vertical" }),
                panes = splitter.find(".t-pane");

            equals(panes.eq(0).height(), 100);
            equals(panes.eq(1).height(), 101);
        });

        module("Sizing with collapsing", {
            teardown: function() {
                $('.t-splitter').remove();
            }
        });

        test("collapsed panes have size 0", function() {
            var splitter = $(getSplitterHtml()).appendTo(document.body).tSplitter({
                    panes: [{ collapsed: true }, {}]
                }),
                panes = splitter.find(".t-pane");

            equals(panes.eq(0).width(), 0);
            equals(panes.eq(1).width(), 200);
        });

    </script>

</asp:Content>
