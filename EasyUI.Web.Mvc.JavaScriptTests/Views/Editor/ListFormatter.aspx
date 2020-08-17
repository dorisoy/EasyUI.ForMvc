<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        ListFormatter</h2>
    <%= Html.EasyUI().Editor().Name("Editor") %>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>
    <script type="text/javascript">
        var editor;
        var ListFormatter;

    </script>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

        QUnit.testStart = function() {
            editor = getEditor();
            ListFormatter = $.easyui.editor.ListFormatter;
        }

        test('apply on text node', function() {
            editor.value('foo');
            var formatter = new ListFormatter('ul');
            formatter.apply([editor.body.firstChild]);
            equal(editor.value(), '<ul><li>foo</li></ul>');
        });

        test('apply on inline node', function() {
            editor.value('<strong>foo</strong>');
            var formatter = new ListFormatter('ul');
            formatter.apply([editor.body.firstChild.firstChild]);
            equal(editor.value(), '<ul><li><strong>foo</strong></li></ul>');
        });

        test('apply on block node', function() {
            editor.value('<div>foo</div>');
            var formatter = new ListFormatter('ul');
            formatter.apply([editor.body.firstChild.firstChild]);
            equal(editor.value(), '<ul><li>foo</li></ul>');
        });

        test('apply on block nodes', function() {
            editor.value('<div>foo</div><div>bar</div>');
            var formatter = new ListFormatter('ul');
            formatter.apply([editor.body.firstChild.firstChild,editor.body.lastChild.firstChild]);
            equal(editor.value(), '<ul><li>foo</li><li>bar</li></ul>');
        });

        test('apply on list and other content merges the list', function() {
            editor.value('<ul><li>foo</li></ul>bar');
            var formatter = new ListFormatter('ul');
            
            formatter.apply([editor.body.firstChild.firstChild.firstChild, editor.body.lastChild]);
            equal(editor.value(), '<ul><li>foo</li><li>bar</li></ul>');
        });

        test('apply on block element which is adjacent to list merges it with the list', function() {
            editor.value('<ul><li>foo</li></ul><p>bar</p>');
            var formatter = new ListFormatter('ul');
            
            formatter.apply([editor.body.lastChild.firstChild]);
            equal(editor.value(), '<ul><li>foo</li><li>bar</li></ul>');
        });

        test('apply on block element which is adjacent to list merges it with the list when the list is selected', function() {
            var range = createRangeFromText(editor, '|<ul><li>foo</li></ul><p>bar</p>|');
            var formatter = new ListFormatter('ul');
            
            formatter.toggle(range);
            equal(editor.value(), '<ul><li>foo</li><li>bar</li></ul>');
        });

        test('apply on block element which is adjacent to list and there is whitespace merges it with the list', function() {
            editor.value('<ul><li>foo</li></ul>     <p>bar</p>');
            var formatter = new ListFormatter('ul');
            
            formatter.apply([editor.body.lastChild.firstChild]);
            equal(editor.value(), '<ul><li>foo</li><li>bar</li></ul>');
        });
        test('apply on block element which precedes a list merges it with the list', function() {
            editor.value('<p>bar</p><ul><li>foo</li></ul>');
            var formatter = new ListFormatter('ul');
            
            formatter.apply([editor.body.firstChild.firstChild]);
            equal(editor.value(), '<ul><li>bar</li><li>foo</li></ul>');
        });

        test('apply on block element which precedes a list and there is whitespace merges it with the list', function() {
            editor.value('<p>bar</p>     <ul><li>foo</li></ul>');
            var formatter = new ListFormatter('ul');
            
            formatter.apply([editor.body.firstChild.firstChild]);
            equal(editor.value(), '<ul><li>bar</li><li>foo</li></ul>');
        });

        test('apply on block element which is amongst lists creates a single list', function() {
            editor.value('<ul><li>foo</li></ul><p>bar</p><ul><li>baz</li></ul>');
            var formatter = new ListFormatter('ul');
            
            formatter.apply([editor.body.firstChild.nextSibling.firstChild]);
            equal(editor.value(), '<ul><li>foo</li><li>bar</li><li>baz</li></ul>');
        });

        test("apply on single paragraph which contains inline elements", function() {
            editor.value('<p><span class="t-marker"></span>f<span class="t-marker"></span><span class="t-marker"></span>oo</p>');
            var formatter = new ListFormatter('ul');
            
            formatter.apply([editor.body.firstChild.childNodes[1], editor.body.firstChild.lastChild]);
            equal(editor.value(), '<ul><li><span class="t-marker"></span>f<span class="t-marker"></span><span class="t-marker"></span>oo</li></ul>');
        });

        test('apply applies to selected block contents only', function() {
            editor.value('<div>foo</div><div>bar</div>');
            var formatter = new ListFormatter('ul');
            
            formatter.apply([editor.body.firstChild.firstChild]);
            equal(editor.value(), '<ul><li>foo</li></ul><div>bar</div>');
        });

        test('apply applies to inline siblings', function() {
            editor.value('<span>foo</span><span>bar</span>');
            var formatter = new ListFormatter('ul');

            formatter.apply([editor.body.firstChild.firstChild]);
            equal(editor.value(), '<ul><li><span>foo</span><span>bar</span></li></ul>');
        });
        
        test('apply when text node and inline node selected', function() {
            editor.value('<p>foo<strong>bar</strong></p>');
            
            var formatter = new ListFormatter('ul');
            
            formatter.apply([editor.body.firstChild.firstChild, editor.body.firstChild.childNodes[1].firstChild]);
            equal(editor.value(), '<ul><li>foo<strong>bar</strong></li></ul>');
        });

        test('apply over paragraph containing whitespace', function() {
            editor.value('<p>foo<strong>foo</strong> </p>');
            
            var formatter = new ListFormatter('ul');
            formatter.apply([editor.body.firstChild.firstChild]);
            equal(editor.value(), '<ul><li>foo<strong>foo</strong> </li></ul>');
        });

        test('apply converts ul to ol', function() {
            editor.value('<ul><li>foo</li></ul>');
            var formatter = new ListFormatter('ol');

            formatter.apply([editor.body.firstChild.firstChild]);
            equal(editor.value(), '<ol><li>foo</li></ol>');
        });

        test('apply converts ol to li', function() {
            editor.value('<ol><li>foo</li></ol>');
            var formatter = new ListFormatter('ul');
            
            formatter.apply([editor.body.firstChild.firstChild]);
            equal(editor.value(), '<ul><li>foo</li></ul>');
        });

        test('apply merges adjacent lists', function() {
            editor.value('<ol><li>foo</li></ol><ol><li>bar</li></ol>');
            var formatter = new ListFormatter('ol');
            
            formatter.apply([editor.body.firstChild.firstChild.firstChild, editor.body.lastChild.firstChild.firstChild]);
            equal(editor.value(), '<ol><li>foo</li><li>bar</li></ol>');
        });
        
        test('apply converts and merges adjacent lists', function() {
            editor.value('<ol><li>foo</li></ol><ol><li>bar</li></ol>');
            var formatter = new ListFormatter('ul');

            formatter.apply([editor.body.firstChild.firstChild.firstChild, editor.body.lastChild.firstChild.firstChild]);
            equal(editor.value(), '<ul><li>foo</li><li>bar</li></ul>');
        });

        test('apply converts and merges adjacent lists of different type li', function() {
            editor.value('<ol><li>foo</li></ol><ul><li>bar</li></ul>');
            var formatter = new ListFormatter('ul');
            
            formatter.apply([editor.body.firstChild.firstChild.firstChild, editor.body.lastChild.firstChild.firstChild]);
            equal(editor.value(), '<ul><li>foo</li><li>bar</li></ul>');
        });
        
        test('apply converts and merges adjacent lists of different type ol', function() {
            editor.value('<ol><li>foo</li></ol><ul><li>bar</li></ul>');
            var formatter = new ListFormatter('ol');

            formatter.apply([editor.body.firstChild.firstChild.firstChild, editor.body.lastChild.firstChild.firstChild]);
            equal(editor.value(), '<ol><li>foo</li><li>bar</li></ol>');
        });

        test('remove keeps order', function() {
            editor.value('<ul><li>foo<p>bar</p></li></ul>');
            var formatter = new ListFormatter('ul');
            formatter.remove([editor.body.firstChild.firstChild.firstChild]);
            equal(editor.value(), '<p>foo</p><p>bar</p>');
        });
         test('remove keeps order with multiple block children', function() {
            editor.value('<ul><li>foo<p>bar</p><p>baz</p></li></ul>');
            var formatter = new ListFormatter('ul');
            formatter.remove([editor.body.firstChild.firstChild.firstChild]);
            equal(editor.value(), '<p>foo</p><p>bar</p><p>baz</p>');
        });
        test('remove keeps order with mixed inline and block children', function () {
            editor.value('<ul><li>foo<p>bar</p>baz</li></ul>');
            var formatter = new ListFormatter('ul');
            formatter.remove([editor.body.firstChild.firstChild.firstChild]);
            equal(editor.value(), '<p>foo</p><p>bar</p><p>baz</p>');
        });
        test('remove unwraps', function () {
            editor.value('<ul><li>foo</li></ul>');

            var formatter = new ListFormatter('ul');

            formatter.remove([editor.body.firstChild.firstChild.firstChild]);
            equal(editor.value(), '<p>foo</p>');
        });

        test('split', function() {
            var range = createRangeFromText(editor, '<ul><li>|foo|</li><li>bar</li></ul>');
            var formatter = new ListFormatter('ul');

            formatter.split(range);
            equal(editor.value(), '<ul><li>foo</li></ul><ul><li>bar</li></ul>');
        });

        test('split partial selection across multiple list items', function() {
            var range = createRangeFromText(editor, '<ul><li>|foo</li><li>bar|</li></ul>');
            var formatter = new ListFormatter('ul');

            formatter.split(range);
            equal(editor.value(), '<ul><li>foo</li><li>bar</li></ul>');
        });

        test('split whole li selected', function() {
            var range = createRangeFromText(editor, '<ul><li>|foo|</li></ul>');
            var formatter = new ListFormatter('ul');

            formatter.split(range);
            equal(editor.value(), '<ul><li>foo</li></ul>');
        });

        test('split partial contents of li selected', function() {
            var range = createRangeFromText(editor, '<ul><li>|fo|o</li></ul>');
            var formatter = new ListFormatter('ul');

            formatter.split(range);
            equal(editor.value(), '<ul><li>foo</li></ul>');
        });

        test('toggle on partial selection', function() {
            var range = createRangeFromText(editor, '<ul><li>|foo</li><li>bar|</li><li>baz</li></ul>');
            var formatter = new ListFormatter('ul');
            
            formatter.toggle(range);
            equal(editor.value(), '<p>foo</p><p>bar</p><ul><li>baz</li></ul>');
        });

        test('toggle formatted element amidst text', function() {
            var range = createRangeFromText(editor, '<ul><li>foo<strong>b|a|r</strong>baz</li></ul>');
            var formatter = new ListFormatter('ul');
            
            formatter.toggle(range);
            equal(editor.value(), '<p>foo<strong>bar</strong>baz</p>');
        });

        test('toggle unformatted element amidst text', function() {
            var range = createRangeFromText(editor, 'foo<strong>b|a|r</strong>baz');
            var formatter = new ListFormatter('ul');
            
            formatter.toggle(range);
            equal(editor.value(), '<ul><li>foo<strong>bar</strong>baz</li></ul>');
        });

        test('toggle unformatted element from caret', function() {
            editor.value('foo <strong>bar</strong> baz');
            var range = editor.createRange();
            range.setStart(editor.body.childNodes[1].firstChild, 1);
            range.collapse(true);

            var formatter = new ListFormatter('ul');
            
            formatter.toggle(range);
            equal(editor.value(), '<ul><li>foo <strong>bar</strong> baz</li></ul>');
        });

        test('toggle applies format if format is not found', function() {
            var range = createRangeFromText(editor, '|foo|');

            var formatter = new ListFormatter('ul');
            var argument;
            formatter.apply = function () {
                argument = arguments[0];
            }
            formatter.toggle(range);
            ok($.isArray(argument));
        });

        test('toggle removes format if format is found', function() {
            var range = createRangeFromText(editor, '<ul><li>|foo|</li>');

            var formatter = new ListFormatter('ul');
            var argument;
            formatter.remove = function () {
                argument = arguments[0];
            }
            formatter.toggle(range);
            ok($.isArray(argument));
        });

        test('toggle and unexpandable range', function() {
            editor.value('foo');
            var range = editor.createRange();
            range.setStartAfter(editor.body.firstChild);
            range.setEndAfter(editor.body.firstChild);

            var formatter = new ListFormatter('ul');
            formatter.toggle(range);
            equal(editor.value(), '<ul><li>foo</li></ul>');
        });

        test('toggle removes list', function() {
            editor.value('<ul><li>foo</li><li>bar</li></ul>');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild.firstChild.firstChild, 0);
            range.setEnd(editor.body.firstChild.lastChild.firstChild, 3);
            
            var formatter = new ListFormatter('ul');
            formatter.toggle(range);
            equal(editor.value(), '<p>foo</p><p>bar</p>');
        });
        
        test('toggle removes empty lists', function() {
            editor.value('<ul>   <li>foo</li>   <li>bar</li>   </ul>');
            var range = editor.createRange();
            var lis = $('li', editor.body.firstChild);
            range.setStart(lis[0].firstChild, 0);
            range.setEnd(lis[1].firstChild, 3);
            
            var formatter = new ListFormatter('ul');
            formatter.toggle(range);
            equal(editor.value(), '<p>foo</p><p>bar</p>');
        });

        test('remove and nested block node', function() {
            editor.value('<ul><li><p>foo</p></li></ul>');
            
            var formatter = new ListFormatter('ul');
            formatter.remove([editor.body.firstChild.firstChild.firstChild.firstChild]);
            
            equal(editor.value(), '<p>foo</p>');
        });

        test('remove and nested text and block node', function() {
            editor.value('<ul><li>foo<div>bar</div>baz</li></ul>');
            
            var formatter = new ListFormatter('ul');
            formatter.remove([editor.body.firstChild.firstChild.firstChild.firstChild]);
            
            editor.value('<p>foo</p><div>bar</div><p>baz</p>');
        });

        test('remove and nested text and inline node', function() {
            editor.value('<ul><li>foo<strong>bar</strong>baz</li></ul>');

            var formatter = new ListFormatter('ul');
            formatter.remove([editor.body.firstChild.firstChild.firstChild.firstChild]);

            editor.value('<p>foo<strong>bar</strong>baz</p>');
        });
        
        test('apply text nodes in inline element', function() {
            editor.value('<span>foo<strong>bar</strong></span>baz');
            
            var formatter = new ListFormatter('ul');
            formatter.apply([editor.body.firstChild.firstChild, editor.body.firstChild.lastChild.firstChild]);
            
            equal(editor.value(), '<ul><li><span>foo<strong>bar</strong></span>baz</li></ul>');
        });

        test('convert mixed nested ul to ol', function() {
            editor.value('<ol><li>foo<ul><li>bar</li></ul></li></ol>');
            var bar = editor.body.getElementsByTagName('li')[1].firstChild;
            var formatter = new ListFormatter('ol');
            formatter.apply([bar]);
            
            equal(editor.value(), '<ol><li>foo<ol><li>bar</li></ol></li></ol>');
        });

        test('convert nested ul to ol', function() {
            editor.value('<ul><li>foo<ul><li>bar</li></ul></li></ul>');
            var bar = editor.body.getElementsByTagName('li')[1].firstChild;
            var formatter = new ListFormatter('ol');
            formatter.apply([bar]);

            equal(editor.value(), '<ul><li>foo<ol><li>bar</li></ol></li></ul>');
        });
        
        test('convert mixed nested ol to ul', function() {
            editor.value('<ul><li>foo<ol><li>bar</li></ol></li></ul>');
            var bar = editor.body.getElementsByTagName('li')[1].firstChild;
            var formatter = new ListFormatter('ul');
            formatter.apply([bar]);
            
            equal(editor.value(), '<ul><li>foo<ul><li>bar</li></ul></li></ul>');
        });
        
        test('convert nested ol to ul', function() {
            editor.value('<ol><li>foo<ol><li>bar</li></ol></li></ol>');
            var bar = editor.body.getElementsByTagName('li')[1].firstChild;
            var formatter = new ListFormatter('ul');
            formatter.apply([bar]);
            
            equal(editor.value(), '<ol><li>foo<ul><li>bar</li></ul></li></ol>');
        });

        test("apply in table cell", function() {
            editor.value("<table><tbody><tr><td>foo</td></tr></tbody></table>");
            var foo = editor.body.getElementsByTagName("td")[0].firstChild;
            var formatter = new ListFormatter("ul");
            
            formatter.apply([foo]);
            equal(editor.value(), "<table><tbody><tr><td><ul><li>foo</li></ul></td></tr></tbody></table>");
        });

        test("apply in selection between sibling table cells", function() {
            editor.value("<table><tbody><tr><td>foo</td><td>bar</td></tr></tbody></table>");
            var foo = editor.body.getElementsByTagName("td")[0].firstChild;
            var bar = editor.body.getElementsByTagName("td")[1].firstChild;
            var formatter = new ListFormatter("ul");
            
            formatter.apply([foo, bar]);
            equal(editor.value(), "<table><tbody><tr><td><ul><li>foo</li></ul></td><td><ul><li>bar</li></ul></td></tr></tbody></table>");
        });

        test("apply in selection between different table rows", function() {
            editor.value("<table><tbody><tr><td>foo</td></tr><tr><td>bar</td></tr></tbody></table>");
            var foo = editor.body.getElementsByTagName("td")[0].firstChild;
            var bar = editor.body.getElementsByTagName("td")[1].firstChild;
            var formatter = new ListFormatter("ul");
            
            formatter.apply([foo, bar]);
            equal(editor.value(), "<table><tbody><tr><td><ul><li>foo</li></ul></td></tr><tr><td><ul><li>bar</li></ul></td></tr></tbody></table>");
        });

        test("apply in selection of paragraph and existing unordered list", function() {
            editor.value("<p>foo</p><ul><li>bar</li></ul>");

            var foo = editor.body.firstChild.firstChild;
            var bar = editor.body.lastChild.firstChild.firstChild;
            var formatter = new ListFormatter("ul");
            
            formatter.apply([foo, bar]);
            equal(editor.value(), "<ul><li>foo</li><li>bar</li></ul>");
        });

        test("apply in selection of paragraph and existing ordered list", function() {
            editor.value("<p>foo</p><ol><li>bar</li></ol>");

            var foo = editor.body.firstChild.firstChild;
            var bar = editor.body.lastChild.firstChild.firstChild;
            var formatter = new ListFormatter("ol");
            
            formatter.apply([foo, bar]);
            equal(editor.value(), "<ol><li>foo</li><li>bar</li></ol>");
        });

        test("remove from nested list", function() {
            var range = createRangeFromText(editor, "<ul><li>foo<ul><li>|bar</li><li>baz|</li></ul></li></ul>");

            var formatter = new ListFormatter("ul");
            
            formatter.toggle(range);
            equal(editor.value(), "<ul><li>foo</li></ul><p>bar</p><p>baz</p>");
        });

        test("remove from deeply nested list", function() {
            var range = createRangeFromText(editor, "<ul><li>foo<ul><li>bar<ul><li>|baz|</li></ul></li></ul></li></ul>")

            var formatter = new ListFormatter("ul");
            
            formatter.toggle(range);
            equal(editor.value(), "<ul><li>foo<ul><li>bar</li></ul></li></ul><p>baz</p>");
        });

        test("remove nested list in the middle of parent list", function() {
            var range = createRangeFromText(editor, "<ul><li>foo<ul><li>|bar|</li></ul></li><li>baz</li></ul>");

            var formatter = new ListFormatter("ul");
            
            formatter.toggle(range);
            equal(editor.value(), "<ul><li>foo</li></ul><p>bar</p><ul><li>baz</li></ul>");
        });

        test("remove partially selected nested list in the middle of parent list", function() {
            var range = createRangeFromText(editor, "<ul><li>foo<ul><li>|bar|</li><li>boo</li></ul></li><li>baz</li></ul>");

            var formatter = new ListFormatter("ul");
            
            formatter.toggle(range);
            equal(editor.value(), "<ul><li>foo</li></ul><p>bar</p><ul><li><ul><li>boo</li></ul></li><li>baz</li></ul>");
        });

        test("empty list item is removed", function() {
            var range = createRangeFromText(editor, "<ul><li>foo</li><li>||</li></ul>");

            var marker = new $.easyui.editor.Marker();
            marker.add(range);

            var formatter = new ListFormatter("ul");
            
            formatter.toggle(range);

            marker.remove(range);
            equal(editor.value(), "<ul><li>foo</li></ul><p></p>");
        });
</script>

</asp:Content>