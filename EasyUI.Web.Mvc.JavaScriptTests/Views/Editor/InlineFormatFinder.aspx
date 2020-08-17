<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>InlineFormatFinder</h2>
    <%= Html.EasyUI().Editor().Name("Editor") %>
    
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">
    
    var editor;

    var InlineFormatFinder;
    var enumerator;

    QUnit.testStart = function() {
        editor = getEditor();
        InlineFormatFinder = $.easyui.editor.InlineFormatFinder;
    }

    test('findSuitable() does not return for single text node', function() {
        editor.value('foo');

        var finder = new InlineFormatFinder(editor.formats.bold);
        ok(null === finder.findSuitable(editor.body.firstChild));
    });

    test('findSuitable() returns matching tag', function() {
        editor.value('<span>foo</span>');

        var finder = new InlineFormatFinder(editor.formats.underline);
        equal(finder.findSuitable(editor.body.firstChild.firstChild), editor.body.firstChild);
    });

    test('findSuitable() returns closest', function() {
        editor.value('<span><span>foo</span></span>');

        var finder = new InlineFormatFinder(editor.formats.underline);
        equal(finder.findSuitable(editor.body.firstChild.firstChild.firstChild), editor.body.firstChild.firstChild);
    });

    test('findSuitable() does not return in case of partial selection', function() {
        editor.value('<span>foo<em>bar</em></span>');

        var finder = new InlineFormatFinder(editor.formats.underline);
        equal(finder.findSuitable(editor.body.firstChild.firstChild), null);
    });

    test('findSuitable() skips caret marker', function() {
        editor.value('<span><span class="t-marker"></span>foo<span class="t-marker"></span>bar<span class="t-marker"></span></span>');

        var finder = new InlineFormatFinder(editor.formats.underline);
        equal(finder.findSuitable(editor.body.firstChild.firstChild), editor.body.firstChild);
    });

    test('findSuitable() skips beginning and end marker', function() {
        editor.value('<span><span class="t-marker"></span>foobar<span class="t-marker"></span></span>');

        var finder = new InlineFormatFinder(editor.formats.underline);
        equal(finder.findSuitable(editor.body.firstChild.childNodes[1]), editor.body.firstChild);
    });

    test('findSuitable() does not skip mid-element markers', function() {
        editor.value('<span>foo <span class="t-marker"></span>ba<span class="t-marker"></span>az<span class="t-marker"></span> bar</span>');

        var finder = new InlineFormatFinder(editor.formats.underline);
        equal(finder.findSuitable(editor.body.firstChild.childNodes[2]), null);
    });

    test('findFormat() finds formatted node by tag', function() {
        editor.value('<strong>foo</strong>');

        var finder = new InlineFormatFinder(editor.formats.bold);

        equal(finder.findFormat(editor.body.firstChild.firstChild), editor.body.firstChild);
    });

    test('findFormat() finds formatterd node by tag and style', function() {
        editor.value('<span style="text-decoration:underline">foo</span>');

        var finder = new InlineFormatFinder(editor.formats.underline);

        equal(finder.findFormat(editor.body.firstChild.firstChild), editor.body.firstChild);
    });
    
    test('findFormat() returns null if node does not match tag and style', function() {
        editor.value('<span>foo</span>');

        var finder = new InlineFormatFinder(editor.formats.underline);

        ok(null === finder.findFormat(editor.body.firstChild.firstChild));
    });

    test('findFormat() returns parent element', function() {
        editor.value('<span style="text-decoration:underline"><span>foo</span></span>');

        var finder = new InlineFormatFinder(editor.formats.underline);
        equal(finder.findFormat(editor.body.firstChild.firstChild.firstChild), editor.body.firstChild);
    });

    test('findFormat() checks all formats', function() {
        editor.value('<span style="font-weight:bold">foo</span>');

        var finder = new InlineFormatFinder(editor.formats.bold);

        equal(finder.findFormat(editor.body.firstChild.firstChild), editor.body.firstChild);
    });

    test('isFormatted() returns true if at least one node has format', function() {
        editor.value('<span style="font-weight:bold">foo</span>');

        var finder = new InlineFormatFinder(editor.formats.bold);
        ok(finder.isFormatted([editor.body.firstChild.firstChild]));
    });

    test('isFormatted() returns false if all nodes dont have format', function() {    
        editor.value('foo');

        var finder = new InlineFormatFinder(editor.formats.bold);
        ok(!finder.isFormatted([editor.body.firstChild]));
    });

    test('isFormatted() returns true for formatted and unformatted nodes', function() {
        editor.value('<strong>foo</strong>bar');

        var finder = new InlineFormatFinder(editor.formats.bold);
        ok(finder.isFormatted([editor.body.firstChild.firstChild, editor.body.lastChild]));
    });

    test('isFormatted() returns true when the format node is the argument', function() {
        editor.value('<strong>foo</strong>');

        var finder = new InlineFormatFinder(editor.formats.bold);
        ok(finder.isFormatted([editor.body.firstChild]));
    });

</script>

</asp:Content>