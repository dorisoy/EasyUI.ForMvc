<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        Navigation</h2>
    <%= Html.EasyUI().Grid<EasyUI.Web.Mvc.JavaScriptTests.Customer>()
            .Name("Grid")
            .Columns(columns =>
            {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.BirthDate.Day);
            })
            .Pageable()
            .Ajax(settings => { })
            .BindTo((List<Customer>)ViewData["moreData"])
            .KeyboardNavigation()
    %>
    <%= Html.EasyUI().Grid<EasyUI.Web.Mvc.JavaScriptTests.Customer>()
            .Name("Grid_ServerSelect")
            .DataKeys(keys => keys.Add("Name"))
            .Columns(columns =>
            {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.BirthDate.Day);
                columns.Command(cmd => cmd.Select());
            })            
            .BindTo((List<Customer>)ViewData["moreData"])
            .KeyboardNavigation()
    %>
    <%= Html.EasyUI().Grid<EasyUI.Web.Mvc.JavaScriptTests.Customer>()
            .Name("Grid_ClientSelect")
            .DataKeys(keys => keys.Add("Name"))
            .Columns(columns =>
            {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.BirthDate.Day);                
            })
            .Selectable()
            .BindTo((List<Customer>)ViewData["moreData"])
            .KeyboardNavigation()
    %>
    <%= Html.EasyUI().Grid<EasyUI.Web.Mvc.JavaScriptTests.Customer>()
            .Name("Grid_Grouped")
            .DataKeys(keys => keys.Add("Name"))
            .Columns(columns =>
            {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.BirthDate.Day);                
            })
            .Groupable(groups =>
            {
                groups.Groups(group => group.Add(c => c.Name));
            })
            .BindTo((List<Customer>)ViewData["moreData"])
            .KeyboardNavigation()
    %>
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid_Editable")
            .DataKeys(keys => keys.Add("Name"))
            .Columns(columns =>
            {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.Address);
                columns.Command(commands =>
                {
                    commands.Edit();
                });
            })
            .DataBinding(binding => binding.Ajax()
                .Select("Select", "Dummy")               
                .Update("Update", "Dummy")
            )
            .Editable(editing => editing.Mode(GridEditMode.InLine))
            .Pageable(pager => pager.PageSize(10))
            .KeyboardNavigation()
    %>
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid_BatchEditing")
            .DataKeys(keys => keys.Add(c => c.Name))            
            .Columns(columns => 
                {
                    columns.Bound(c => c.Name);
                    columns.Bound(c => c.BirthDate);
                    columns.Bound(c => c.ReadOnly);
                    columns.Command(commands =>
                    {
                        commands.Edit();                        
                    });
                })
            .DataBinding(binding => binding.Ajax()
                        .Select("GroupingAjax", "Grid")
                                .Update("GroupingAjax", "Grid")
            )
            .Editable(editing => editing.Mode(GridEditMode.InCell))
            .Pageable(pager => pager.PageSize(10))
            .KeyboardNavigation()
    %>
