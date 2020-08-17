<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        LinkCommand</h2>
    <%= Html.EasyUI().Editor().Name("Editor") %>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

        var editor;
        var LinkCommand;

        function execLinkCommandOnRange(range) {
            var command = new LinkCommand({ range: range });
            command.editor = editor;
            command.exec();

            return command;
        }

        module("Editor / LinkCommand", {
            setup: function() {
                editor = getEditor();
                LinkCommand = $.easyui.editor.LinkCommand;
            },
            teardown: function() {
                var wnd = $('.t-window').data('tWindow');
                if (wnd) wnd.destroy();
            }
        });

        test('exec creates window', function() {
            var range = createRangeFromText(editor, '|foo|');
            execLinkCommandOnRange(range);

            equal($('.t-window').length, 1)
        });

        test('clicking close closes the window', function() {
            var range = createRangeFromText(editor, '|foo|');
            execLinkCommandOnRange(range);

            $('.t-dialog-close').click();
            equal($('.t-window').length, 0)
        });

        test('clicking insert closes the window', function() {
            var range = createRangeFromText(editor, '|foo|');
            execLinkCommandOnRange(range);

            $('.t-dialog-insert').click();
            equal($('.t-window').length, 0)
        });

        test('text is filled when only text is selected', function() {
            var range = createRangeFromText(editor, '|foo bar|');
            execLinkCommandOnRange(range);

            equal($('#t-editor-link-text').val(), 'foo bar')
        });

        test('text is removed if more than one text node is selected', function() {
            var range = createRangeFromText(editor, '|foo <strong>bar</strong>|');
            execLinkCommandOnRange(range);

            equal($('label[for=t-editor-link-text]').length, 0)
            equal($('#t-editor-link-text').length, 0)
        });

        test('collapsed range is expanded', function() {
            editor.value('foo');
            var range = editor.createRange();
            
            range.setStart(editor.body.firstChild, 1);
            range.setEnd(editor.body.firstChild, 1);
            
            execLinkCommandOnRange(range);

            equal($('#t-editor-link-text').val(), 'foo')
        });

        test('clicking insert inserts link if url is set', function() {
            var range = createRangeFromText(editor, '|foo|');
            execLinkCommandOnRange(range);

            $('#t-editor-link-url').val('foo');
            $('.t-dialog-insert').click();
            equal(editor.value(), '<a href="foo">foo</a>')
        });

        test('clicking insert does not inserts link if url is not set', function() {
            var range = createRangeFromText(editor, '|foo|');
            execLinkCommandOnRange(range);

            $('#t-editor-link-url').val('');
            $('.t-dialog-insert').click();
            equal(editor.value(), 'foo')
        });

        test('clicking insert updates existing url', function() {
            var range = createRangeFromText(editor, '<a href="bar">|foo|</a>');
            execLinkCommandOnRange(range);

            $('#t-editor-link-url').val('foo');
            $('.t-dialog-insert').click();
            equal(editor.value(), '<a href="foo">foo</a>')
        });

        test('url text is set', function() {
            var range = createRangeFromText(editor, '<a href="bar">|foo|</a>');
            execLinkCommandOnRange(range);

            equal($('#t-editor-link-url').val(), 'bar');
        });

        test('hitting enter in url inserts link', function() {
            var range = createRangeFromText(editor, '|foo|');
            execLinkCommandOnRange(range);

            var e = new $.Event();
            e.type = 'keydown';
            e.keyCode = 13;
            
            $('#t-editor-link-url')
                .val('foo')
                .trigger(e);
            
            equal(editor.value(), '<a href="foo">foo</a>')
            equal($('.t-window').length, 0);
        });
        test('hitting esc in url cancels', function() {
            var range = createRangeFromText(editor, '|foo|');
            execLinkCommandOnRange(range);

            var e = new $.Event();
            e.type = 'keydown';
            e.keyCode = 27;

            $('#t-editor-link-url')
                .val('foo')
                .trigger(e);

            equal(editor.value(), 'foo')
            equal($('.t-window').length, 0);
        });

        test('hitting enter in name field inserts link', function() {
            var range = createRangeFromText(editor, '|foo|');
            execLinkCommandOnRange(range);

            var e = new $.Event();
            e.type = 'keydown';
            e.keyCode = 13;
            
            $('#t-editor-link-url')
                .val('foo')
            $('#t-editor-link-text').trigger(e);

            equal(editor.value(), '<a href="foo">foo</a>')
            equal($('.t-window').length, 0);
        });
        
        test('hitting enter in title field inserts link', function() {
            var range = createRangeFromText(editor, '|foo|');
            execLinkCommandOnRange(range);

            var e = new $.Event();
            e.type = 'keydown';
            e.keyCode = 13;

            $('#t-editor-link-url')
                .val('foo')
            $('#t-editor-link-title').trigger(e);

            equal(editor.value(), '<a href="foo">foo</a>')
            equal($('.t-window').length, 0);
        });

         test('hitting esc in text cancels', function() {
            var range = createRangeFromText(editor, '|foo|');
            execLinkCommandOnRange(range);

            var e = new $.Event();
            e.type = 'keydown';
            e.keyCode = 27;

            $('#t-editor-link-url')
                .val('foo')

            $('#t-editor-link-text').trigger(e);
            
            equal(editor.value(), 'foo')
            equal($('.t-window').length, 0);
        });
        
        test('hitting esc in title cancels', function() {
            var range = createRangeFromText(editor, '|foo|');
            execLinkCommandOnRange(range);

            var e = new $.Event();
            e.type = 'keydown';
            e.keyCode = 27;

            $('#t-editor-link-url')
                .val('foo')

            $('#t-editor-link-title').trigger(e);

            equal(editor.value(), 'foo')
            equal($('.t-window').length, 0);
        });

        test('closing the window restores content', function() {
            var range = createRangeFromText(editor, '|foo|');
            execLinkCommandOnRange(range);

            $('.t-window').css({width:200,height:300}).find('.t-close').click();

            equal(editor.value(), 'foo')
            equal($('.t-window').length, 0);
        });

        test('setting title', function() {
            var range = createRangeFromText(editor, '|foo|');
            execLinkCommandOnRange(range);

            $('#t-editor-link-url')
                .val('foo');

            $('#t-editor-link-title')
                .val('bar')

            $('.t-dialog-insert').click();
            equal(editor.value(), '<a href="foo" title="bar">foo</a>')
        });

        test('setting opening in new window', function() {
            var range = createRangeFromText(editor, '|foo|');
            execLinkCommandOnRange(range);

            $('#t-editor-link-url')
                .val('foo');

            $('#t-editor-link-target').attr('checked', true)

            $('.t-dialog-insert').click();
            equal(editor.value(), '<a href="foo" target="_blank">foo</a>')
        });

        test('title text box is updated', function() {
            var range = createRangeFromText(editor, '<a href="#" title="bar">|foo|</a>');
            execLinkCommandOnRange(range);

            equal($('#t-editor-link-title').val(), 'bar');
        });

        test('target checkbox is updated', function() {
            var range = createRangeFromText(editor, '<a href="#" target="_blank">|foo|</a>');
            execLinkCommandOnRange(range);

            ok($('#t-editor-link-target').is(':checked'));
        });

        test('updatung link text', function() {
            var range = createRangeFromText(editor, '|foo|');
            execLinkCommandOnRange(range);

            $('#t-editor-link-url')
                .val('foo');

            $('#t-editor-link-text')
                .val('bar')

            $('.t-dialog-insert').click();
            equal(editor.value(), '<a href="foo">bar</a>')
        });
        
        test('updating link text from caret', function() {
            editor.value('foo');
            var range = editor.getRange();
            range.setStart(editor.body.firstChild,1);
            range.setEnd(editor.body.firstChild,1);
            
            execLinkCommandOnRange(range);

            $('#t-editor-link-url')
                .val('foo');

            $('#t-editor-link-text')
                .val('bar')

            $('.t-dialog-insert').click();
            equal(editor.value(), '<a href="foo">bar</a>')
        });

        test('undo restores content', function() {
            editor.value('foo');
            var range = editor.getRange();
            range.setStart(editor.body.firstChild,1);
            range.setEnd(editor.body.firstChild,1);
            
            var command = execLinkCommandOnRange(range);

            $('#t-editor-link-url')
                .val('foo');

            $('#t-editor-link-text')
                .val('bar')

            $('.t-dialog-insert').click();
            command.undo();
            equal(editor.value(), 'foo');
        });

        test('redo creates link', function() {
            editor.value('foo');
            var range = editor.getRange();
            range.setStart(editor.body.firstChild,1);
            range.setEnd(editor.body.firstChild,1);
            
            var command = execLinkCommandOnRange(range);

            $('#t-editor-link-url')
                .val('foo');

            $('#t-editor-link-text')
                .val('bar')

            $('.t-dialog-insert').click();
            command.undo();
            command.redo();
            equal(editor.value(), '<a href="foo">bar</a>')            
        });

        test('link is not created if url is http slash slash', function() {
            var range = createRangeFromText(editor, '|foo|');
            
            execLinkCommandOnRange(range);

            $('.t-dialog-insert').click();
            equal(editor.value(), 'foo')            
        });
        
        test('exec inserts link with empty range', function() {
            editor.value('foo ');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 4);
            range.setEnd(editor.body.firstChild, 4);
            
            execLinkCommandOnRange(range);
            
            $('#t-editor-link-url')
                .val('bar');

            $('.t-dialog-insert').click();
            equal(editor.value(), 'foo <a href="bar"></a>')            
        });

</script>

</asp:Content>