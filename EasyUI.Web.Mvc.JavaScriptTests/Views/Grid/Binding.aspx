<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <%= Html.EasyUI().Grid(Model)
            .Name("Grid1")
            .Columns(columns =>columns.Bound(c => c.Name))
            .Ajax(settings => { })
            .Pageable(pager => pager.PageSize(10))
    %>
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid2")
            .Columns(columns =>
            {
                columns.Bound(c => c.Name).HtmlAttributes(new { dir="rtl" });
                columns.Bound(c => c.Name);
            })
            .Ajax(settings => { })
            .Pageable(pager => pager.PageSize(10))
    %>
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid3")
            .Columns(columns =>
            {
                columns.Bound(c => c.Name);
            })
            .Ajax(settings => { })
            .Pageable(pager => pager.PageSize(10))
    %>
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid4")
            .Columns(columns =>
            {
                columns.Bound(c => c.Name);
            })
            .Ajax(settings => { })
            .Pageable(pager => pager.PageSize(10))
    %>
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid5")
            .Columns(columns =>
            {
                columns.Bound(c => c.BirthDate);
            })
            .Ajax(settings => { })
            .Pageable(pager => pager.PageSize(10))
    %>
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid6")
            .Columns(columns =>
            {
                columns.Bound(c => c.BirthDate);
            })
            .Ajax(settings => { })
            .Pageable(pager => pager.PageSize(10))
    %>    
    
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid7")
            .Columns(columns =>
            {
                columns.Bound(c => c.Address);
                columns.Bound(c => c.Name).Encoded(false);
                columns.Bound(c => c.IntegerValue);
                columns.Bound(c => c.Name).Format("<strong>{0}</strong>");
            })
            .Ajax(settings => { })
            .Pageable(pager => pager.PageSize(10))
    %>

     <%= Html.EasyUI().Grid(Model)
            .Name("Grid8")
            .Columns(columns =>
            {
                columns.Bound(c => c.Address);
                columns.Bound(c => c.Name).Encoded(false);
                columns.Bound(c => c.IntegerValue);
                columns.Bound(c => c.Name).Format("<strong>{0}</strong>");
            })
            .DataBinding(binding => binding.Ajax().OperationMode(GridOperationMode.Client))            
            .Pageable(pager => pager.PageSize(10))
    %>
    <%= Html.EasyUI().Grid<Customer>()
            .Name("Grid9")
            .Columns(columns =>
            {
                columns.Bound(c => c.Address);
                columns.Bound(c => c.Name).Encoded(false);
                columns.Bound(c => c.IntegerValue);
                columns.Bound(c => c.Name).Format("<strong>{0}</strong>");
            })
            .DataBinding(binding => binding.Ajax().OperationMode(GridOperationMode.Client))
            .ClientEvents(events => events.OnDataBinding("grid9_dataBinding"))            
            .Pageable(pager => pager.PageSize(10))
    %>
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid10")
            .Columns(columns =>
            {
                columns.Bound(c => c.Address);
                columns.Bound(c => c.Name).Encoded(false);
                columns.Bound(c => c.IntegerValue);
                columns.Bound(c => c.Name).Format("<strong>{0}</strong>");
            })
            .DataBinding(binding => binding.Ajax().OperationMode(GridOperationMode.Client))            
            .Pageable(pager => pager.PageSize(10))    
    %>

    <%= Html.EasyUI().Grid(Model)
            .Name("Grid11")
            .Columns(columns =>
            {
                columns.ForeignKey(c => c.Name, new[] { new { Key = "Customer2", Value ="Customer Name" } }, "Key", "Value").Format("<strong>{0}</strong>");
                columns.ForeignKey(c => c.IntegerValue, new [] { new {Key = 1, Value = "Value1" } }, "Key", "Value" );                
            })
            .DataBinding(binding => binding.Ajax())            
    %>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">
        var populated;

        function getGrid(selector) {
            return $(selector || "#Grid1").data("tGrid");
        }

        module("Grid / Binding", {
            setup: function() {
                populated = false;
                $.mockjaxSettings.responseTime = 0;
            },
            teardown: function() {
                var grid = getGrid();
            
                $("tbody tr", grid.element).remove();
                for (var i = 0; i < 10; i++) {
                    $("<tr><td/></tr>").appendTo($("tbody", grid.element));
                }
                $.mockjaxClear();
            }
        });
        
        test('should removes rows when data length is less than page size', function() {
            var grid = getGrid();
            grid.dataBind([{}, {}]);

            equal($("tbody tr", grid.element).length, 2);
        });

        test('should create rows up to page size when they dont exist', function() {
            var grid = getGrid();
            $("tbody tr", grid.element).remove();
            grid.dataBind([{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}]);
            equal($("tbody tr", grid.element).length, 10);
        });
        
        test('should bind columns with same name', function() {
            var grid = getGrid("#Grid2");

            grid.dataBind([{ Name: "Test"}]);
            
            equal($("tbody tr td:last", grid.element).html(), "Test");
            equal($("tbody tr:last td:first", grid.element).html(), "Test");
        });
        
        test('should apply alt style', function() {
            var grid = getGrid();
            $("tbody tr", grid.element).remove();
            grid.dataBind([{}, {}]);
            equal($("tbody tr", grid.element).length, 2);
            equal($("tbody tr:nth-child(2)", grid.element).attr("class"), "t-alt");
        });
        
        test('should serialize attributes', function() {
            var grid = getGrid("#Grid2");
            
            equal(grid.columns[0].attr, ' dir="rtl"');
        });
        
        test('should apply column html attributes', function() {
            var grid = getGrid('#Grid2');
            $('tbody tr', grid.element).remove();
            grid.dataBind([{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}]);
            equal($('#Grid2 tbody tr:first td:first').attr('dir'), 'rtl');
        });

        test('rebind multiple arguments', function() {
            var grid = getGrid('#Grid2');
            var data;
            grid.ajaxRequest = function(additionalData) { data = additionalData; }
            grid.rebind({a:1,b:2});
            equal(data.a, 1);
            equal(data.b, 2);
        });

        test('binding to empty result clears the grid', function() {
            var grid = getGrid('#Grid3');
            grid.dataBind([]);
            equal($('tbody tr', grid.element).length, 1);
        });

        test('binding to empty result should return noRecords form localization', function() {
            var grid = getGrid('#Grid3');
            grid.dataBind([]);
            equal($('tbody td', grid.element).text(), grid.localization.noRecords);
        });

        test('binding to empty result should serialize noRecords', function() {
            var grid = getGrid('#Grid3');
            grid.dataBind([]);
            ok(grid.localization.noRecords != null);
        });

        test('binding to null result clears the grid', function() {            
            var grid = getGrid('#Grid4');
            grid.dataBind(null);
            equal($('tbody tr', grid.element).length, 1);
        });

        test('date time null binding', function() {
            var grid = getGrid('#Grid5');
            ok(null === grid.columns[0].value({BirthDate:null}));
        });

        test('binding to null shows empty string', function() {
            var grid = getGrid('#Grid6');
            $("tbody tr", grid.element).remove();

            grid.dataBind([{ BirthDate: null}]);
            equal($('tbody tr:first td:first', grid.element).html(), '');
        });

        test('encoded is serialized', function() {
            var grid = getGrid('#Grid7');

            ok(undefined === grid.columns[0].encoded);
            ok(!grid.columns[1].encoded);
        });        
        
        test('should display foreign value', function() {
            var grid = getGrid('#Grid11');
            equal(grid.displayFor(grid.columns[1])({IntegerValue:1}), 'Value1');
        });     

        test('should apply format to foreign value', function() {
            var grid = getGrid('#Grid11');
            equal(grid.displayFor(grid.columns[0])({Name:"Customer2"}), '&lt;strong&gt;Customer Name&lt;/strong&gt;');
        });     

        test('should encode html when binding', function() {
            var grid = getGrid('#Grid7');
            equal(grid.displayFor(grid.columns[0])({Address:'<strong>foo</strong>'}), '&lt;strong&gt;foo&lt;/strong&gt;');
        });        

        test('should not encode html when column is not encoded', function() {
            var grid = getGrid('#Grid7');
            equal(grid.displayFor(grid.columns[1])({Name:'<strong>foo</strong>'}), '<strong>foo</strong>');
        });
        
        test('encoding and numeric columns', function() {
            var grid = getGrid('#Grid7');
            equal(grid.displayFor(grid.columns[2])({IntegerValue:1}), '1');
        });        
        
        test('encoding and zero', function() {
            var grid = getGrid('#Grid7');
            equal(grid.displayFor(grid.columns[2])({IntegerValue:0}), '0');
        });        
        
        test('encoding and null', function() {
            var grid = getGrid('#Grid7');
            equal(grid.displayFor(grid.columns[0])({Address:null}), '');
        });        
        
        test('encoding and undefined', function() {
            var grid = getGrid('#Grid7');
            equal(grid.displayFor(grid.columns[0])({}), '');
        });

        test('should encode html when format is set', function() {
            var grid = getGrid('#Grid7');
            equal(grid.displayFor(grid.columns[3])({Name:'foo'}), '&lt;strong&gt;foo&lt;/strong&gt;');
        });

        test('dataBind should raise repaint event', function() {
            var grid = getGrid('#Grid6');
            var raised = false;
            $(grid.element).bind('repaint', function() { raised = true; });
            grid.dataBind([{ BirthDate: null}]);
            equal(raised, true);
        });

        test("rebind using client operation mode and initially populated grid should make request", function() {        
            var grid = getGrid('#Grid8');

            grid.ajax.selectUrl = "foo";

            $.mockjax({
                url: "foo",
                response: function() {
                    ok(true);
                    start();                    
                    this.responseText = '{"data":[], "total": 0 }';
                }
            });
            grid.rebind({foo: "bar"});
            stop(1000);
        });

        test("ajaxRequest using client operation mode and initially populated grid should not make request", function() {            
            var grid = getGrid('#Grid8'),
                called = false;

            grid.ajax.selectUrl = "foo";            
            $.mockjax({
                url: "foo",
                response: function() {                    
                    called = true;
                    this.responseText = '{"data":[], "total": 0 }';
                }
            });
            grid.ajaxRequest({foo: "bar"});
            stop(1000);

            ok(!called);
            start();
        });
        
        function grid9_dataBinding() {
            if (!populated) {
                var grid = getGrid('#Grid9');
                grid.ajax.selectUrl = "foo";
                $.mockjax({
                    url: "foo",
                    response: function() {                               
                        this.responseText = '{"data":[], "total": 0 }';
                    }
                });
            }
        }

        test("rebind using client operation mode and not initially populated grid should make request", function() {        
            var grid = getGrid('#Grid9');

            grid.ajax.selectUrl = "foo";

            $.mockjax({
                url: "foo",
                response: function() {
                    ok(true);
                    start();                    
                    this.responseText = '{"data":[], "total": 0 }';
                }
            });
            grid.rebind({foo: "bar"});
            stop(1000);
        });

        test("ajaxRequest using client operation mode and not initially populated grid should make request", function() {
            var grid = getGrid('#Grid9'),
                called = false;

            grid.ajax.selectUrl = "foo";            
            $.mockjax({
                url: "foo",
                response: function() {                    
                    ok(true)
                    start();
                    this.responseText = '{"data":[], "total": 0 }';
                }
            });
            grid.ajaxRequest({foo: "bar"});
            stop(1000);      
        });

        test("data of not grouped paged grid with operation mode client and initial server binding", function() {
            var grid = getGrid("#Grid10");
            equal(grid.data.length, 10);
            equal(grid.dataSource.data().length, 20);            
        });

        test("dataBinding event is raised when refresh button is clicked", function() {
            var grid = getGrid("#Grid10"),
                called = false;

            $(grid.element).bind("dataBinding", function() {
                called = true;
            });

            grid.refreshClick($.Event("click"));

            ok(called);
        });
    </script>

</asp:Content>