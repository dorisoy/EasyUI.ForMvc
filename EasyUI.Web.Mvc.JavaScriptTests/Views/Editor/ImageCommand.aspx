<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <%= Html.EasyUI().Editor().Name("Editor") %>

    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">
        var editor;
        var ImageCommand;

        function execImageCommandOnRange(range) {
            var command = new ImageCommand({ range: range });
            command.editor = editor;
            command.exec();

            return command;
        }

        module("Editor / ImageCommand", {
            setup: function() {
                editor = getEditor();
                ImageCommand = $.easyui.editor.ImageCommand;
            },
            teardown: function() {
                var wnd = $('.t-window').data('tWindow');
                if (wnd) wnd.destroy();
            }
        });

        test('exec creates window', function() {
            var range = createRangeFromText(editor, '|foo|');
            execImageCommandOnRange(range);

            equal($('.t-window').length, 1)
        });

        test('clicking close closes the window', function() {
            var range = createRangeFromText(editor, '|foo|');
            execImageCommandOnRange(range);

            $('.t-dialog-close').click();
            equal($('.t-window').length, 0)
        });

        test('clicking insert closes the window', function() {
            var range = createRangeFromText(editor, '|foo|');
            execImageCommandOnRange(range);

            $('.t-dialog-insert').click();
            equal($('.t-window').length, 0)
        });

        test('clicking insert inserts image if url is set', function() {
            var range = createRangeFromText(editor, '|foo|');
            execImageCommandOnRange(range);

            $('#t-editor-image-url').val('foo');
            $('.t-dialog-insert').click();
            equal(editor.value(), '<img alt="" src="foo" />')
        });

        test('clicking insert does not inserts image if url is not set', function() {
            var range = createRangeFromText(editor, '|foo|');
            execImageCommandOnRange(range);

            $('#t-editor-image-url').val('');
            $('.t-dialog-insert').click();
            equal(editor.value(), 'foo')
        });

        test('clicking insert updates existing src', function() {
            editor.value('<img src="bar" style="float:left" />');
            var range = editor.createRange();
            range.selectNode(editor.body.firstChild);
            execImageCommandOnRange(range);

            $('#t-editor-image-url').val('foo');
            $('.t-dialog-insert').click();
            equal(editor.value(), '<img alt="" src="foo" style="float:left;" />')
        });

        test('url text is set', function() {
            editor.value('<img src="bar" />');
            var range = editor.createRange();
            range.selectNode(editor.body.firstChild);
            execImageCommandOnRange(range);

            equal($('#t-editor-image-url').val(), 'bar');
        });

        test('hitting enter in url inserts image', function() {
            var range = createRangeFromText(editor, '|foo|');
            execImageCommandOnRange(range);

            var e = new $.Event();
            e.type = 'keydown';
            e.keyCode = 13;

            $('#t-editor-image-url')
                .val('http://foo')
                .trigger(e);

            equal(editor.value(), '<img alt="" src="http://foo" />')
            equal($('.t-window').length, 0);
        });

        test('hitting esc in url cancels', function() {
            var range = createRangeFromText(editor, '|foo|');
            execImageCommandOnRange(range);

            var e = new $.Event();
            e.type = 'keydown';
            e.keyCode = 27;

            $('#t-editor-image-url')
                .val('foo')
                .trigger(e);

            equal(editor.value(), 'foo')
            equal($('.t-window').length, 0);
        });

        test('hitting enter in title field inserts link', function() {
            var range = createRangeFromText(editor, '|foo|');
            execImageCommandOnRange(range);

            var e = new $.Event();
            e.type = 'keydown';
            e.keyCode = 13;

            $('#t-editor-image-url')
                .val('http://foo')
            $('#t-editor-image-title').trigger(e);

            equal(editor.value(), '<img alt="" src="http://foo" />')
            equal($('.t-window').length, 0);
        });

        test('hitting esc in title cancels', function() {
            var range = createRangeFromText(editor, '|foo|');
            execImageCommandOnRange(range);

            var e = new $.Event();
            e.type = 'keydown';
            e.keyCode = 27;

            $('#t-editor-image-url')
                .val('foo')

            $('#t-editor-image-title').trigger(e);

            equal(editor.value(), 'foo')
            equal($('.t-window').length, 0);
        });

        test('setting title sets alt', function() {
            var range = createRangeFromText(editor, '|foo|');
            execImageCommandOnRange(range);

            $('#t-editor-image-url')
                .val('http://foo');

            $('#t-editor-image-title')
                .val('bar')

            $('.t-dialog-insert').click();
            equal(editor.value(), '<img alt="bar" src="http://foo" />')
        });

        test('title text box is filled from alt', function() {
            editor.value('<img src="foo" alt="bar" />');
            var range = editor.createRange();
            range.selectNode(editor.body.firstChild);
            execImageCommandOnRange(range);

            equal($('#t-editor-image-title').val(), 'bar');
        });

        test('undo restores content', function() {
            var range = createRangeFromText(editor, '|foo|');

            var command = execImageCommandOnRange(range);

            $('#t-editor-image-url')
                .val('foo');

            $('.t-dialog-insert').click();
            command.undo();
            equal(editor.value(), 'foo');
        });


        test('exec inserts image with empty range', function() {
            editor.value('foo ');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 4);
            range.setEnd(editor.body.firstChild, 4);
            
            execImageCommandOnRange(range);

            $('#t-editor-image-url')
                .val('http://foo');

            $('.t-dialog-insert').click();
            equal(editor.value(), 'foo <img alt="" src="http://foo" />')
        });

        test('link is not created if url is http slash slash', function() {
            var range = createRangeFromText(editor, '|foo|');
            
            execImageCommandOnRange(range);

            $('.t-dialog-insert').click();
            equal(editor.value(), 'foo')
        });

        test('cursor is put after image', function() {
            var range = createRangeFromText(editor, '|foo|bar');
            execImageCommandOnRange(range);

            $('#t-editor-image-url')
                .val('http://foo');
            
            $('.t-dialog-insert').click();
            
            range = editor.getRange();
            range.insertNode(editor.document.createElement('span'));
            equal(editor.value(), '<img alt="" src="http://foo" /><span></span>bar');
        });

        test('closing the window restores content', function() {
            var range = createRangeFromText(editor, '|foo|');
            execImageCommandOnRange(range);
            
            $('.t-window').css({width:200,height:300}).find('.t-close').click();

            equal(editor.value(), 'foo')
            equal($('.t-window').length, 0);
        });

</script>

</asp:Content>