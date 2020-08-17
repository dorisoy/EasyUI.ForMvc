<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

   <%= Html.EasyUI().Editor().Name("Editor") %>

    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">
        var editor;
        var UnlinkCommand;

        module("Editor / UnlinkCommand", {
            setup: function() {
                editor = getEditor();
                UnlinkCommand = $.easyui.editor.UnlinkCommand;
            }
        });

        test('exec removes link', function() {
            var range = createRangeFromText(editor, '<a>|foo|</a>');
            var command = new UnlinkCommand({range:range});
            command.exec();
            equal(editor.value(), 'foo');
        });        
        
        test('exec removes link with mixed selection', function() {
            var range = createRangeFromText(editor, '|foo<a>bar</a>baz|');
            var command = new UnlinkCommand({range:range});
            command.exec();
            equal(editor.value(), 'foobarbaz');
        });

        test('exec maintains selection', function() {
            var range = createRangeFromText(editor, '<a>|foo|</a>');
            var command = new UnlinkCommand({range:range});
            command.exec();
            range = editor.getRange();
            equal(range.startOffset, 0);
            equal(range.endOffset, 3);
        });
        
        test('exec from cursor', function() {
            editor.value('<a>foo</a>');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild.firstChild, 1);
            range.collapse(true);

            var command = new UnlinkCommand({range:range});
            command.exec();

            equal(editor.value(), 'foo');
        });

        test('unlink tool is initially disabled', function() {
            editor.focus();
            var range = createRangeFromText(editor, '|foo|');
            editor.selectRange(range);
            $(editor.element).trigger('selectionChange');
            ok($('.t-unlink').hasClass('t-state-disabled'));
        });
        
        test('unlink tool is enabled when cursor is inside a link', function() {
            editor.focus();
            var range = createRangeFromText(editor, '<a>|foo|</a>');
            editor.selectRange(range);
            
            $(editor.element).trigger('selectionChange');
            ok(!$('.t-unlink').hasClass('t-state-disabled'));
        });
        
        test('unlink tool is enabled when there is a link in the selection', function() {
            editor.focus();
            var range = createRangeFromText(editor, '|foo<a>bar</a>baz|');
            editor.selectRange(range);
            
            $(editor.element).trigger('selectionChange');
            ok(!$('.t-unlink').hasClass('t-state-disabled'));
        });

</script>

</asp:Content>