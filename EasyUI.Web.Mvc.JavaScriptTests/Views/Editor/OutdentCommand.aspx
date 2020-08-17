<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

     <%= Html.EasyUI().Editor().Name("Editor") %>
    
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>
    
    <script type="text/javascript">
        var editor;
        var OutdentCommand;

        module("Editor / OutdentCommand", {
            setup: function() {
                editor = getEditor();
                OutdentCommand = $.easyui.editor.OutdentCommand;
            }
        });

        test('exec indents', function() {
            var range = createRangeFromText(editor, '<div style="margin-left:30px;">|foo|</div>');
            var command = new OutdentCommand({range:range});
            command.exec();
            equal(editor.value(), '<div>foo</div>');
        });

        test('undo removes margin', function() {
            var range = createRangeFromText(editor, '<div style="margin-left:30px;">|foo|</div>');
            var command = new OutdentCommand({range:range});
            command.exec();
            command.undo();

            equal(editor.value(), '<div style="margin-left:30px;">foo</div>');
        });
        
        test('redo indents', function() {
            var range = createRangeFromText(editor, '<div style="margin-left:30px;">|foo|</div>');
            var command = new OutdentCommand({ range: range });
            command.exec();
            command.undo();
            command.exec();

            equal(editor.value(), '<div>foo</div>');
        });

        test('tool is initially disabled', function() {
            editor.value('foo');
            editor.focus();
            $(editor.element).trigger('selectionChange');
            ok($('.t-outdent').hasClass('t-state-disabled'));
        });    
        
        test('tool is enabled when cursor is inside block node with marginLeft', function() {
            var range = createRangeFromText(editor, '<p style="margin-left:10px">|foo|</p>');
            editor.selectRange(range);
            editor.focus();
            $(editor.element).trigger('selectionChange');
            ok(!$('.t-outdent').hasClass('t-state-disabled'));
        });

        test('tool is enabled for nested list item', function() {
            var range = createRangeFromText(editor, '<ul><li>bar<ul><li>f|o|o</li></ul></li></ul>');
            editor.selectRange(range);
            editor.focus();
            $(editor.element).trigger('selectionChange');
            ok(!$('.t-outdent').hasClass('t-state-disabled'));
        });
        
        test('tool is disabled for first-level lists', function() {
            var range = createRangeFromText(editor, '<ul><li>|foo|</li></ul>');
            editor.selectRange(range);
            editor.focus();
            $(editor.element).trigger('selectionChange');
            ok($('.t-outdent').hasClass('t-state-disabled'));
        });
        
        test('tool is enabled for first-level lists with marginLeft', function() {
            var range = createRangeFromText(editor, '<ul style="margin-left:30px;"><li>|foo|</li></ul>');
            editor.selectRange(range);
            editor.focus();
            $(editor.element).trigger('selectionChange');
            ok(!$('.t-outdent').hasClass('t-state-disabled'));
        });

    </script>

</asp:Content>