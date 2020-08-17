<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <%= Html.EasyUI().Grid(Model)
            .Name("Grid1")
            .DataKeys(keys => keys.Add(c => c.Name))
            .ToolBar(toolbar => toolbar.Insert())
            .Columns(columns => 
                {
                    columns.Bound(c => c.Name);
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
            .Pageable()
    %>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

    var grid;
    var originalHasErrors;
    var originalAjax;
    var originalDisplayErrors;

    function getGrid(selector) {
        return $(selector || "#Grid1").data("tGrid");
    }

    module("Grid / ModelStateErrors", {
        setup: function() {
            grid = getGrid();
            originalHasErrors = grid.hasErrors;
            originalAjax = $.ajax;
            originalDisplayErrors = grid.displayErrors;
        },
        teardown: function() {
            grid.hasErrors = originalHasErrors;
            $.ajax = originalAjax;
            grid.displayErrors = originalDisplayErrors;
        }
    });
    
    test('grid does not bind if hasErrors returns true', function() {
        $.ajax = function(options) {
            options.success('{data:[], modelState:{foo:{errors:[]}}}')
        }

        grid.hasErrors = function() { return true }
        
        var dataBound = false;
            
        $(grid.element).bind('dataBound', function() {
            dataBound = true;
        });

        grid.sendValues({}, 'updateUrl');

        ok(!dataBound);
    });     
    
    test('grid displays errors if hasErrors returns true', function() {
        $.ajax = function(options) {
            options.success('{data:[], modelState:{foo:{errors:[]}}}')
        }

        var displayed = false;
        
        grid.displayErrors = function() { displayed = true };
        grid.sendValues({}, 'updateUrl');

        ok(displayed);
    });    
    
    test('grid does not display errors if hasErrors returns false', function() {
        $.ajax = function(options) {
            options.success('{data:[]}')
        }

        var displayed = false;
        
        grid.displayErrors = function() { displayed = true };
        grid.sendValues({}, 'updateUrl');

        ok(!displayed);
    });    
    
    test('grid binds if hasErrors returns false', function() {
        $.ajax = function(options) {
            options.success('{data:[]}')
        }
    
        grid.hasErrors = function() { return false }
        var dataBound = false;
            
        $(grid.element).bind('dataBound', function() {
            dataBound = true;
        });

        grid.sendValues({}, 'updateUrl');

        ok(dataBound);
    });

    test('hasErrors returns true if modelState has errors', function() {
        ok(grid.hasErrors({modelState:{foo:{errors:[]}}}));
    });

    test('hasErrors returns false if modelState has no errors', function() {
        ok(!grid.hasErrors({modelState:{}}));
    });

    test('hasErrors returns false if modelState is not present', function() {
        ok(!grid.hasErrors({}));
    });

</script>

</asp:Content>