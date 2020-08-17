<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <%= Html.EasyUI().Grid(Model)
            .Name("Grid1")
            .Columns(columns =>
            {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.BirthDate.Day);
            })
            .Ajax(settings => { })
            .Pageable()
            .Selectable()
            .ClientEvents(events => events.OnRowSelect("onRowSelected"))
    %>
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid2")
            .Columns(columns =>
            {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.BirthDate.Day);
            })
            .Ajax(settings => { })
            .Pageable()
            
    %>

    <script type="text/javascript">
        var rowSelected;
        
        function onRowSelected (e) {
            rowSelected = e.row;
        }
    </script>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

        function getGrid(selector) {
            return $(selector || '#Grid1').data('tGrid');
        }

        module("Grid / Selection", {
            setup: function() {
                rowSelected = null;
            },
            teardown: function() {
                $('#Grid1 tbody tr').removeClass('t-state-selected');
            }
        });

        test('clicking a row should select it', function() {
            $('#Grid1 tbody tr:first').trigger('click');
            ok($('#Grid1 tbody tr:first').hasClass('t-state-selected'));
        });

        test('clicking another row removes selected style', function() {
            $('#Grid1 tbody tr:first').trigger('click');
            $('#Grid1 tbody tr:nth-child(2)').trigger('click');
            ok(!$('#Grid1 tbody tr:first').hasClass('t-state-selected'));
        });

        test('selection style is removed after binding', function() {
            $('#Grid1 tbody tr:first').trigger('click');
            getGrid().dataBind([{ BirthDate: new Date() }, { BirthDate: new Date()}]);
            equal($('#Grid1 tbody tr.t-state-selected').length, 0);
        });

        test('selection is disabled by default', function() {
            $('#Grid2 tbody tr:first').trigger('click');
            ok(!$('#Grid2 tbody tr:first').hasClass('t-state-selected'));
        });
        
        test('row selected is raised', function() {
            $('#Grid1 tbody tr:first').trigger('click');
            equal(rowSelected, $('#Grid1 tbody tr:first')[0]);
        });

</script>

</asp:Content>