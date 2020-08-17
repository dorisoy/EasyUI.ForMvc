<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <%= Html.EasyUI().AutoComplete()
            .Name("AutoComplete")
            .BindTo(new[] { "Item1", "Item2", "Item3", "Item4", "Item5", "Item6", "Item7", "Item8" })
            .Effects(effects => effects.Toggle())
                    .ClientEvents(events => events.OnOpen("onOpen")
                                                  .OnClose("onClose")
                                                  .OnChange("onChange"))
    %>

     <%= Html.EasyUI().AutoComplete()
            .Name("AjaxAutoComplete")
            .Effects(effects => effects.Toggle())
            .DataBinding(binding => binding.Ajax().Select("_AjaxLoading", "ComboBox"))
            .ClientEvents(events => events.OnDataBinding("onDataBinding")
                                          .OnDataBound("onDataBound"))
    %>

    <%= Html.EasyUI().AutoComplete()
            .Name("FakeAjaxAutoComplete")
            .ClientEvents(events => events.OnDataBinding("onDataBinding"))
    %>

    <script type="text/javascript">
        var isChanged;
        var returnedValue;
        var isOpenRaised;
        var isCloseRaised;
        var isDataBinding;
        var isDataBound;
        var autoComplete;

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
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

        function getAutoComplete(id) {
            return $(id || '#AutoComplete').data('tAutoComplete');
        }

        module("AutoComplete / ClientEvents", {
            setup: function() {
                autoComplete = getAutoComplete();
                isOpenRaised = false;
                isCloseRaised = false;
                returnedValue = undefined; 
                isChangeRaised = false;
                isDataBinding = false;
                isDataBound = false;
            }
        });

        test('clicking document should raise onClose event', function() {
            autoComplete.open();

            $(document.body).mousedown();

            ok(isCloseRaised);
        });
        
        test('clicking escape should raise onClose if opened', function() {
            autoComplete.open();

            autoComplete.$text.trigger({ type: "keydown", keyCode: 27 });

            ok(isCloseRaised);
        });

        test('clicking escape should not raise onClose if closed', function() {
            autoComplete.close();

            autoComplete.$text.trigger({ type: "keydown", keyCode: 27 });

            ok(!isCloseRaised);
        });

        test('clicking enter should raise onClose if list is opened', function() {

            autoComplete.open();

            autoComplete.$text
                .focus()
                .trigger({ type: "keydown", keyCode: 40 })
                .trigger({ type: "keydown", keyCode: 13 });

            ok(isCloseRaised);
        });

        test('clicking tab should raise onClose if list is opened', function() {
            autoComplete.open();

            autoComplete.$text.trigger({ type: "keydown", keyCode: 9 });

            ok(isCloseRaised);
        });

        test('clicking item from dropDownList should raise onClose when it is opened', function() {

            autoComplete.$text.focus();

            autoComplete.open();

            autoComplete.dropDown.$items.first().click();

            ok(isCloseRaised);
        });

        test('enter should raise onChange event if other item is selected and dropDown is shown', function () {
            autoComplete.open();

            autoComplete.$text
                .focus()
                .trigger({ type: "keydown", keyCode: 40 })
                .trigger({ type: "keydown", keyCode: 13 });

            ok(isChangeRaised);
        });

        test('clicking on new item should raise onChange event', function() {
            autoComplete.$text.focus();

            autoComplete.open();

            var item = autoComplete.dropDown.$items.find('.t-state-selected').first().next();

            if (!item.length)
                item = autoComplete.dropDown.$items.first();
            else
                item = item[0];

            $(item).click();

            ok(isChangeRaised);
        });

        test('cleared input should not raise change event if opened and close after clearing', function() {

            autoComplete.open();

            autoComplete.$text
                .focus()
                .trigger({ type: "keydown", keyCode: 13 })
                .trigger({ type: "keydown", keyCode: 40 })
                .val('');

            $(document.body).mousedown();

            isChangeRaised = false;

            autoComplete.$text.focus();
            $(document.body).mousedown();

            ok(!isChangeRaised);
        });

        test('trigger change should set value if text has exact match with date items', function() {
            
            autoComplete.text('Item2');
            autoComplete.trigger.change();

            equal(autoComplete.text(), 'Item2');
        });

        test('Fill method on ajax should call change event handler', function() {
            var isCalled = false;
            var autoComplete = $('#FakeAjaxAutoComplete').data('tAutoComplete');
            var old = autoComplete.trigger.change;

            autoComplete.ajaxRequest = function (callback) { callback(); }
            autoComplete.trigger.change = function () { isCalled = true; }
            autoComplete.$text.val('c');

            autoComplete.fill();

            ok(isCalled);
        });

        test('document click should raise change event if dropdown list is never opened', function() {

            isChangeRaised = false;
            autoComplete.$text.focus().val('22');

            $(document.documentElement).mousedown();

            ok(isChangeRaised);
            equal(returnedValue, '22');
        });

        test('clicking enter should raise change event if custom text is typed', function() {
            autoComplete.open();
            autoComplete.close();
            
            isChangeRaised = false;
            autoComplete.$text
                        .focus()
                        .val('44')
                        .trigger({ type: "keydown", keyCode: 13 });

            ok(isChangeRaised);
            //equal(returnedValue, '44');
        });

</script>

</asp:Content>