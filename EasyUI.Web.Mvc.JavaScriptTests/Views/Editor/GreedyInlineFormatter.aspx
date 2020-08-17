<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <%= Html.EasyUI().Editor().Name("Editor") %>
    
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">
    
        var editor;

        var GreedyInlineFormatter;

        module("Editor / GreedyInlineFormatter", {
            setup: function() {
                editor = getEditor();
                GreedyInlineFormatter = $.easyui.editor.GreedyInlineFormatter;
            }
        });

        test('toggle applies format on simple selection', function() {
            var range = createRangeFromText(editor, "|foo|");
            var formatter = new GreedyInlineFormatter([{ tags: ['span'] }], { style: { fontFamily: 'Arial' } }, 'font-family');
            formatter.toggle(range);
            equal(editor.value(), '<span style="font-family:Arial;">foo</span>');
        });

        test('toggle applies format on suitable node', function() {
            var range = createRangeFromText(editor, '|<span style="font-family:Courier;">foo</span>|');
            var formatter = new GreedyInlineFormatter([{ tags: ['span'] }], { style: { fontFamily: 'Arial' } }, 'font-family');
            formatter.toggle(range);
            equal(editor.value(), '<span style="font-family:Arial;">foo</span>');
        });

        test('formats split existing format nodes', function() {
            var range = createRangeFromText(editor, '<span style="font-family:Courier;">fo|o</span>bar|');
            var formatter = new GreedyInlineFormatter([{ tags: ['span'] }], { style: { fontFamily: 'Arial' } }, 'font-family');
            
            var marker = new $.easyui.editor.Marker();
            marker.add(range);
            formatter.toggle(range);
            marker.remove(range);

            equal(editor.value(), '<span style="font-family:Courier;">fo</span><span style="font-family:Arial;">obar</span>');
        });

        test('format splits span when inherit is supplied', function() {
            var range = createRangeFromText(editor, '<span style="font-family:Courier;">fo|o</span>bar|');
            var formatter = new GreedyInlineFormatter([{ tags: ['span'] }], { style: { fontFamily: 'inherit' } }, 'font-family');
            
            var marker = new $.easyui.editor.Marker();
            marker.add(range);
            formatter.toggle(range);
            marker.remove(range);

            equal(editor.value(), '<span style="font-family:Courier;">fo</span>obar');
        });

    </script>

</asp:Content>