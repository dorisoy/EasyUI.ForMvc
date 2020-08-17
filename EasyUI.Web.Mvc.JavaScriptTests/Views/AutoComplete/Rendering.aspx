<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <%= Html.EasyUI().AutoComplete()
            .Name("AutoComplete")
            .BindTo(new string[] { "Item1", "Item2", "Item3" })
            .HtmlAttributes(new { style="position: relative"})
            .Effects(effect => effect.Toggle())
    %>
    
    <div style="display:none">
    <%= Html.EasyUI().AutoComplete()
        .Name("AutoCompleteWithServerAttr")
        .DropDownHtmlAttributes(new { style = "width:400px"})
        .BindTo(new string[] {"Item1", "Item2", "Item3"})
        .Effects(effect => effect.Toggle())
    %>
    </div>

</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

        function getAutoComplete(selector) {
            return $(selector || '#AutoComplete').data('tAutoComplete');
        }

        test('click item in dropDown list when it is shown should call select method', function() {

            var isSelectCalled = false;

            var autoComplete = getAutoComplete();
            autoComplete.effects = $.easyui.fx.toggle.defaults();

            var old = autoComplete.select;
            autoComplete.select = function () { isSelectCalled = true; }

            autoComplete.open();         

            $(autoComplete.dropDown.$items[2]).click();

            ok(isSelectCalled);

            autoComplete.select = old;
        });

        test('open sets dropdown zindex', function() {
            var autoComplete = getAutoComplete();
            autoComplete.effects = autoComplete.dropDown.effects = $.easyui.fx.toggle.defaults();

            var $combo = $(autoComplete.element)

            var lastZIndex = $combo.css('z-index');

            $combo.css('z-index', 42);

            autoComplete.close();
            autoComplete.open();

            equal('' + autoComplete.dropDown.$element.parent().css('z-index'), '43');

            $combo.css('z-index', lastZIndex);
        });

        test('open sets dropdown width', function() {
            var autoComplete = getAutoComplete('#AutoCompleteWithServerAttr');

            autoComplete.close();
            autoComplete.open();
            autoComplete.close();
            autoComplete.open();
            autoComplete.close();
            autoComplete.open();

            equal(autoComplete.dropDown.$element.parent()[0].style.width, '402px');
        });

</script>

</asp:Content>