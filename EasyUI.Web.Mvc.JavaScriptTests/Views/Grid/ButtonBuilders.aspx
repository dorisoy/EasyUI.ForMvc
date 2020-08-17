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

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">
    var ButtonBuilder, ImageButtonBuilder, ImageTextButtonBuilder, BareImageButtonBuilder, builder; 

    module("Grid / ButtonBuilders", {
        setup: function() {
            ButtonBuilder = $.easyui.grid.ButtonBuilder;
            ImageButtonBuilder = $.easyui.grid.ImageButtonBuilder;
            ImageTextButtonBuilder = $.easyui.grid.ImageTextButtonBuilder;
            BareImageButtonBuilder = $.easyui.grid.BareImageButtonBuilder;
        }
    });

    test('build creates button', function() {
        builder = new ButtonBuilder({});
        
        var button = $(builder.build());
    
        ok(button.is('a'));
    });    
    
    test('build sets className', function() {
        builder = new ButtonBuilder({});
        
        builder.classNames.push('foo');
        
        var button = $(builder.build());
    
        ok(button.is('a.t-button.foo'));
    });
    
    test('build sets className based on button name', function() {
        builder = new ButtonBuilder({name:'foo'});
        
        same(builder.classNames, ['t-button', 't-grid-foo']);
    });
    
    test('build sets button attributes', function() {
        builder = new ButtonBuilder({attr:' foo="bar" '});
        
        var button = $(builder.build());
    
        ok(button.is('a[foo=bar]'));
    });
    
    test('build sets content', function() {
        builder = new ButtonBuilder({});
        builder.content = function() { return 'foo'};
        
        var button = $(builder.build());
    
        equals(button.html(), 'foo');
    });    
    
    test('content returns text of the button', function() {
        builder = new ButtonBuilder({name:'foo', text: 'bar'});
        
        equals(builder.content(), 'bar');
    });

    test('imagebuttonbuilder applies t-button-icon class', function() {
        builder = new ImageButtonBuilder({name:'foo'});
        
        equals(builder.classNames.pop(), 't-button-icon');
    });
    
    test('imagebuttonbuilder content returns span', function() {
        builder = new ImageButtonBuilder({name:'foo'});
        var span = $(builder.content());
        ok(span.is('span.t-icon.t-foo'));
    });    
    
    test('imagebuttonbuilder content applies image attributes', function() {
        builder = new ImageButtonBuilder({imageAttr: ' foo="bar"'});
        var span = $(builder.content());
        ok(span.is('span[foo=bar]'));
    });

    test('imagetextbuttonbuilder applies t-button-icontext class', function() {
        builder = new ImageTextButtonBuilder({name:'foo'});
        
        equals(builder.classNames.pop(), 't-button-icontext');
    });

    test('imagetextbuttonbuilder build returns span and text', function() {
        builder = new ImageTextButtonBuilder({name:'foo', text: 'bar'});
        var button = $(builder.build());
        
        ok(button.children().eq(0).is('span.t-icon.t-foo'));
        
        equal(button.text(), 'bar');
    }); 
    
    test('bareimagebuttonbuilder applies t-button-icon and t-button-bare classes', function() {
        builder = new BareImageButtonBuilder({name:'foo'});
        
        equals(builder.classNames.pop(), 't-button-bare');
        equals(builder.classNames.pop(), 't-button-icon');
    });
    
</script>

</asp:Content>