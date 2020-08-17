<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <h2>TimeView</h2>
    
    <script type="text/javascript">
        var tv;
        var $input;
        var position;
        var itemValue;
        var passedValue;

        function changeCallBack(pass) {
            passedValue = pass;
        }

        function navigateWithOpenPopupCallBack(pass) {
            itemValue = pass;
        }

    </script>

    <input id="testInput" />

    <% Html.EasyUI().ScriptRegistrar()
           .DefaultGroup(group => group.Add("easyui.common.js")
                                       .Add("easyui.timepicker.js")); 
    %>

</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">


    module("TreeView / ClientAPI", {
        setup: function () {
            $input = $('#testInput');

            tv = new $t.timeView({
                effects: new $t.fx.toggle.defaults(),
                dropDownAttr: '',
                format: $t.cultureInfo.shortTime,
                interval: 30,
                isRtl: $input.closest('.t-rtl').length,
                minValue: new Date(2010, 10, 10, 12, 0, 0),
                maxValue: new Date(2010, 10, 10, 12, 0, 0),
                onChange: changeCallBack,
                onNavigateWithOpenPopup: navigateWithOpenPopupCallBack
            });

            position = {
                offset: $input.offset(),
                outerHeight: $input.outerHeight(),
                outerWidth: $input.outerWidth(),
                zIndex: $t.getElementZIndex($input[0])
            }
        }
    });

    test('timeView should create dropDown on its creating', function () {

        var timeView = new $t.timeView({
            effects: new $t.fx.slide.defaults(),
            dropDownAttr: 'width:100px',
            isRtl: 0
        });

        ok(undefined !== timeView.dropDown);
        ok(undefined !== timeView.dropDown.onClick);
        equal(timeView.dropDown.effects.list[0].name, timeView.effects.list[0].name, 'not correct effects are set');
        equal(timeView.dropDown.attr, timeView.dropDownAttr, 'not correct effects are set');
    });

    test('ensure items will call bind if not items are created', function () {
        var isCalled = false;
        var oldM = tv.bind;
        tv.bind = function () { isCalled = true; }

        tv.dropDown.$items = null;

        tv._ensureItems();

        ok(isCalled, 'bind method was not called');

        tv.bind = oldM;
    });

    test('open method should call ensureItems', function () {
        var isCalled = false;
        var oldM = tv._ensureItems;
        tv._ensureItems = function () { isCalled = true; }

        tv.open(position);

        ok(isCalled, '_ensureItems was not called');

        tv._ensureItems = oldM;
    });

    test('open method should call dropDown open method with position data', function () {
        var passedPos;
        var isCalled = false;
        var oldM = tv.dropDown.open;
        tv.dropDown.open = function (pos) { isCalled = true; passedPos = pos; }

        tv.open(position);

        ok(isCalled, 'open method was not called');
        equal(passedPos.offset.top, position.offset.top, 'passed position is not correct'); //just chekc one property

        tv.dropDown.open = oldM;
    });

    test('open method should call dropDown close method', function () {
        var isCalled = false;
        var oldM = tv.dropDown.close;
        tv.dropDown.close = function () { isCalled = true; }

        tv.close();

        ok(isCalled, 'close method was not called');

        tv.dropDown.close = oldM;
    });

    test('bind method will call dataBind with correct array of available hours', function () {
        var timeView = new $t.timeView({
            effects: new $t.fx.slide.defaults(),
            dropDownAttr: 'width:100px',
            isRtl: 0,
            format: 'H:mm',
            interval: 30,
            isRtl: $input.closest('.t-rtl').length,
            minValue: new Date(2010, 10, 10, 23, 0, 0),
            maxValue: new Date(2010, 10, 10, 2, 0, 0)
        });

        var availableHours;
        var oldM = timeView.dropDown.dataBind;
        timeView.dropDown.dataBind = function (hours) { availableHours = hours; }

        timeView.bind();

        ok(undefined !== availableHours);
        equal(availableHours.length, 7, 'renderedItems are not correct number');
        equal(availableHours[0], "23:00", 'hours is not formatted correctly');

        timeView.dropDown.dataBind = oldM;
    });

    test('bind method should add maxValue to items list', function () {
        var timeView = new $t.timeView({
            effects: new $t.fx.slide.defaults(),
            dropDownAttr: 'width:100px',
            isRtl: 0,
            format: 'H:mm',
            interval: 30,
            isRtl: $input.closest('.t-rtl').length,
            minValue: new Date(2010, 10, 10, 23, 0, 0),
            maxValue: new Date(2010, 10, 10, 2, 15, 0)
        });

        var availableHours;
        var oldM = timeView.dropDown.dataBind;
        timeView.dropDown.dataBind = function (hours) { availableHours = hours; }

        timeView.bind();

        equal(availableHours.length, 8, 'renderedItems are not correct number');
        equal(availableHours[7], "2:15", 'hours is not formatted correctly');

        timeView.dropDown.dataBind = oldM;
    });

    test('value method should highlight item depending on the passed date', function () {
        tv.dropDown.$items = null
        tv.minValue = new Date(2010, 10, 10, 12, 0, 0);
        tv.maxValue = new Date(2010, 10, 10, 12, 0, 0);

        tv.value("3:00 PM");

        var $item = tv.dropDown.$items.filter('.t-state-selected');

        equal($item.length, 1, 'Selected item is not one');
        equal($item.text(), "3:00 PM", 'selected item is not correct');
    });

    test('value method should deselect all items if value is null', function () {
        tv.dropDown.$items = null
        tv.minValue = new Date(2010, 10, 10, 12, 0, 0);
        tv.maxValue = new Date(2010, 10, 10, 12, 0, 0);

        tv.value(null);

        var $item = tv.dropDown.$items.filter('.t-state-selected');

        equal($item.length, 0, 'Selected item is not 0');
    });

    test('value method should return text of the selected item', function () {
        tv._ensureItems();
        var $item = tv.dropDown.$items.filter('.t-state-selected');
        equal(tv.value(), $item.text());
    });

    test('max method should rebind items list', function () {
        var date = new Date(2000, 1, 1, 3, 0, 0);

        tv.max(date)

        var $items = tv.dropDown.$items;

        equal(tv.maxValue - date, 0, 'maxValue is not set correctly');
        equal($($items[$items.length - 1]).text(), $t.datetime.format(tv.maxValue, tv.format));
    });

    test('max method should return maxValue', function () {
        var date = tv.max();

        equal(date - tv.maxValue, 0);
    });

    test('min method should rebind items list', function () {
        var date = new Date(2000, 1, 1, 10, 0, 0)

        tv.min(date)

        var $items = tv.dropDown.$items;

        equal(tv.minValue - date, 0, 'minValue is not set correctly');
        equal($($items[0]).text(), $t.datetime.format(tv.minValue, tv.format));
    });

    test('min method should return minValue', function () {
        var date = tv.min();

        equal(date - tv.minValue, 0);
    });

    test('clicking item should raise onChange callback', function () {
        tv.open(position);

        var $item = tv.dropDown.$items.eq(1);

        $item.click();

        ok(undefined !== passedValue);
        equal(passedValue, $item.text(), 'passed value is not correct');
    });

    test('pressing down arrow should select next item', function () {
        tv.open(position);

        var $initialSelectedItem = tv.dropDown
                                            .$items
                                            .removeClass('t-state-selected')
                                            .first()
                                            .addClass('t-state-selected');

        tv.navigate({ keyCode: 40, preventDefault: function () { } });

        var $selectedItem = tv.dropDown.$items.filter('.t-state-selected').eq(0);

        equal($selectedItem.index(), $initialSelectedItem.next().index(), 'correct item is not selected');
        equal(itemValue, $selectedItem.text());
    });

    test('pressing up arrow should select prev item', function () {
        tv.open(position);

        tv.dropDown.highlight(tv.dropDown.$items[1]);

        tv.navigate({ keyCode: 38, preventDefault: function () { } });

        var $selectedItem = tv.dropDown.$items.filter('.t-state-selected').eq(0);

        equal($selectedItem.index(), 0, 'correct item is not selected');
        equal(itemValue, $selectedItem.text());
    });

    test('keydown should create $items if they do not exist', function () {
        tv.dropDown.$items = null;

        tv.navigate({ keyCode: 38, preventDefault: function () { } });

        ok(tv.dropDown.$items.length > 0);
    });

    test('pressing up arrow should select first item if no selected item', function () {
        tv.open(position);

        tv.dropDown.$items.removeClass('t-state-selected');

        tv.navigate({ keyCode: 38, preventDefault: function () { } });

        equal(tv.dropDown.$items.filter('.t-state-selected').index(), 0)
    });

    test('pressing up arrow should raise OnChange if popup is closed', function () {
        tv.close(position);

        tv._ensureItems();

        tv.dropDown.highlight(tv.dropDown.$items[1]);

        tv.navigate({ keyCode: 38, preventDefault: function () { } });

        var $selectedItem = tv.dropDown.$items.filter('.t-state-selected').eq(0);

        equal($selectedItem.index(), 0, 'correct item is not selected');
        equal(passedValue, $selectedItem.text());
    });

    test('navigate should not call preventDefault if key is not arrow', function () {

        var isCalled = false;

        tv.navigate({ keyCode: 49, preventDefault: function () { isCalled = true; } });

        ok(!isCalled, 'preventDefault was called');
    });

    test('navigate should call preventDefault if key is arrow', function () {

        var isCalled = false;

        tv.navigate({ keyCode: 38, preventDefault: function () { isCalled = true; } });

        ok(isCalled, 'preventDefault was not called');
    });

</script>

</asp:Content>