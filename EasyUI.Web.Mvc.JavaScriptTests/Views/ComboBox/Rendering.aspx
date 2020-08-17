<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2>ComboBox Rendering</h2>

    <script type="text/javascript">
        function getComboBox(selector) {
            return $(selector || '#ComboBox').data('tComboBox');
        }
    </script>

    <%= Html.EasyUI().ComboBox()
            .Name("ComboBox")
            .Items(items =>
            {
                items.Add().Text("Item1").Value("1");
                items.Add().Text("Item2").Value("2");
                items.Add().Text("Item3").Value("3");
                items.Add().Text("Item4").Value("4");
                items.Add().Text("Item5").Value("5");
                items.Add().Text("Item6").Value("6");
                items.Add().Text("Item7").Value("7");
                items.Add().Text("Item8").Value("8");
                items.Add().Text("Item9").Value("9");
                items.Add().Text("Item10").Value("10");
                items.Add().Text("Item11").Value("11");
                items.Add().Text("Item12").Value("12");
                items.Add().Text("Item13").Value("13");
                items.Add().Text("Item14").Value("14");
                items.Add().Text("Item15").Value("15");
                items.Add().Text("Item16").Value("16");
                items.Add().Text("Item17").Value("17");
                items.Add().Text("Item18").Value("18");
                items.Add().Text("Item19").Value("19");
                items.Add().Text("тtem20").Value("20");
            })
            .Effects(effect => effect.Toggle())
    %>

    <div style="display:none">
    <%= Html.EasyUI().ComboBox()
        .Name("ComboWithServerAttr")
        .DropDownHtmlAttributes(new { style = "width:400px"})
        .Effects(e => e.Toggle())
        .Items(items =>
        {
            items.Add().Text("Item1").Value("1");
            items.Add().Text("Item2").Value("2");
            items.Add().Text("Item3").Value("3");
        })
    %>
    </div>

    <%= Html.EasyUI().ComboBox()
            .Name("ComboBox2")
            .Effects(e => e.Toggle())
    %>
</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



        test('combobox method should not select first item if there is no selectedItem and selectIndex is negative', function() {
            
            var ddl = getComboBox();
            ddl.index = -1;
            ddl.$element.val('');
            ddl.dropDown.$items = null;
            ddl.fill();

            equal(ddl.dropDown.$element.find('> li.t-state-selected').length, 0);
        });

        test('click item in dropDown list when it is shown should call select method', function() {

            var isSelectCalled = false;

            var ddl = getComboBox();
            ddl.effects = $.easyui.fx.toggle.defaults();

            var old = ddl.select;
            ddl.select = function () { isSelectCalled = true; }

            ddl.open();         

            $(ddl.dropDown.$items[2]).click();

            ok(isSelectCalled);

            ddl.select = old;
        });

        test('dataBind method should not select item if no items selected and selectedIndex is negative', function() {
            var combo2 = getComboBox('#ComboBox2');

            combo2.index = -1;
            combo2.highlightFirst = false;
            combo2.$element.val('');
            combo2.data = [{ "Text": "Chai", "Value": "1" },
                           { "Text": "Chang", "Value": "2" },
                           { "Text": "Aniseed Syrup", "Value": "3"}];
            combo2.dropDown.$items = null;
            combo2.fill();

            equal(combo2.dropDown.$items.filter('.t-state-selected').length, 0);
            equal(combo2.selectedIndex, -1);
        });

        test('dataBind method should select second item when selected index is 1', function() {
            var combo2 = getComboBox('#ComboBox2');
            combo2.index = 1;

            combo2.data = [{ "Text": "Chai", "Value": "1" },
                           { "Text": "Chang", "Value": "2" },
                           { "Text": "Aniseed Syrup", "Value": "3"}];
            combo2.$element.val('');
            combo2.dropDown.$items = null;
            combo2.fill();

            equal(combo2.selectedIndex, 1);
        });

        test('fill method should highlight first item if no selected item and highlightFirst option is true', function() {
            var combo2 = getComboBox('#ComboBox2');
            combo2.index = -1;
            combo2.highlightFirst = true;

            combo2.$element.val('');
            combo2.data[{ "Text": "Chai", "Value": "1" },
                           { "Text": "Chang", "Value": "2" },
                           { "Text": "Aniseed Syrup", "Value": "3"}];
            
            combo2.dropDown.$items = null;
            combo2.fill();

            ok(combo2.dropDown.$items.first().hasClass('t-state-selected'));
        });

        test('select should set text defined in li element', function() { //if text is encoded in the dataItem.Text

            var combo = $('#ComboBox2').data('tComboBox');

            combo.dataBind([{ "Text": "Calendar » Select Action", "Value": "1" },
                           { "Text": "Chang", "Value": "2" },
                           { "Text": "Aniseed Syrup", "Value": "3"}]);

            var li = combo.dropDown.$items[0];
            
            combo.select(li);

            equal(combo.text(), "Calendar » Select Action");
        });

        test('open sets dropdown zindex', function () {
            var combo = getComboBox();
            combo.effects = combo.dropDown.effects = $.easyui.fx.toggle.defaults();

            var $combo = combo.$wrapper;

            var lastZIndex = $combo.css('z-index');

            $combo.css('z-index', 42);

            combo.close();
            combo.open();

            equal('' + combo.dropDown.$element.parent().css('z-index'), '43');

            $combo.css('z-index', lastZIndex);
        });

        test('open sets dropdown width', function() {
            var combo = getComboBox('#ComboWithServerAttr');

            combo.close();
            combo.open();
            combo.close();
            combo.open();
            combo.close();
            combo.open();

            equal(combo.dropDown.$element.parent()[0].style.width, '402px');
        });

</script>

</asp:Content>