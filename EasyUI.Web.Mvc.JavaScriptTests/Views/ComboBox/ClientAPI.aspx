<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>ComboBox Rendering</h2>

    <script type="text/javascript">
        function getComboBox(selector) {
            return $(selector || '#ComboBox').data('tComboBox');
        }

        var $t;

</script>

    <%= Html.EasyUI().ComboBox()
            .Name("ComboWithNoValues")
            .Items(items =>
            {
                items.Add().Text("Item1");
                items.Add().Text("Item2").Value("2");
                items.Add().Text("Item3");
                items.Add().Text("Item4");
                items.Add().Text("Item5").Value("5");
            })
    %>

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
                items.Add().Text("ttem20").Value("20");
            })
    %>

    <%= Html.EasyUI().ComboBox()
            .Name("ComboBox3")
    %>

        <%= Html.EasyUI().ComboBox()
            .Name("ComboBox2")
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
                items.Add().Text("ttem20").Value("20");
            })
            .Filterable(f => f.FilterMode(AutoCompleteFilterMode.StartsWith))
                    
    %>

    <%= Html.EasyUI().ComboBox()
            .Name("ComboBox3") %>

    <%= Html.EasyUI().ComboBox()
        .Name("ComboBox4")
        .Items(items =>
        {
            items.Add().Text("Item1").Value("1");
        }) %>

    <%= Html.EasyUI().ComboBox()
            .Name("AjaxComboBox")
            .DataBinding(binding => binding.Ajax().Select("Fake", "Home"))
    %>

    <%= Html.EasyUI().ComboBox()
            .Name("ComboBoxWithEncodedValue")
            .Items(items =>
            {
                items.Add().Text("Chef Anton's    Cajun Seasoning").Value("1");
                items.Add().Text("Item2").Value("2");
            })
            .Filterable(f => f.FilterMode(AutoCompleteFilterMode.StartsWith))
                    
    %>

    <div class="t-combobox t-header t-fontFamily"><div class="t-dropdown-wrap t-state-default"><input type="text" title="Select font family" class="t-input" autocomplete="off"><span class="t-select t-header"><span class="t-icon t-arrow-down">select</span></span></div><input type="text" style="display: none;"></div>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



        QUnit.testStart = function() {
            $t = $.easyui;
        }

        test('open method should not throw exception if no data', function () {
            try {
                var combo = getComboBox("#ComboBox3");
                combo.open();
            } catch (e) {
                ok(false);
            }
        });

        test('open method should call ajax if isAjax and no data', function () {
            
            var combo = getComboBox("#AjaxComboBox");
            var oldFill = combo.fill;
            var called = false;

            try {
                combo.fill = function () { called = true; }
                combo.open();
            } catch (e) {
                ok(false);
            } finally {
                combo.fill = oldFill;
            }

            ok(called);
        });

        test('show method should open dropDown list', function() {
            var combo = getComboBox();
            combo.effects = combo.dropDown.effects = $.easyui.fx.toggle.defaults();
            combo.close();
            combo.open();

            ok(combo.dropDown.isOpened());
        });

        test('show method reposition dropDown list', function () {
            var combo = getComboBox();
            combo.effects = combo.dropDown.effects = $.easyui.fx.toggle.defaults();

            combo.close();
            combo.open();
            
            var animatedContainer = combo.dropDown.$element.parent();

            var elementPosition = combo.$wrapper.offset();

            elementPosition.top += combo.$wrapper.outerHeight();

            equal(animatedContainer.css('position'), 'absolute');
            equal(animatedContainer.css('top'), Math.round(elementPosition.top * 1000) / 1000 + 'px');
            equal(animatedContainer.css('left'), Math.round(elementPosition.left * 1000) / 1000 + 'px');
        });

        test('select should select one item only', function() {

            var combo = getComboBox();
            combo.fill();

            var li = combo.dropDown.$element.find('li')[3];

            combo.select(li);

            ok(combo.dropDown.$element.find('.t-state-selected').length == 1);
            ok($(li).hasClass('t-state-selected'));
        });

        test('select should cache selected index', function() {
            var combo = getComboBox();

            combo.selectedIndex = -1;

            var li = combo.dropDown.$element.find('li')[3];

            combo.select(li);

            ok(combo.selectedIndex == 3);
        });

        test('select should call $t.list.updateTextAndValue method with decoded value', function () {
            var combo = $("#ComboBoxWithEncodedValue").data("tComboBox"),
                old = $t.list.updateTextAndValue,
                passedText;

            $t.list.updateTextAndValue = function (component, text, value) { passedText = text; };

            combo.fill();
            combo.selectedIndex = -1;

            combo.select(0);
            
            equal(passedText, "Chef Anton's    Cajun Seasoning");

            $t.list.updateTextAndValue = old;
        });

        test('select method should select correct item index after filtration', function () {
            var combo = $('#ComboBox2').data('tComboBox');

            combo.fill();
            combo.selectedIndex = -1;

            combo.$text.val('tt');
            combo.filter = 1;

            combo.filters[combo.filter](combo, combo.data, 'tt');
            
            combo.select(combo.dropDown.$items[0]);

            equal(combo.selectedIndex, 19);

            combo.filter = 0;
        });

        test('clicking items with templates selects items correctly', function() {
            var combo = $('#ComboBox4').data('tComboBox');

            combo.fill();

            var oldSelect = combo.select;
            var item = null;

            combo.select = function() { item = arguments[0]; };

            combo.open();

            var testee = combo.dropDown.$element.find('li');

            testee.html('<span>Item1</span>');

            testee.find('span').trigger('click');

            equal(item, testee[0]);
            
            testee.html('Item1');

            combo.select = oldSelect;
        });

        test('text method should set value of text span', function() {

            var item = { Selected: false, Text: "Item2", Value: "2" };

            var combo = getComboBox();

            combo.text("Item2");

            equal(combo.$text.val(), item.Text);
        });

        test('text method should return value if no parameters', function() {

            var item = { "Selected": false, "Text": "Item2", "Value": "2" };

            var combo = getComboBox();

            combo.text(item.Text);

            var result = combo.text();

            equal(result, item.Text);
        });

        test('value method should set value attribute of hidden input', function() {
            var item = { "Selected": false, "Text": "Item2", "Value": "2" };

            var combo = getComboBox();

            combo.value(2);

            equal(combo.$element.val(), item.Value);
        });

        test('value method should return value hidden input', function() {
            var item = { "Selected": false, "Text": "Item2", "Value": "2" };

            var combo = getComboBox();

            combo.value(2);

            var result = combo.value();

            equal(result, item.Value);
        });

        test('value method should select item depending on its text if item value is not set', function() {
            var combo = $('#ComboWithNoValues').data('tComboBox');

            combo.value('Item1');

            equal(combo.data[0].Value, null)
            equal(combo.text(), combo.data[0].Text)
            equal(combo.value(), combo.data[0].Text)
        });

        test('value method should not select item and set passed argument to hidden and visible textbox', function() {
            var combo = $('#ComboWithNoValues').data('tComboBox');

            combo.value('3');

            combo.value('Illegal');

            equal(combo.text(), 'Illegal')
            equal(combo.value(), 'Illegal')
        });

        test('open method should show hidden items if there is selected item', function() {

            var combo = getComboBox();
            
            combo.select(combo.dropDown.$items[0]);
            combo.isFiltered = true;

            combo.close();
            combo.open();
            
            equal(combo.dropDown.$items.length, 20);
        });

        test('open method should set height of the dropDown if items are filtered and item is selected', function () {

            var combo = getComboBox();

            combo.dropDown.$element.css('height', 'auto'); // set auto in order to simulate filtering of items and reducing their count to less then 10

            combo.reload();
            combo.select(combo.dropDown.$items[0]);
            combo.isFiltered = true;

            combo.close();
            combo.open();

            equal(combo.dropDown.$element.css('height'), "200px");
        });

        test('open method should unformat filtered items if there is selected item', function () {

            var combo = getComboBox();
            combo.filter = 1;
            var text = combo.dropDown.$items.first().html();
            combo.dropDown.$items.first().html("<strong>" + text + "<strong>");
            combo.isFiltered = true;

            combo.select(combo.dropDown.$items[0]);
            combo.close();
            combo.open();

            equal(combo.dropDown.$items.first().html().indexOf('<strong>'), -1);
        });

        test('open method should select item if input text is same as selected item', function() {

            var combo = getComboBox();

            var $item = combo.dropDown.$items.first();

            combo.select($item[0]);

            combo.dropDown.$items.removeClass('t-state-selected');

            combo.$text.val($item.text());
            combo.isFiltered = true;

            combo.close();
            combo.open();

            ok($(combo.dropDown.$items[combo.selectedIndex]).hasClass('t-state-selected'));
        });

        test('open method should remove selection and filter items if text is different then selected item', function() {
            
            var combo = getComboBox();

            combo.filter = 1;
            combo.select(combo.dropDown.$items[0]);
            combo.$text.val('tt');

            combo.isFiltered = true;
            
            combo.close();
            combo.open();

            equal(combo.selectedIndex, -1);
            equal(combo.dropDown.$items.length, 1);
        });

        test('open method should call filter method if text is different than selected item', function() {

            var filterIsCalled = false;
            
            var combo = getComboBox();
            combo.fill();
            
            combo.filter = 0;

            var old = combo.filters[0];
            combo.filters[0] = function () { filterIsCalled = true; };
            combo.isFiltered = true;

            combo.select(combo.dropDown.$items[0]);
            combo.$text.val('tt');

            combo.close();
           
            try {
                combo.open(); //will throw error because the replacing filter method
            }
            catch (e) { }

            combo.filters[0] = old;

            ok(filterIsCalled);
        });

        test('show method should append dropdown list to body', function() {

            var combo = getComboBox();
            combo.effects = combo.dropDown.effects = $.easyui.fx.toggle.defaults();

            combo.close();
            combo.open();

            ok($.contains(document.body, combo.dropDown.$element[0]));
        });
        
        test('hide method should remove dropdown list to body', function() {

            var combo = getComboBox();
            combo.effects = combo.dropDown.effects = $.easyui.fx.toggle.defaults();

            combo.open();
            combo.close();

            ok(!$.contains(document.body, combo.dropDown.$element[0]));
        });
        
        test('updateTextAndValue method should set value and text', function() {

            var combo = getComboBox();

            var dataitem = { Text: "Custom", Value: "1" };

            $t.list.updateTextAndValue(combo, dataitem.Text, dataitem.Value);

            equal(combo.value(), "1");
            equal(combo.text(), "Custom");
        });
        
        test('combobox initializes correctly when no name and ids are rendered', function() {
            var combo = $('.t-fontFamily').tComboBox().data('tComboBox');

            equal(combo.$element[0], combo.element);
        });

        test('reload should call fill method with empty $items collection', function() {
            var isCalled = false;
            var isEmpty = false;
            var combo = getComboBox();
            var oldFill = combo.fill;

            combo.fill = function () { isCalled = true; if (!combo.dropDown.$items) isEmpty = true; };

            combo.reload();

            ok(isCalled, "fill method was not called");
            ok(isEmpty, "$items is not empty");
            
            combo.fill = oldFill;
        });

        test('fill method should preserve current status when call dataBind', function() {
            
            var preserveStatus = false;
            var combo = getComboBox('#ComboBox3');
            combo.dataBind([{ Text: 'Item1', Value: '1' },
                            { Text: 'Item1', Value: '2' },
                            { Text: 'Item1', Value: '3' },
                            { Text: 'Item1', Value: '4' },
                            { Text: 'Item1', Value: '5' }]);
            
            var oldDataBind = combo.dataBind;
            combo.dataBind = function (data, combostatus) { preserveStatus = combostatus; combo.dropDown.dataBind(data); };
            combo.dropDown.$items = null;
            combo.fill();
            
            ok(preserveStatus, 'status is not preserved');
            combo.dataBind = oldDataBind;
        });

        test('fill method should select second item if value update selected index', function () {
            var combo = getComboBox();
            combo.data = [{ Text: 'Item1', Value: '1', Selected: false },
                        { Text: 'Item2', Value: '2', Selected: false },
                        { Text: 'Item3', Value: '3', Selected: false },
                        { Text: 'Item4', Value: '4', Selected: false },
                        { Text: 'Item5', Value: '5', Selected: false}];

            combo.index = 4;
            combo.selectedValue = "2";
            combo.dropDown.$items = null;
            combo.filteredDataIndexes = [];

            combo.fill();

            equal(combo.selectedIndex, 1);
            ok(combo.dropDown.$items.eq(1).hasClass('t-state-selected'), 'item is selected');
        });

        test('fill method should set selectedValue to the text and value inputs when it is custom value', function () {
            var combo = getComboBox();
            combo.data = [{ Text: 'Item1', Value: '1', Selected: false },
                        { Text: 'Item2', Value: '2', Selected: false },
                        { Text: 'Item3', Value: '3', Selected: false },
                        { Text: 'Item4', Value: '4', Selected: false },
                        { Text: 'Item5', Value: '5', Selected: false}];

            var customValue = "Test";
            combo.index = 4;
            combo.selectedValue = customValue;
            combo.dropDown.$items = null;
            combo.filteredDataIndexes = [];

            combo.fill();

            equal(combo.selectedIndex, -1);
            ok(!combo.dropDown.$items.hasClass('t-state-selected'), 'no items should be selected');
            equal(combo.text(), customValue);
            equal(combo.value(), customValue);
        });

        test('dataBind method should preserve selectedItem depending on Selected property even selectedIndex is present', function() {
            var combo = getComboBox('#ComboBox3');
            var data = [{ Text: 'Item1', Value: '1', Selected: false },
                        { Text: 'Item1', Value: '2', Selected: false },
                        { Text: 'Item1', Value: '3', Selected: false },
                        { Text: 'Item1', Value: '4', Selected: false },
                        { Text: 'Item1', Value: '5', Selected: true}];
            combo.index = 1;

            combo.dataBind(data);

            equal(combo.index, 4);
        });

        test('dataBind method should override selectedIndex there is no Selected true', function() {
            var combo = getComboBox('#ComboBox3');
            var data = [{ Text: 'Item1', Value: '1', Selected: false },
                        { Text: 'Item1', Value: '2', Selected: false },
                        { Text: 'Item1', Value: '3', Selected: false },
                        { Text: 'Item1', Value: '4', Selected: false },
                        { Text: 'Item1', Value: '5', Selected: false}];

            combo.index = 1;

            combo.dataBind(data);

            equal(combo.index, 1);
        });

        test('dataBind method should override selectedIndex there is no Selected defined', function() {
            var combo = getComboBox('#ComboBox3');
            var data = [{ Text: 'Item1', Value: '1' },
                        { Text: 'Item1', Value: '2' },
                        { Text: 'Item1', Value: '3' },
                        { Text: 'Item1', Value: '4' },
                        { Text: 'Item1', Value: '5'}];

            combo.index = 2;

            combo.dataBind(data);

            equal(combo.index, 2);
        });

        test('fill method should call component dataBind method', function() {
            var combo = getComboBox('#ComboBox3');
            combo.data = [{ Text: 'Item1', Value: '1', Selected: false },
                        { Text: 'Item1', Value: '2', Selected: false },
                        { Text: 'Item1', Value: '3', Selected: true },
                        { Text: 'Item1', Value: '4', Selected: false },
                        { Text: 'Item1', Value: '5', Selected: false}];

            combo.index = 1;
            combo.dropDown.$items = null;
            combo.fill();

            equal(combo.index, 2);
            ok(combo.dropDown.$items.eq(2).hasClass('t-state-selected'));
        });

        test('disable method should disable comboBox', function() {
            var combo = getComboBox('#ComboBox3');

            combo.enable();
            combo.disable();

            ok($('#ComboBox3').closest(".t-combobox").hasClass('t-state-disabled'));
            equal($('#ComboBox3').closest(".t-combobox").find('.t-input').attr('disabled'), 'disabled');
            equal($('#ComboBox3').attr('disabled'), 'disabled');
        });

        test('enable method should enable comboBox', function() {
            var combo = getComboBox('#ComboBox3');

            combo.disable();
            combo.enable();

            ok(!$('#ComboBox3').hasClass('t-state-disabled'));
            ok(!$('#ComboBox3').find('.t-input').attr('disabled'));
            ok(!$('#ComboBox3').attr('disabled'));
        });

        test('call enable() twice brokes opening drop-down', function() {
            var combo = getComboBox('#ComboBox3');

            combo.disable();
            combo.enable();
            combo.enable();

            combo.$wrapper.find('.t-select').click();

            setTimeout(function() {
                ok(combo.dropDown.isOpened());
                start();
            }, 300);

            stop(400);
        });

        test('select method should return selected index', function () {
            var combo = getComboBox('#ComboBox3');
            var index = combo.select(2);
            equal(index, combo.selectedIndex);
        });

        test('value method should update correctly previousValue', function () {
            var combo = getComboBox('#ComboBox3');
            var data = [{ Text: 'Item1', Value: '1', Selected: false },
                        { Text: 'Item2', Value: '2', Selected: false },
                        { Text: 'Item3', Value: '3', Selected: false },
                        { Text: 'Item4', Value: '4', Selected: false },
                        { Text: 'Item5', Value: '5', Selected: false}];

            combo.dataBind(data);
            
            combo.value("3");

            equal(combo.previousValue, "3");
        });

        test('dataBind should clear filteredDataIndexes', function () {
            var combo = getComboBox('#ComboBox3');

            combo.filteredDataIndexes = [9, 2];
            combo.dataBind();
            
            equal(combo.filteredDataIndexes, null);
        });

</script>

</asp:Content>