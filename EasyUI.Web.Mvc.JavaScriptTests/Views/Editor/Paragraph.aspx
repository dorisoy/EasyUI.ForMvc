<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

     <%= Html.EasyUI().Editor().Name("Editor") %>

    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>

</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

        var editor;

        var ParagraphCommand;

        module("Editor / Paragraph", {
            setup: function() {
                editor = getEditor();
                ParagraphCommand = $.easyui.editor.ParagraphCommand;
            }
        });
        
        test('exec wraps the node in paragraph and creates a new paragraph', function() {
            editor.value('foo');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 1);
            range.collapse(true);
            var command = new ParagraphCommand({range:range});
            command.exec();
            equal(editor.value(), '<p>f</p><p>oo</p>');
        });

        test('exec splits paragraph', function() {
            editor.value('<p>foo</p>');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild.firstChild, 1);
            range.collapse(true);
            var command = new ParagraphCommand({range:range});
            command.exec();
            equal(editor.value(), '<p>f</p><p>oo</p>');
        });

        test('exec splits inline elements', function() {
            editor.value('fo<em>ob</em>ar');
            var range = editor.createRange();
            range.setStart(editor.body.childNodes[1].firstChild, 1);
            range.collapse(true);
            var command = new ParagraphCommand({range:range});
            command.exec();
            equal(editor.value(), '<p>fo<em>o</em></p><p><em>b</em>ar</p>');
        });

        test('exec deletes selected content', function() {
            editor.value('foobar');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 1);
            range.setEnd(editor.body.firstChild, 5)
            var command = new ParagraphCommand({range:range});
            command.exec();
            equal(editor.value(), '<p>f</p><p>r</p>');
        });

        test('exec adds paragraph around inline content', function() {
            editor.value('foo<p>bar</p>');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 1);
            range.collapse(true);
            var command = new ParagraphCommand({range:range});
            command.exec();
            equal(editor.value(), '<p>f</p><p>oo</p><p>bar</p>');
        });

        test('exec creates new li when inside ul', function() {
            editor.value('<ul><li>foo</li></ul>');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild.firstChild.firstChild, 1);
            range.collapse(true);
            var command = new ParagraphCommand({range:range});
            command.exec();
            equal(editor.value(), '<ul><li>f</li><li>oo</li></ul>');
        });

        test('exec when inside empty li', function() {
            editor.value('<ul><li></li></ul>');
            var range = editor.createRange();
            range.selectNodeContents(editor.body.firstChild.firstChild);
            var command = new ParagraphCommand({range:range});
            command.exec();
            equal(editor.value(), '');
            equal(editor.body.firstChild.nodeName.toLowerCase(), 'p');
        });
        
        test('exec when inside empty li and p', function() {
            editor.value('<ul><li><p></p></li></ul>');
            var range = editor.createRange();
            range.selectNodeContents(editor.body.firstChild.firstChild.firstChild);
            var command = new ParagraphCommand({ range: range });
            command.exec();
            equal(editor.value(), '');
            equal(editor.body.firstChild.nodeName.toLowerCase(), 'p');
        });
        
        test('exec creates new li when inside ul and p', function() {
            editor.value('<ul><li><p>foo</p></li></ul>');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild.firstChild.firstChild.firstChild, 1);
            range.collapse(true);
            var command = new ParagraphCommand({ range: range });
            command.exec();
            equal(editor.value(), '<ul><li><p>f</p></li><li><p>oo</p></li></ul>');
        });
        
        test('exec when in last li and it is empty', function() {
            editor.value('<ul><li>foo</li><li></li></ul>');
            var range = editor.createRange();
            range.selectNodeContents(editor.body.firstChild.lastChild);
            var command = new ParagraphCommand({ range: range });
            command.exec();
            equal(editor.value(), '<ul><li>foo</li></ul><p></p>');
        });
        
        test('exec in empty list item preserves line breaks in others', function() {
            editor.value('<ul><li>fo<br />o</li><li></li><li>ba<br />r</li></ul>');
            var range = editor.createRange();
            range.selectNodeContents(editor.body.firstChild.childNodes[1]);
            var command = new ParagraphCommand({ range: range });
            command.exec();
            equal(editor.value(), '<ul><li>fo<br />o</li></ul><p></p><ul><li>ba<br />r</li></ul>');
        });
        
        test('exec when there is empty li', function() {
            editor.value('<ul><li>foo</li><li></li></ul>');
            var range = editor.createRange();
            range.setStartAfter(editor.body.firstChild.firstChild.firstChild);
            range.setEndAfter(editor.body.firstChild.firstChild.firstChild);
            var command = new ParagraphCommand({ range: range });
            command.exec();
            equal(editor.value(), '<ul><li>foo</li><li></li><li></li></ul>');
        });

        test('exec handles li containing br', function() {
            editor.value('<ul><li><br/></li></ul>');
            var range = editor.createRange();
            range.selectNodeContents(editor.body.firstChild.firstChild, 1);
            range.collapse(true);
            var command = new ParagraphCommand({ range: range });
            command.exec();
            equal(editor.value(), '');
            equal(editor.body.firstChild.nodeName.toLowerCase(), 'p');
        });

        test('exec removes br', function() {
            editor.value('foo<br/>bar');
            var range = editor.createRange();
            range.selectNode(editor.body.firstChild);
            range.collapse(false);
            var command = new ParagraphCommand({ range: range });
            command.exec();
            equal(editor.value(), '<p>foo</p><p>bar</p>');
        });

        test('exec deletes selected inline content', function() {
            editor.value('foo<p>bar</p>');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 1);
            range.setEnd(editor.body.lastChild.firstChild, 1);
            var command = new ParagraphCommand({range:range});
            command.exec();
            equal(editor.value(), '<p>f</p><p>ar</p>');
        });

        test('exec deletes all contents', function() {
            editor.value('foo');
            var range = editor.createRange();
            range.selectNodeContents(editor.body);
            
            var command = new ParagraphCommand({range:range});
            
            command.exec();
            equal(editor.value(), '<p></p><p></p>');
        });

        test('exec caret at end of content', function() {
            editor.value('foo');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 3);
            range.setEnd(editor.body.firstChild, 3);
            var command = new ParagraphCommand({range:range});
            command.exec();
            equal(editor.value(), '<p>foo</p><p></p>');
        });

        test('undo reverts content', function() {
            editor.value('foo');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 1);
            range.collapse(true);
            var command = new ParagraphCommand({range:range});
            command.exec();
            command.undo();
            equal(editor.value(), 'foo');
        });

        test('redo', function() {
            editor.value('foo');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 1);
            range.collapse(true);
            var command = new ParagraphCommand({range:range});
            
            command.exec();
            command.undo();
            command.exec();

            equal(editor.value(), '<p>f</p><p>oo</p>');
        });

        test('exec moves caret', function() {
            editor.value('foo');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 1);
            range.collapse(true);
            var command = new ParagraphCommand({range:range});
            command.exec();
            
            range = editor.getRange();
            range.insertNode(editor.document.createElement('span'));
            
            equal(editor.value(), '<p>f</p><p><span></span>oo</p>');            
        });

        test('exec at end of text node wraps with paragraph and inserts new paragraph', function() {
            editor.value('<p>foo</p>');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild.firstChild, 3);
            range.collapse(true);
            var command = new ParagraphCommand({range:range});
            command.exec();
            equal(editor.value(), '<p>foo</p><p></p>');
        });

        test('exec in empty paragraph at middle of text adds more paragraphs', function() {
            editor.value('<p>foo</p><p></p><p>bar</p>');
            var range = editor.createRange();
            range.selectNodeContents(editor.body.childNodes[1]);
            range.collapse(true);
            var command = new ParagraphCommand({range:range});
            command.exec();
            equal(editor.value(), '<p>foo</p><p></p><p></p><p>bar</p>');
        });

        test('exec at start of paragraph leaves selection in paragraph', function() {
            editor.value('<p>foo</p><p>bar</p>');
            var range = editor.createRange();
            range.setStart(editor.body.lastChild, 0);
            range.collapse(true);
            var command = new ParagraphCommand({range:range});
            command.exec();

            range = editor.getRange();
            
            range.insertNode(editor.document.createElement('a'));
            
            equal(editor.value(), '<p>foo</p><p></p><p><a></a>bar</p>');
        });

        test('exec in td', function() {
            var range =  createRangeFromText(editor, '<table><tr><td>|f|oo</td></tr></table>');
            var command = new ParagraphCommand({range:range});
            command.exec();
            
            equal(editor.value(), '<table><tbody><tr><td><p></p><p>oo</p></td></tr></tbody></table>');
        });
        
        test('exec in header goes in new paragraph', function() {
            editor.value('<h1>foo</h1>');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild.firstChild, 3);
            range.collapse(true);
            var command = new ParagraphCommand({range:range});
            
            command.exec();

            range = editor.getRange();
            
            range.insertNode(editor.document.createElement('a'));
            
            equal(editor.value(), '<h1>foo</h1><p><a></a></p>');
        });
        
        test('exec in midst of header splits it in two', function() {
            editor.value('<h1>foo</h1>');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild.firstChild, 2);
            range.collapse(true);
            var command = new ParagraphCommand({range:range});

            command.exec();

            range = editor.getRange();
            
            range.insertNode(editor.document.createElement('a'));
            
            equal(editor.value(), '<h1>fo</h1><h1><a></a>o</h1>');
        });
        
        test('exec at beginning of header adds header above', function() {
            editor.value('<h1>foo</h1>');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild.firstChild, 0);
            range.collapse(true);
            var command = new ParagraphCommand({range:range});

            command.exec();

            range = editor.getRange();
            
            range.insertNode(editor.document.createElement('a'));
            
            equal(editor.value(), '<h1></h1><h1><a></a>foo</h1>');
        });
        
        test('exec in list before image', function() {
            editor.value('<ul><li><img src="foo" /></li></ul>');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild.firstChild, 0);
            range.collapse(true);
            var command = new ParagraphCommand({range:range});

            command.exec();

            range = editor.getRange();
            
            range.insertNode(editor.document.createElement('a'));
            
            equal(editor.value(), '<ul><li></li><li><a></a><img src="foo" /></li></ul>');
        });

</script>

</asp:Content>