</asp:Content>
<asp:Content ContentPlaceHolderID="TestContent" runat="server">
    <script type="text/javascript">
        var keys = {
            BACKSPACE: 8,
            TAB: 9,
            ENTER: 13,
            ESC: 27,
            LEFT: 37,
            UP: 38,
            RIGHT: 39,
            DOWN: 40,
            END: 35,
            HOME: 36,
            SPACEBAR: 32,
            PAGEUP: 33,
            PAGEDOWN: 34
        };
        var FOCUSED = "t-state-focused";
        var grid;

        function getGrid(selector) {
            return $(selector).data("tGrid");
        }

        $.each('edit,cancel,update,insert'.split(','), function (index, command) {
            window[command] = function (selector) {
                $(selector || '#Grid').find('.t-grid-' + command + ':first').click();
            }
        });

        $.fn.press = function (key, ctrl, shift) {
            return this.trigger({ type: "keydown", keyCode: key, ctrlKey: ctrl, shiftKey: shift });
        }

        module("Grid / Navigation", {
            setup: function () {
                grid = getGrid("#Grid");
            },
            teardown: function () {
                $("td." + FOCUSED, getGrid("#Grid").element).removeClass(FOCUSED);
                grid._current = null;

                getGrid("#Grid_BatchEditing")._current = null;
                getGrid("#Grid_BatchEditing").cancelChanges();
            }
        });

        test("tabIndex is set to 0", function () {
            var element = $(grid.element);

            equal(element.attr("tabIndex"), 0);
        });

        test("focusing grid element focus first cell", function () {
            var element = $(grid.element);

            element.focus();
            ok($(">tr>td", grid.$tbody).first().is("." + FOCUSED));
        });

        test("focusing grid element does not change focus cell if cell with t-state-focused", function () {
            var element = $(grid.element);

            $(">tr>td", grid.$tbody).eq(1).addClass(FOCUSED);
            element.focus();
            ok($("td." + FOCUSED, grid.$tbody).index(), 1);
        });

        test("focusing grouped grid element focus first data cell", function () {
            grid = getGrid("#Grid_Grouped");
            $(grid.element).focus();

            ok($("tr:not(.t-grouping-row)>td:not(.t-group-cell)", grid.$tbody).first().is("." + FOCUSED));
        });

        test("focused state is removed on blur", function () {
            var element = $(grid.element);

            element.focus().trigger("focusout");
            ok(!element.find(">table>tbody>tr>td").first().is("." + FOCUSED));
        });

        test("focused state is maintained after refocus", function () {
            var element = $(grid.element);
            element.focus().blur().focus();

            ok(element.find(">table>tbody>tr>td").first().is("." + FOCUSED));
        });

        test("clicking a child focuses it", function () {
            var element = $(grid.element),
                cell = element.find(">table>tbody>tr>td").last();
            cell.mousedown().click();

            ok(cell.last().is("." + FOCUSED));
        });

        test("down arrow moves focus on the next row same cell", function () {
            var element = $(grid.element),
                table = grid.$tbody.parent();
            element.focus().press(keys.DOWN);

            ok(table.find("tbody tr:eq(1)").find("td").hasClass(FOCUSED));
            equal(table.find("." + FOCUSED).length, 1);
        });

        test("right arrow moves focus on the next cell on the same row", function () {
            var element = $(grid.element),
                table = grid.$tbody.parent();
            element.focus().press(keys.RIGHT);

            ok(table.find("tbody tr:eq(0)").find("td:eq(1)").hasClass(FOCUSED));
        });

        test("left arrow moves focus on the prev cell on the same row", function () {
            var element = $(grid.element),
                table = grid.$tbody.parent();
            element.focus().press(keys.RIGHT).press(keys.LEFT);

            ok(table.find("tbody tr:eq(0)").find("td:eq(0)").hasClass(FOCUSED));
        });

        test("up arrow moves focus on the prev row same cell", function () {
            var element = $(grid.element),
                table = grid.$tbody.parent();
            element.focus().press(keys.DOWN).press(keys.UP);

            ok(table.find("tbody tr:eq(0)").find("td").hasClass(FOCUSED));
        });

        test("pageDOWN should page to the next page", function () {
            var element = $(grid.element),
                dataBindingWasCalled = false,
                dataBindingHandler = function (e) {
                    e.preventDefault();
                    equal(e.page, 2);
                    dataBindingWasCalled = true;
                };

            element.bind("dataBinding", dataBindingHandler);

            element.focus().press(keys.PAGEDOWN);
            ok(dataBindingWasCalled);

            element.unbind("dataBinding", dataBindingHandler);
        });

        test("pageUP should page to the prev page", function () {
            var element = $(grid.element),
                origAjaxRequest = grid.ajaxRequest;
            grid.ajaxRequest = $.noop;

            $(".t-grid-pager", element).find("a:not(.currentPage)").click();
            element.focus().press(keys.PAGEUP);

            grid.ajaxRequest = origAjaxRequest;
            equal(grid.currentPage, 1);
        });

        test("space should select current row with client-selection", function () {
            var grid = getGrid("#Grid_ClientSelect"),
                element = $(grid.element);
            element.focus().press(keys.SPACEBAR);

            ok(element.find("tbody>tr").eq(0).is(".t-state-selected"));
        });

        test("enter puts current row in edit", function () {
            var grid = getGrid("#Grid_Editable"),
                element = $(grid.element);
            element.focus().press(keys.ENTER);

            ok(element.find("tbody>tr").eq(0).is(".t-grid-edit-row"));

            cancel("#Grid_Editable");
        });

        test("enter focus first input in edited row", function () {
            var grid = getGrid("#Grid_Editable"),
                element = $(grid.element);
            grid._current = null;
            element.focus().press(keys.ENTER);

            ok(element.find("tbody>tr :input").eq(0).is(":focus"));

            cancel("#Grid_Editable");
        });

        test("esc cancel currunt row editing", function () {
            var grid = getGrid("#Grid_Editable"),
                element = $(grid.element);
            element.focus().press(keys.ENTER);
            element.focus().press(keys.ESC);

            ok(element.find("tbody>tr").eq(0).is(":not(.t-grid-edit-row)"));
        });

        test("enter with InCell editing puts current cell in edit mode", function () {
            var grid = getGrid("#Grid_BatchEditing"),
                element = $(grid.element);

            element.focus().press(keys.ENTER);

            ok(element.find("tr>td:first").is(".t-grid-edit-cell"));

            element.press(keys.ESC);
        });

        test("enter with InCell editing when current cell is in edit mode saves changes", function () {
            var grid = getGrid("#Grid_BatchEditing"),
                element = $(grid.element);

            element.focus().press(keys.ENTER).press(keys.ENTER);

            var cell = element.find("tr>td:first");
            ok(cell.is(":not(.t-grid-edit-cell)"));
            ok(cell.is("." + FOCUSED));
        });

        test("esc with InCell editing for already edited cell cancel changes", function () {
            var grid = getGrid("#Grid_BatchEditing"),
                element = $(grid.element);
            element.focus().press(keys.ENTER).press(keys.ESC);

            var cell = element.find("tr>td:first");
            ok(cell.is(":not(.t-grid-edit-cell)"));
            ok(cell.is("." + FOCUSED));
        });

        test("tab with InCell editing for already edited cell saves changes and move right", function () {
            var grid = getGrid("#Grid_BatchEditing"),
                element = $(grid.element);

            element.focus().press(keys.ENTER).press(keys.TAB);

            var cell = element.find("tr>td:first");
            ok(cell.is(":not(.t-grid-edit-cell)"));
            ok(cell.next().is("." + FOCUSED));
        });        
    </script>
</asp:Content>
