<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" Culture="de-DE"%>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <% Html.EasyUI().ScriptRegistrar().Globalization(true); %>

    <%= Html.EasyUI().Grid(Model)
            .Name("Grid1")
            .DataKeys(keys => keys.Add(c => c.Name))
            .ToolBar(toolbar => toolbar.Insert())
            .Columns(columns => 
                {
                    columns.Bound(c => c.Name).Format("<strong>{0}</strong>");
                    columns.Bound(c => c.BirthDate).Format("{0:d}");
                    columns.Bound(c => c.ReadOnly);
                    columns.Command(commands =>
                    {
                        commands.Edit();
                        commands.Delete();
                    });
                })
            .DataBinding(binding => binding.Ajax()
                .Select("Select", "Dummy")
                .Insert("Insert", "Dummy")
                .Delete("Delete", "Dummy")
                .Update("Update", "Dummy")
            )
            .Pageable(pager => pager.PageSize(10))
    %>

    <div id="date">
        <%= Html.EasyUI().DatePicker()
                .Name("DatePicker")
                .Value(DateTime.Today)
        %>
    </div>

    <div id="time">
        <%= Html.EasyUI().TimePicker()
                .Name("TimePicker")
                .Value(DateTime.Today)
        %>
    </div>

    <div id="datetime">
        <%= Html.EasyUI().DateTimePicker()
                .Name("DateTimePicker")
                .Value(DateTime.Today)
        %>
    </div>

    <div id="numeric">
        <%= Html.EasyUI().NumericTextBox()
                .Name("NumericTextBox")
                .MinValue( double.MinValue)
                .MaxValue( double.MaxValue)
                .Value(1231234.12)
        %>
    </div>

    <div id="integer">
        <%= Html.EasyUI().IntegerTextBox()
                .Name("IntegerTextBox")
                .MinValue( int.MinValue)
                .MaxValue( int.MaxValue)
                .Value(1231234)
        %>
    </div>

    <div id="dropdown">
        <%= Html.EasyUI().DropDownList()
                .Name("DropDownList")
                .Items(items =>
                {
                    items.Add().Text("foo");
                    items.Add().Text("bar");
                }) 
        %>
    </div>

    <div id="combobox">
        <%= Html.EasyUI().ComboBox()
                .Name("ComboBox")
                .Items(items =>
                {
                    items.Add().Text("foo");
                    items.Add().Text("bar");
                })
                .SelectedIndex(1)
        %>
    </div>
    <div id="editor">
         <%= Html.EasyUI().Editor()
            .Name("Editor1")
            .Value("<strong>foo</strong>")
            .Tools(tools => tools
                .Clear()
                .Bold())
        %>
    </div>
     <div id="autocomplete">
         <%= Html.EasyUI().AutoComplete()
            .Name("AutoComplete1")
            .Value("foo")
        %>
    </div>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">
    
    function getGrid(selector) {
        return $(selector || "#Grid1").data("tGrid");
    }
    
    var ModelBinder;
    var binder;

    module("Grid / ModelBinder", {
        setup: function() {
            ModelBinder = $.easyui.grid.ModelBinder;
            binder = new ModelBinder();
        }
    });
    
    test('bind textbox', function() {
        var $ui = $('<div><input type="text" name="foo" value="bar" /></div>');
        
        var model = binder.bind($ui);

        equal(model.foo, 'bar');
    });

    test('bind skips disabled elements', function() {
        var $ui = $('<div><input type="text" name="foo" value="bar" disabled="disabled" /></div>');
        
        var model = binder.bind($ui);

        ok(undefined === model.foo, 'bar');
    });

    test('bind skips buttons', function() {
        var $ui = $('<div><input type="button" name="foo" value="bar" /></div>');
        
        var model = binder.bind($ui);

        ok(undefined === model.foo);
    });

    test('bind checked checkbox yields true', function() {
        var $ui = $('<div><input type="checkbox" name="foo" checked="checked" /></div>');
        
        var model = binder.bind($ui);

        equal(model.foo, true);
    });

    test('bind unchecked checkbox yields false', function() {
        var $ui = $('<div><input type="checkbox" name="foo" /></div>');
        
        var model = binder.bind($ui);

        equal(model.foo, false);
    });

    test('bind extracts selected radio button value', function() {
        var $ui = $('<div><input type="radio" name="foo" value="1" checked="checked" /><input type="radio" name="foo" value="2" /></div>');
        
        var model = binder.bind($ui);

        equal(model.foo, 1);
    });

    test('bind extracts undefined if no radio button is selected', function() {
        var $ui = $('<div><input type="radio" name="foo" value="1" /><input type="radio" name="foo" value="2" /></div>');
        
        var model = binder.bind($ui);

        equal(model.foo, undefined);
    });

    test('bind textarea', function() {
        var $ui = $('<div><textarea name="foo">bar</textarea></div>');
        
        var model = binder.bind($ui);

        equal(model.foo, 'bar');
    });

    test('bind select', function() {
        var $ui = $('<div><select name="foo"><option>foo</option><option selected="selected">bar</option></select></div>');
        
        var model = binder.bind($ui);

        equal(model.foo, 'bar');
    });

    test('bind populates datepicker', function () {
        var $ui = $('#date');

        var model = binder.bind($ui);
        var date = new Date();
        date.setHours(0);
        date.setMinutes(0);
        date.setSeconds(0);
        date.setMilliseconds(0);
        
        equal(+model.DatePicker, +date);
    });

    test('bind populates datepicker', function () {
        var $ui = $('#time');

        var model = binder.bind($ui);
        var date = new Date();
        date.setHours(0);
        date.setMinutes(0);
        date.setSeconds(0);
        date.setMilliseconds(0);

        equal(+model.TimePicker, +date);
    });

    test('bind populates datetimepicker', function () {
        var $ui = $('#datetime');

        var model = binder.bind($ui);
        var date = new Date();
        date.setHours(0);
        date.setMinutes(0);
        date.setSeconds(0);
        date.setMilliseconds(0);

        equal(+model.DateTimePicker, +date);
    });

    test('bind populates numeric text box', function() {
        var $ui = $('#numeric');
        
        var model = binder.bind($ui);

        equal(model.NumericTextBox, 1231234.12);
    });

    test('bind populates integer text box', function() {
        var $ui = $('#integer');
        
        var model = binder.bind($ui);

        deepEqual(model.IntegerTextBox, 1231234);
    }); 

    test('bind dropdownlist', function() {
        var $ui = $('#dropdown');
        
        var model = binder.bind($ui);

        equal(model.DropDownList, 'foo');
    });
    
    test('bind combobox', function() {
        var $ui = $('#combobox');
        
        var model = binder.bind($ui);
        equal(model.ComboBox, 'bar');
    });

    test('bind nested', function() {
        var $ui = $('<div><input name="foo.bar" value="baz" /></div>');
        
        var model = binder.bind($ui);

        equal(model['foo.bar'], 'baz');
    });

    test('bind editor', function() {
        var $ui = $('#editor');
        
        var model = binder.bind($ui);
        equal(model.Editor1, '&lt;strong&gt;foo&lt;/strong&gt;');
    });

     test('bind autocomplete', function() {
        var $ui = $('#autocomplete');
                
        var model = binder.bind($ui);
        equal(model.AutoComplete1, 'foo');
    });

</script>

</asp:Content>