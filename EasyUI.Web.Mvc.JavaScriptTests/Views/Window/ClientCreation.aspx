<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <div id="Window1"></div>
    <div id="Window2"></div>
    <div id="Window3"></div>
    <div id="Window4"></div>
    <div id="Window5"></div>
    <div id="Window6"></div>
    <div id="Window7"></div>
    <div id="Window8"></div>
    <div id="Window9"></div>
    <div id="Window10"></div>

    <% Html.EasyUI().ScriptRegistrar().DefaultGroup(group => group
           .Add("easyui.common.js")
           .Add("easyui.draganddrop.js")
           .Add("easyui.window.js")); %>

</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">

        module("Window / ClientCreation", {
            teardown: function() {
                $(".t-window").each(function() {
                    $(this).data("tWindow").destroy();
                });
           } 
        });

        $.extend($.fn.tWindow.defaults, {
            effects: { list: [{ name: 'toggle' }], openDuration: 'fast', closeDuration: 'fast' }
        });

        test('creates default html structure', function() {
            var dialog = $('#Window1').tWindow();

            ok(dialog.is('.t-widget, .t-window'));
            ok(dialog.children().eq(0).is('.t-window-titlebar, .t-header'));
        });

        test('if contentUrl is local call ajaxRequest on refresh method', function() {
            var dialog = $('#Window2').tWindow().data('tWindow');
            var hasRequestedData = false;

            dialog.contentUrl = "~/something";

            dialog.ajaxRequest = function () { hasRequestedData = true };

            dialog.refresh();

            ok(hasRequestedData);
        });

        test('if contentUrl is remote should not call ajaxRequest on refresh method', function() {
            var dialog = $('#Window3').tWindow().data('tWindow');
            var hasRequestedData = false;

            dialog.contentUrl = "http://";

            dialog.ajaxRequest = function () { hasRequestedData = true };

            dialog.refresh();

            ok(!hasRequestedData);
        });

        test('if contentUrl is local and relative should call ajaxRequest on refresh method', function() {
            var dialog = $('#Window4').tWindow().data('tWindow');
            var hasRequestedData = false;

            dialog.contentUrl = "httpfoo";

            dialog.ajaxRequest = function () { hasRequestedData = true };

            dialog.refresh();

            ok(hasRequestedData);
        });

        test('construction triggers open and activate events', function() {
            var isActivated = false,
                isOpened = false;

            var dialog = $('#Window5').tWindow({
                    onOpen: function () { isOpened = true; },
                    onActivate: function () {isActivated = true; }
                }).data('tWindow');

            ok(isActivated);
            ok(isOpened);
        });

        test('construction does not trigger open and activate events on hidden windows', function() {
            var isActivated = false,
                isOpened = false;

            var dialog = $('<div />').hide().tWindow({
                    onOpen: function () { isOpened = true; },
                    onActivate: function () {isActivated = true; }
                }).data('tWindow');

            ok(!isActivated);
            ok(!isOpened);
        });

        test('construction of modal window shows overlay', function() {
            var dialog = $t.window.create({
                    html: '<div id="content">content</div>',
                    modal: true
                }).data('tWindow');

            ok($('.t-overlay').is(':visible'));
        });

        test('construction of modal window renders overlay with a z-index smaller by 1', function() {
            var dialog = $t.window.create({
                    html: '<div id="content">content</div>',
                    modal: true
                }).data('tWindow');

            ok(parseInt($('.t-overlay').css('zIndex'), 10) == parseInt($(dialog.element).css('zIndex'), 10) - 1);
        });

        test('hiding second modal window does not hide first overlay', function() {
            var dialog1 = $t.window.create({
                    html: 'content',
                    modal: true
                }).data('tWindow');

            var dialog2 = $t.window.create({
                    html: 'content, too',
                    modal: true
                }).data('tWindow');

            dialog2.close();

            ok($('.t-overlay').is(':visible'));

            dialog1.close();

            ok(!$('.t-overlay').is(':visible'));

            dialog1.open();

            ok($('.t-overlay').is(':visible'));
        });

        test('destroy() does not delete overlay if there are other opened modal windows', function() {
            var dialog1 = $t.window.create({
                    html: 'content',
                    modal: true
                }).data('tWindow');

            var dialog2 = $t.window.create({
                    html: 'content, too',
                    modal: true
                }).data('tWindow');

            dialog2.destroy();

            equals($('.t-overlay').length, 1);
            ok($('.t-overlay').is(':visible'));

            dialog1.destroy();

            equals($('.t-overlay').length, 0);
        });

        test('creating a modal window after closing another shows overlay', function() {
            var dialog1 = $t.window.create({
                    html: 'content',
                    modal: true
                }).data('tWindow');

            dialog1.close();

            var dialog2 = $t.window.create({
                    html: 'content, too',
                    modal: true
                }).data('tWindow');

            ok($('.t-overlay').is(':visible'));
        });

        test('creating a window with a remote contentUrl creates iframe', function() {
            var dialog = $t.window.create({
                    contentUrl: 'http://google.com/',
                    title: 'title'
                }),
                iframe = dialog.find('iframe');

            equals(iframe.length, 1);
            equals(iframe.attr('title'), 'title');
            equals(iframe.attr('src'), 'http://google.com/');
        });

        test('creating a window with a contentUrl on the same server does not create iframe', function() {
            var dialog = $t.window.create({
                contentUrl: '<%= Url.Action("Blank", "Window") %>'
            });

            equals(dialog.find('iframe').length, 0);
        });

        test('creating a window without a contentUrl does not create iframe', function() {
            var dialog = $('<div />').appendTo(document.body).tWindow();

            equals(dialog.find('iframe').length, 0);
        });

        test('creating a window with html and contentUrl', function() {
            var dialog = $t.window.create({
                html: "foo",
                contentUrl: '<%= Url.Action("Blank", "Window") %>'
            });

            equals(dialog.find('.t-window-content')[0].innerHTML, "foo");
        });

        test('creating a modal adds overlay and places it before the window markup', function() {
            var dialog = $t.window.create({
                html: "foo",
                modal: true
            });

            ok(dialog.prev("div").is(".t-overlay"));
        });

        test('creating a second modal moves overlay after the first one', function() {
            var dialog = $t.window.create({
                html: "foo",
                modal: true
            });

            var overlappingDialog = $t.window.create({
                html: "bar",
                modal: true
            });

            ok(!dialog.prev("div").is(".t-overlay"));
            ok(overlappingDialog.prev("div").is(".t-overlay"));
            same(dialog.next("div")[0], overlappingDialog.prev("div")[0]);
        });

        test('creating a hidden modal window does not hide overlay', function() {
            $t.window.create({
                html: "foo",
                modal: true
            });

            $("<div style='display: none' />").appendTo(document.body).tWindow({ modal: true });

            ok($(".t-overlay").is(":visible"));
        });

        test('opening a Window moves it on top of all others', function() {
            var w1 = $('#Window6').tWindow().data("tWindow");
            var w2 = $('#Window7').tWindow().data("tWindow");
            var w3 = $('#Window8').tWindow().data("tWindow");

            w3.open();
            w1.open();
            w2.open();

            var z1 = parseInt($(w1.element).css("zIndex"), 10);
            var z2 = parseInt($(w2.element).css("zIndex"), 10);
            var z3 = parseInt($(w3.element).css("zIndex"), 10);

            ok(z2 > z1);
            ok(z1 > z3);
        });

        test('opening a modal Window on top of another changes the z-index of the overlay', function() {
            var w1 = $('#Window9').tWindow({modal: true}).data("tWindow");
            var w2 = $('#Window10').tWindow({modal: true}).data("tWindow");

            w2.open();
            w1.open();

            var windowZ = parseInt($(w1.element).css("zIndex"), 10);
            var overlayZ = parseInt($(".t-overlay").css("zIndex"), 10);

            ok(windowZ == overlayZ + 1);
        });

        test('creating a window from element with script content', function() {
            var calls = 0;
            window.temp = function() {
                calls++;
            }
            var dialog = $t.window.create({
                html: "foo<script>temp();<\/script>bar"
            });

            ok(dialog);
            equal(calls, 1);
        });

    </script>

</asp:Content>
