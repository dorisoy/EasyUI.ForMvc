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
            .Editable(editing => editing.Mode(GridEditMode.InCell))
            .Pageable(pager => pager.PageSize(10))
    %>
</asp:Content>
<asp:Content ContentPlaceHolderID="TestContent" runat="server">
    <script type="text/javascript">
        var CellEditor, editor, nop = function () { };

        module("Grid / CellEditor", {
            setup: function () {
                CellEditor = $.easyui.grid.CellEditor;
            }
        });

        function createCellEditor(options) {
            return new CellEditor(
                $.extend({
                    cellIndex: function() { return 0 },
                    validate: nop,
                    bind: nop,
                    columns: [{ edit: function () { return 'foo' } }]
                }, options)
            );
        }

        test('edit sets the cell content using the column editor', function () {
            editor = createCellEditor();

            var tr = $('<tr><td/></tr>');
            var td = tr.find('td');

            editor.edit(td, null);

            equal(td.html(), 'foo');
        });        
        
        test('edit passes the dataItem to the column editor', function () {
            editor = createCellEditor({
                columns: [{ edit: function (dataItem) { return dataItem; } }]
            });

            var tr = $('<tr><td/></tr>');
            var td = tr.find('td');

            editor.edit(td, 'foo');

            equal(td.html(), 'foo');
        });    
    
        test('edit sets the css class of the row', function() {
            editor = createCellEditor();

            var tr = $('<tr><td/></tr>');
            var td = tr.find('td');

            editor.edit(td, 'foo');

            ok(tr.is('tr.t-grid-edit-row'));
        });
        
        test('edit wraps table with a form', function() {
            editor = createCellEditor({
                id: 'foo'
            });

            var table = $('<table><tr><td/></tr></table>');
            var td = table.find('td');

            editor.edit(td, 'foo');

            ok(table.parent().is('form.t-edit-form#foo'));
        });        
        
        test('edit does not create more than one form', function() {
            editor = createCellEditor();

            var form = $('<form><table><tr><td/></tr></table></form>');
            var td = form.find('td');

            editor.edit(td, 'foo');

            equal(form.find('table').parents().length, 1);
        });

        test('edit initializes validation', function() {
            var called = false;

            editor = createCellEditor({
                validate: function() { called = true }
            });

            var tr = $('<tr><td/></tr>');
            var td = tr.find('td');

            editor.edit(td, null);

            ok(called);
        });

        test('edit does not use column editor if the column is readonly', function() {
            var called = false;

            editor = createCellEditor({
                columns: [{ readonly: true, edit: function() { called = true; return 'foo' }}]
            });

            var tr = $('<tr><td/></tr>');
            var td = tr.find('td');

            editor.edit(td, null);

            ok(!called);
        });       
        
        test('edit uses cellIndex', function() {
            var called = false;

            editor = createCellEditor({
                cellIndex: function() { called = true; return 0; }
            });

            var tr = $('<tr><td/></tr>');
            var td = tr.find('td');

            editor.edit(td, null);

            ok(called);
        });

        test('edit binds the editor to the dataItem', function() {
            
            var called = false;
            
            editor = createCellEditor({
                bind: function(td, dataItem) { called = true; }
            });

            var tr = $('<tr><td/></tr>');
            var td = tr.find('td');

            editor.edit(td, null);

            ok(called);
        });

        test('edit returns false if column is readonly', function () {
            editor = createCellEditor({ columns: [{readonly:true}]});

            equal(editor.edit(), false)
        });        
        
        test('edit returns true if column is not readonly', function () {
            editor = createCellEditor();

            equal(editor.edit($('<td/>')), true)
        });
        
        test('display uses passes dataItem to the display method of the options', function() {
            editor = createCellEditor({
                columns: [{ display: function(dataItem) { return dataItem }}]
            });

            var td = $('<td />');

            editor.display(td, 'foo');

            equal(td.html(), 'foo');
        });
        
        test('display removes the t-grid-edit-row class from the parent tr', function() {
            editor = createCellEditor({
                columns: [{ display: function(dataItem) { return dataItem }}]
            });

            var tr = $('<tr class="t-grid-edit-row"><td /></tr>');

            editor.display(tr.find('td'), 'foo');

            ok(!tr.is('tr.t-grid-edit-row'));
        });


    </script>
</asp:Content>
