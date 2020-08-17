<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Apply Inline Commands</h2>

    <%= Html.EasyUI().Editor().Name("Editor1").Tools(tools => tools.Bold().Italic()) %>

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
                         return new $.easyui.editor.InlineFormatter(format);
                        }
                    })
                    command.exec();
                }
            }
        }

        test('applyFormat applies format on text range', function() {
            editor.value('<p>golgafrincham telephone sanitisers</p>');

            var pararagraph = $('p', editor.document)[0].firstChild;
            var range = editor.createRange();
            range.setStart(pararagraph, 0);
            range.setEnd(pararagraph, 13);

            impl.formatRange(range, editor.formats.bold);

            equal(editor.value(), '<p><strong>golgafrincham</strong> telephone sanitisers</p>');
        });
        
        test('applyFormat applies inline formats properly on block elements', function() {
            editor.value('<p>golgafrincham</p>');

            var pararagraph = $('p', editor.document)[0];

            var range = editor.createRange();
            range.selectNode(pararagraph);

            impl.formatRange(range, editor.formats.bold);
            
            equal(editor.value(), '<p><strong>golgafrincham</strong></p>');
        });
        
        test('applyFormat applies format on split text elements', function() {
            editor.value('<p>golga<em>frin</em>cham</p>');

            var pararagraph = $('p', editor.document)[0];

            var range = editor.createRange();
            range.setStart(pararagraph.firstChild, 2);
            range.setEnd(pararagraph.lastChild, 2);

            impl.formatRange(range, editor.formats.bold);

            equal(editor.value(), '<p>go<strong>lga</strong><em><strong>frin</strong></em><strong>ch</strong>am</p>');
        });
        
        test('applyFormat uses the supplied selector', function() {
            editor.value('<p>golgafrincham</p>');

            var pararagraph = $('p', editor.document)[0];

            var range = editor.createRange();
            range.selectNode(pararagraph);

            impl.formatRange(range, editor.formats.italic);
            
            equal(editor.value(), '<p><em>golgafrincham</em></p>');
        });
        
        test('formatRange applies style commands', function() {
            editor.value('<p>golgafrincham</p>');

            var range = editor.createRange();
            range.setStart(editor.body.firstChild.firstChild, 5);
            range.setEnd(editor.body.firstChild.firstChild, 9);

            impl.formatRange(range, editor.formats.underline);

            var span = $(editor.value()).find('span');

            equal(span.length, 1);
            equal(span.css('textDecoration'), 'underline');
        });
        
        test('formatRange does not introduce blank text nodes', function() {
            editor.value('golgafrincham');

            var range = editor.createRange();
            range.setStart(editor.body, 0);
            range.setEnd(editor.body, 1);
            
            impl.formatRange(range, editor.formats.bold);

            equal(editor.body.childNodes.length, 1);
        });

        test('formatRange does honor block elements', function() {
            editor.value('<p>golgafrincham</p><p>telephone</p>');

            var range = editor.createRange();
            range.setStart(editor.body, 0);
            range.setEnd(editor.body, 2);
            
            impl.formatRange(range, editor.formats.bold);

            equal(editor.value().replace(/\s*/gi, ''), '<p><strong>golgafrincham</strong></p><p><strong>telephone</strong></p>');
        });

        test('formatRange honors nested block element', function() {
            editor.value('<div><div>golgafrincham</div></div>');

            var range = editor.createRange();
            range.setStart(editor.body, 0);
            range.setEnd(editor.body, 1);
            
            impl.formatRange(range, editor.formats.bold);

            equal(editor.value().replace(/\s*/gi, ''), '<div><div><strong>golgafrincham</strong></div></div>');
        });

        test('formatRange honors multiple nested block elements', function() {
            editor.value('<ul><li>golgafrincham</li><li>telephone</li></ul>');
            
            var range = editor.createRange();
            range.setStart(editor.body, 0);
            range.setEnd(editor.body, 1);
            
            impl.formatRange(range, editor.formats.bold);

            equal(editor.value().replace(/\s*/gi, ''), '<ul><li><strong>golgafrincham</strong></li><li><strong>telephone</strong></li></ul>');
        });
        
        test('formatRange reuses span', function() {
            editor.value('<span>golgafrincham</span>');

            var range = editor.createRange();
            range.selectNode(editor.body.firstChild);

            impl.formatRange(range, editor.formats.underline);

            equal(editor.value(), '<span style="text-decoration:underline;">golgafrincham</span>');
        });
        
        test('formatRange reuses span when node contents are selected', function() {
            editor.value('<span>golgafrincham</span>');

            var range = editor.createRange();
            range.selectNodeContents(editor.body.firstChild);
            
            impl.formatRange(range, editor.formats.underline);

            equal(editor.value(), '<span style="text-decoration:underline;">golgafrincham</span>');
        });

        test('formatRange does not reuse span if tags are specified', function() {
            editor.value('<span>golgafrincham</span>');

            var range = editor.createRange();
            range.selectNode(editor.body.firstChild);

            impl.formatRange(range, editor.formats.bold);

            equal(editor.value(), '<span><strong>golgafrincham</strong></span>');
        });
        
        test('formatRange with inline format on collapsed range formats to word boundary', function() {
            editor.value('foo');

            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 1);
            range.setEnd(editor.body.firstChild, 1);

            impl.formatRange(range, editor.formats.bold);

            equal(editor.value(), '<strong>foo</strong>');
        });

        test('underline and collapsed range', function() {
            editor.value('foo');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 1);
            range.setEnd(editor.body.firstChild, 1);
            
            impl.formatRange(range, editor.formats.underline);

            equal(editor.value(), '<span style="text-decoration:underline;">foo</span>');
        });

</script>

</asp:Content>