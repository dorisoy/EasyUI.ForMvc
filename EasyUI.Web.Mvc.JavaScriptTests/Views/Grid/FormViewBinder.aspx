<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

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

    <div id="numeric">
        <%= Html.EasyUI().NumericTextBox()
                .Name("NumericTextBox")
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
                    items.Add().Text("foo text").Value("foo");
                    items.Add().Text("bar text").Value("bar");
                }) 
        %>

        <%= Html.EasyUI().ComboBox()
                .Name("ComboBox1")
                .Items(items =>
                {
                    items.Add().Text("foo text").Value("foo");
                    items.Add().Text("bar text").Value("bar");
                }) 
        %>
    </div>
    <div id="editor">
         <%= Html.EasyUI().Editor()
            .Name("Editor1")
            .Value("foo")
            .Tools(tools => tools
                .Clear()
                .Bold()
            )
    %>
    </div>
    <div id="upload">
         <%= Html.EasyUI().Upload()
            .Name("Upload1")
    %>
    </div>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">
    
    function getGrid(selector) {
        return $(selector || "#Grid1").data("tGrid");
    }
    
    var FormViewBinder;
    var binder; 

    module("Grid / FormViewBinder", {
        setup: function() {
            FormViewBinder = $.easyui.grid.FormViewBinder;
            binder = new FormViewBinder();
        }
    });
    
    test('bind populates textbox', function() {
        var $ui = $('<div><input type="text" name="foo" /></div>');
        
        binder.bind($ui, {foo:'bar'});

        equal($ui.find(':input').val(), 'bar');
    });
    
    test('bind with array access populates textbox', function() {
        var $ui = $('<div><input type="text" name="foo[0]" /></div>');
        
        binder.bind($ui, {foo:[1,2] });

        equal($ui.find(':input').val(), '1');
    });    

    test('bind with nested array populates textbox', function() {
        var $ui = $('<div><input type="text" name="foo[0].bar[0].baz" /></div>');
        
        binder.bind($ui, { foo:[ { 
            bar: [
                { baz: "baz" }
            ] 
          } ]
        });

        equal($ui.find(':input').val(), 'baz');
    });    

    test('bind checkes checkboxes', function() {
        var $ui = $('<div><input type="checkbox" name="foo" /></div>');
        
        binder.bind($ui, {foo:true});

        equal($ui.find(':checkbox').attr('checked'), 'checked');
    });
    
    test('bind selects radiobutton', function() {
        var $ui = $('<div><input type="radio" name="foo" value="1" /><input type="radio" name="foo" value="2" /></div>');
        
        binder.bind($ui, {foo:1});

        equal($ui.find(':radio:first').attr('checked'), 'checked');
    });

    test('bind does not set null', function() {
        var $ui = $('<div><input type="text" name="foo" /></div>');
        
        binder.bind($ui, {foo:null});

        equal($ui.find(':input').val(), '');
    });    
    
    test('bind populates text area', function() {
        var $ui = $('<div><textarea name="foo" ></textarea></div>');
        
        binder.bind($ui, {foo:'bar'});

        equal($ui.find('textarea').val(), 'bar');
    });

    test('bind populates select', function() {
        var $ui = $('<div><select name="foo"><option>foo</option><option>bar</option></select></div>');
        
        binder.bind($ui, {foo:'bar'});

        equal($ui.find('select').val(), 'bar');
    });

    test('bind populates numeric text box', function () {
        var $ui = $('#numeric');
        binder.bind($ui, { NumericTextBox: 42 });

        equal($('#NumericTextBox').data('tTextBox').value(), 42);
        equal($('#NumericTextBox').closest('.t-numerictextbox').find('.t-formatted-value').html(), '42.00');
    });
    
    test('bind skips inputs whose name does not match', function() {
        var $ui = $('<div><input type="text" name="bar" /></div>');
        
        binder.bind($ui, {foo:'baz'});

        equal($ui.find(':input').val(), '');
    });

    test('eval for prefixed column', function() {
        equal(binder.evaluate({Name:'Customer1'}, 'm.Name'), 'Customer1');
    });

    test('eval uses converters', function() {
        var binder = new FormViewBinder({'number':function(name,value){return -value;}});
        
        equal(binder.evaluate({foo:42}, 'foo'), -42);
    });
        
    test('eval for nested property', function() {
        equal(binder.evaluate({Address:{Street:'foo'}}, 'Address.Street'), 'foo');
    });
        
    test('eval for property which does not have a column', function() {
        equal(binder.evaluate({Active:true}, 'Active'), true);
    });

    test('eval for nested property with prefix', function() {
        equal(binder.evaluate({Address:{Street:'foo'}}, 'm.Address.Street'), 'foo');
    });
    
    test('eval for nested property with prefix and indexer', function() {
        equal(binder.evaluate({Address:{Street:'foo'}}, 'm[0].Address.Street'), 'foo');
    });

    test('eval returns undefined with invalid expression with valid parts', function() {
        ok(undefined === binder.evaluate({Address:{Street:'foo'}}, 'm.Address.Foo'));
    });
        
    test('eval with more than one prefix', function() {
        equal(binder.evaluate({Address:{Street:'foo'}}, 'foo.bar.Address.Street'), 'foo');
    });
        
    test('eval returns undefined with invalid expression', function() {
        ok(undefined === binder.evaluate({}, 'foo'));
    });
    
    test('eval returns date time for serialized dates', function() {
        var value = binder.evaluate({ Date: "/Date(315525600000)/" }, 'Date');
        equal(value.getDate(), 1);
        equal(value.getMonth() + 1, 1);
        equal(value.getFullYear(), 1980);
    });

    test('eval with non existent name', function() {
        var value = binder.evaluate({ }, 'Foo');
        ok(undefined === value);
    });    
    
    test('eval nested member of null', function() {
        var value = binder.evaluate({ Foo: null }, 'Foo.Bar');
        ok(undefined === value);
    });
    
    test('eval nested member of primitive type', function() {
        var value = binder.evaluate({ Foo: true}, 'Foo.Bar');
        ok(undefined === value);
    });
    
    test('eval returns undefined when expression is null', function() {
        var value = binder.evaluate({}, null);
        ok(undefined === value);
    });
    
    test('eval returns undefined when expression is undefined', function() {
        var value = binder.evaluate({}, undefined);
        ok(undefined === value);
    });

    test('eval returns undefined when expression is empty string', function() {
        var value = binder.evaluate({}, '');
        ok(undefined === value);
    });    
    
    test('eval returns undefined when model is null', function() {
        var value = binder.evaluate(null, 'foo');
        ok(undefined === value);
    });

    test('evaluate returns undefined for non primitive values', function() {
        var value = binder.evaluate({ Foo: {} }, 'Foo');
        ok(undefined === value);
    });
    
    test('eval returns undefined when model is undefined', function() {
        var value = binder.evaluate(undefined, 'foo');
        ok(undefined === value);
    });

    test('bind populates dropdownlist', function() {
        var $ui = $('#dropdown');
        binder.bind($ui, {DropDownList: 'bar'});

        equal($('#DropDownList').data('tDropDownList').value(), 'bar');
        equal($('#DropDownList').val(), 'bar');
    });
    
    test('bind populates combobox', function() {
        var $ui = $('#combobox');
        
        binder.bind($ui, {ComboBox: 'bar'});

        equal($('#ComboBox').data('tComboBox').value(), 'bar');
    });

    test('bind populates both combobox', function () {
        var $ui = $('#combobox');

        binder.bind($ui, { ComboBox: 'foo', ComboBox1: 'foo' });

        equal($('#ComboBox').data('tComboBox').$text.val(), 'foo text');
        equal($('#ComboBox1').data('tComboBox').$text.val(), 'foo text');
        equal($('#ComboBox').data('tComboBox').value(), 'foo');
        equal($('#ComboBox1').data('tComboBox').value(), 'foo');
    });
    
    test('bind populates editor', function() {
        var $ui = $('#editor');
        
        binder.bind($ui, {Editor1: 'bar'});

        equal($('#Editor1').data('tEditor').value(), 'bar');
    });
    
    test('bind does not try to populate upload', function() {
        var $ui = $('#upload');
        
        binder.bind($ui, {Upload1: 'bar'});
    });

</script>

</asp:Content>