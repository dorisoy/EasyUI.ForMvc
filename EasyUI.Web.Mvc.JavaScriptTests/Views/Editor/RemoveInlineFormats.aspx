<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Remove Inline Commands</h2>

    <%= Html.EasyUI().Editor().Name("Editor").Tools(tools => tools.Bold()) %>
    
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>

    <script type="text/javascript">
        var impl;
        var editor;


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
                         return new $.easyui.editor.InlineFormatter(format);
                        }
                    })
                    command.exec();
                }
            }
            editor = getEditor();
        }

        test('removeFormat removes format from text range', function() {
            editor.value('<p><strong>golgafrincham</strong> telephone sanitisers</p>');

            var strongContent = $('strong', editor.document)[0].firstChild;
            var range = editor.createRange();
            range.setStart(strongContent, 0);
            range.setEnd(strongContent, 13);
            
            impl.formatRange(range, editor.formats.bold);
            
            equal(editor.value(), '<p>golgafrincham telephone sanitisers</p>');
            equal(editor.body.firstChild.childNodes.length, 1);
        });
        
        test('removeFormat removes format from selected node contents', function() {
            editor.value('<strong>golga<em>fr</em>in</strong>');

            var strong = $('strong', editor.document)[0];

            var range = editor.createRange();
            range.selectNodeContents(strong);
            impl.formatRange(range, editor.formats.bold);

            equal(editor.value(), 'golga<em>fr</em>in');
        });

        test('removeFormat removes format from complete tags across paragraphs', function() {
            editor.value('<p>golgafrin<strong>cham</strong></p><p><strong>tele</strong>phone</p>');

            var $strongs = $('strong', editor.document);

            var range = editor.createRange();
            range.setStartBefore($strongs[0]);
            range.setEndAfter($strongs[1]);

            impl.formatRange(range, editor.formats.bold);

            equal(editor.value().replace(/\s+/gi, ''), '<p>golgafrincham</p><p>telephone</p>');
        });

        test('removeFormat when formatted and unformatted nodes are selected', function() {
            editor.value('<strong>f</strong>oo');
            var range = editor.createRange();
            range.setStart(editor.body, 0);
            range.setEnd(editor.body, 2);

            impl.formatRange(range, editor.formats.bold);

            equal(editor.value(), 'foo');
        });

        test('removeFormat when there is unformatted content before formatted', function() {
            editor.value('fo<strong>o</strong>');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 0);
            range.setEnd(editor.body.childNodes[1].firstChild, 1);
            impl.formatRange(range, editor.formats.bold);

            equal(editor.value(), 'foo');
        });
        
        test('removeFormat when there is unformatted content after formatted', function() {
            editor.value('<strong>fo</strong>ob');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild.firstChild, 0);
            range.setEnd(editor.body.lastChild, 1);
            impl.formatRange(range, editor.formats.bold);

            equal(editor.value(), 'foob');
        });

        test('remove styled format from selection', function() {
            editor.value('<span style="text-decoration:underline;">foo</span>');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild.firstChild, 1);
            range.setEnd(editor.body.firstChild.firstChild, 2);
            
            impl.formatRange(range, editor.formats.underline);
            
            equal(editor.value(), '<span style="text-decoration:underline;">f</span>o<span style="text-decoration:underline;">o</span>');
        });

</script>

</asp:Content>