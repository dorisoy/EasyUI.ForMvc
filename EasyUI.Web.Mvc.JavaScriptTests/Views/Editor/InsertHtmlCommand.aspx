<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>InsertHtmlCommand</h2>
    
     <%= Html.EasyUI().Editor().Name("Editor") %>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>
    <script type="text/javascript">

        var editor;
        var InsertHtmlCommand;
    </script>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



        QUnit.testStart = function() {
            editor = getEditor();
            InsertHtmlCommand = $.easyui.editor.InsertHtmlCommand;
        }

        test('exec calls clipboard paste', function() {
            var range = createRangeFromText(editor, 'f|o|o');

            var oldPaste = editor.clipboard.paste;
            var argument;
            
            try { 
                editor.clipboard.paste = function() { argument = arguments[0]; }

                var command = new InsertHtmlCommand({ range:range, value: '<span class="test-icon"></span>' });
                command.editor = editor;
                command.exec();
                equal(argument, '<span class="test-icon"></span>');

           } finally {
                editor.clipboard.paste = oldPaste;
           }
        });

        test('exec inserts html parameter', function() {
            var range = createRangeFromText(editor, 'fo||o');
            editor.selectRange(range);

            var command = new InsertHtmlCommand({ range:range, value: '<span class="test-icon"></span>' });
            command.editor = editor;
            command.exec();
            equal(editor.value(), 'fo<span class="test-icon"></span>o');
        });

</script>

</asp:Content>