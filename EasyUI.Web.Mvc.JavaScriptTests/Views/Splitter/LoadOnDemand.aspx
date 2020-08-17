<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <% Html.RegisterSplitterScripts(); %>

</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">
        
        module("Splitter / LoadOnDemand", {
            teardown: function() {
                $(".t-splitter").remove();
            }
        });

        test("ajaxRequest calls ajaxOptions", function() {
            var url = '<%= Url.Action("LoadOnDemand", "Splitter", new { echo = "foo" }) %>',
                called = false,
                splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter({
                        ajaxOptions: function() {
                            called = true;
                            return $t.splitter.prototype.ajaxOptions.apply(this, arguments);
                        },
                        panes: [ {}, { contentUrl: url } ]
                    })
                    .data("tSplitter");

            splitter.ajaxRequest(".t-pane:first");

            ok(called);
        });

        test("ajaxRequest loads custom urls", function() {
            var url = '<%= Url.Action("LoadOnDemand", "Splitter", new { echo = "foo" }) %>',
                customUrl = '<%= Url.Action("LoadOnDemand", "Splitter", new { echo = "bar" }) %>',
                requestedUrl,
                splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .bind("ajaxSend", function(e, request, settings) {
                        e.preventDefault();
                        requestedUrl = settings.url;
                    })
                    .tSplitter().data("tSplitter");

            splitter.ajaxRequest(".t-pane:first", customUrl);

            equals(requestedUrl, customUrl);
        });

        test("splitter loads content for LoadOnDemand panes when initializing", function() {
            var counter = 0,
                url = '<%= Url.Action("LoadOnDemand", "Splitter", new { echo = "foo" }) %>',
                requestedUrl;

            $(getSplitterHtml())
                .appendTo(document.body)
                .bind("ajaxSend", function(e, request, settings) {
                    e.preventDefault();
                    counter++;
                    requestedUrl = settings.url;
                })
                .tSplitter({
                    panes: [ {}, { contentUrl: url } ]
                });

            equals(counter, 1);
            equals(requestedUrl, url);
        });

        asyncTest("ajaxRequest places loaded data in target pane", function() {
            var url = '<%= Url.Action("LoadOnDemand", "Splitter", new { echo = "foobar" }) %>',
                splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter()
                    .bind("ajaxComplete", function(e, request, settings) {
                        if (settings.url === url) {
                            start();
                            equals(splitter.find(".t-pane:first")[0].innerHTML, "foobar");
                        }
                    });

            splitter.data("tSplitter").ajaxRequest(".t-pane:first", url);
        });

        asyncTest("ajaxRequest places loading icon in pane", function() {
            var url = '<%= Url.Action("LoadOnDemand", "Splitter", new { echo = "foobar" }) %>',
                splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter()
                    .bind("ajaxSend", function(e, request, settings) {
                        request.abort();
                    });

            splitter.data("tSplitter").ajaxRequest(".t-pane:first", url);

            setTimeout(function() {
                start();
                equals(splitter.find(".t-pane-loading.t-loading").length, 1);
                ok(splitter.find(".t-pane-loading.t-loading").parent().is(".t-pane:first"));
            }, 500);
        });

        asyncTest("ajaxRequest triggers contentLoad event", function() {
            var url = '<%= Url.Action("LoadOnDemand", "Splitter", new { echo = "foobar" }) %>',
                triggered = false,
                splitter = $(getSplitterHtml())
                    .appendTo(document.body)
                    .tSplitter()
                    .bind("contentLoad", function(e) {
                        triggered = e;
                    })
                    .bind("ajaxComplete", function(e, request, settings) {
                        if (settings.url === url) {
                            start();
                            ok(triggered);
                            equals(triggered.pane, splitter.find(".t-pane:first")[0]);
                        }
                    });

            splitter.data("tSplitter").ajaxRequest(".t-pane:first", url);
        });

    </script>

</asp:Content>
