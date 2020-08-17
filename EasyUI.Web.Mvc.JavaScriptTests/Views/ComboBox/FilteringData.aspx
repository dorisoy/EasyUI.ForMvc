<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    
    <% Html.EasyUI().ScriptRegistrar()
           .Scripts(scripts => scripts
               .Add("easyui.common.js")
               .Add("easyui.list.js")
               .Add("easyui.combobox.js")); %>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">
        var comboBoxObject;

        module("ComboBox / FilteringData", {
            setup: function() {
                comboBoxObject =
                    $($('<div id="ComboBox" class="t-combobox t-header"><div class="t-dropdown-wrap"><input type="text" value="" name="ComboBox" id="ComboBox-input" class="t-input"><span class="t-select t-header"><span class="t-icon t-arrow-down">select</span></span><input type="hidden" id="ComboBox-value" name="ComboBox" value="70"></div></div>'))
                        .appendTo(document.body)
                        .tComboBox()
                        .data('tComboBox');

                comboBoxObject.data = [{ "Text": "Chai", "Value": "1", "Selected": true },
                                       { "Text": "Chang", "Value": "2", "Selected": false },
                                       { "Text": "Aniseed Syrup", "Value": "3", "Selected": false },
                                       { "Text": "Chef Anton\u0027s Cajun Seasoning", "Value": "4", "Selected": false },
                                       { "Text": "Chef Anton\u0027s Gumbo Mix", "Value": "5", "Selected": false },
                                       { "Text": "Grandma\u0027s Boysenberry Spread", "Value": "6", "Selected": false },
                                       { "Text": "Uncle Bob\u0027s Organic Dried Pears", "Value": "7", "Selected": false },
                                       { "Text": "Northwoods Cranberry Sauce", "Value": "8", "Selected": false },
                                       { "Text": "Mishi Kobe Niku", "Value": "9", "Selected": false },
                                       { "Text": "Ikura", "Value": "10", "Selected": false },
                                       { "Text": "Queso Cabrales", "Value": "11", "Selected": false },
                                       { "Text": "Queso Manchego La Pastora", "Value": "12", "Selected": false },
                                       { "Text": "Konbu", "Value": "13", "Selected": false },
                                       { "Text": "Tofu", "Value": "14", "Selected": false },
                                       { "Text": "Genen Shouyu", "Value": "15", "Selected": false },
                                       { "Text": "Pavlova", "Value": "16", "Selected": false },
                                       { "Text": "Alice Mutton", "Value": "17", "Selected": false },
                                       { "Text": "Carnarvon Tigers", "Value": "18", "Selected": false },
                                       { "Text": "Teatime Chocolate Biscuits", "Value": "19", "Selected": false },
                                       { "Text": "Sir Rodney\u0027s Marmalade", "Value": "20", "Selected": false },
                                       { "Text": "Sir Rodney\u0027s Scones", "Value": "21", "Selected": false },
                                       { "Text": "Genen Tofu", "Value": "22", "Selected": false },
                                       { "Text": "Gustaf\u0027s Kn�ckebr�d", "Value": "23", "Selected": false }, 
                                       { "Text": "Tunnbr�d", "Value": "24", "Selected": false}];
            },
            teardown: function() {
                $(comboBoxObject.element).remove();
                comboBoxObject = null;
            }
        });

        test('filter type none should select Tofu item', function() {
            
            var firstMatch = comboBoxObject.filters[0]; //none type filter.

            comboBoxObject.fill();
            
            firstMatch(comboBoxObject, comboBoxObject.data, 'To');

            var $selectedItem = comboBoxObject.dropDown.$items.filter('.t-state-selected');

            equal($selectedItem.text(), 'Tofu');
        });

        test('filter type none should deselect last selected if no item is found', function() {
            var firstMatch = comboBoxObject.filters[0]; //none type filter.
            
            comboBoxObject.dropDown.$items = [];

            firstMatch(comboBoxObject, comboBoxObject.data, 'Not existing item');

            equal(comboBoxObject.selectedIndex, -1);
        });

        test('filter type none should do nothing if no data', function() {
            var firstMatch = comboBoxObject.filters[0]; //none type filter.

            comboBoxObject.selectedIndex = -1;

            firstMatch(comboBoxObject, null, 'To'); //if data, select Tofu item

            equal(comboBoxObject.selectedIndex, -1);
        });

        test('filter type none should select first if highlightFirst is true', function() {
            var firstMatch = comboBoxObject.filters[0]; //none type filter.

            comboBoxObject.highlightFirst = true;
            comboBoxObject.dropDown.$items = [];

            firstMatch(comboBoxObject, comboBoxObject.data, 'Toffff'); //should not find such item

            ok(comboBoxObject.dropDown.$items.first().hasClass('t-state-selected'));
        });

        test('filter type none should create $items if they were not before that', function() {

            var firstMatch = comboBoxObject.filters[0]; //none type filter.

            comboBoxObject.dataBind(); //create empty ul

            var data = [{ "Text": "Chai", "Value": "1", "Selected": true },
                        { "Text": "Chang", "Value": "2", "Selected": false },
                        { "Text": "Aniseed Syrup", "Value": "3", "Selected": false }];
                        
            firstMatch(comboBoxObject, data, 'To');

            equal(comboBoxObject.dropDown.$items.length, 3);
        });

        test('filter type none should create $items again if component uses ajax binding', function() {
            
            var firstMatch = comboBoxObject.filters[0]; //none type filter.

            comboBoxObject.dropDown.$items = [];
            comboBoxObject.isAjax = function () { return true; };

            var data = [{ "Text": "Chai", "Value": "1", "Selected": true },
                        { "Text": "Chang", "Value": "2", "Selected": false },
                        { "Text": "Aniseed Syrup", "Value": "3", "Selected": false}];
                        
            firstMatch(comboBoxObject, data, 'To');

            equal(comboBoxObject.dropDown.$items.length, 3);
        });

        test('startsWith filter should render item Tofu with formated text', function() {

            var startsWith = comboBoxObject.filters[1]; //startsWith filter.

            comboBoxObject.open();
            
            startsWith(comboBoxObject, comboBoxObject.data, 'To');

            equal(comboBoxObject.dropDown.$items.first().html().toLowerCase(), '<strong>To</strong>fu'.toLowerCase());
        });

        test('filter startsWith type should not render items if no match', function() {
            var startsWith = comboBoxObject.filters[1]; //startsWith filter.

            comboBoxObject.open();

            startsWith(comboBoxObject, comboBoxObject.data, 'Not correct item');

            ok(comboBoxObject.dropDown.$items.length == 0);
        });

        test('filter startsWith type should render all items if text is empty', function() {
            var startsWith = comboBoxObject.filters[1]; //startsWith filter.

            comboBoxObject.open();

            startsWith(comboBoxObject, comboBoxObject.data, '');

            equal(comboBoxObject.dropDown.$items.length, comboBoxObject.data.length);
        });

        test('filter startsWith should format only first match of the filtered items', function() {
            var startsWith = comboBoxObject.filters[1]; //startsWith filter.

            comboBoxObject.open();

            startsWith(comboBoxObject, comboBoxObject.data, 'T');

            //Teatime Chocolate Biscuits item
            var $item = $(comboBoxObject.dropDown.$items[1]);

            equal($item.text(), 'Teatime Chocolate Biscuits');
            equal($item.html().toLowerCase(), '<strong>T</strong>eatime Chocolate Biscuits'.toLowerCase());
        });

        test('filter startsWith should render only one item', function() {
            var startsWith = comboBoxObject.filters[1]; //startsWith filter.

            comboBoxObject.open();

            startsWith(comboBoxObject, comboBoxObject.data, 'Chai');

            ok(comboBoxObject.dropDown.$items.length == 1);
        });

        test('filter startsWith should remove selected state class', function() {
            var startsWith = comboBoxObject.filters[1]; //startsWith filter.

            comboBoxObject.highlightFirst = false;

            comboBoxObject.open();
            comboBoxObject.select(comboBoxObject.dropDown.$items[0]);

            startsWith(comboBoxObject, comboBoxObject.data, 'Chai');

            ok(!comboBoxObject.dropDown.$items.hasClass('t-state-selected'));
        });

        test('filter startsWith should do nothing if no data', function() {
            var firstMatch = comboBoxObject.filters[1];

            comboBoxObject.fill();

            comboBoxObject.select(comboBoxObject.dropDown.$items[0]);

            firstMatch(comboBoxObject, null, 'To'); //should Tofu item

            ok($(comboBoxObject.dropDown.$items[0]).hasClass('t-state-selected'));
        });

        test('filter startsWith should select first item if there are filtered items', function() {
            var firstMatch = comboBoxObject.filters[1];

            comboBoxObject.fill();

            comboBoxObject.highlightFirst = true;

            firstMatch(comboBoxObject, comboBoxObject.data, 'To'); //should Tofu item

            ok($(comboBoxObject.dropDown.$items[0]).hasClass('t-state-selected'));
        });

        test('filter StartsWith should not raise error if item.Text is empty text', function() {

            var firstMatch = comboBoxObject.filters[1]; //none type filter.

            comboBoxObject.dataBind(); //create empty ul

            var data = [{ "Text": "", "Value": "1" },
                        { "Text": "Chang", "Value": "2" },
                        { "Text": "Aniseed Syrup", "Value": "3" }];
                        
            firstMatch(comboBoxObject, data, 'To');

            ok(true);
        });

        test('filter Contains should not render items if no match', function() {
            var contains = comboBoxObject.filters[2]; 

            comboBoxObject.open();

            contains(comboBoxObject, comboBoxObject.data, 'Not correct item');

            ok(comboBoxObject.dropDown.$items.length == 0);
        });

        test('filter Contains should render all items if text is empty', function() {
            var contains = comboBoxObject.filters[2]; 

            comboBoxObject.open();

            contains(comboBoxObject, comboBoxObject.data, '');

            equal(comboBoxObject.dropDown.$items.length, comboBoxObject.data.length);
        });

        test('filter Contains should apply format to mathes in the item text', function() {
            var contains = comboBoxObject.filters[2]; 

            comboBoxObject.open();

            contains(comboBoxObject, comboBoxObject.data, 'y');

            //Teatime Chocolate Biscuits item
            var $item = $(comboBoxObject.dropDown.$items[1]);

            equal($item.text(), "Grandma's Boysenberry Spread");
            equal($item.html().toLowerCase(), "Grandma's Bo<strong>y</strong>senberr<strong>y</strong> Spread".toLowerCase());
        });

        test('filter Contains should render only one item', function() {
            var contains = comboBoxObject.filters[2]; 

            comboBoxObject.open();

            contains(comboBoxObject, comboBoxObject.data, 'Chai');

            ok(comboBoxObject.dropDown.$items.length == 1);
        });

        test('filter contains should remove selected state class', function() {
            var contains = comboBoxObject.filters[2];

            comboBoxObject.highlightFirst = false;

            comboBoxObject.open();
            comboBoxObject.select(comboBoxObject.dropDown.$items[0]);

            contains(comboBoxObject, comboBoxObject.data, 'Chai');

            ok(!comboBoxObject.dropDown.$items.hasClass('t-state-selected'));
        });

        test('filter contains should do nothing if no data', function() {
            var contains = comboBoxObject.filters[2];

            comboBoxObject.fill();

            comboBoxObject.select(comboBoxObject.dropDown.$items[0]);

            contains(comboBoxObject, null, '');

            ok($(comboBoxObject.dropDown.$items[0]).hasClass('t-state-selected'));
        });

        test('filter contains should select first item if there are filtered items', function() {
            
            var firstMatch = comboBoxObject.filters[2];

            comboBoxObject.fill();

            comboBoxObject.highlightFirst = true;

            firstMatch(comboBoxObject, comboBoxObject.data, 'To'); //should Tofu item

            ok($(comboBoxObject.dropDown.$items[0]).hasClass('t-state-selected'));
        });

        test('filter method should not add <strong> tag if input is empty', function () {

            var firstMatch = comboBoxObject.filters[1];

            comboBoxObject.fill();

            comboBoxObject.highlightFirst = true;

            firstMatch(comboBoxObject, comboBoxObject.data, ''); //should Tofu item

            ok(comboBoxObject.dropDown.$items.eq(0).html().indexOf('<strong>') == -1);
        });

</script>

</asp:Content>