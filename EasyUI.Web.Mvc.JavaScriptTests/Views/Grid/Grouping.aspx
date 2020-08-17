<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <%= Html.EasyUI().Grid(Model)
            .Name("Grid1")
            .Columns(columns =>
            {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.BirthDate);
                columns.Bound(c => c.Active);
            })
            .Scrollable()
            .Groupable(grouping => grouping.Groups(groups => 
                {
                    groups.Add(c => c.Name);
                    groups.Add(c => c.BirthDate);
                }))
            .DataBinding(dataBinding => dataBinding.Ajax().Select("Foo", "Bar"))
        %>
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid2")
            .Columns(columns =>
            {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.BirthDate);
                columns.Bound(c => c.Active);
                columns.Bound(c => c.Active).Title("Ungroupable").Groupable(false);
            })
            .Scrollable()
            .Groupable()
            .DataBinding(dataBinding => dataBinding.Ajax().Select("Foo", "Bar"))
        %>
    
        <%= Html.EasyUI().Grid(Model)
            .Name("Grid3")
            .Columns(columns =>
            {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.BirthDate).Hidden(true);
                columns.Bound(c => c.Active);
            })
            .Scrollable()
            .Groupable()
            .DataBinding(dataBinding => dataBinding.Ajax().Select("Foo", "Bar"))
        %>
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid4")
            .Columns(columns =>
            {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.BirthDate);
                columns.Bound(c => c.Active);
            })
            .Scrollable()
            .Groupable(grouping => grouping.Groups(groups => 
                {
                    groups.Add(c => c.Name);
                    groups.Add(c => c.BirthDate);
                }))
            .DataBinding(dataBinding => dataBinding.Ajax().Select("Foo", "Bar"))
        %>
               
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid5")
            .Columns(columns =>
            {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.BirthDate);
                columns.Bound(c => c.Active);
            })
            .Scrollable()
            .Groupable(grouping => grouping.Groups(groups => 
                {
                    groups.Add(c => c.Active);                    
                }))
            .DataBinding(dataBinding => dataBinding.Ajax().OperationMode(GridOperationMode.Client).Select("Foo", "Bar"))
            .Pageable()
        %>

    <%= Html.EasyUI().Grid<EasyUI.Web.Mvc.JavaScriptTests.Customer>()
            .Name("Grid6")
            .Columns(columns =>
            {
                columns.Bound(c => c.Name);                
                columns.Bound(c => c.Active);
            })
            .Scrollable()
            .Groupable()
            .DataBinding(dataBinding => dataBinding.Ajax().Select("Foo", "Bar"))
            .Pageable()
            .ClientEvents(events => events.OnDataBinding("grid6_dataBinding"))
        %>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

        function getGrid(selector) {
            return $(selector).data("tGrid");
        }

        module("Grid / Grouping", {
            setup: function() {
                getGrid('#Grid1').ajaxRequest = function() {};
                getGrid('#Grid2').ajaxRequest = function() {};
                getGrid('#Grid3').ajaxRequest = function() {};
                getGrid('#Grid4').ajaxRequest = function() {};
                getGrid('#Grid5').ajaxRequest = function() {};
                //getGrid('#Grid6').ajaxRequest = function() {};
            }
        });

        function grid6_dataBinding(e) {
            var grid = $(this).data("tGrid"),
                data = [ { Aggregates: {}, HasSubgroups: false, Items: [{Name: "foo", Active: false}, {Name: "bar", Active: false}], Key: false, Subgroups: [] }];

            e.preventDefault();

            grid.dataBind(data);
        }

        test('ungrouping removes grouping columns', function() {
            var grid = getGrid('#Grid1');
            grid.unGroup('Birth Date');
            grid.normalizeColumns(grid.groups.length + grid.columns.length);
            
            equal($('table:first col', grid.element).length, 4)
            equal($('tr:has(th):first .t-group-cell', grid.element).length, 1)
        });

        test('ungrouping removes grouping columns hidden', function() {
            var grid = getGrid('#Grid4');
            grid.unGroup('Birth Date');
            grid.normalizeColumns(grid.groups.length + grid.columns.length);

            equal($('table:first col', grid.element).length, 4)
            equal($('tr:has(th):first .t-group-cell', grid.element).length, 1)
        });
        
        test('grouping creates grouping columns', function() {
            var grid = getGrid('#Grid2');
            grid.group('Name');
            grid.normalizeColumns(grid.groups.length + grid.columns.length);

            equal($('table:first col', grid.element).length, 5)
            equal($('tr:has(th):first .t-group-cell', grid.element).length, 1)
        });
        
        test('grouping creates grouping hidden', function() {
            var grid = getGrid('#Grid3');
            grid.group('Name');
            grid.normalizeColumns(grid.groups.length + grid.columns.length);

            equal($('table:first col', grid.element).length, 3)
            equal($('tr:has(th):first .t-group-cell', grid.element).length, 1)
        });

        test('ungroupable columns groupable serialized', function() {
            var grid = getGrid('#Grid2');
            ok(!grid.columns[grid.columns.length - 1].groupable);
        });

        test("data contains flat view of the data when operation mode is client and grid is populated from the server", function() {
            var grid = getGrid('#Grid5');
            equal(grid.data.length, 10);
            equal(grid.data[0].Active, false);
            equal(grid.data[1].Active, false);
            equal(grid.data[2].Active, false);
        });

        test("custom binding with grouped data passed through dataBind method", function() {
            var grid = getGrid('#Grid6');       
            grid.group('Active');     
            equal(grid.dataSource.group().length, 1);
            equal(grid.data.length, 2);
        });
</script>

</asp:Content>