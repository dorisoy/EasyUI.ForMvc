<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2>Keyboard support</h2>
    
    <script type="text/javascript">

        var $t;
        var combobox;
        var filtering;

        function getComboBox(id) {
            return $(id || '#ComboBox').data('tComboBox');
        }

    </script>
           
    <%= Html.EasyUI().ComboBox()
        .Name("ComboBox")
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
        .Effects(fx => fx.Toggle())
        .Filterable(filtering => filtering.FilterMode(AutoCompleteFilterMode.StartsWith))
    %>
</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



        QUnit.testStart = function() {
            $t = $.easyui;
            combobox = getComboBox();
            filtering = combobox.filtering;
            combobox.scrollTo = function () { };
        }

        test('filter method should pass first item text to the autoFill method', function() {

            var oldAutoFill = filtering.autoFill;
            var text;

            try {
                combobox.$text.val('boy');
                filtering.autoFill = function (component, itemText) { text = itemText; };
                filtering.filter(combobox);

                equal(text, "Boysenberry");
            } finally {
                filtering.autoFill = oldAutoFill;
                combobox.$text.val('');
                filtering.filter(combobox);
            }
        });

        test('filter method should pass Tofu text to the autoFill method if filter mode is None', function() {

            var oldAutoFill = filtering.autoFill;
            var text;
            
            try {
                combobox.filter = 0;
                filtering.autoFill = function (component, itemText) { text = itemText; };
                combobox.$text.val('tofu');

                filtering.filter(combobox);

                equal(text, "Tofu");
            } finally {
                filtering.autoFill = oldAutoFill;
                combobox.filter = 1;
            }
        });

        test('filter method should return if text length is less than minChars', function() {
            var oldFilter = combobox.filters[combobox.filter];
            var isCalled = false;
            
            try {
                combobox.minChars = 10;
                combobox.$text.val('12345');
                combobox.filters[combobox.filter] = function () { isCalled = true; };
                
                filtering.filter(combobox);

                ok(!isCalled);
            } finally {
                combobox.minChars = 0;
                combobox.$text.val('');
                combobox.filters[combobox.filter] = oldFilter;
            }
        });

        test('filter should call startsWith filter method', function() {
            var oldFilter = combobox.filters[combobox.filter];
            var isCalled = false;

            combobox.dropDown.$items = null;
            combobox.fill();
            
            try {
                combobox.filters[combobox.filter] = function () { isCalled = true; };
                combobox.selectedIndex = -1;

                filtering.filter(combobox);

                ok(isCalled);
            } finally {
                combobox.filters[combobox.filter] = oldFilter;
            }
        });

        test('filter should not raise error if no data', function () {
            var oldFilter = combobox.filters[combobox.filter];
            combobox.dropDown.$items = null;

            try {
                combobox.filters[combobox.filter] = function () { isCalled = true; };
                combobox.selectedIndex = -1;

                filtering.filter(combobox);
            } finally {
                combobox.filters[combobox.filter] = oldFilter;
            }
        });

        test('filter method should call ajaxRequest method if isAjax and no cache or no items after filtering', function() {
            var oldAjaxRequest = combobox.ajaxRequest;
            var oldAjax = combobox.loader.isAjax;
            var isCalled = false;
            
            combobox.filteredDataIndexes = [];
            combobox.cache = false;

            try {
                combobox.loader.ajaxRequest = function () { isCalled = true; };
                combobox.loader.isAjax = function () { return true; };
            
                filtering.filter(combobox);

                ok(isCalled);
            } finally {
                combobox.loader.isAjax = oldAjax;
                combobox.loader.ajaxRequest = oldAjaxRequest;
            }
        });

        test('filter method should call startsWith method if isAjax and cache is enabled', function() {

            var oldFilter = combobox.filters[combobox.filter];
            var oldAjax = combobox.loader.isAjax;
            var oldData = combobox.data;
            var oldCache = combobox.cache;
            var oldFilteredDataIndexes = combobox.filteredDataIndexes;
            var isCalled = false;
            
            try {
                combobox.data = [{ "Text": "Chai", "Value": "1", "Selected": true}];
                combobox.filteredDataIndexes = [];
                combobox.cache = true;

                combobox.filters[combobox.filter] = function () { isCalled = true; };
                combobox.loader.isAjax = function () { return true; }; //predefining isAjax method to return 'true';
            
                filtering.filter(combobox);

                ok(isCalled);
            } catch(e) {
            } finally {
                combobox.data = oldData;
                combobox.cache = oldCache;
                combobox.loader.isAjax = oldAjax;
                combobox.filteredDataIndexes = oldFilteredDataIndexes;
                combobox.filters[combobox.filter] = oldFilter;
            }
        });

        test('filter method should rebind and close dropDown if no data after ajax request', function() {

            var oldAjax = combobox.loader.isAjax;
            var oldData = combobox.data;
            var ajaxRequest = combobox.loader.ajaxRequest;

            combobox.open();

            combobox.cache = false;

            try {
                combobox.loader.isAjax = function () { return true; };
                combobox.loader.ajaxRequest = function (callback) { callback([]); };
            
                filtering.filter(combobox);

                equal(combobox.dropDown.$items.length, 0);
                ok(combobox.dropDown.$element.attr('style').indexOf('none') != -1);
                
            } finally {
                combobox.data = oldData;
                combobox.loader.isAjax = oldAjax;
                combobox.loader.ajaxRequest = ajaxRequest;
            }
        });

        test('filter method should not encode data everytime on databinding if DataBinding is wired and isAjax', function () {
            var isCalled = false;
            var oldData = combobox.data;
            var encode = $t.encode;
            var ajaxRequest = combobox.loader.ajaxRequest;

            var filter = combobox.filters[combobox.filter];

            combobox.open();
            combobox.cache = false;
            combobox.filters[combobox.filter] = function () { }
            combobox.onDataBinding = true;

            combobox.$items = [];

            try {
                combobox.onDataBinding = true;
                $t.encode = function () { isCalled = true; }
                combobox.loader.ajaxRequest = function (callback) { callback(oldData); };
                filtering.filter(combobox);

                ok(!isCalled, "encode was called");
            } finally {
                combobox.data = oldData;
                $t.encode = encode;
                combobox.onDataBinding = undefined;
                combobox.loader.ajaxRequest = ajaxRequest;
                combobox.filters[combobox.filter] = filter;
            }
        });

        test('filter method should rebind and close items list and open after filtering', function() {
            var oldAjax = combobox.loader.isAjax;
            var oldData = combobox.data;
            var ajaxRequest = combobox.loader.ajaxRequest;

            combobox.close();

            combobox.cache = false;

            try {
                combobox.loader.isAjax = function () { return true; };
                combobox.loader.ajaxRequest = function (callback) { callback([{ "Text": "Chai", "Value": "1" }, { "Text": "Chang", "Value": "2"}]); };

                combobox.dropDown.$items = [];
            
                filtering.filter(combobox);

                equal(combobox.dropDown.$items.length, 2);
                ok(combobox.dropDown.isOpened());

            } finally {
                combobox.data = oldData;
                combobox.loader.isAjax = oldAjax;
                combobox.loader.ajaxRequest = ajaxRequest;
            }
        });

        test('selecting items after filtering selects correct item', function() {
            var oldAjax = combobox.loader.isAjax;
            var oldData = combobox.data;
            var ajaxRequest = combobox.loader.ajaxRequest;

            combobox.close();

            combobox.cache = false;

            try {
                combobox.loader.isAjax = function () { return true; };
                combobox.loader.ajaxRequest = function (callback) { callback([
                    { "Text": "Chai", "Value": "1" },
                    { "Text": "Tofu", "Value": "3" },
                    { "Text": "Chang", "Value": "2"}]); };

                combobox.dropDown.$items = [];
                combobox.$text.val('C');
            
                filtering.filter(combobox);

                combobox.dropDown.$element.find('.t-item').eq(1).click();

                equal(combobox.$text.val(), 'Chang');

            } finally {
                combobox.data = oldData;
                combobox.$text.val('');
                combobox.loader.isAjax = oldAjax;
                combobox.loader.ajaxRequest = ajaxRequest;
            }
        });

        test('filter method should encode newly retrieved data if encoded true', function () {
            var oldData = combobox.data;
            var oldAjax = combobox.loader.isAjax;            
            var decodedText = '<>&Visit W3Schools!';
            var ajaxRequest = combobox.loader.ajaxRequest;

            var dataSource = [
                { Text: decodedText, Value: decodedText },
                { Text: "Product 2", Value: "2" }
            ];

            combobox.close();
            combobox.cache = false;

            try {
                combobox.loader.isAjax = function () { return true; };
                combobox.loader.ajaxRequest = function (callback) { callback(dataSource); };

                filtering.filter(combobox);

                equal('&lt;&gt;&amp;Visit W3Schools!', combobox.dropDown.$items.eq(0).html());
                equal(decodedText, combobox.data[0].Value);

            } finally {
                combobox.data = oldData;
                combobox.loader.isAjax = oldAjax;
                combobox.loader.ajaxRequest = ajaxRequest;
            }
        });

</script>

</asp:Content>