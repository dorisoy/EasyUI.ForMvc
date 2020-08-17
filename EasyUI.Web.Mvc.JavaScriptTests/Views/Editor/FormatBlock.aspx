<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>FormatBlock</h2>

    <%= Html.EasyUI().Editor().Name("Editor") %>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>
    <script type="text/javascript">
        var editor;
    </script>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



        QUnit.testStart = function() {
            editor = getEditor();
        }

        test('tool should display format initially', function() {
            editor.value('');
            editor.focus();
            $(editor.element).trigger('selectionChange');
            equal($('.t-formatBlock .t-input').text(), 'Format')
        });

        test('tool displays known values', function() {
            var range = createRangeFromText(editor, '<p>|foo|</p>');
            editor.selectRange(range);
            $(editor.element).trigger('selectionChange');
            equal($('.t-formatBlock .t-input').text(), 'Paragraph')
        });

</script>

</asp:Content>