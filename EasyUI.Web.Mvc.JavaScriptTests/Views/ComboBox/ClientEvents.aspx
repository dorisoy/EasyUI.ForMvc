<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2>Client Events</h2>
    <script type="text/javascript">
        var isChanged;
        var returnedValue;
        var isOpenRaised;
        var isCloseRaised;
        var isDataBinding;
        var isDataBound;
        var comboBox;

        function getComboBox(id) {
            return $(id || '#ComboBox').data('tComboBox');
        }

        //handlers
        function onChange(e) {
            returnedValue = e.value; 
            isChangeRaised = true;
        }

        function onClose(sender, args) {
            isCloseRaised = true;
        }

        function onOpen(sender, args) {
            isOpenRaised = true;
        }

        function onDataBinding(sender, args) {
            isDataBinding = true;
        }

        function onDataBound(sender, args) {
            isDataBound = true;
        }
    </script>

    <%= Html.EasyUI().ComboBox()
            .Name("ComboWithNoValue")
            .Items(items =>
            {
                items.Add().Text("Item1");
                items.Add().Text("Item2").Value("2");
                items.Add().Text("Item3");
                items.Add().Text("Item4").Value("4");
                items.Add().Text("Item5");
            })
            .Effects(effects => effects.Toggle())
            .OpenOnFocus(true)
    %>

    <%= Html.EasyUI().ComboBox()
            .Name("ComboWithEmptyValue")
            .Items(items =>
            {
                items.Add().Text("");
                items.Add().Text("Item2").Value("2");
                items.Add().Text("Item3");
                items.Add().Text("Item4").Value("4");
                items.Add().Text("Item5");
            })
            .Effects(effects => effects.Toggle())
    %>

    <%= Html.EasyUI().ComboBox()
            .Name("ComboBox")
            .Items(items =>
            {
                for (var i = 1; i <= 14; i++)
                    items.Add().Text("Item" + i).Value(i.ToString());
            })
            .OpenOnFocus(true)
            .Effects(effects => effects.Toggle())
                    .ClientEvents(events => events.OnOpen("onOpen")
                                                  .OnClose("onClose")
                                                  .OnChange("onChange"))
    %>

     <%= Html.EasyUI().ComboBox()
            .Name("AjaxComboBox")
            .Effects(effects => effects.Toggle())
            .DataBinding(binding => binding.Ajax().Select("_AjaxLoading", "ComboBox"))
            .ClientEvents(events => events.OnDataBinding("onDataBinding")
                                          .OnDataBound("onDataBound"))
    %>

    <%= Html.EasyUI().ComboBox()
            .Name("AjaxComboBoxWithMinChars")
            .Filterable(filtering => filtering.MinimumChars(3))
            .Effects(effects => effects.Toggle())
            .DataBinding(binding => binding.Ajax().Select("_AjaxLoading", "ComboBox"))
            .ClientEvents(events => events.OnDataBinding("onDataBinding")
                                          .OnDataBound("onDataBound"))
    %>

    <%= Html.EasyUI().ComboBox()
            .Name("FakeAjaxComboBox")
            .ClientEvents(events => events.OnDataBinding("onDataBinding"))
    %>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

        QUnit.testStart = function() {
            comboBox = getComboBox();
            isOpenRaised = false;
            isCloseRaised = false;
            returnedValue = undefined; 
            isChangeRaised = false;
            isDataBinding = false;
            isDataBound = false;
        }
                
        test('on input focus should raise onOpen event', function () {
            comboBox.close();

            comboBox.$text.focus();

            ok(isOpenRaised);
        });

        test('on input focus should not raise onOpen event if openOnFocus is set to false', function () {

            comboBox.openOnFocus = false;
            comboBox.close();

            comboBox.$text.focus();

            ok(!isOpenRaised);

            comboBox.openOnFocus = true;
        });

        test('clicking toggle button should raise onClose event', function() {
            comboBox.open();

            $('.t-dropdown-wrap > .t-select', comboBox.$wrapper[0]).trigger('click');

            ok(isCloseRaised);
        });

        test('clicking document should raise onClose event', function() {
            comboBox.open();

            $(document.body).mousedown();

            ok(isCloseRaised);
        });

        test('clicking alt and down arrow should raise onOpen', function() {
            comboBox.close();

            comboBox.$text.trigger({ type: "keydown", keyCode: 40, altKey: true });

            ok(isOpenRaised);
        });

        test('clicking escape should raise onClose if opened', function() {
            comboBox.open();

            comboBox.$text.trigger({ type: "keydown", keyCode: 27 });

            ok(isCloseRaised);
        });

        test('clicking escape should not raise onClose if closed', function() {
            comboBox.close();

            comboBox.$text.trigger({ type: "keydown", keyCode: 27 });

            ok(!isCloseRaised);
        });

        test('clicking enter should raise onClose if list is opened', function() {

            comboBox.$text
                .focus()
                .trigger({ type: "keydown", keyCode: 40 })
                .trigger({ type: "keydown", keyCode: 13 });

            ok(isCloseRaised);
        });

        test('clicking tab should raise onClose if list is opened', function() {
            comboBox.open();

            comboBox.$text.trigger({ type: "keydown", keyCode: 9 });

            ok(isCloseRaised);
        });

        test('clicking tab should set value if text has exact match with date items', function () {

            comboBox._textChanged = true;
            comboBox.text('Item2');

            comboBox.$text.trigger({ type: "keydown", keyCode: 9 });

            equal(comboBox.text(), 'Item2');
            equal(comboBox.value(), '2');
        });

        test('clicking tab should stop filtering', function () {
            var isCalled = false;
            var oldClear = window.clearTimeout;

            try {
                window.clearTimeout = function () { isCalled = true; };
                comboBox._textChanged = true;
                comboBox.text('Item2');

                comboBox.$text.trigger({ type: "keydown", keyCode: 8 });
                isCalled = false
                comboBox.$text.trigger({ type: "keydown", keyCode: 9 });

                ok(isCalled);

            } finally {
                window.clearTimeout = oldClear;
            }
        });

        test('clicking item from dropDownList should raise onClose when it is opened', function() {

            comboBox.$text.focus();

            comboBox.dropDown.$items.first().click();

            ok(isCloseRaised);
        });

        test('enter should raise onChange event if other item is selected and dropDown is shown', function() {
            
            comboBox.open();

            comboBox.$text
                .focus()
                .trigger({ type: "keydown", keyCode: 40 })
                .trigger({ type: "keydown", keyCode: 13 });

            ok(isChangeRaised);
        });

        test('escape should raise onChange event if other item is selected and dropDown is shown', function() {
            comboBox.open();

            comboBox.$text
                .focus()
                .trigger({ type: "keydown", keyCode: 40 })
                .trigger({ type: "keydown", keyCode: 27 });

            ok(isChangeRaised);
        });

        test('down arrow should raise onChange event if other item is selected and dropDown is closed', function() {

            comboBox.$text
                .focus()
                .trigger({ type: "keydown", keyCode: 13 })
                .trigger({ type: "keydown", keyCode: 40 });

            ok(isChangeRaised);
        });

        test('down arrow should not raise onChange event if other item is selected and dropDown is shown', function() {
            comboBox.open();
            
            comboBox.$text
                .focus()
                .trigger({ type: "keydown", keyCode: 40 });

            ok(!isChangeRaised);
        });

        test('clicking on new item should raise onChange event', function() {
            comboBox.$text.focus();

            var item = comboBox.dropDown.$items.find('.t-state-selected').first().next();

            if (!item.length)
                item = comboBox.dropDown.$items.first();
            else
                item = item[0];

            $(item).click();

            ok(isChangeRaised);
        });

        test('cleared input should not raise change event if opened and close after clearing', function() {
            comboBox.$text
                .focus()
                .trigger({ type: "keydown", keyCode: 13 })
                .trigger({ type: "keydown", keyCode: 40 })
                .val('');

            comboBox.selectedIndex = -1;
            comboBox.previousSelectedIndex = -1;

            comboBox.$text.blur();

            isChangeRaised = false;
            
            comboBox.$text.focus();
            $(document.body).mousedown();

            ok(!isChangeRaised);
        });

        test('document clicking should raise value changed if different item is selected', function() {

            comboBox.$text
                .focus()
                .trigger({ type: "keydown", keyCode: 40 });

            isChangeRaised = false;

            $(document.body).mousedown();

            ok(isChangeRaised);
        });

        test('document click should set value if text has exact match with date items', function () {

            comboBox._textChanged = true;
            comboBox.text('Item2');

            $(document.body).mousedown();

            equal(comboBox.text(), 'Item2');
            equal(comboBox.value(), '2');
        });

        test('trigger change should set value if text is empty', function () {
            var combobox = $('#ComboBoxWithEmptyValue').data('tComboBox');
            comboBox.text('');
            comboBox.trigger.change();

            equal(comboBox.text(), '');
        });

        test('trigger change method should set hidden value to text if item value is null', function() {
            var ddl = $('#ComboWithNoValue').data('tComboBox');
            ddl.select(2);
            ddl.trigger.change();

            var item = ddl.data[2];

            equal(item.Value, null);
            equal(ddl.value(), item.Text);
        });

        test('Fill method on ajax should call change event handler', function() {
            var isCalled = false;
            var combo = $('#FakeAjaxComboBox').data('tComboBox');
            var old = combo.trigger.change;

            combo.ajaxRequest = function (callback) { callback(); }
            combo.trigger.change = function () { isCalled = true; }

            combo.fill();

            ok(isCalled);
        });

</script>

</asp:Content>