<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <%= Html.EasyUI().Grid(Model)
            .Name("Grid1")
            .Columns(columns => {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.BirthDate.Day);
            })
            .Sortable()
            .Pageable(pager => pager.PageSize(1))
    %>
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid2")
            .Columns(columns => {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.BirthDate.Day);
            })
            .Sortable(sorting => sorting.OrderBy(columns => columns
                .Add(c => c.Name)))
            .Pageable(pager => pager.PageSize(1))
    %>

    <%= Html.EasyUI().Grid(Model)
            .Name("Grid3")
            .Columns(columns => {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.Name);
                columns.Bound(c => c.BirthDate.Day);
            })
            .Sortable(sorting => sorting.OrderBy(columns => columns
                .Add(c => c.Name)))
            .Pageable(pager => pager.PageSize(1))
            .DataBinding(dataBinding => dataBinding.Ajax()
                .Select("foo", "bar"))
    %>

    <%= Html.EasyUI().Grid(Model)
            .Name("Grid4")
            .Columns(columns => {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.Name);
                columns.Bound(c => c.BirthDate.Day);
            })
            .Sortable(sorting => sorting.OrderBy(columns => columns
                .Add(c => c.Name)))
            .Pageable(pager => pager.PageSize(1))
            .DataBinding(dataBinding => dataBinding.Ajax().OperationMode(GridOperationMode.Client)
                .Select("foo", "bar"))
    %>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">

        var gridElement;

        function getGrid(selector) {
            return $(selector).data("tGrid");
        }

        function createGrid(gridElement, options) {
            options = $.extend({}, $.fn.tGrid.defaults, options);
            return new $.easyui.grid(gridElement, options);
        }

        
        module("Grid / Sorting", {
            setup: function() {
                gridElement = document.createElement("div");
                gridElement.id = "tempGrid";
            }
        });


        test('clicking the header calls order by', function() {
            var grid = getGrid("#Grid1");
            var columnIndex = 0;
            var orderBy = grid.sort;
            grid.toggleOrder = function(index) {
                columnIndex = index;
            }

            $("th:nth-child(1)", grid.element).trigger("click");

            equal(columnIndex, 0);

            grid.sort = orderBy;
        });

        test('sort expression should return column', function() {
            var grid = createGrid(gridElement, { columns: [{ member: "c1", order: 'asc' }, { member: "c2"}] });

            equal(grid.sortExpr(), "c1-asc");
        });

        test('sort expression multiple columns', function() {
            var grid = createGrid(gridElement, { columns: [{ member: "c1" }, { member: "c2"}] });
            grid.toggleOrder(1);
            grid.toggleOrder(0);

            equal(grid.sortExpr(), "c2-asc~c1-asc");
        });

        test('sort expression correctly updates sorting order', function() {
            var grid = createGrid(gridElement, { columns: [{ member: "c1" }, { member: "c2"}] });
            grid.toggleOrder(0);
            equal(grid.sortExpr(), "c1-asc");
            
            grid.toggleOrder(0);
            equal(grid.sortExpr(), "c1-desc");
            
            grid.toggleOrder(0);
            
            equal(grid.sortExpr(), "");
        });

        test('sort is undefined by default', function() {
            var grid = createGrid(gridElement, { columns: [{ member: "c1" }, { member: "c2"}] });
            ok(undefined === grid.sortMode);
        });

        test('sort is serialized', function() {
            var grid = getGrid("#Grid1");
            equal(grid.sortMode, "single");
        });

        test('sort expression supports single sort mode', function() {
            var grid = createGrid(gridElement, { sortMode: "single", columns: [{ member: "c1" }, { member: "c2"}] });
            grid.toggleOrder(0);
            grid.toggleOrder(1);
            equal(grid.sortExpr(), "c2-asc");
            equal(grid.columns[0].order, null);
        });

        test('sort expression changes sort direction in single sort mode', function() {
            var grid = createGrid(gridElement, { sortMode: "single", columns: [{ member: "c1" }, { member: "c2"}] });

            grid.toggleOrder(0);
            grid.toggleOrder(0);
            
            equal(grid.sortExpr(), "c1-desc");
        });

        test('order serialized for sorted columns', function() {
            var grid = getGrid("#Grid2");
            equal(grid.columns[0].order, "asc");
        });
        
        test('rebind clears sort order', function() {
            var grid = getGrid("#Grid3");
            grid.ajaxRequest = function() {};
                
            grid.rebind();
            equal(grid.orderBy, '');
        });

        test("data of not grouped paged grid with operation mode client and initial server binding", function() {
            var grid = getGrid("#Grid4");
            equal(grid.data.length, 1);
            equal(grid.dataSource.data().length, 2);                        
            equal(grid.data[0].Name, "Customer1");
        });

        test('duplicate column icon cleared', function() {
//            var grid = getGrid("#Grid3");
//            grid.ajaxRequest = function() {
//            }
//            grid.sort('BirthDate.Day-asc');
//            grid.updateSorting();
//            equal($('#Grid3 .t-arrow-up').length, 1);
        });

    </script>

</asp:Content>