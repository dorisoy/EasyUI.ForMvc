<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <input type="text" id="NumericTextBoxStandalone" value="123" />

    <%= Html.EasyUI().Grid(Model)
            .Name("Grid1")
            .Columns(columns =>
            {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.BirthDate.Date).Format("{0:d}");
                columns.Bound(c => c.BirthDate.Day);
                columns.Bound(c => c.Active);
                columns.Bound(c => c.BirthDate.DayOfWeek).Filterable(false);
                columns.Bound(c => c.BirthDate.DayOfYear);
                columns.Bound(c => c.Gender);
            })
            .Ajax(settings => { })
            .Pageable()
            .Filterable()
    %>
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid2")
            .Columns(columns =>
            {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.BirthDate.Date).Format("{0:d}");
                columns.Bound(c => c.BirthDate.Day);
                columns.Bound(c => c.Active);
                columns.Bound(c => c.BirthDate.DayOfWeek).Filterable(false);
                columns.Bound(c => c.BirthDate.DayOfYear);
                columns.Bound(c => c.Gender);
            })
            .Ajax(settings => { })
            .Pageable()
            .Filterable(filtering => filtering.Filters(filters =>
                {
                    filters.Add(c => c.BirthDate.DayOfYear).IsGreaterThanOrEqualTo(1).And().IsLessThanOrEqualTo(1);
                    filters.Add(c => c.Name).Contains("Customer1").And().EndsWith("Customer1");
                    filters.Add(c => c.Active).IsEqualTo(true);
                    filters.Add(c => c.Gender).IsEqualTo(EasyUI.Web.Mvc.JavaScriptTests.Gender.Female).And().IsNotEqualTo(EasyUI.Web.Mvc.JavaScriptTests.Gender.Male);
                }))
    %>
    
    <%= Html.EasyUI().Grid(Model)
        .Name("Grid3")
        .Columns(columns =>
        {
            columns.Bound(c => c.BirthDate.Date).Format("{0:dd-MM-yyyy}");
        })
        .Ajax(settings => { })
        .Pageable()
        .Filterable()
    %>
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid4")
            .Columns(columns =>
            {
                columns.Bound(c => c.Name);
            })
            .Ajax(settings => { })
            .Pageable()
            .Filterable(filtering => filtering.Filters(filters => filters.Add(c => c.Name).IsEqualTo("Customer1")))
    %>
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid5")
            .Columns(columns =>
            {
                columns.Bound(c => c.BirthDate);
            })
            .Ajax(settings => { })
            .Pageable()
            .Filterable(filtering => filtering.Filters(filters => filters.Add(c => c.BirthDate).IsEqualTo(new DateTime(1980, 1, 1))))
    %>
    
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

        function getGrid(selector) {
            return $(selector || "#Grid1").data("tGrid");
        }

        function getNumericTextBox() {
            if ($("#NumericTextBoxStandalone").data("tTextBox") === undefined) {
                $(document.documentElement).css( {'font-size': '12px', 'line-height': 'normal', 'font-family': 'sans-serif' } );
                $("#NumericTextBoxStandalone").tTextBox({ type: 'numeric', minValue: null, maxValue: null, numFormat: '', groupSeparator: '' });
            }

            return $("#NumericTextBoxStandalone").data("tTextBox");
        }

        module("Grid / Filtering", {
            setup: function() {
                getGrid().ajaxRequest = function() {};
                getGrid('#Grid2').ajaxRequest = function() {};
                getGrid('#Grid3').ajaxRequest = function() {};
                getGrid('#Grid4').ajaxRequest = function() {};
                getGrid('#Grid5').ajaxRequest = function() {};
            },
            teardown: function() {
                var grid = getGrid();
                $.each(grid.columns, function() { this.filters = null });
                $('.t-grid-filter', grid.element).removeClass('t-active-filter').removeData('filter');
                $('.t-filter-options', grid.element).parent().remove();
                grid.filterBy = null;
            }
        });
        
        test('single filter expr for one column', function() {
            var grid = getGrid();
            
            grid.columns[0].filters = [
            {
                operator: "eq",
                value:"10"
            }];
            
            equal(grid.filterExpr(), "Name~eq~'10'")
        });
        
        test('filter expr for bool column', function() {
            var grid = getGrid();
            
            grid.columns[3].filters = [
            {
                operator: "eq",
                value:true
            }];
            
            equal(grid.filterExpr(), "Active~eq~true")
        });

        test('filter expr for enum column', function() {
            var grid = getGrid();

            grid.columns[grid.columns.length - 1].filters = [
            {
                operator: "eq",
                value: 1
            }];

            equal(grid.filterExpr(), "Gender~eq~1")
        });
        
        test('single filter expr for one column when operator is function', function() {
            var grid = getGrid();
            
            grid.columns[0].filters = [
            {
                operator: "startswith",
                value:"10"
            }];
            
            equal(grid.filterExpr(), "Name~startswith~'10'")
        });
        
        test('two filters for one column', function() {
            var grid = getGrid();
            
            grid.columns[0].filters = [{
                operator: "startswith",
                value:"10"
            },
            {
                operator: "eq",
                value:"10"
            }];
            
            equal(grid.filterExpr(), "Name~startswith~'10'~and~Name~eq~'10'")
        });
        
        test('encode number', function() {
            var grid = getGrid();
            var encoded = grid.encodeFilterValue(grid.columns[2], 10);
            equal(encoded, 10);
        });
        
        test('encode string', function() {
            var grid = getGrid();
            var encoded = grid.encodeFilterValue(grid.columns[0], "test");
            equal(encoded, "'test'");
        });
        
        test('escape quotes in string', function() {
            var grid = getGrid();
            var encoded = grid.encodeFilterValue(grid.columns[0], "t'est");
            equal(encoded, "'t''est'");
        });
        
        test('encode date', function() {
            var grid = getGrid();
            
            var encoded = grid.encodeFilterValue(grid.columns[1], '10/11/2000');
            equal(encoded, "datetime'2000-10-11T00-00-00'");
        });
        
        test('validate Date fails when invalid date string', function() {
            var grid = getGrid();
            ok(!grid.isValidFilterValue(grid.columns[1], "string"));
        });

        test('validate Date succeeds when valid date string', function() {
            var grid = getGrid();
            ok(grid.isValidFilterValue(grid.columns[1], "10/11/2000"));
        });

        test('validate Date succeeds when valid date literal', function() {
            var grid = getGrid();
            ok(grid.isValidFilterValue(grid.columns[1], "\/Date(1265752800000)\/"));
        });        
        
        test('validate number succeeds when whole number', function() {
            var grid = getGrid();
            ok(grid.isValidFilterValue(grid.columns[2], "1"));
        });

        test('validate number succeeds when decimal number', function() {
            var grid = getGrid();
            ok(grid.isValidFilterValue(grid.columns[2], "3.14"));
        });
        
        test('validate number succeeds when decimal number without whole part', function() {
            var grid = getGrid();
            ok(grid.isValidFilterValue(grid.columns[2], ".14"));
        });
        
        test('validate number succeeds when positive number', function() {
            var grid = getGrid();
            ok(grid.isValidFilterValue(grid.columns[2], "+1"));
        });
        
        test('validate number succeeds when negative number', function() {
            var grid = getGrid();
            ok(grid.isValidFilterValue(grid.columns[2], "-1"));
        });
        
        test('validate string succeeds always', function() {
            var grid = getGrid();
            ok(grid.isValidFilterValue(grid.columns[0], "anything"));
        });

        test('filtering applies filtered css', function() {
            var grid = getGrid();
            grid.columns[0].filters = [{ operator: 'eq', value: 'test'}]
            grid.filter(grid.filterExpr());
            ok($('th:contains("Name")', grid.element).find('.t-grid-filter').hasClass('t-active-filter'));
        });

        test('rebind removes filtered css', function() {
            var grid = getGrid();
            grid.columns[0].filters = [{ operator: 'eq', value: 'test'}]
            grid.columns[2].filters = [{ operator: 'gt', value: '0'}]
            grid.filter(grid.filterExpr());
            grid.rebind();
            equal($('.t-active-filter', grid.element).length, 0);
        });

        test('filtering applies filtered css to one column only', function() {
            var grid = getGrid();
            grid.columns[0].filters = [ {operator:'eq', value:'test' }]
            grid.filter(grid.filterExpr());
            equal($('.t-active-filter', grid.element).length, 1);
        });

        test('filtering applies filtered css with columns which are not filterable', function() {
            var grid = getGrid();
            grid.columns[5].filters = [{ operator: 'eq', value: 'test'}]
            grid.filter(grid.filterExpr());
            ok($('th:contains("Day Of Year")', grid.element).find('.t-grid-filter').hasClass('t-active-filter'));
        });

        test('clearing boolean filter unchecks radio buttons', function() {
            var grid = getGrid();
            $('th:contains("Active") .t-filter', grid.element).click();
            $('.t-filter-options input[type="radio"]:first', grid.element).click();
            $('.t-filter-options .t-clear-button', grid.element).click();
            equal($('.t-filter-options input:checked', grid.element).length, 0);
        });


        test('column format propagates to datepicker', function () {
            var grid = getGrid();
            $('th:eq(1) .t-filter', grid.element).click();
            
            var datePicker = $('.t-filter-options:last input:last', grid.element).data('tDatePicker');

            equal(datePicker.format, 'd');
        });

        test('column filter values serialized for enum', function() {
            var column = getGrid().columns[getGrid().columns.length - 1];

            equal(column.type, 'Enum');
            equal(column.values.Female, 0);
            equal(column.values.Male, 1);
        });

        test('enum filter ui', function() {
            var grid = getGrid();
            $('th:contains("Gender")', grid.element).find('.t-grid-filter').click();

            equal($('.t-filter-options:last select', grid.element).length, 4);
            equal($('.t-filter-options:last select:eq(1) option:eq(0)', grid.element).text(), grid.localization.filterSelectValue);
            equal($('.t-filter-options:last select:eq(1) option:eq(1)', grid.element).text(), 'Female');
            equal($('.t-filter-options:last select:eq(1) option:eq(2)', grid.element).text(), 'Male');
            equal($('.t-filter-options:last select:eq(3) option:eq(0)', grid.element).text(), grid.localization.filterSelectValue);
            equal($('.t-filter-options:last select:eq(3) option:eq(1)', grid.element).text(), 'Female');
            equal($('.t-filter-options:last select:eq(3) option:eq(2)', grid.element).text(), 'Male');
        });

        test('ajax style date parsing', function() {
            var grid = getGrid();
            equal(grid.encodeFilterValue(grid.columns[1], "\/Date(1265752800000)\/"), "datetime'2010-02-10T00-00-00'");
        });

        test('filter ui prefilled with filter values for numeric filter', function() {
            var grid = getGrid('#Grid2');
            $('th:contains("Day Of Year")', grid.element).find('.t-grid-filter').click();

            equal($('.t-filter-options:last select:eq(0)', grid.element).val(), 'ge');
            equal($('.t-filter-options:last input:eq(0)', grid.element).val(), '1');

            equal($('.t-filter-options:last select:eq(1)', grid.element).val(), 'le');
            equal($('.t-filter-options:last input:eq(1)', grid.element).val(), '1');
        });

        test('filter ui prefilled with filter values for string filter', function() {
            var grid = getGrid('#Grid2');
            $('th:contains(Name)', grid.element).find('.t-grid-filter').click();

            equal($('.t-filter-options:last select:eq(0)', grid.element).val(), 'substringof');
            equal($('.t-filter-options:last input:eq(0)', grid.element).val(), 'Customer1');

            equal($('.t-filter-options:last select:eq(1)', grid.element).val(), 'endswith');
            equal($('.t-filter-options:last input:eq(1)', grid.element).val(), 'Customer1');
        });

        test('filter ui prefilled with filter values for boolean filter', function() {
            var grid = getGrid('#Grid2');
            $('th:contains(Active)', grid.element).find('.t-grid-filter').click();

            equal($('.t-filter-options:last :checked', grid.element).val(), 'true');
        });

        test('filter ui prefilled with filter values for enum filter', function() {
            var grid = getGrid('#Grid2');
            $('th:contains(Gender)', grid.element).find('.t-grid-filter').click();

            equal($('.t-filter-options:last select:eq(0)', grid.element).val(), 'eq');
            equal($('.t-filter-options:last select:eq(1)', grid.element).val(), '0');
            equal($('.t-filter-options:last select:eq(2)', grid.element).val(), 'ne');
            equal($('.t-filter-options:last select:eq(3)', grid.element).val(), '1');
        });

        test('filter custom date format', function() {
            var grid = getGrid('#Grid3');

            $('th:contains(Date)', grid.element).find('.t-grid-filter').click();
            equal(grid.encodeFilterValue(grid.columns[0], '1-1-2000'), "datetime'2000-01-01T00-00-00'");
        });

        test('filter by calculated for filtered grid', function() {
            var grid = getGrid('#Grid4');

            equal(grid.filterBy, "Name~eq~'Customer1'");
        });

        test('date populated correctly initially filtered grid', function() {
            var grid = getGrid('#Grid5');
            $('th:contains(Birth Date)', grid.element).find('.t-grid-filter').click();

            equal($('.t-filter-options:last input', grid.element).val(), '1/1/1980');
        });
        
        test('number filtering', function() {
            var grid = getGrid();
            $('th:eq(2)', grid.element).find('.t-grid-filter').click();
            
            $('.t-filter-options:last .t-input:eq(0)', grid.element).val(1);
            $('.t-filter-options:last .t-filter-button', grid.element).click();

            equal(grid.filterExpr(), 'BirthDate.Day~eq~1');
        });

        test('boolean filtering value true', function() {            
            var grid = getGrid();
            $('th:eq(3)', grid.element).find('.t-grid-filter').click();
            
            $('.t-filter-options:last input:radio:eq(0)', grid.element).attr("checked",true);
            $('.t-filter-options:last .t-filter-button', grid.element).click();

            equal(grid.columns[3].filters[0].value, true);
        });

        test('boolean filtering value false', function() {            
            var grid = getGrid();
            $('th:eq(3)', grid.element).find('.t-grid-filter').click();
            
            $('.t-filter-options:last input:radio:eq(1)', grid.element).attr("checked",true);
            $('.t-filter-options:last .t-filter-button', grid.element).click();

            equal(grid.columns[3].filters[0].value, false);
        });

        test('rebind removes formatted numberic filter value', function() {
            var grid = getGrid();
            $('th:eq(2)', grid.element).find('.t-grid-filter').click();
            
            $("[id*='Grid1BirthDate']").data("tTextBox").value(1);
            $('.t-filter-options:last .t-filter-button', grid.element).click();

            grid.rebind();

            equal($('.t-filter-options .t-formatted-value', grid.element).html(), "");
        });

        test('numeric textbox in filter dropdown has correct font styles for its formatted value', function() {
            var ntb = getNumericTextBox();
            var grid = getGrid();

            grid.$header.find("th:eq(2) .t-filter").click();

            var filterntb = $("[id*='Grid1BirthDate']").data("tTextBox");

            equal(filterntb.$text.css('font-size'), ntb.$text.css('font-size'), 'font size does not match');
            equal(filterntb.$text.css('line-height'), ntb.$text.css('line-height'), 'line height does not match');
        });

</script>

</asp:Content>