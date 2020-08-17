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
    var FormContainerBuilder, builder, nop = function(){}; 

    module("Grid / FormContainerBuilder", {
        setup: function() {
            FormContainerBuilder = $.easyui.grid.FormContainerBuilder;
        }
    });
    
    test('edit returns div', function() {
        
        builder = new FormContainerBuilder({
            html: nop,
            edit: nop
        });
        
        var div = $(builder.edit());

        ok(div.is('div.t-edit-form-container'))
    });    
    
    test('edit uses options html', function() {
        
        builder = new FormContainerBuilder({
            html: function() { return '<strong>foo</strong>' },
            edit: nop
        });
        
        var div = $(builder.edit());

        equal(div.children().first().html(), 'foo');
    });

    test('edit calls and appends options.edit', function() {
        builder = new FormContainerBuilder({
            edit: function() { return '<strong>foo</strong>'},
            html: nop
        });
        
        var div = $(builder.edit());

        equal(div.children().last().html(), 'foo');
    });    
    
    test('insert calls and appends options.insert', function() {
        builder = new FormContainerBuilder({
            insert: function() { return '<strong>foo</strong>'},
            html: nop
        });
        
        var div = $(builder.insert());

        equal(div.children().last().html(), 'foo');
    });

    </script>
</asp:Content>
