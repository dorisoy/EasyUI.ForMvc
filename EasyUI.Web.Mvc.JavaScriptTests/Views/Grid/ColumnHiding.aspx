<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <% Html.EasyUI().Grid(Model)
            .Name("Grid")
            .DataKeys(keys => keys.Add(c => c.Name))
            .Columns(columns =>
            {
                columns.Bound(c => c.Name).Width(100);
                columns.Bound(c => c.IntegerValue);
                columns.Bound(c => c.Gender);
            })
            .DataBinding(binding => binding.Ajax().Select("foo", "bar"))
            .Scrollable()            
            .Render();
    %>

    <% Html.EasyUI().Grid(Model)
            .Name("Grid1")
            .DataKeys(keys => keys.Add(c => c.Name))
            .Columns(columns =>
            {
                columns.Bound(c => c.Name).Width(100);
                columns.Bound(c => c.IntegerValue);
                columns.Bound(c => c.Gender);
            })
            .Groupable(settings=>settings.Groups(group=> {
                group.Add(c=>c.Name);
                group.Add(c=>c.Gender);
            }))
            .DataBinding(binding => binding.Ajax().Select("foo", "bar"))           
            .Render();
    %>

    <% Html.EasyUI().Grid(Model)
            .Name("Grid2")
            .DataKeys(keys => keys.Add(c => c.Name))
            .Columns(columns =>
            {
                columns.Bound(c => c.Name).Width(100);
                columns.Bound(c => c.IntegerValue);
                columns.Bound(c => c.Gender);
            })
            .DetailView(view=> view.ClientTemplate(""))
            .DataBinding(binding => binding.Ajax().Select("foo", "bar"))           
            .Render();
    %>
    
    <% Html.EasyUI().Grid(Model)
            .Name("Grid3")
            .DataKeys(keys => keys.Add(c => c.Name))
            .Columns(columns =>
            {
                columns.Bound(c => c.Name).Width(100).Hidden();
                columns.Bound(c => c.IntegerValue);
                columns.Bound(c => c.Gender);
            })            
            .DataBinding(binding => binding.Ajax().Select("foo", "bar"))           
            .Render();
    %> 

    <% Html.EasyUI().Grid<Customer>()
            .Name("Grid4")
            .DataKeys(keys => keys.Add(c => c.Name))
            .Columns(columns =>
            {
                columns.Bound(c => c.Name).Width(100).Hidden();
                columns.Bound(c => c.IntegerValue).Aggregate(ag => ag.Sum()).ClientGroupFooterTemplate("foo");
                columns.Bound(c => c.Gender);
            })
            .Groupable(settings=>settings.Groups(group=> {
                group.Add(c=>c.Gender);
            }))
            .DataBinding(binding => binding.Ajax())
            .ClientEvents(ev => ev.OnDataBinding("grid4_dataBinding"))
            .Render();
    %>



