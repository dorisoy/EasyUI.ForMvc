<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Components</h2>
    
    <%= Html.EasyUI().Editor().Name("Editor") %>

    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>
    <script type="text/javascript">

        var editor;
        var colorpicker;
    </script>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



        QUnit.testStart = function() {
            editor = getEditor();
            colorpicker = $(editor.element).find('.t-colorpicker').eq(0).data('tColorPicker');
        }

        test('colorpicker value returns black when no value has been selected', function() {
            equal(colorpicker.value(), '#000000');
        });

</script>

</asp:Content>