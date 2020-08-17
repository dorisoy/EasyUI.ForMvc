<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>ClientSideApi</h2>

    
    <%= Html.EasyUI().Editor().Name("EditorEncodeFalse").Encode(false)%>
    <%= Html.EasyUI().Editor().Name("Editor") %>
    <%= Html.EasyUI().Editor().Name("EditorWithStyleSheets").StyleSheets(style => style.Add("easyui.common.css").Add("easyui.vista.css"))%>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>
    <script type="text/javascript">

        var editor;
        var rootUrl = '<%= Url.Content("~/") %>';

    </script>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



        QUnit.testStart = function() {
            editor = getEditor();
        }

        test('editor value should not be encoded', function() {
            var editorEncodeFalse = getEditor('#EditorEncodeFalse');
            editorEncodeFalse.value('<p>foo</p>');

            editorEncodeFalse.update();

            equal(editorEncodeFalse.textarea.value, '<p>foo</p>');
        });

        test('editor default Encode value must be true', function() {
            equal(editor.encoded, true);
        });

        test('editor should add stylesheets', function() {
            var editorWithStyleSheets = getEditor('#EditorWithStyleSheets');

            equal(editorWithStyleSheets.stylesheets[0], rootUrl + 'Content/easyui.common.css');
            equal(editorWithStyleSheets.stylesheets[1], rootUrl + 'Content/easyui.vista.css');
        });

        test('editor outputs css links in iframe', function() {
            var editorWithStyleSheets = getEditor('#EditorWithStyleSheets');
            
            var links = $('link', editorWithStyleSheets.document);
            
            equal(links.eq(0).attr('href'), rootUrl + 'Content/easyui.common.css');
            equal(links.eq(1).attr('href'), rootUrl + 'Content/easyui.vista.css');
        });

</script>

</asp:Content>