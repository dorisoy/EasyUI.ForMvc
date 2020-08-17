<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>ListCommandFormatter</h2>
    <%= Html.EasyUI().Editor().Name("Editor") %>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>
    
    <script type="text/javascript">

        var editor;

        var ListCommand;
        var enumerator;
    </script>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



        QUnit.testStart = function() {
            editor = getEditor();
            ListCommand = $.easyui.editor.ListCommand;
        }

        test('exec adds list', function() {
            var range = createRangeFromText(editor, '|foo|');
            var command = new ListCommand({tag:'ul', range:range});
            command.exec();
            equal(editor.value(), '<ul><li>foo</li></ul>');
        });

        test('undo removes list', function() {
            var range = createRangeFromText(editor, '|foo|');
            var command = new ListCommand({tag:'ul', range:range});
            command.exec();
            command.undo();

            equal(editor.value(), 'foo');
        });

        test('redo adds list', function() {
            var range = createRangeFromText(editor, '|foo|');
            var command = new ListCommand({ tag: 'ul', range: range });
            command.exec();
            command.undo();
            command.exec();

            equal(editor.value(), '<ul><li>foo</li></ul>');
        });

        test('exec with collapsed range', function() {
            editor.value('foo');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 1);
            range.setEnd(editor.body.firstChild, 1);
            var command = new ListCommand({ tag: 'ul', range: range });
            command.exec();

            equal(editor.value(), '<ul><li>foo</li></ul>');
        });

        test('apply on block element which is adjacent to list merges it with the list when the list is selected', function() {
            var range = createRangeFromText(editor, '|<ul><li>foo</li></ul><p>bar</p>|');
            var command = new ListCommand({ tag: 'ul', range: range });
            command.exec();
            equal(editor.value(), '<ul><li>foo</li><li>bar</li></ul>');
        });

        test('exec keeps selection', function() {
            editor.value('foo');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 1);
            range.setEnd(editor.body.firstChild, 1);
            var command = new ListCommand({ tag: 'ul', range: range });
            command.exec();
            range = editor.getRange();
            equal(range.startContainer, editor.body.firstChild.firstChild.firstChild);
            equal(range.startOffset, 1);
            ok(range.collapsed);
        });

        test('apply and cursor', function() {
            editor.value('foo<ul><li>bar</li></ul>');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 1);
            range.collapse(true);
            var command = new ListCommand({ tag: 'ul', range: range });
            command.exec();
            equal(editor.value(), '<ul><li>foo</li><li>bar</li></ul>')
        });

        test('exec puts cursor in empty li', function() {
            editor.value('');
            editor.focus();
            var command = new ListCommand({ tag: 'ul', range: editor.getRange() });
            command.exec();
            editor.getRange().insertNode(editor.document.createElement('a'));
            equal(editor.value(), '<ul><li><a></a></li></ul>')
        });

</script>

</asp:Content>