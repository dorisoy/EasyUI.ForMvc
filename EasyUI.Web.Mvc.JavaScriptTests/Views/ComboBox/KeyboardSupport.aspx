<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2>Keyboard support</h2>
    
    <script type="text/javascript">

        function getComboBox() {
            return $('#ComboBox').data('tComboBox');
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
            .Filterable(filtering => filtering.FilterMode(AutoCompleteFilterMode.StartsWith))
    %>

        
    <%= Html.EasyUI().ComboBox()
        .Name("ComboBox2")
        .Items(items =>
        {
            items.Add().Text("Chai").Value("1");
            items.Add().Text("Chang").Value("2");
            items.Add().Text("Tofu").Value("3");
            items.Add().Text("Boysenberry").Value("4");
            items.Add().Text("Uncle").Value("5");
            items.Add().Text("Northwoods").Value("6");
            items.Add().Text("Ikura").Value("7");
            items.Add().Text("Queso").Value("8");
            items.Add().Text("Manchego").Value("9");
            items.Add().Text("Dried").Value("10");
            items.Add().Text("тtem20").Value("11");
        })
        .Filterable(filtering => filtering.FilterMode(AutoCompleteFilterMode.StartsWith))
    %>

           <%= Html.EasyUI().ComboBox()
            .Name("ComboBox3")
            .Items(items =>
            {
                items.Add().Text("Item1").Value("1");
                items.Add().Text("Item2").Value("2");
                items.Add().Text("Item3").Value("3");
            })
            .OpenOnFocus(true)
    %>

</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

    test('pressing alt down arrow should open dropdown list if LI items are not rendered', function () {
        var combo = getComboBox();
        combo.effects = $.easyui.fx.toggle.defaults();

        combo.close();

        combo.dropDown.$items = null;

        combo.$text.focus();
        combo.$text.trigger({ type: "keydown", keyCode: 40, altKey: true });

        ok(combo.dropDown.isOpened());
    });

    test('pressing down arrow when is Ajax should not throw error', function () {
        var combo = getComboBox();
        var oldFill = combo.fill;
        try {
            combo.fill = function () { }
            combo.dropDown.$items = null;
            combo.$text.focus();
            combo.$text.trigger({ type: "keydown", keyCode: 40 });
        } finally {
            combo.fill = oldFill;
        }
    });

        test('pressing down arrow should select next item', function() {
            var combo = getComboBox();

            combo.fill();

            var $initialSelectedItem = combo.dropDown.$items.first();
            var initialSelectedIndex = $initialSelectedItem.index();
            combo.select($initialSelectedItem);

            
            combo.$text.focus();
            combo.$text.trigger({ type: "keydown", keyCode: 40 });

            notEqual(combo.selectedIndex, -1);
            notEqual(combo.selectedIndex, initialSelectedIndex);
        });

        test('pressing up arrow should select prev item', function() {
            var combo = getComboBox();

            combo.select(combo.dropDown.$items[1]);

            var initialSelectedIndex = $(combo.dropDown.$element.find('.t-state-selected')[0]).index();

            combo.$text.focus();
            combo.$text.trigger({ type: "keydown", keyCode: 38 });

            notEqual(combo.selectedIndex, -1);
            notEqual(combo.selectedIndex, initialSelectedIndex);
        });

        test('keydown should create $items if they do not exist', function() {
            var combo = getComboBox();
            combo.dropDown.$items = null;

            combo.$text.focus();

            combo.$text.trigger({ type: "keydown", keyCode: 38 });

            ok(combo.dropDown.$items.length > 0);
        });

        test('down arrow should select next item', function() {
            var combo = getComboBox();

            combo.open();

            combo.select(combo.dropDown.$items[0]);

            combo.$text.focus();
            combo.$text.trigger({ type: "keydown", keyCode: 40 });

            equal(combo.selectedIndex, 1)
        });

        test('down arrow should select first item if no selected', function() {
            var combo = getComboBox();
            
            combo.open();

            combo.dropDown.$items.removeClass('t-state-selected');
            combo.selectedIndex = -1;

            combo.$text.focus();
            combo.$text.trigger({ type: "keydown", keyCode: 40 });

            equal(combo.selectedIndex, 0)
        });

        test('up arrow should select previous item', function() {
            var combo = getComboBox();
            
            combo.open();

            combo.select(combo.dropDown.$items[4]);

            combo.$text.focus();
            combo.$text.trigger({ type: "keydown", keyCode: 38 });

            equal(combo.selectedIndex, 3)
        });

        test('clicking up arrow should select first item if no selected item', function() {
            var combo = getComboBox();
            
            combo.open();
            combo.selectedIndex = -1;
            combo.dropDown.$items.removeClass('t-state-selected');

            combo.$text.focus();
            combo.$text.trigger({ type: "keydown", keyCode: 38});

            equal(combo.selectedIndex, 0)
        });

        test('pressing Enter should close dropdown list', function() {
            var isCalled = false;
            var combo = getComboBox();
            combo.effects = $.easyui.fx.toggle.defaults();

            combo.$text.focus();

            var old = combo.trigger.close;

            combo.trigger.close = function () { isCalled = true; }

            combo.$text.trigger({ type: "keydown", keyCode: 40 });
            combo.$text.trigger({ type: "keydown", keyCode: 13 });

            ok(isCalled);

            combo.trigger.close = old;
        });

        test('pressing Enter should change hidden input value', function() {
            var combo = getComboBox();
            combo.effects = $.easyui.fx.toggle.defaults();

            combo.$text.focus();

            combo.dropDown.$items.removeClass('t-state-selected');

            combo.$text.val('test');
            combo.$text.trigger({ type: "keydown", keyCode: 13 });

            equal(combo.value(), 'test');
        });

        test('pressing Enter should not post if items list is opened', function() {
            var combo = getComboBox();
            combo.effects = $.easyui.fx.toggle.defaults();

            var isPreventCalled = false;

            combo.$text.focus();
            combo.$text.trigger({ type: "keydown", keyCode: 40 });
            combo.$text.trigger({ type: "keydown", keyCode: 13, preventDefault: function () { isPreventCalled = true } });

            ok(isPreventCalled);
        });

        test('pressing escape should call trigger close', function() {
            var isCalled = false;
            var combo = getComboBox();
            combo.effects = combo.dropDown.effects = $.easyui.fx.toggle.defaults();

            combo.open();
            combo.$text.focus();
            var old = combo.trigger.close;

            combo.trigger.close = function () { isCalled = true; }

            combo.$text.trigger({ type: "keydown", keyCode: 27 });

            ok(isCalled);

            combo.trigger.close = old;
        });

        test('pressing escape should blur input', function() {
            var combo = getComboBox();

            var isFocused = true;

            combo.$text.focus();
            combo.$text.blur(function () { isFocused = false });

            combo.$text.trigger({ type: "keydown", keyCode: 27 });

            ok(!isFocused);
        });

        test('if pressed key is part of keyCodes collection do not continue', function() {
            var combo = getComboBox();
            
            var oldFilter = combo.filters[combo.filter];

            var isCalled = true;

            combo.filters[combo.filter] = function () { isCalled = false; };

            combo.$text.focus();
            combo.$text.trigger({ type: "keypress", keyCode: 38 });

            ok(isCalled);

            combo.filters[combo.filter] = oldFilter;
        });

        test('pressing down arrow should select first item if no selected, but first is highlighted', function () {
            var combo = getComboBox();

            combo.open();

            combo.dropDown.$items.removeClass('t-state-selected').eq(0).addClass('t-state-selected');
            combo.selectedIndex = -1;

            combo.$text.focus();
            combo.$text.trigger({ type: "keydown", keyCode: 40 });

            equal(combo.selectedIndex, 0)
        });

        test("drop-down list should close when close method is called even when it is still opening", function () {
            var combo = $("#ComboBox3").data("tComboBox");
            combo.openOnFocus = true;
            combo.$element.bind("close", function () {
                ok(true);
                start();
            });

            combo.$text.focus();
            $(document.documentElement).mousedown();

            stop(500);
        });

</script>

</asp:Content>