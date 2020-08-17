<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <%= Html.EasyUI().Grid(Model)
            .Name("Grid1")
            .DataKeys(keys => keys.Add(c => c.Name))
            .ToolBar(toolbar => toolbar.Insert())
            .Columns(columns =>
            {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.BirthDate.Day);
                columns.Command(command =>
                {
                    command.Delete();
                    command.Select();
                    command.Edit();
                });
            })
            .DataBinding(dataBinding => dataBinding.Ajax()
                    .Select("Select", "Controller")
                    .Insert("Insert", "Controller")
                    .Delete("Delete", "Controller")
                    .Update("Update", "Controller"))
            .Pageable(paging => paging.Style(GridPagerStyles.NextPreviousAndNumeric | GridPagerStyles.PageInput | GridPagerStyles.Status))
            .Filterable()
            .Selectable()
            .Sortable()
            .Groupable()
    %>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

        var grid;

        function getGrid(selector) {
            return $(selector || "#Grid1").data("tGrid");
        }
        
        module("Grid / Localization", {
            setup: function() {
                grid = getGrid('#Grid1');
                grid.ajaxRequest = function() { }
            },
            teardown: function() {
            }
        });

        test('input paging text', function() {
            grid.localization.page = 'stranica';
            grid.localization.pageOf = 'ot {0}';
            
            var $pager = $('.t-page-i-of-n');
            grid.updatePager();
            ok($pager.html().indexOf('stranica') > -1);
            ok($pager.html().indexOf('ot') > -1);
        });

        test('pager status', function() {
            grid.localization.displayingItems = 'Pokazvame zapisi {0} - {1} ot {2}';
            grid.updatePager();
            var $status = $('.t-status-text');
            equal($status.html(), 'Pokazvame zapisi 1 - 10 ot 20');
        });

        test('filter localization', function() {
            grid.localization['filter'] = "filtrirai";
            grid.localization['filterClear'] = "mahni filter";
            grid.localization['filterShowRows'] = "pokazhi redove, koito";
            grid.localization['filterAnd'] = "i";
            grid.localization['filterStringEq'] = "sushtoto kato";
            $('th:contains(Name) .t-filter').click();
            equal($('.t-filter-button:visible').text(), 'filtrirai');
            equal($('.t-clear-button:visible').text(), 'mahni filter');
            equal($('.t-filter-help-text:visible:first').text(), 'pokazhi redove, koito');
            equal($('.t-filter-help-text:visible:eq(1)').text(), 'i');
            equal($('select:visible option:first').text(), 'sushtoto kato');
        });

        test('grouping localization', function() {
            grid.localization.groupHint = 'grupirane';
            grid.group('Name');
            grid.unGroup('Name');
            equal($('.t-grouping-header').text(), 'grupirane');
        });

</script>

</asp:Content>