<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>StyleCommand</h2>

    <%= Html.EasyUI().Editor()
            .Name("Editor")
            .Tools(tools => tools
                .Clear()
                .Styles(styles => styles.Add("Foo", "foo"))
            )
            .StyleSheets(stylesheets => stylesheets.Add("styles.css")) %>
    
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>

    <script type="text/javascript">
    
    var editor;
    var StyleCommand;
    </script>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



    QUnit.testStart = function() {
        editor = getEditor();
        $('#Editor .t-style .t-input').click();
        StyleCommand = $.easyui.editor.StyleCommand;
    }

    test('exec applies css class to inline element', function() {
        var range = createRangeFromText(editor, '<span>|foo|</span>');
        editor.selectRange(range);
        editor.exec('style', {value:'bar'});
        equal(editor.value(), '<span class="bar">foo</span>');
    });

    test('styles applied to list item', function() {
        var span = $('.t-animation-container .t-item span')[0];
        
        if (!span) return; //does not currently work in IE!

        equal($.easyui.editor.Dom.toHex(span.style.color), '#a0b0c0');
        
        equal(span.style.paddingLeft, "42px");
        equal(span.style.paddingRight, "42px");
        equal(span.style.paddingTop, "42px");
        equal(span.style.paddingBottom, "42px");
        
        equal($.easyui.editor.Dom.toHex(span.style.backgroundColor), '#f1f1f1');
        equal(span.style.backgroundAttachment, "fixed");
        equal(span.style.backgroundImage, "none");
        equal(span.style.backgroundRepeat, "no-repeat");

        equal(span.style.borderTopStyle, "solid");
        equal(span.style.borderTopWidth, "1px");
        equal($.easyui.editor.Dom.toHex(span.style.borderTopColor), "#a0b0c0");
        
        equal(span.style.borderRightStyle, "solid");
        equal(span.style.borderRightWidth, "1px");
        equal($.easyui.editor.Dom.toHex(span.style.borderRightColor), "#a0b0c0");
        
        equal(span.style.borderLeftStyle, "solid");
        equal(span.style.borderLeftWidth, "1px");
        equal($.easyui.editor.Dom.toHex(span.style.borderLeftColor), "#a0b0c0");
        
        equal(span.style.borderLeftStyle, "solid");
        equal(span.style.borderLeftWidth, "1px");
        equal($.easyui.editor.Dom.toHex(span.style.borderLeftColor), "#a0b0c0");

        equal(span.style.fontFamily, "Arial");
        equal($.easyui.editor.Dom.toHex(span.style.fontSize), "42px");
        equal(span.style.fontStyle, "italic");
        equal(span.style.fontVariant, "small-caps");
        equal(span.style.fontWeight, "800");
        equal(span.style.lineHeight, "69px");
    });

    test('tool displays styles initially', function() {
        editor.focus();
        editor.value('');
        $(editor.element).trigger('selectionChange');
        equal($('.t-style .t-input').text(), 'Styles')
    });
    
    test('tool displays known values', function() {
        editor.focus();
        var range = createRangeFromText(editor, '<span class="foo">|foo|</span>');
        editor.selectRange(range);
        $(editor.element).trigger('selectionChange');
        equal($('.t-style .t-input').text(), 'Foo')
    });

</script>

</asp:Content>