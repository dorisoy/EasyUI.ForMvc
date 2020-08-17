<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <%= Html.EasyUI().Grid(Model)
            .Name("Grid1")
            .DataKeys(keys => keys.Add(c => c.Name))
            .Columns(columns => 
                {
                    columns.Bound(c => c.Name)
                        .ClientTemplate("<strong><#= Name #></strong>");
                    
                    columns.Bound(c => c.BirthDate);
                    
                    columns.Command(commands =>
                    {
                        commands.Edit();
                        commands.Delete();
                    });

                    columns.Template(delegate { }).ClientTemplate("<strong><#= Name #></strong>");
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

        function getGrid(selector) {
            return $(selector || "#Grid1").data("tGrid");
        }

        test('client template is serialized for bound column', function() {
            equal(getGrid().columns[0].template, '<strong><#= Name #></strong>');
        });

        test('client template is serialized for template column', function() {
            equal(getGrid().columns[3].template, '<strong><#= Name #></strong>');
            ok(undefined !== getGrid().columns[3].display);
        });

        test('template is applied for bound column', function() {
            var grid = getGrid();
            var column = grid.columns[0];
            equal(grid.displayFor(column)({ Name: 'test' }), "<strong>test</strong>");
        });

        test('template is applied for template column', function() {
            var grid = getGrid();
            var column = grid.columns[3];
            equal(grid.displayFor(column)({ Name: 'test' }), "<strong>test</strong>");
        });

        test('value of serialized date', function() {
            var grid = getGrid();
            var column = grid.columns[1];
            ok(grid.valueFor(column)(grid.data[0]) instanceof Date);
        });

    </script>

</asp:Content>