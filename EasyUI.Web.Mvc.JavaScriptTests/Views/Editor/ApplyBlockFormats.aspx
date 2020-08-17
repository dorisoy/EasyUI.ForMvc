<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Apply Inline Commands</h2>

    <%= Html.EasyUI().Editor().Name("Editor1").Tools(tools => tools.Bold().Italic()) %>

    <script type="text/javascript">
        var impl;

        function getEditor() {
            return $('#Editor1').data("tEditor");
        }

    </script>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



        QUnit.testStart = function() {
            impl = {
                formatRange: function(range, format) {
                    var command = new $.easyui.editor.FormatCommand({
                        range:range,
                        format: format,
                        formatter: function() {
                         return new $.easyui.editor.BlockFormatter(format);
                        }
                    })
                    command.exec();
                }
            }
        }

        test('applyFormat applies block format on full selection', function() {
            var editor = getEditor();

            editor.value('<p>golgafrincham</p>');

            var pararagraph = $('p', editor.document)[0].firstChild;
            var range = editor.createRange();
            range.setStart(pararagraph, 0);
            range.setEnd(pararagraph, 13);

            impl.formatRange(range, editor.formats.justifyCenter);
            
            equal(editor.value(), '<p style="text-align:center;">golgafrincham</p>');
        });

        test('applyFormat applies block format on partial selection', function() {
            var editor = getEditor();

            editor.value('<p>golgafrincham</p>');

            var pararagraph = $('p', editor.document)[0].firstChild;
            var range = editor.createRange();
            range.setStart(pararagraph, 5);
            range.setEnd(pararagraph, 10);

            impl.formatRange(range, editor.formats.justifyCenter);
            
            equal(editor.value(), '<p style="text-align:center;">golgafrincham</p>');
        });

        test('applyFormat applies block format on partial selection with line break', function() {
            var editor = getEditor();

            editor.value('<p>golga<br />frincham</p>');

            var pararagraph = $('p', editor.document)[0];
            var range = editor.createRange();
            range.setStart(pararagraph.firstChild, 2);
            range.setEnd(pararagraph.lastChild, 4);

            impl.formatRange(range, editor.formats.justifyCenter);
            
            equal(editor.value(), '<p style="text-align:center;">golga<br />frincham</p>');
        });

        test('applyFormat applies block format on block level around selection', function() {
            var editor = getEditor();

            editor.value('golgafrincham');

            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 5);
            range.setEnd(editor.body.firstChild, 9);

            impl.formatRange(range, editor.formats.justifyCenter);
            
            equal(editor.value(), '<div style="text-align:center;">golgafrincham</div>');
        });

</script>

</asp:Content>