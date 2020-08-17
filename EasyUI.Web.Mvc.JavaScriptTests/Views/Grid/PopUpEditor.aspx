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
            .Editable(editing =>editing.Mode(GridEditMode.PopUp))
    %>
</asp:Content>
<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">
    
    var PopUpEditor, editor, nop = function(){}; 

    module("Grid / PopUpEditor", {
        setup: function() {
            PopUpEditor = $.easyui.grid.PopUpEditor;
        }
    });

    test('edit creates window', function() {
        var container = $('<div id="foo" />');
        
        var editor = new PopUpEditor({
            container: container[0],
            edit: nop
        });
        
        var wnd = editor.edit($('<tr/>'));

        ok(wnd.is('div.t-window#fooPopUp'));
    });
    
    test('edit creates form', function() {
        var container = $('<div id="foo" />');
        
        var editor = new PopUpEditor({
            id: 'bar',
            container: container[0],
            edit: nop
        });
        
        var wnd = editor.edit($('<tr/>'));

        ok(wnd.find('.t-window-content').children().first().is('form#bar.t-edit-form'));
    });    
    
    test('edit uses options.edit to set the contents of the form', function() {
        var container = $('<div id="foo" />');
        
        var editor = new PopUpEditor({
            id: 'bar',
            container: container[0],
            edit: function() { return "foo" }
        });
        
        var wnd = editor.edit($('<tr/>'));

        equal(wnd.find('form').html(), 'foo');
    });
    
    test('edit sets title to edit title', function() {
        var container = $('<div id="foo" />');
        
        var editor = new PopUpEditor({
            id: 'bar',
            container: container[0],
            edit: nop,
            editTitle : 'foo'
        });
        
        var wnd = editor.edit($('<tr/>'));

        equal(wnd.find('.t-window-title').html(), 'foo');
    });    
    
    test('insert sets title to insert title', function() {
        var container = $('<div id="foo" />');
        
        var editor = new PopUpEditor({
            id: 'bar',
            container: container[0],
            insert: nop,
            insertTitle : 'foo'
        });
        
        var wnd = editor.insert($('<tr/>'));

        equal(wnd.find('.t-window-title').html(), 'foo');
    });    
    
    test('insert uses options.insert to set the content of the form', function() {
        var container = $('<div id="foo" />');
        
        var editor = new PopUpEditor({
            id: 'bar',
            container: container[0],
            insert: function() { return 'foo' }
        });
        
        var wnd = editor.insert($('<tr/>'));

        equal(wnd.find('form').html(), 'foo');
    });
    
    </script>
</asp:Content>
