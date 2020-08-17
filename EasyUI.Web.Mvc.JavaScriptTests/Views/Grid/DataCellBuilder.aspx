<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid1")
            .DataKeys(keys => keys.Add(c => c.Name))
            .ToolBar(toolbar => toolbar.Insert())
            .Columns(columns => 
                {
                    columns.Bound(c => c.Name);
                    columns.Bound(c => c.BirthDate);
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
    var DataCellBuilder, builder, nop = function(){}; 

    module("Grid / DataCellBuilder", {
        setup: function() {
            DataCellBuilder = $.easyui.grid.DataCellBuilder;
        }
    });
    
    test('build creates a cell for every column', function() {
        builder = new DataCellBuilder({
            columns: [{edit:nop}, {edit:nop}]
        });
        
        var tr = $('<tr />').append(builder.edit(null));
        equal(tr.find('> td').length, 2);
    });    
    
    test('build applies last cell class', function() {
        builder = new DataCellBuilder({
            columns: [{edit:nop}, {edit:nop}]
        });
        
        var tr = $('<tr />').append(builder.edit(null));
        ok(tr.find('> td:last').is('td.t-last'));
    });
    
    test('build appends column editor to cell', function() {
        builder = new DataCellBuilder({
            columns: [{edit: function() { return '<input type="text" />'} }]
        });
        
        var tr = $('<tr />').append(builder.edit(null));
        ok(tr.find('> td').children().first().is(':text'));
    });    
    
    test('build passes dataItem to method', function() {
        builder = new DataCellBuilder({
            columns: [{edit: function(dataItem) { return dataItem} }]
        });
        
        var tr =  $('<tr />').append(builder.edit('foo'));
        equal(tr.find('> td').html(), 'foo');
    });    

    </script>
</asp:Content>
