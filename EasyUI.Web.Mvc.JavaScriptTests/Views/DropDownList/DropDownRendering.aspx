<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2>DropDown Rendering</h2>

    <script type="text/javascript">
        function dataBinding() { }

        function getDropDownList(selector) {
            return $(selector || '#DropDownList').data('tDropDownList');
        }
    </script>

    <%= Html.EasyUI().DropDownList()
        .Name("DropDownList")
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
    %>

    <div style="display:none">
    <%= Html.EasyUI().DropDownList()
        .Name("DDLWithServerAttr")
        .DropDownHtmlAttributes(new { style = "width:400px"})
        .Items(items =>
        {
            items.Add().Text("Item1").Value("1");
            items.Add().Text("Item2").Value("2");
            items.Add().Text("Item3").Value("3");
        })
    %>
    </div>

    <%= Html.EasyUI().DropDownList()
        .Name("DropDownList2") %>

    <%= Html.EasyUI().DropDownList()
        .Name("AjaxDropDownList")
        .ClientEvents(e => e.OnDataBinding("dataBinding")) 
    %>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

    test('pressing alt down arrow should open dropdown list', function () {
        var ddl = getDropDownList();
        ddl.effects = $.easyui.fx.toggle.defaults();

        ddl.close();

        ddl.dropDown.$items = null;

        var $ddl = $('#DropDownList');
        $ddl.focus();

        $ddl.trigger({ type: "keydown", keyCode: 40, altKey: true });

        ok(ddl.dropDown.$element.is(':visible'));
    });

        test('DDL should tabindex 0 applied on client', function() {
            ok(getDropDownList().element.tabIndex == 0);
        });

        test('on initialize DDL should render hidden input', function() {
            var ddl = getDropDownList();
            var input = ddl.$element;
            

            ok(input.length == 1);
            ok(input[0].type == 'text');
        });

        test('open method should open dropDown list', function() {
            var ddl = getDropDownList();
            ddl.effects = ddl.dropDown.effects = $.easyui.fx.toggle.defaults();
            ddl.close();
            ddl.open();

            ok(ddl.dropDown.isOpened());
        });

        test('open method reposition dropDown list', function() {
            var ddl = getDropDownList();
            ddl.effects = $.easyui.fx.toggle.defaults();

            ddl.close();
            ddl.open();

            var animatedContainer = ddl.dropDown.$element.parent();

            var elementPosition = ddl.$wrapper.offset();

            elementPosition.top += ddl.$wrapper.outerHeight();

            equal(animatedContainer.css('position'), 'absolute');
            equal(animatedContainer.css('top'), Math.round(elementPosition.top * 1000) / 1000 + 'px');
            equal(animatedContainer.css('left'), Math.round(elementPosition.left * 1000) / 1000 + 'px');
        });

        test('open method should append dropdown list to body', function() {

            var ddl = getDropDownList();
            ddl.effects = $.easyui.fx.toggle.defaults();

            ddl.close();
            ddl.open();

            ok($.contains(document.body, ddl.dropDown.$element[0]));
        });

        test('close method should remove dropdown list to body', function() {

            var ddl = getDropDownList();
            ddl.effects = $.easyui.fx.toggle.defaults();

            ddl.open();
            ddl.close();

            ok(!$.contains(document.body, ddl.dropDown.$element[0]));
        });

        test('click item in items list when it is shown should call select method', function() {

            var isSelectCalled = false;
            
            var ddl = getDropDownList();
            ddl.effects = $.easyui.fx.toggle.defaults();

            var old = ddl.select;
            ddl.select = function () { isSelectCalled = true; }

            ddl.open();

            $(ddl.dropDown.$element.find('li')[2]).click();

            ok(isSelectCalled);

            ddl.select = old;
        });

        test('select should select one item only', function() {
            
            var ddl = getDropDownList();

            var li = ddl.dropDown.$element.find('li')[3];

            ddl.select(li);

            ok(ddl.dropDown.$element.find('.t-state-selected').length == 1);
            ok($(li).hasClass('t-state-selected'));
        });

        test('select should cache selected item', function() {
            var ddl = getDropDownList();
            
            ddl.selectedIndex = -1;

            var li = ddl.dropDown.$element.find('li')[3];

            ddl.select(li);

            equal(ddl.selectedIndex, 3);
        });

        test('highlight should highlight only one item by index', function() {
            var ddl = getDropDownList();

            ddl.highlight(2);

            equal(ddl.dropDown.$element.find('.t-state-selected').length, 1);
        });

        test('highlight should highlight fourth item by index', function() {
            var ddl = getDropDownList();

            ddl.highlight(3);

            equal(ddl.dropDown.$element.find('.t-state-selected').first().index(), 3);
        });

        test('highlight should preserve previous value after rebind', function() {
            var ddl = getDropDownList();
           
            ddl.highlight(4);
            
            var value = ddl.previousValue;
            
            ddl.highlight(2);

            equal(ddl.previousValue, value);
        });

        test('hightlight method should return negative if no such index', function() {
            var ddl = getDropDownList();
            
            var result = ddl.highlight(3000);

            equal(result, -1);
        });

        test('hightlight method should call close if correct index is passed', function () {
            var ddl = getDropDownList();

            var isCloseCalled = false;
            
            var close = ddl.close;

            ddl.close = function () { isCloseCalled = true; };

            ddl.highlight(2);

            ok(isCloseCalled);

            ddl.close = close;
        });

        test('highlight should higlight item found by predicate', function() {
            var ddl = getDropDownList();
            ddl.fill();
            
            ddl.highlight(function (dataItem) {
                return dataItem.Value == 2;
            });

            equal(ddl.dropDown.$element.find('.t-state-selected').first().index(), 1);
        });

        test('hightlight method should return negative if no such item', function() {
            var ddl = getDropDownList();
            ddl.fill();
            
            var result = ddl.highlight(function (dataItem) {
                return dataItem.Value == 1000;
            });

            equal(result, -1);
        });

        test('hightlight method should call close if item is found by predicate', function() {
            var ddl = getDropDownList();
            ddl.fill();

            var isCloseCalled = false;

            var close = ddl.close;

            ddl.close = function () { isCloseCalled = true; };

            ddl.highlight(function (dataItem) {
                return dataItem.Value == 2;
            });

            ok(isCloseCalled);

            ddl.close = close;
        });

        test('highlight method should return negative index if data is undefined', function() {

            var ddl = $('#DropDownList2').data('tDropDownList');
            
            var index = ddl.highlight(0);

            equal(index, -1);
        });
        
        test('text method should set html of text span', function() {

            var item = { "Selected": false, "Text": "Item2", "Value": "2" };

            var ddl = getDropDownList();

            ddl.text("Item2");

            equal(ddl.$text.html(), item.Text);
        });

        test('text method should return innerHtml if no parameters', function() {
            
            var item = { "Selected": false, "Text": "Item2", "Value": "2" };
            
            var ddl = getDropDownList();

            ddl.text("Item2");

            var result = ddl.text();

            equal(result, item.Text);
        });

        test('value method should call select method and set previousSelected value if such item', function () {
            var item = { "Selected": false, "Text": "Item2", "Value": "2" };
            var isCalled = false;

            var ddl = getDropDownList();
            var select = ddl.select;
            ddl.previousValue = null;
            ddl.select = function () { isCalled = true; ddl.$element.val("2"); return 2; }

            ddl.value(2);

            equal(isCalled, true);
            equal(ddl.previousValue.toString(), '2', 'previous value was not updated');

            ddl.select = select;
        });

        test('value method should return value hidden input', function() {
            var item = { "Selected": false, "Text": "Item2", "Value": "2" };
            
            var ddl = getDropDownList();

            ddl.value(2);

            equal(item.Value, ddl.value());
        });

        test('keyPress should find element т', function() {
            var ddl = getDropDownList();
            
            var $ddl = $('#DropDownList');
            $ddl.focus();
            $ddl.trigger({ type: "keypress", keyCode: 1058 });

            ok($(ddl.dropDown.$element.find('.t-state-selected')[0]).text() == "тtem20");
        });

        test('pressing right arrow should select next item', function() {
            var ddl = getDropDownList();

            var $initialSelectedItem = $(ddl.dropDown.$element.find('.t-item')[0]);
            ddl.select($initialSelectedItem);

            var $ddl = $('#DropDownList');
            $ddl.focus();
            $ddl.trigger({ type: "keydown", keyCode: 39 });

            var $nextSelectedItem = $(ddl.dropDown.$element.find('.t-state-selected')[0]);

            ok(!($initialSelectedItem.text() == $nextSelectedItem.text()));
        });


        test('pressing down arrow should select next item', function() {
            var ddl = getDropDownList();

            var $initialSelectedItem = $(ddl.dropDown.$element.find('.t-item')[0]);
            ddl.select($initialSelectedItem);

            var $ddl = $('#DropDownList');
            $ddl.focus();
            $ddl.trigger({ type: "keydown", keyCode: 40 });

            var $nextSelectedItem = $(ddl.dropDown.$element.find('.t-state-selected')[0]);

            ok(!($initialSelectedItem.text() == $nextSelectedItem.text()));
        });

        test('pressing up arrow should select prev item', function() {
            var ddl = getDropDownList();

            ddl.select(ddl.dropDown.$element.find('li')[1]);

            var $initialSelectedItem = $(ddl.dropDown.$element.find('.t-state-selected')[0]);

            var $ddl = $('#DropDownList');
            $ddl.focus();
            $ddl.trigger({ type: "keydown", keyCode: 38 });

            var $prevSelectedItem = $(ddl.dropDown.$element.find('.t-state-selected')[0]);

            ok(!($initialSelectedItem.text() == $prevSelectedItem.text()));
        });

        test('pressing left arrow should select prev item', function() {
            var ddl = getDropDownList();

            ddl.select(ddl.dropDown.$element.find('li')[1]);

            var $initialSelectedItem = $(ddl.dropDown.$element.find('.t-state-selected')[0]);

            var $ddl = $('#DropDownList');
            $ddl.focus();
            $ddl.trigger({ type: "keydown", keyCode: 37 });

            var $prevSelectedItem = $(ddl.dropDown.$element.find('.t-state-selected')[0]);

            ok(!($initialSelectedItem.text() == $prevSelectedItem.text()));
        });

        test('Home should select first item', function() {
            var ddl = getDropDownList();

            var $ddl = $('#DropDownList');
            $ddl.focus();
            $ddl.trigger({ type: "keydown", keyCode: 36 });

            var $nextSelectedItem = $(ddl.dropDown.$element.find('.t-state-selected')[0]);

            ok(ddl.dropDown.$element.find('.t-item').first().text() == $nextSelectedItem.text());
        });

        test('End should select last item', function() {
            var ddl = getDropDownList();

            var $ddl = $('#DropDownList');
            $ddl.focus();
            $ddl.trigger({ type: "keydown", keyCode: 35 });

            var $nextSelectedItem = $(ddl.dropDown.$element.find('.t-state-selected')[0]);

            ok(ddl.dropDown.$element.find('.t-item').last().text() == $nextSelectedItem.text());
        });

        test('pressing escape should close dropdown list', function() {
            var ddl = getDropDownList();
            ddl.effects = ddl.dropDown.effects = $.easyui.fx.toggle.defaults();
            
            ddl.open();
            
            var $ddl = $('#DropDownList');
            $ddl.focus();

            $ddl.trigger({ type: "keydown", keyCode: 27});

            ok(!ddl.dropDown.isOpened());
        });

        test('scrollTo method should return if item is undefined', function() {
            var ddl2 = getDropDownList();

            var throwException = false;

            try {
                ddl2.dropDown.scrollTo(undefined);
            }
            catch (e) {
                throwException = true;
            }
                        
            ok(!throwException, "Thrown exception when item is undefined.");
        });

        test('Fill method on ajax should call change event handler', function() {
            var isCalled = false;
            var ddl = $('#AjaxDropDownList').data('tDropDownList');
            var old = ddl.trigger.change;

            ddl.ajaxRequest = function (callback) { callback(); }
            ddl.trigger.change = function () { isCalled = true; }

            ddl.fill();

            ok(isCalled);
        });

        test('open sets dropdown zindex', function () {
            var ddl = getDropDownList();
            ddl.effects = ddl.dropDown.effects = $.easyui.fx.toggle.defaults();

            var $ddl = ddl.$wrapper;

            var lastZIndex = $ddl.css('z-index');

            $ddl.css('z-index', 42);

            ddl.close();
            ddl.open();

            equal('' + ddl.dropDown.$element.parent().css('z-index'), '43');

            $ddl.css('z-index', lastZIndex);
        });

        test('open sets dropdown width', function() {
            var ddl = getDropDownList('#DDLWithServerAttr');

            ddl.close();
            ddl.open();
            ddl.close();
            ddl.open();
            ddl.close();
            ddl.open();

            equal(ddl.dropDown.$element.parent()[0].style.width, '402px');
        });

        test('dataBind method should not throw exception if item is null', function () {
            var decodedText = '<>&Visit W3Schools!';
            var ddl = getDropDownList();

            var dataSource = [
                { Text: decodedText, Value: decodedText },
                null
            ];

            var result;

            try {
                ddl.dataBind(dataSource);
                result = true;
            } catch (e) {
                result = false;
            } finally {
                ok(result);
            }
        });

        test('dataBind method should encode Text property if encoded is true', function () {
            var decodedText = '<>&Visit W3Schools!';
            var ddl = getDropDownList();
            var old = ddl.loader.isAjax;
            ddl.loader.isAjax = function () { return true; }
            
            var dataSource = [
                { Text: decodedText, Value: decodedText },
                { Text: "Product 2", Value: "2" }
            ];
            
            ddl.dataBind(dataSource);

            ddl.loader.isAjax = old;

            equal('&lt;&gt;&amp;Visit W3Schools!', ddl.dropDown.$items.eq(0).html(), 'Text property is not encoded');
            equal(dataSource[0].Value, ddl.data[0].Value);
        });

        test('dataBind method should not encode Text property if encoded is true and isAjax returns false', function () {
            var ddl = getDropDownList();
            var old = ddl.loader.isAjax;
            ddl.loader.isAjax = function () { return false; }

            var dataSource = [
                { Text: "&lt;&gt;&amp;Visit W3Schools!", Value: "" },
                { Text: "Product 2", Value: "2" }
            ];

            ddl.dataBind(dataSource);

            ddl.loader.isAjax = old;

            equal('&lt;&gt;&amp;Visit W3Schools!', ddl.data[0].Text, 'Text property is encoded twice');
        });

        test('dataBind method should not encode Text property if encoded is true, but isAjax returns onDataBinding handler', function () {
            var ddl = $('#DropDownList2').data('tDropDownList');
            ddl.onDataBinding = function () { };
            
            var dataSource = [
                { Text: "&lt;&gt;&amp;Visit W3Schools!", Value: "" },
                { Text: "Product 2", Value: "2" }
            ];

            ddl.dataBind(dataSource);

            equal('&lt;&gt;&amp;Visit W3Schools!', ddl.data[0].Text, 'Text property is encoded twice');
        });

        test('hightlight method should call dataBind dropDown.$items is undefined', function () {
            var ddl = getDropDownList();

            var isDataBindCalled = false;

            var dataBind = ddl.dropDown.dataBind;

            ddl.dropDown.dataBind = function () { ddl.dropDown.$items = $("<li><li>"); isDataBindCalled = true; };
            ddl.dropDown.$items = null;
            
            ddl.highlight(function (dataItem) {
                return dataItem.Value == 2;
            });

            ok(isDataBindCalled);

            ddl.dropDown.dataBind = dataBind;
        });

</script>

</asp:Content>