<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        DropDown Rendering</h2>
    <script type="text/javascript">
        var isChanged;
        var isRaised;
        var isDataBinding;
        var isDataBound;

        var itemText;

        function getDropDownList() {
            return $('#DropDownList').data('tDropDownList');
        }

        function getAjaxDropDownList() {
            return $('#AjaxDropDownList').data('tDropDownList');
        }

        //handlers
        function onLoad(sender, args) {
            isRaised = true;
        }

        function onChange(sender) {
            isChangeRaised = true;
        }

        function onClose(sender, args) {
            isRaised = true;
        }

        function onOpen(sender, args) {
            isRaised = true;
        }

        function onDataBinding(sender, args) {
            isDataBinding = true;
        }

        function onDataBound(sender, args) {
            isDataBound = true;
        }

        function DataBindDDL() {
            getAjaxDropDownList().dataBind([{ Text: "1", Value: 1, Selected: false }, { Text: "2", Value: 2, Selected: false }, { Text: "3", Value: 3, Selected: false}]);
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
            })
            .Effects(effects => effects.Toggle())
            .ClientEvents(events => events.OnLoad("onLoad")
                                          .OnOpen("onOpen")
                                          .OnClose("onClose")
                                          .OnChange("onChange"))
    %>

    <%= Html.EasyUI().DropDownList()
            .Name("DDLWithNoValue")
            .Items(items =>
            {
                items.Add().Text("Item1");
                items.Add().Text("Item2").Value("2");
                items.Add().Text("Item3");
                items.Add().Text("Item4").Value("4");
                items.Add().Text("Item5");
            })
            .Effects(effects => effects.Toggle())
    %>


     <%= Html.EasyUI().DropDownList()
            .Name("AjaxDropDownList")
            .Effects(effects => effects.Toggle())
            .DataBinding( binding => binding.Ajax().Select("_AjaxDropDownList","DropDownList"))
            .ClientEvents(events => events.OnDataBinding("onDataBinding")
                                          .OnDataBound("onDataBound"))
    %>

    <% Html.EasyUI().ScriptRegistrar()
           .Scripts(scripts => scripts
           .Add("easyui.common.js")
           .Add("easyui.list.js")); 
    %>

    <br />
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

    test('clicking toggle button should raise onOpen event', function () {
        var ddl = getDropDownList();
        ddl.close();

        var wrapper = ddl.$wrapper;

        isRaised = false;

        wrapper.trigger('click');

        ok(isRaised);
    });

        test('clicking toggle button should raise onClose event', function() {
            var ddl = getDropDownList();
            ddl.open();

            var wrapper = ddl.$wrapper;

            isRaised = false;

            wrapper.trigger('click');

            ok(isRaised);
        });

        test('clicking alt and down arrow should raise onOpen', function() {
            var ddl = getDropDownList();
            ddl.close();

            var wrapper = ddl.$wrapper;

            isRaised = false;

            wrapper.trigger({ type: "keydown", keyCode: 40, altKey: true });

            ok(isRaised);
        });

        test('clicking escape should raise onClose if opened', function() {
            var ddl = getDropDownList();
            ddl.open();

            var wrapper = ddl.$wrapper;

            isRaised = false;

            wrapper.trigger({ type: "keydown", keyCode: 27 });

            ok(isRaised);
        });

        test('clicking escape should not raise onClose if closed', function () {
            var ddl = getDropDownList();
            ddl.close();

            var wrapper = ddl.$wrapper;

            isRaised = false;

            wrapper.trigger({ type: "keydown", keyCode: 27 });

            ok(!isRaised);
        });

        test('clicking enter should raise onClose if list is opened', function() {
            var ddl = getDropDownList();
            ddl.open();

            var wrapper = ddl.$wrapper;

            isRaised = false;

            wrapper.trigger({ type: "keydown", keyCode: 13 });

            ok(isRaised);
        });

        test('clicking tab should raise onClose if list is opened', function() {
            var ddl = getDropDownList();
            ddl.open();

            var wrapper = ddl.$wrapper;

            isRaised = false;

            wrapper.trigger({ type: "keydown", keyCode: 9 });

            ok(isRaised);
        });

        test('clicking item from dropDownList should raise onClose when it is opened', function() {
            getDropDownList().open();

            isRaised = false;
            
            var $selectedItems = $('.t-state-selected', getDropDownList().dropDown.$items);
            $selectedItems = $selectedItems.length > 0 ? $selectedItems : getDropDownList().dropDown.$items.first();
            $selectedItems.next().click();

            ok(isRaised);
        });

        test('enter should raise onChange event if other item is selected and dropDown is shown', function() {
            getDropDownList().open();

            isChangeRaised = false;

            var $ddl = $('#DropDownList').closest('.t-dropdown');
            $ddl.focus();
            $ddl.trigger({ type: "keydown", keyCode: 40 });
            $ddl.trigger({ type: "keydown", keyCode: 13 });

            ok(isChangeRaised);
        });

        test('escape should raise onChange event if other item is selected and dropDown is shown', function() {
            getDropDownList().open();

            isChangeRaised = false;

            var $ddl = $('#DropDownList').closest('.t-dropdown');
            $ddl.focus();
            $ddl.trigger({ type: "keydown", keyCode: 40 });
            $ddl.trigger({ type: "keydown", keyCode: 27 });

            ok(isChangeRaised);
        });

        test('down arrow should raise onChange event if other item is selected and dropDown is closed', function() {
            getDropDownList().close();

            isChangeRaised = false;

            var $ddl = $('#DropDownList').closest('.t-dropdown');
            $ddl.focus();
            $ddl.trigger({ type: "keydown", keyCode: 40 });

            ok(isChangeRaised);
        });

        test('down arrow should not raise onChange event if other item is selected and dropDown is shown', function() {
            getDropDownList().open();

            isChangeRaised = false;

            var $ddl = $('#DropDownList').closest('.t-dropdown');
            $ddl.focus();
            $ddl.trigger({ type: "keydown", keyCode: 40 });

            ok(!isChangeRaised);
        });

        test('clicking on new item should raise onChange event', function() {
            var ddl = getDropDownList();
            ddl.open();

            isChangeRaised = false;

            $(ddl.dropDown.$element.find('li')[2]).click();

            ok(isChangeRaised);
        });

        test('focus open close blur will not raise change event', function() {
            var ddl = getDropDownList();

            var $ddl = $('#DropDownList').closest('.t-dropdown');
            $ddl.focus();

            ddl.open();
            ddl.close();

            $ddl.blur();

            isChangeRaised = false;

            ok(!isChangeRaised);
        });

        test('trigger change method should set hidden value to text if item value is null', function() {
            var ddl = $('#DDLWithNoValue').data('tDropDownList');
            ddl.select(2);
            ddl.trigger.change();

            var item = ddl.data[2];

            equal(item.Value, null);
            equal(ddl.value(), item.Text);
        });

</script>

</asp:Content>