</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">
    
        function getGrid(selector) {
            
            var grid = $(selector || '#Grid').data('tGrid');
            return grid;
        }

        var populated;

        module("Grid / Column hiding", {
            setup: function() {
                populated = false;
            },
            teardown: function() {
                $.mockjaxClear();
            }
        });

        test("hiding a column removes the col elment", function() {
            var grid = getGrid(),
                visibleColumns,
                headerCols, bodyCols;

            grid.hideColumn("Gender");

            visibleColumns = $.grep(grid.columns, function(col) { return !col.hidden; }).length;
            headerCols = $("col:not(.t-group-col,.t-hierarchy-col)", grid.$header.parent().prev());
            bodyCols = $("col:not(.t-group-col,.t-hierarchy-col)", grid.$tbody.prev());

            equal(headerCols.length, visibleColumns);
            equal(bodyCols.length, visibleColumns);
        });        

        test("hiding column persits its width", function() {
            var grid = getGrid();

            grid.hideColumn("Name");

            equal(grid.columns[0].width, "100px");
        });
      
        test("the header of hidden columns is not visible", function() {
            var grid = getGrid(),
                hiddenColumns = $.grep(grid.columns, function(col) { return col.hidden; }),
                th = grid.$columns().filter(":not(:visible)");

            equal(hiddenColumns.length, th.length);
        });        

        test("hidden columns body cells are invisible", function() {
            var grid = getGrid(),
                hiddenColumns = $.grep(grid.columns, function(col) { return col.hidden; }),
                td = grid.$tbody.find("tr:first>td:not(:visible)");

            equal(hiddenColumns.length, td.length);
        });       

        test("hiding column decrease colspan of grouping cells", function() {
            var grid = getGrid("#Grid1"),
                groupingRows = grid.$tbody.children("tr.t-grouping-row");
             
            grid.hideColumn("Gender");
            
            equal(groupingRows.eq(0).children(":not(.t-group-cell):first").attr("colspan"), 4);
            equal(groupingRows.eq(1).children(":not(.t-group-cell):first").attr("colspan"), 3);
        });

        test("hiding column decrease colspan of detail cells", function() {
            var grid = getGrid("#Grid2"),
                detailRows = grid.$tbody.children("tr.t-detail-row"),
                visibleColumns;
             
            grid.hideColumn("Gender");
            visibleColumns = $.grep(grid.columns, function(col) { return !col.hidden; });
            
            equal(detailRows.eq(0).children(".t-detail-cell").attr("colspan"), visibleColumns.length);            
        });
        
        test("showing last column creates col element", function() {
            var grid = getGrid(),
                headerCols,
                bodyCols,
                visibleColumns;
            grid.showColumn("Gender");

            headerCols = $("col:not(.t-group-col,.t-hierarchy-col)", grid.$header.parent().prev());
            bodyCols = $("col:not(.t-group-col,.t-hierarchy-col)", grid.$tbody.prev());
            visibleColumns = $.grep(grid.columns, function(col) { return !col.hidden; });

            equal(headerCols.length, visibleColumns.length);
            equal(bodyCols.length, visibleColumns.length);

        });

        test("showing column before last creates col element", function() {
            var grid = getGrid(),
                headerCols,
                bodyCols,
                visibleColumns;
            grid.showColumn("Name");

            headerCols = $("col:not(.t-group-col,.t-hierarchy-col)", grid.$header.parent().prev());
            bodyCols = $("col:not(.t-group-col,.t-hierarchy-col)", grid.$tbody.prev());
            visibleColumns = $.grep(grid.columns, function(col) { return !col.hidden; });

            equal(headerCols.length, visibleColumns.length);
            equal(bodyCols.length, visibleColumns.length);
        });

        test("showing column removes persisted width", function() {
            var grid = getGrid();

            grid.hideColumn("Name");
            grid.showColumn("Name");

            ok(!grid.columns[0].width);
        })

        test("showing column shows its header", function() {
            var grid = getGrid(),
                visibleColumns = $.grep(grid.columns, function(col) { return !col.hidden; }),
                th = grid.$columns().filter(":visible");

            equal(visibleColumns.length, th.length);
        });      

        test("showColumn shows column cells", function() {
            var grid = getGrid(),
                visibleColumns = $.grep(grid.columns, function(col) { return !col.hidden; }),
                td = grid.$tbody.find("tr:first>td:visible");

            equal(visibleColumns.length, td.length);
        });        

        test("hideColumn accepts column index as parameter", function() {
            var grid = getGrid(),
                column = grid.columns[0];

            grid.hideColumn(0);

            ok(column.hidden);
        });

        test("showColumn accpets column index as parameter", function() {
            var grid = getGrid(),
                column = grid.columns[0];

            grid.showColumn(0);

            ok(!column.hidden);
        });        

        test("hideColumn on hidden column, column remain hidden", function() {
            var grid = getGrid(),
                column = grid.columns[0];

            grid.hideColumn(0);
            grid.hideColumn(0);

            ok(column.hidden);
        });

        test("showColumn on visible column, column remain visible", function() {
            var grid = getGrid(),
                column = grid.columns[0];

            grid.showColumn(0);
            grid.showColumn(0);

            ok(!column.hidden);
        });

        test("hiding column adds style='display:none' to its attr", function() {
            var grid = getGrid(),
                column = grid.columns[0];

            grid.hideColumn(0);
            
            equal(column.attr, " style=\"display:none;\" ");
            grid.showColumn(0);
        });

        test("showing column removes 'display:none' style from its attr", function() {
            var grid = getGrid(),
                column = grid.columns[0];

            grid.hideColumn(0);
            grid.showColumn(0);
            
            equal(column.attr, " style=\"\" ");
            grid.showColumn(0);
        });

        test("showing column rendered hidden", function() {
            var grid = getGrid("#Grid3"),
                columns = grid.columns;

            grid.showColumn(0);

            equal($("col", grid.element).length, columns.length);
            equal($("th:visible", grid.element).length, columns.length);
            equal($("tr:first>td:visible", grid.$tbody).length, columns.length);
        });

        function grid4_dataBinding() {
            if (!populated) {
                var grid = getGrid('#Grid4');
                grid.ajax.selectUrl = "foo";
                $.mockjax({
                    url: "foo",
                    response: function() {                               
                        this.responseText = '{"data":[{"Key":0,"HasSubgroups":false,"Items":[{"Name":"Customer1","BirthDate":"\/Date(315525600000)\/","Active":true,"ReadOnly":0,"Gender":0,"IntegerValue":0,"Address":{"Street":"foo"}},{"Name":"Customer2","BirthDate":"\/Date(315612000000)\/","Active":false,"ReadOnly":0,"Gender":0,"IntegerValue":1,"Address":{"Street":"foo"}},{"Name":"Customer3","BirthDate":"\/Date(315698400000)\/","Active":false,"ReadOnly":0,"Gender":0,"IntegerValue":2,"Address":{"Street":"foo"}},{"Name":"Customer4","BirthDate":"\/Date(315784800000)\/","Active":false,"ReadOnly":0,"Gender":0,"IntegerValue":3,"Address":{"Street":"foo"}},{"Name":"Customer5","BirthDate":"\/Date(315871200000)\/","Active":false,"ReadOnly":0,"Gender":0,"IntegerValue":4,"Address":{"Street":"foo"}},{"Name":"Customer6","BirthDate":"\/Date(315957600000)\/","Active":false,"ReadOnly":0,"Gender":0,"IntegerValue":5,"Address":{"Street":"foo"}},{"Name":"Customer7","BirthDate":"\/Date(316044000000)\/","Active":false,"ReadOnly":0,"Gender":0,"IntegerValue":6,"Address":{"Street":"foo"}},{"Name":"Customer8","BirthDate":"\/Date(316130400000)\/","Active":false,"ReadOnly":0,"Gender":0,"IntegerValue":7,"Address":{"Street":"foo"}},{"Name":"Customer9","BirthDate":"\/Date(316216800000)\/","Active":false,"ReadOnly":0,"Gender":0,"IntegerValue":8,"Address":{"Street":"foo"}},{"Name":"Customer11","BirthDate":"\/Date(316389600000)\/","Active":false,"ReadOnly":0,"Gender":0,"IntegerValue":10,"Address":{"Street":"foo"}}],"Aggregates":{"IntegerValue":{"Sum":55}},"Subgroups":[]}],"total":11,"aggregates":{"IntegerValue":{"Sum":55}}}';
                    }
                });
            }
        }

        test("hidden columns have a hidden group footer cell with Ajax binding", function() {
            var grid = getGrid("#Grid4");

            $(grid.element).bind("dataBound", function() {                
                var visibleColumns = $.grep(grid.columns, function(col) { return !col.hidden; }).length,
                visibleFooterTDs = grid.$tbody.find(".t-group-footer:first>td:visible").length - 1;

                start();

                equal(visibleFooterTDs, visibleColumns);
            });

            stop();
        });

</script>

</asp:Content>
