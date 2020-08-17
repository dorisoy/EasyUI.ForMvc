<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>GreedyInlineFormatFinder</h2>
    
    
    <%= Html.EasyUI().Editor().Name("Editor") %>
    
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>

    <script type="text/javascript">
    
    var editor;

    var GreedyInlineFormatFinder;
    var enumerator;
    </script>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



    QUnit.testStart = function() {
        editor = getEditor();
        GreedyInlineFormatFinder = $.easyui.editor.GreedyInlineFormatFinder;
    }
    test('getFormat returns inherit when called on unformatted node', function() {
        editor.value('foo');

        var finder = new GreedyInlineFormatFinder([{ tags: ['span'] }], 'font-family');
        equal(finder.getFormat([editor.body.firstChild]), 'inherit');
    });

    test('getFormat returns correct font when in format node', function() {
        editor.value('foo<span style="font-family:Courier, monospace;">bar</span>baz');

        var finder = new GreedyInlineFormatFinder([{ tags: ['span'] }], 'font-family');

        var span = editor.body.childNodes[1];
        equal(finder.getFormat([span.firstChild]).replace(/\s+/g, ''), $(span).css('font-family').replace(/\s+/g, ''));
    });

    test('getFormat returns correct font when deep in format node', function() {
        editor.value('foo<span style="font-family:Courier, monospace;"><del>bar</del></span>baz');

        var finder = new GreedyInlineFormatFinder([{ tags: ['span'] }], 'font-family');

        var span = editor.body.childNodes[1];
        equal(finder.getFormat([span.firstChild.firstChild]).replace(/\s+/g, ''), $(span).css('font-family').replace(/\s+/g, ''));
    });

    test('getFormat returns empty string when different fonts are encountered', function() {
        editor.value('<span style="font-family:Verdana,sans-serif;">foo</span><span style="font-family:Courier,monospace;">bar</span>');

        var finder = new GreedyInlineFormatFinder([{ tags: ['span'] }], 'font-family');

        equal(finder.getFormat([editor.body.firstChild.firstChild, editor.body.lastChild.firstChild]), '');
    });

    test('getFormat returns relative font sizes when they are set', function() {
        editor.value('<span style="font-size:x-large;">foo</span>');

        var finder = new GreedyInlineFormatFinder([{ tags: ['span'] }], 'font-size');

        equal(finder.getFormat([editor.body.firstChild.firstChild]), 'x-large');
    });

</script>

</asp:Content>