<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Remove Inline Commands</h2>

    <%= Html.EasyUI().Editor().Name("Editor1").Tools(tools => tools.Bold()) %>

    <script type="text/javascript">
        var impl;
        var editor;
        
        function getEditor() {
            return $('#Editor1').data("tEditor");
        }
    </script>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



        QUnit.testStart = function() {
            editor = getEditor();
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

        test('removeFormat applies block format on full selection', function() {
            editor.value('<p style="text-align:center;">golgafrincham</p>');

            var pararagraph = $('p', editor.document)[0].firstChild;
            var range = editor.createRange();
            range.setStart(pararagraph, 0);
            range.setEnd(pararagraph, 13);

            impl.formatRange(range, editor.formats.justifyCenter);
            
            equal(editor.value(), '<p>golgafrincham</p>');
        });

        test('removeFormat applies block format on partial selection', function() {
            editor.value('<p style="text-align:center;">golgafrincham</p>');

            var pararagraph = $('p', editor.document)[0].firstChild;
            var range = editor.createRange();
            range.setStart(pararagraph, 5);
            range.setEnd(pararagraph, 10);

            impl.formatRange(range, editor.formats.justifyCenter);
            
            equal(editor.value(), '<p>golgafrincham</p>');
        });

        test('removeFormat applies block format on partial selection with line break', function() {
            editor.value('<p style="text-align:center;">golga<br />frincham</p>');

            var pararagraph = $('p', editor.document)[0];
            var range = editor.createRange();
            range.setStart(pararagraph.firstChild, 2);
            range.setEnd(pararagraph.lastChild, 4);

            impl.formatRange(range, editor.formats.justifyCenter);
            
            equal(editor.value(), '<p>golga<br />frincham</p>');
        });

</script>

</asp:Content>