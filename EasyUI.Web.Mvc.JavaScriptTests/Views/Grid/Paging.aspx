<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        Paging</h2>
    <%= Html.EasyUI().Grid<EasyUI.Web.Mvc.JavaScriptTests.Customer>()
            .Name("Grid_DefaultPager")
            .Columns(columns =>
            {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.BirthDate.Day);
            })
            .Ajax(settings => { })
			.BindTo((List<Customer>)ViewData["moreData"])
            .Pageable(pager => pager.PageSize(1))				   
    %>
    <%= Html.EasyUI().Grid<EasyUI.Web.Mvc.JavaScriptTests.Customer>()
            .Name("Grid_NextPrevAndInputPager")
            .Columns(columns =>
            {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.BirthDate.Day);
            })
            .Ajax(delegate{})
			.BindTo((List<Customer>)ViewData["lessData"])
			.Pageable(pager => pager.PageSize(1).Style(GridPagerStyles.NextPreviousAndInput))
    %>
    <%= Html.EasyUI().Grid<EasyUI.Web.Mvc.JavaScriptTests.Customer>()
            .Name("Grid_UpdatePager")
            .Columns(columns =>
            {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.BirthDate.Day);
            })
            .Ajax(settings => { })
            .BindTo((List<Customer>)ViewData["moreData"])
            .Pageable()
    %>
    <%= Html.EasyUI().Grid<EasyUI.Web.Mvc.JavaScriptTests.Customer>()
            .Name("Grid_TopAndBottomPager")
            .Columns(columns =>
            {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.BirthDate.Day);
            })
            .Ajax(settings => { })
            .BindTo((List<Customer>)ViewData["moreData"])
            .Pageable(pager => pager.Position(GridPagerPosition.Both))
    %>
    <%= Html.EasyUI().Grid<EasyUI.Web.Mvc.JavaScriptTests.Customer>()
            .Name("Grid_LoadOnScroll")
            .Columns(columns =>
            {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.BirthDate.Day);
            })
            .Ajax(settings => { })
            .BindTo((List<Customer>)ViewData["moreData"])
            .Pageable(pager => {
                pager.PageOnScroll(true);
                pager.Style(GridPagerStyles.Status);
            })            
            .Scrollable()
    %>
    <div id="dummyGrid">
    </div>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

        var gridElement;

        function getGrid(selector) {
            return $(selector).data("tGrid");
        }
        
        function createGrid(gridElement, options)
        {
             options = $.extend({}, $.fn.tGrid.defaults, options);
             return new $.easyui.grid(gridElement, options);
        }    

        module("Grid / Paging", {
            setup: function() {
                gridElement = document.createElement("div");
                gridElement.id = "tempGrid";
            },
            teardown: function() {
                gridElement = null;

                $("#Grid_DefaultPager .t-arrow-next").parent().removeClass("t-state-disabled");
                $("#Grid_DefaultPager .t-arrow-last").parent().removeClass("t-state-disabled");
                $("#Grid_DefaultPager .t-arrow-prev").parent().add("t-state-disabled");
                $("#Grid_DefaultPager .t-arrow-first").parent().add("t-state-disabled");
                $("#Grid_DefaultPager .t-pager .t-state-active").removeClass("t-state-active");
                $("#Grid_DefaultPager .t-pager .t-link").eq(0).addClass("t-state-active");

                $("#Grid_NextPrevAndInputPager .t-arrow-next").parent().removeClass("t-state-disabled");
                $("#Grid_NextPrevAndInputPager .t-arrow-last").parent().removeClass("t-state-disabled");
                $("#Grid_NextPrevAndInputPager .t-arrow-prev").parent().add("t-state-disabled");
                $("#Grid_NextPrevAndInputPager .t-arrow-first").parent().add("t-state-disabled");

                $("#Grid_NextPrevAndInputPager .t-pager input[type=text]").val(1);
                $("#Grid_NextPrevAndInputPager .t-status-text").text("Displaying items 1 - 1 of 2");

                getGrid("#Grid_DefaultPager").currentPage = 1;
                getGrid("#Grid_NextPrevAndInputPager").currentPage = 1;
            }
        });

        test('grid object is initialized', function() {
            var grid = getGrid("#Grid_DefaultPager");
            ok(null !== grid);
            ok(undefined !== grid);
        });

        test('grid colum names are initialized', function() {
            var grid = getGrid("#Grid_DefaultPager");
            equal(grid.columns[0].member, "Name");
            equal(grid.columns[1].member, "BirthDate.Day");
        });

        test('createColumnMappings maps data fields to column', function() {
            var grid = createGrid(gridElement, { columns: [
                { member: "Name" },
                { member: "Id" }
            ]
            
            });

            var dataItem = { Id: 1, Name: "John" };
            grid.initializeColumns(dataItem);
            var nameMapping = grid.columns[0].display;
            ok(undefined !== nameMapping);
            equal(nameMapping(dataItem), dataItem.Name);
        });

        test('bind populates from data', function() {
            var grid = getGrid("#Grid_DefaultPager");
            var data = [{ Name: "Test", BirthDate: { Day: 1}}];

            grid.dataBind(data);
            equal($("#Grid_DefaultPager tbody tr:nth-child(1) td:nth-child(1)").text(), "Test");
            equal($("#Grid_DefaultPager tbody tr:nth-child(1) td:nth-child(2)").text(), "1");
        });

        test('page size serialized', function() {
            var grid = getGrid("#Grid_DefaultPager");
            equal(grid.pageSize, 1);
        });

        test('update pager next disabled on last page', function() {
            var grid = getGrid("#Grid_NextPrevAndInputPager");
            grid.currentPage = 2;
            grid.updatePager(2);
            ok($("#Grid_NextPrevAndInputPager .t-arrow-next").parent().hasClass("t-state-disabled"));
        });

        test('total pages when page size divides total without remainder', function() {
            var grid =createGrid(gridElement, { pageSize: 10 });
            grid.total = 20;
            equal(grid.totalPages(), 2);
        });

        test('total pages when page size divides total with remainder', function() {
            var grid =createGrid(gridElement, { pageSize: 10 });
            grid.total = 19;
            equal(grid.totalPages(), 2);
        });

        test('total when total is less than page size', function() {
            var grid =createGrid(gridElement, { pageSize: 10 });
            grid.total = 9;
            equal(grid.totalPages(), 1);
        });

        test('total when total is zero', function() {
            var grid =createGrid(gridElement, { pageSize: 10 });
            grid.total = 0;
            equal(grid.totalPages(), 0);
        });

        test('update default pager sets the text', function() {
            var grid = getGrid("#Grid_NextPrevAndInputPager");
            grid.currentPage = 2;
            grid.updatePager();

            equal($("#Grid_NextPrevAndInputPager .t-pager input[type=text]").val(), "2");
        });

        test('clicking next increments current page', function() {

            var grid = getGrid("#Grid_DefaultPager");
            grid.ajaxRequest = function() { };
            $("#Grid_DefaultPager .t-arrow-next").parent().trigger("click");
            equal(grid.currentPage, 2);
        });

        test('clicking last set the page to last', function() {
            var grid = getGrid("#Grid_NextPrevAndInputPager");
            grid.ajaxRequest = function() { };
            $("#Grid_NextPrevAndInputPager .t-arrow-last").parent().trigger("click");
            equal(grid.currentPage, 2);
        });

        test('current page is one by default', function() {
            var grid = getGrid("#Grid_DefaultPager");
            equal(grid.currentPage, 1);
        });

        test('update pager last button disabled on last page', function() {
            var grid = getGrid("#Grid_NextPrevAndInputPager");
            grid.currentPage = 2;
            grid.updatePager(2);
            ok($("#Grid_NextPrevAndInputPager .t-arrow-last").parent().hasClass("t-state-disabled"));
        });

        test('update pager prev button enabled on last page', function() {
            var grid = getGrid("#Grid_DefaultPager");
            grid.currentPage = 2;
            grid.updatePager(2);
            ok(!$("#Grid_DefaultPager .t-arrow-prev").parent().hasClass("t-state-disabled"));
        });

        test('update pager first button enabled on last page', function() {
            var grid = getGrid("#Grid_DefaultPager");
            grid.currentPage = 2;
            grid.updatePager(2);
            ok(!$("#Grid_DefaultPager .t-arrow-first").parent().hasClass("t-state-disabled"));
        });

        test('clicking prev goes to previous page', function() {
            var grid = getGrid("#Grid_DefaultPager");
            grid.ajaxRequest = function() { };
            grid.currentPage = 2;
            grid.updatePager(2);

            $("#Grid_DefaultPager .t-arrow-prev").parent().trigger("click");
            equal(grid.currentPage, 1);
        });

        test('clicking first goes to first page', function() {
            var grid = getGrid("#Grid_DefaultPager");
            grid.ajaxRequest = function() { };
            grid.currentPage = 2;
            grid.updatePager(2);

            $("#Grid_DefaultPager .t-arrow-first").parent().trigger("click");
            equal(grid.currentPage, 1);
        });

        test('firstItemInPage first page', function() {
            var grid =createGrid(gridElement, { currentPage: 1, pageSize: 10, total: 20 });
            equal(grid.firstItemInPage(), 1);
        });

        test('firstItemInPage when total is 0', function() {
            var grid = createGrid(gridElement, { currentPage: 1, pageSize: 10, total: 0 });
            equal(grid.firstItemInPage(), 0);
        });
        test('firstItemInPage second page', function() {
            var grid =createGrid(gridElement, { currentPage: 2, pageSize: 10, total: 20 });
            equal(grid.firstItemInPage(), 11);
        });

        test('lastItemInPage first page', function() {
            var grid =createGrid(gridElement, { currentPage: 1, pageSize: 10, total: 20 });
            equal(grid.lastItemInPage(), 10);
        });

        test('lastItemInPage last page', function() {
            var grid =createGrid(gridElement, { currentPage: 2, pageSize: 10, total: 20 });
            equal(grid.lastItemInPage(), 20);
        });

        test('last itemInPage last page page size divides total with remainder', function() {
            var grid =createGrid(gridElement, { currentPage: 2, pageSize: 10, total: 19 });
            equal(grid.lastItemInPage(), 19);
        });

        test('sanitizePage returns the value if valid integer below total pages', function() {
            var grid =createGrid(gridElement, { currentPage: 2, pageSize: 10, total: 19 });
            equal(grid.sanitizePage("1"), 1);
        });

        test('sanitizePage returns currentPage when the value is not a number', function() {
            var grid =createGrid(gridElement, { currentPage: 2, pageSize: 10, total: 19 });
            equal(grid.sanitizePage("something"), 2);
        });

        test('sanitizePage returns currentPage when the value is a negative number or zero', function() {
            var grid =createGrid(gridElement, { currentPage: 2, pageSize: 10, total: 19 });
            equal(grid.sanitizePage("-1"), 2);
            equal(grid.sanitizePage("0"), 2);
        });

        test('sanitizePage returns whole fraction when the value is floating point', function() {
            var grid =createGrid(gridElement, { currentPage: 2, pageSize: 10, total: 19 });
            equal(grid.sanitizePage("2.5"), 2);
        });

        test('sanitizePage returns total pages if number is bigger than total pages', function() {
            var grid =createGrid(gridElement, { currentPage: 2, pageSize: 10, total: 19 });
            equal(grid.sanitizePage("3"), 2);
        });

        test('pressing enter in pager text box pages', function() {
            var grid = getGrid("#Grid_NextPrevAndInputPager");
            grid.ajaxRequest = function() { };
            $("#Grid_NextPrevAndInputPager .t-pager input").val("2").trigger({ type: "keydown", keyCode: 13 });
            equal(grid.currentPage, 2);
        });

        test('query string parameter names are set by default', function() {
            var grid = getGrid("#Grid_DefaultPager");
            equal(grid.queryString.page, "page");
            equal(grid.queryString.size, "size");
            equal(grid.queryString.orderBy, "orderBy");
        });

        test('numeric page buttons decreased when total is less than initial', function() {
            var grid = getGrid("#Grid_UpdatePager");

            grid.total = 10;
            grid.data = [];
            grid._populate(grid.data);

            equal($(".t-numeric", grid.element).children().length, 1);
        });
        test('numeric pager when current page is less than total number of numeric buttons', function() {
            var grid = getGrid("#Grid_UpdatePager");
            var pager = $(".t-pager .t-numeric", grid.element);

            grid.numericPager(pager[0], 1, 10);
            equal(pager.children().length, 10);
            equal(pager.children().eq(0).attr("class"), 't-state-active');
        });

        test('numeric pager when current page is on the second set of numeric page buttons', function() {
            var grid = getGrid("#Grid_UpdatePager");
            var pager = $(".t-pager .t-numeric", grid.element);
            grid.numericPager(pager[0], 11, 21);
            equal(pager.children().length, 12);
            equal(pager.children().eq(1).attr("class"), 't-state-active');
        });

        test('numeric pager when current page is on the third set of numeric page buttons', function() {
            var grid = getGrid("#Grid_UpdatePager");
            var pager = $(".t-pager .t-numeric", grid.element);
            grid.numericPager(pager[0], 21, 31);
            equal(pager.children().length, 12);
            equal(pager.children().eq(1).attr("class"), 't-state-active');
        });

        test('top pager diplaying items update after paging', function() {
            var grid = getGrid("#Grid_TopAndBottomPager");
            grid.ajaxRequest = function () { };
            grid.currentPage = 2;
            grid.updatePager(2);

            var displayingItemsText = $("#Grid_TopAndBottomPager .t-status-text:first").text()

            $("#Grid_TopAndBottomPager .t-arrow-next").parent().trigger("click");

            equal(displayingItemsText, 'Displaying items 11 - 20 of 20');
        });

        test("data is populated with initial binding data", function() {
            var grid = getGrid("#Grid_LoadOnScroll"),
                data = grid.data;
            
            equal(data.length, grid.pageSize);
        });

        test("pageTo is called if scroll to bottom", function() {
            var grid = getGrid("#Grid_LoadOnScroll"),
                origPageTo = grid.pageTo,
                scrollWasCalled = false,
                gridContent = $("> .t-grid-content", grid.element)[0];
            
            grid.pageTo = function() {            
                scrollWasCalled = true;                
            };
            gridContent.scrollTop = gridContent.scrollHeight;            
            $(gridContent).trigger("scroll");

            gridContent.scrollTop = 0;
            grid.pageTo = origPageTo;

            ok(scrollWasCalled);
        });

        test("pageTo is not called if on last page", function() {
            var grid = getGrid("#Grid_LoadOnScroll"),
                origPageTo = grid.pageTo,
                scrollWasCalled = false,
                gridContent = $("> .t-grid-content", grid.element)[0];
            
            grid.pageTo = function() {            
                scrollWasCalled = true;                
            };
            gridContent.scrollTop = gridContent.scrollHeight;
            grid.currentPage = grid.totalPages();
            $(gridContent).trigger("scroll");

            gridContent.scrollTop = 0;
            grid.pageTo = origPageTo;

            ok(!scrollWasCalled);
        });

        test("pageTo with loadOnScroll accumulate the data", function() {
             var grid = getGrid("#Grid_LoadOnScroll"),
                origAjaxRequest = grid.ajaxRequest,
                data;

            grid.ajaxRequest = function() {
                grid.dataSource._view = grid.data;
                grid._dataChange();
            };
            grid.pageTo(2);
            data = grid.data;

            equal(data.length, 20);

            grid.ajaxRequest = origAjaxRequest;
        });
</script>

</asp:Content>