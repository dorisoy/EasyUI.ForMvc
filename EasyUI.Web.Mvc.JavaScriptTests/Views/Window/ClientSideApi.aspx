<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    
    <%= Html.EasyUI().Window()
            .Name("Window")
            .Title("Title")
            .Content("Content")
            .Effects(fx => fx.Toggle()) 
    %>

    <%= Html.EasyUI().Window()
            .Name("ModalWindow")
            .Title("Modal Window")
            .Content("No content to display")
            .Modal(true)
            .Visible(false)
            .Effects(fx => fx.Toggle()) 
    %>

    <div id="test" style="padding:50px;margin:50px"><div id="Window1" class="t-widget t-window"></div></div>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">    

        var oWindow;

        function getWindow(selector) {
            return $(selector || '#Window').data('tWindow');
        }
    
        module("Window / ClientSideApi", {
            setup: function() {
                oWindow = getWindow();
            },
            teardown: function() {
            }
        });
    
        test('title gets title', function() {
            equal(oWindow.title(), 'Title');
        });
    
        test('title sets title', function() {
            var oldTitle = oWindow.title();
            var titleElement = $('.t-window-title', oWindow.element);

            oWindow.title('Title is the new title!');

            equal(titleElement.text(), 'Title is the new title!');

            oWindow.title(oldTitle);

            equal(titleElement.text(), oldTitle);
        });
    
        test('content gets content', function() {
            equal(oWindow.content(), 'Content');
        });
    
        test('content sets content', function() {
            var oldContent = oWindow.content();
            var contentElement = $('.t-window-content', oWindow.element);

            oWindow.content('Content is the new content!');

            equal(contentElement.text(), 'Content is the new content!');

            oWindow.content(oldContent);
        
            equal(contentElement.text(), oldContent);
        });

        test('open of modal window adds overlay if it does not exist', function() {
            $('body > .t-overlay').remove();

            getWindow('#ModalWindow').open();

            equal($('body > .t-overlay').length, 1);
        });

        test('dblclick on resizable window title maximizes window', function() {
            var $window = $('<div />').tWindow();

            $window.find('.t-window-titlebar').trigger('dblclick');

            ok($window.data('tWindow').isMaximized);
        });

        test('dblclick on non resizable window title does not maximize window', function() {
            var $window = $('<div />').tWindow({ resizable: false });

            $window.find('.t-window-titlebar').trigger('dblclick');

            ok(!$window.data('tWindow').isMaximized);
        });

        test('open method set offset left and top to auto', function() {
            var $window = $('#Window1');
            $.easyui.window.create($window[0], {});
       
            var initialOffset = $window.show().offset();
            $window.hide();

            $window.tWindow().data('tWindow').open();

            var afterOpenOffset = $window.offset();
        
            equal(afterOpenOffset.left - 20, parseInt(initialOffset.left));
            equal(afterOpenOffset.top - 20, parseInt(initialOffset.top));
            $window.tWindow().data('tWindow').close();
        });

        test('title function works after client-side creation', function () {
            var wnd = $.easyui.window.create({
                    title: 'foo',
                    modal: false
                });

            equal(wnd.find('.t-window-title').text(), 'foo');

            wnd.data('tWindow').title('bar');

            equal(wnd.find('.t-window-title').text(), 'bar');
        });

        test('destroying a modal window moves overlay before previous window', function() {
            $(".t-window,.t-overlay").remove();

            var dialog = $t.window.create({
                html: "foo",
                modal: true
            });

            var overlappingDialog = $t.window.create({
                html: "bar",
                modal: true
            });

            overlappingDialog.data("tWindow").destroy();
            ok(dialog.prev("div").is(".t-overlay"));
        });

        test('closing a modal window moves overlay before previous window', function() {
            $(".t-window,.t-overlay").remove();

            var dialog = $t.window.create({
                html: "foo",
                modal: true
            });

            var overlappingDialog = $t.window.create({
                html: "bar",
                modal: true
            });

            overlappingDialog.data("tWindow").close();
            ok(dialog.prev("div").is(".t-overlay"));
        });

        test('ajaxRequest() sends provided data to url', function() {
            var ajax = $.ajax;

            try {

                expect(2);

                $.ajax = function(settings) {
                    equal(settings.url, "/Window/foo");
                    same(settings.data, { id: 1 });
                };

                $(".t-window,.t-overlay").remove();

                var dialog = $t.window.create({ html: "foo" });

                dialog.data("tWindow").ajaxRequest("/Window/foo", { id: 1 });
                
            } finally {
                $.ajax = ajax;
            }
        });

    </script>

</asp:Content>
