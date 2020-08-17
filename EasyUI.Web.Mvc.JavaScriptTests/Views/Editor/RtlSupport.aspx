<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Marker</h2>

    <div class="t-rtl">
    <%= Html.EasyUI().Editor().Name("Editor") %>
    </div>
    
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

        test('content iframe inherits rtl direction', function() {
            equal($(editor.body, editor.document).css('direction'), 'rtl');
        });

</script>

</asp:Content>