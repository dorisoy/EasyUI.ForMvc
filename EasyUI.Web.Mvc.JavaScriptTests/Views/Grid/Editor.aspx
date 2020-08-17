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
    var Editor, editor, nop = function(){}; 

    module("Grid / InlineFormBuilder", {
        setup: function() {
            Editor = $.easyui.grid.Editor;
        }
    });
    
    test('edit wraps table with form', function() {
        editor = new Editor({
            id: 'foo',
            edit: nop
        });
        
        var table = $('<table><tr/></table>');
        
        editor.edit(table.find('tr'));

        ok(table.parent().is('form#foo.t-edit-form'));
    });    
    
    test('insert wraps table with form', function() {
        editor = new Editor({
            id: 'foo',
            insert: nop
        });
        
        var table = $('<table><tr/></table>');
        
        editor.insert(table);

        ok(table.parent().is('form#foo'));
    });     
    
    test('edit wraps table with only one form', function() {
        editor = new Editor({
            id: 'foo',
            edit: nop
        });
        
        var table = $('<table><tr/></table>');
        
        editor.edit(table.find('tr'));
        editor.edit(table.find('tr'));

        equal(table.parents('form').length, 1);
    }); 
    
    test('edit returns row', function() {
        editor = new Editor({
            id: 'foo',
            edit: nop
        });
        
        var table = $('<table><tr/></table>');
        
        var tr = editor.edit(table.find('tr'));

        same(tr[0], table.find('tr')[0]);
    });    
    
    test('edit applies edit-row-class', function() {
        editor = new Editor({
            id: 'foo',
            edit: nop
        });
        
        var table = $('<table><tr/></table>');
        
        var tr = editor.edit(table.find('tr'));

        ok(tr.is('tr.t-grid-edit-row'));
    });
    
    test('edit appends cells to container', function() {
        editor = new Editor({
            id: 'foo',
            edit: function(dataItem) { return '<td>' + dataItem + '</td>' }
        });
        
        var tr = $('<tr/>');
        
        editor.edit(tr, 'foo');

        equal(tr.find('> td').html(), 'foo');
    });    
    
    test('edit preserves group cells', function() {
        editor = new Editor({
            id: 'foo',
            edit: function() { return '<td />' }
        });
        
        var tr = $('<tr><td class="t-group-cell"></td></tr>');
        
        editor.edit(tr);

        equal(tr.children().length, 2);
        
        ok(tr.find('> td:first').is('td.t-group-cell'));
    });    
    
    test('edit preserves hierarchy cells', function() {
        editor = new Editor({
            id: 'foo',
            edit: function() { return '<td />' }
        });
        
        var tr = $('<tr><td class="t-hierarchy-cell"></td></tr>');
        
        editor.edit(tr);

        equal(tr.children().length, 2);
        
        ok(tr.find('> td:first').is('td.t-hierarchy-cell'));
    });

    test('edit cleans data cells', function() {
        editor = new Editor({
            id: 'foo',
            edit: function() { return '<td />' }
        });
        
        var tr = $('<tr><td /></tr>');
        
        editor.edit(tr);

        equal(tr.children().length, 1);
    });    
    
    test('insert calls options insert', function() {
        editor = new Editor({
            id: 'foo',
            insert: function() { return '<td />' }
        });
        
        var table = $('<table />');
        
        editor.insert(table);

        ok(table.find('tr').is('tr.t-grid-new-row'));
    });    
    
    test('insert adds group cells', function() {        
        editor = new Editor({
            id: 'foo',
            insert: function() { return '<td />'; },
            groups: function() { return 1; }
        });
        
        var table = $('<table><tr/></table>');
        
        editor.insert(table);
        
        var tr = table.find("tr");

        equal(tr.children().length, 2);
        
        ok(tr.find('> td:first').is('td.t-group-cell'));
    });

    test('insert adds hierarchy cells', function() {        
        editor = new Editor({
            id: 'foo',
            insert: function() { return '<td />' },
            details: true
        });        
        var table = $('<table><tr/></table>');
        
        editor.insert(table);
        
        var tr = table.find("tr");

        equal(tr.children().length, 2);
        
        ok(tr.find('> td:first').is('td.t-hierarchy-cell'));
    });

    test('insert adds hierarchy and group cells', function() {        
        editor = new Editor({
            id: 'foo',
            insert: function() { return '<td />' },
            details: true,
            groups: function() { return 1; }
        });        
        var table = $('<table><tr/></table>');
        
        editor.insert(table);
        
        var tr = table.find("tr");

        equal(tr.children().length, 3);
        
        ok(tr.find('> td').eq(0).is('td.t-group-cell'));
        ok(tr.find('> td').eq(1).is('td.t-hierarchy-cell'));
    });

    test('insert prepends row', function() {
        editor = new Editor({
            id: 'foo',
            insert: function() { return '<td />' }
        });
        
        var table = $('<table><tr/></table>');
        
        editor.insert(table);

        ok(table.find('tr').is('tr.t-grid-new-row'));
    });
    
    test('cancel calls options cancel', function() {
        editor = new Editor({
            id: 'foo',
            cancel: function() { return '<td />' }
        });
        
        var tr = $('<tr/>');
        
        editor.cancel(tr);

        ok(tr.children().first().is('td'));
    });    
    
    test('cancel removes edit row class', function() {
        editor = new Editor({
            id: 'foo',
            cancel: function() { return '<td />' }
        });
        
        var tr = $('<tr/>');
        
        editor.cancel(tr);

        equal(tr.hasClass('t-grid-edit-row'), false);
    });

    test('cancel removes new row from its container', function() {
        
        editor = new Editor({
            id: 'foo',
            cancel: function() { return '<td />' }
        });
        
        var table = $('<table><tr class="t-grid-new-row" /></table>');
        
        editor.cancel(table.find('tr'));

        equal(table.find('tr').length, 0);
    });

    </script>
</asp:Content>
