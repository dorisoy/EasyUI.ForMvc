<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Culture="de-DE" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <%= 10.ToString("N") %>

    <%= Html.EasyUI().Grid(Model)
            .Name("Grid1")
            .DataKeys(keys => keys.Add(c => c.Name))
            .ToolBar(toolbar => toolbar.Insert())
            .Columns(columns => 
                {
                    columns.Bound(c => c.Name).Format("<strong>{0}</strong>");
                    columns.Bound(c => c.BirthDate).Format("{0:d}");
                    columns.Bound(c => c.ReadOnly);
                    columns.Command(commands =>
                    {
                        commands.Edit();
                        commands.Delete();
                    });
                })
            .DataBinding(binding => binding.Ajax()
                .Select("Select", "Dummy")
                .Insert("Insert", "Dummy")
                .Delete("Delete", "Dummy")
                .Update("Update", "Dummy")
            )
            .Pageable(pager => pager.PageSize(10))
    %>

    <%= Html.EasyUI().Grid(Model)
            .Name("Grid2")
            .DataKeys(keys => keys.Add(c => c.Name))
            .ToolBar(toolbar => toolbar.Insert())
            .Columns(columns => 
                {
                    columns.Bound(c => c.Name);
                    columns.Bound(c => c.BirthDate).Format("{0:d}");
                    columns.Command(commands =>
                    {
                        commands.Edit();
                        commands.Delete();
                    });
                })
            .DataBinding(binding => binding.Server()
                .Select("Select", "Dummy")
                .Insert("Insert", "Dummy")
                .Delete("Delete", "Dummy")
                .Update("Update", "Dummy")
            )
            .Pageable(pager => pager.PageSize(10))
    %>

    <%= Html.EasyUI().Grid(Model)
            .Name("Grid3")
            .DataKeys(keys => keys.Add(c => c.Name))
            .ToolBar(toolbar => toolbar.Insert())
            .Columns(columns => 
                {
                    columns.Bound(c => c.Active);
                    columns.Command(commands =>
                    {
                        commands.Edit();
                        commands.Delete();
                    });
                })
            .DataBinding(binding => binding.Ajax()
                .Select("Select", "Dummy")
                .Insert("Insert", "Dummy")
                .Delete("Delete", "Dummy")
                .Update("Update", "Dummy")
            )
            .Pageable(pager => pager.PageSize(10))
    %>
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid4")
            .DataKeys(keys => keys.Add(c => c.Name))
            .ToolBar(toolbar => toolbar.Insert())
            .Columns(columns => 
                {
                    columns.Bound(c => c.Active);
                    columns.Command(commands =>
                    {
                        commands.Edit();
                        commands.Delete();
                    });
                })
            .DataBinding(binding => binding.Ajax()
                .Select("Select", "Dummy")
                .Insert("Insert", "Dummy")
                .Delete("Delete", "Dummy")
                .Update("Update", "Dummy")
            )
            .Pageable(pager => pager.PageSize(10))
    %>
    
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid5")
            .DataKeys(keys => keys.Add(c => c.Name))
            .ToolBar(toolbar => toolbar.Insert())
            .Columns(columns => 
                {
                    columns.Bound(c => c.Active);
                    columns.Command(commands =>
                    {
                        commands.Edit();
                        commands.Delete();
                    });
                })
            .DataBinding(binding => binding.Ajax()
                .Select("Select", "Dummy")
                .Insert("Insert", "Dummy")
                .Delete("Delete", "Dummy")
                .Update("Update", "Dummy")
            )
            .Pageable(pager => pager.PageSize(10))
    %>

       <%= Html.EasyUI().Grid(Model)
            .Name("Grid6")
            .DataKeys(keys => keys.Add(c => c.Name))
            .ToolBar(toolbar => toolbar.Insert())
            .Columns(columns => 
                {
                    columns.Bound(c => c.Name);
                    columns.Bound(c => c.Active);
                    columns.Command(commands =>
                    {
                        commands.Edit();
                        commands.Delete();
                    });
                })
            .DataBinding(binding => binding.Ajax()
                .Select("Select", "Dummy")
                .Insert("Insert", "Dummy")
                .Delete("Delete", "Dummy")
                .Update("Update", "Dummy")
            )
            .Editable(editing => editing.Mode(GridEditMode.PopUp).Window(settings => settings.Effects(effects => effects.Toggle())))
            .Pageable(pager => pager.PageSize(10))
    %>

    <%= Html.EasyUI().Grid(Model)
            .Name("Grid7")
            .DataKeys(keys => keys.Add(c => c.Name))
            .ToolBar(toolbar => toolbar.Insert())
            .Columns(columns => 
                {
                    columns.Bound(c => c.Name);
                    columns.Bound(c => c.IntegerValue);
                    columns.Command(commands =>
                    {
                        commands.Edit();
                        commands.Delete();
                    });
                })
            .DataBinding(binding => binding.Ajax()
                .Select("Select", "Dummy")
                .Insert("Insert", "Dummy")
                .Delete("Delete", "Dummy")
                .Update("Update", "Dummy")
            )
            .Editable(editing => editing.Mode(GridEditMode.InLine))
            .Pageable(pager => pager.PageSize(10))
    %>    
    
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid8")
            .DataKeys(keys => keys.Add(c => c.Name))
            .ToolBar(toolbar => toolbar.Insert())
            .Columns(columns => 
                {
                    columns.Bound(c => c.Name);
                    columns.Bound(c => c.Address);
                    columns.Command(commands =>
                    {
                        commands.Edit();
                        commands.Delete();
                    });
                })
            .DataBinding(binding => binding.Ajax()
                .Select("Select", "Dummy")
                .Insert("Insert", "Dummy")
                .Delete("Delete", "Dummy")
                .Update("Update", "Dummy")
            )
            .Editable(editing => editing.Mode(GridEditMode.InLine))
            .Pageable(pager => pager.PageSize(10))
    %>    
    
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid9")
            .DataKeys(keys => keys.Add(c => c.Name))
            .ToolBar(toolbar => toolbar.Insert())
            .Columns(columns => 
                {
                    columns.Bound(c => c.Name);
                    columns.Bound(c => c.Address);
                    columns.Command(commands =>
                    {
                        commands.Edit();
                        commands.Delete();
                    });
                })
            .DataBinding(binding => binding.Ajax()
                .Select("Select", "Dummy")
                .Insert("Insert", "Dummy")
                .Delete("Delete", "Dummy")
                .Update("Update", "Dummy")
            )
            .Editable(editing => editing.Mode(GridEditMode.InLine))
            .Pageable(pager => pager.PageSize(10))
    %>

     <%= Html.EasyUI().Grid(Model)
            .Name("Grid10")
            .DataKeys(keys => keys.Add(c => c.Name))
            .ToolBar(toolbar => toolbar.Insert())
            .Columns(columns => 
                {
                    columns.Bound(c => c.Name);
                    columns.Bound(c => c.Address);
                    columns.Command(commands =>
                    {
                        commands.Edit();
                        commands.Delete();
                    });
                })
            .DataBinding(binding => binding.Ajax()
                .Select("Select", "Dummy")
                .Insert("Insert", "Dummy")
                .Delete("Delete", "Dummy")
                .Update("Update", "Dummy")
            )
            .Editable(editing => editing.Mode(GridEditMode.InLine))
            .Pageable(pager => pager.PageSize(10))
    %>

     <%= Html.EasyUI().Grid(Model)
            .Name("GridWithHierarchy")
            .DataKeys(keys => keys.Add(c => c.Name))
            .ToolBar(toolbar => toolbar.Insert())
            .Columns(columns => 
                {
                    columns.Bound(c => c.Name);
                    columns.Bound(c => c.Address);
                    columns.Command(commands =>
                    {
                        commands.Edit();
                        commands.Delete();
                    });
                })
            .DetailView(c => {
                c.ClientTemplate("none");
            })
            .DataBinding(binding => binding.Ajax()
                .Select("Select", "Dummy")
                .Insert("Insert", "Dummy")
                .Delete("Delete", "Dummy")
                .Update("Update", "Dummy")
            )
            .Editable(editing => editing.Mode(GridEditMode.InLine))
            .Pageable(pager => pager.PageSize(10))
    %>
    <%= Html.EasyUI().Grid(Model)
            .Name("GridGroupedInCell")
            .DataKeys(keys => keys.Add(c => c.Name))
            .ToolBar(toolbar => toolbar.Insert())
            .Columns(columns => 
                {
                    columns.Bound(c => c.Name);
                    columns.Bound(c => c.Address);
                    columns.Command(commands =>
                    {
                        commands.Edit();
                        commands.Delete();
                    });
                })            
            .DataBinding(binding => binding.Ajax().OperationMode(GridOperationMode.Client)
                .Select("Select", "Dummy")
                .Insert("Insert", "Dummy")
                .Delete("Delete", "Dummy")
                .Update("Update", "Dummy")
            )
            .Editable(editing => editing.Mode(GridEditMode.InCell))
            .Groupable(groupable => groupable.Groups(g => g.Add(c => c.Active)))
            .Pageable(pager => pager.PageSize(10))
    %>
    <% Html.EasyUI().ScriptRegistrar().Globalization(true); %>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

        function addNew(selector) {
            $(selector || '#Grid1').find('.t-grid-add').trigger('click');
        }

        $.each('edit,cancel,update,insert'.split(','), function(index, command) {
            window[command] = function(selector) {
                $(selector || '#Grid1').find('.t-grid-' + command + ':first').click();
            }
        });
        
        function getGrid(selector) {
            return $(selector || "#Grid1").data("tGrid");
        }

        module("Grid / Editing", {
            teardown: function() {
                getGrid().cancel();
                getGrid().editing = { confirmDelete: true, mode: 'InLine', defaultDataItem: {} };
                var wnd = $('.t-window').data('tWindow');
                if (wnd) wnd.destroy();
            }
        });

        test('edit for does not exist by default', function() {
            equal($('#Grid1form').length, 0);
        });

        test('clicking edit creates edit form', function() {
            edit();
            equal($('#Grid1form').length, 1);
        });
        
        test('clicking edit puts the row in edit mode', function() {
            edit();

            equal($('#Grid1 tbody tr').find(':input').first().val(), 'Customer1');
        });

        test('date is set according to format', function() {
            edit();

            equal($('#Grid1 tbody tr').find(':input').eq(1).val(), '01.01.1980');
        });

        test('clicking cancel restores original data', function() {
            edit();
            $('#Grid1 tbody tr').find(':input').eq(0).val('test');
            cancel();
            edit();
            equal($('#Grid1 tbody tr').find(':input').first().val(), 'Customer1');
        });

        test('data keys serialized', function() {
            equal(getGrid().data[0].Name, 'Customer1');
            equal(getGrid().dataKeys.Name, 'id');
        });

        test('clicking update posts data', function() {
            
            var called = false;

            getGrid().sendValues = function(values, url) {
                called = true;
                equal(values.Name, 'Customer1');
                equal(url, 'updateUrl');
            }
            
            edit();
            update();

            ok(called);
        });

        test('create row creates edit form', function() {
            getGrid().addRow();

            equal($('#Grid1form').length, 1);
        });

        test('create row creates empty edit form', function() {
            getGrid().addRow();

            equal($('#Grid1 tbody tr:first :input').first().val(), '');
        });

        test('clicking insert posts data', function() {
            var called = false;

            getGrid().sendValues = function(values, url) {
                called = true;
                equal(values.Name, 'test');
                equal(url, 'insertUrl');
            }

            getGrid().addRow();
            
            $('#Grid1 tbody tr:first :input').val('test');
            
            insert();

            ok(called);
        });

        test('clicking delete posts data', function() {
            var called = false;
            getGrid().sendValues = function(values, url) {
                called = true;
                equal(url, 'deleteUrl');
            }

            window.confirm = function() {
                return true;
            }
            $('#Grid1 tbody tr:first .t-grid-delete').trigger('click');

            ok(called);
        });

        test('no confirmation', function() {
            getGrid().editing = { confirmDelete: false };

            var called = false;
            window.confirm = function() {
                called = true;
            }
            $('#Grid1 tbody tr:first .t-grid-delete').trigger('click');

            ok(!called);
        });

        test('cancelling confirm on delete does not post data', function() {
            var called = false;
            
            getGrid().sendValues = function(values, url) {
                called = true;
            }

            window.confirm = function() {
                return false;
            }

            $('#Grid1 tbody tr:first .t-grid-delete').trigger('click');

            ok(!called);
        });

        test('validation', function() {

            var called = false;
            getGrid().sendValues = function(values, url) {
                called = true;
            }

            getGrid().addRow();
            insert();

            ok(!called);
            equal($('#Grid1 .field-validation-error').length, 1);
        });

        test('datepicker instantiation', function() {
            addNew();

            ok(undefined !== $('input[id=BirthDate]').data('tDatePicker'));
        });

        test('confirm shown for server binding', function() {
            var called = false;
            window.confirm = function() {
                called = true;
                return false;
            }

            $('#Grid2 tbody tr:first .t-grid-delete').trigger('click');

            ok(called);
        });

        test('read only column', function() {
            var grid = getGrid();
            ok(grid.columns[2].readonly);
        });

        test('read only column shown in edit mode', function() {
            edit();

            equal($('#Grid1 tr:has(td):first td:eq(2)').text(), "0");
        });

        test('checkbox checked for true boolean', function() {
            edit('#Grid3');
            ok($('#Grid3 tbody tr:first :checkbox').attr('checked'));
        });

        test('extracts boolean values from checkboxes', function() {
            $('#Grid3 tbody tr:eq(1)').find('.t-grid-edit').trigger('click');
            $('#Grid3 tbody tr:eq(1) :checkbox').attr('checked', true);
            
            getGrid('#Grid3').ajaxRequest = function() { }
            
            var called = false;
            
            getGrid('#Grid3').sendValues = function(values, url) {
                called = true;
                equal(values.Active, true);
            }

            $('#Grid3 tbody tr:eq(1)').find('.t-grid-update').trigger('click');

            ok(called);
        });

        test('cancelling boolean restores the value', function() {
            $('#Grid4 tbody tr:eq(0)').find('.t-grid-edit').trigger('click');
            $('#Grid4 tbody tr:eq(0)').find('.t-grid-cancel').trigger('click');

            equal($('#Grid4 tbody tr:eq(0) td:first').text(), "true");
        });

        test('cancelling raises row data bound', function() {
            var row;
            var dataItem;
            
            edit('#Grid4');
            
            $('#Grid4').bind('rowDataBound', function(e) {
                row = e.row;
                dataItem = e.dataItem;
            });
            
            cancel('#Grid4');
            equal(row, $('#Grid4 tbody tr:eq(0)')[0]);
            equal($('#Grid4').data('tGrid').data[0], dataItem);
        });

        test('cancelling insert does not raises row data bound', function() {
            var wasCalled = false;
            
            addNew('#Grid4');
            
            $('#Grid4').bind('rowDataBound', function(e) {
                wasCalled = true;
            });
            
            cancel('#Grid4');

            ok(!wasCalled);
        });

        test('booleans are not validated', function() {
            getGrid('#Grid5').sendValues = function() { }
            $('#Grid5 tbody tr:eq(0)').find('.t-grid-edit').trigger('click');
            $('#Grid5 tbody tr:eq(0) :checkbox').attr('checked', false);
            $('#Grid5 tbody tr:eq(0)').find('.t-grid-update').trigger('click');
            ok(!$('#Grid5 tbody tr:eq(0) :checkbox').hasClass('input-validation-error'));
        });

        test('editing in popup populates data', function() {

            $('#Grid6 tbody tr:first').find('.t-grid-edit').trigger('click');
            equal($('#Grid6PopUp input[name=Name]').val(), 'Customer1');
            $('#Grid6PopUp').remove();
        });

        test('editing in popup update sends data', function() {
            var grid = getGrid('#Grid6');
            $('#Grid6 tbody tr:eq(1)').find('.t-grid-edit').trigger('click');
            $('#Grid6PopUp input[name=Name]').val('test');

            var called = false;
            grid.sendValues = function(values, url) {
                called = true;
                equal(values.Name, 'test');
            }

            $('#Grid6PopUp .t-grid-update').trigger('click');

            ok(called);
        });

        test('nested properties are set', function() {
            $('#Grid9 tbody tr:first').find('.t-grid-edit').trigger('click');
            
            equal($('#Grid9form #Address_Street').val(), 'foo');
        });

        test('extractValues extracts all input values', function() {
            edit('#Grid8');
            var values = getGrid('#Grid8').extractValues($('#Grid8 tbody tr:first'));
            equal(values['Address.Street'], 'foo');
        });        
        
        test('null is not set to ui elements', function() {
            var grid = getGrid('#Grid10');
            grid.data[7].Name = null;

            $('#Grid10 tbody tr:eq(7)').find('.t-grid-edit').trigger('click');
            equal($('#Grid10form input[name=Name]').val(), '');
        });

        test('editing a grid with hierarchy gets proper layout', function() {
            edit('#GridWithHierarchy');

            ok($('#GridWithHierarchy tr:has(td):first td').hasClass('t-hierarchy-cell'));
        });

        test("_convert removes properties with no value", function(){
            var grid = getGrid('#Grid6');
            var values = {
                bar: 0,
                foo: undefined,
                baz: ""
            };            

            grid._convert(values);

            ok(!("foo" in values));
            equal(values.bar, <%= 0 %>);
            equal(values.baz, "");
        });

        test("_convert should format Date object", function () {
            var grid = getGrid('#Grid6');
            var date = new Date("10/10/2000");
            var values = {
                bar: date
            };

            grid._convert(values);

            equal(values.bar, $t.formatString('{0:G}', date));
        });

        test("_convert should format Number object", function () {
            var grid = getGrid('#Grid6');
            var values = {
                bar: 10.11
            };

            grid._convert(values);

            equal(values.bar, '10,11');
        });
        
        test("data contains flat view of the data when operation mode is client and grid is populated from the server", function() {
            var grid = getGrid('#GridGroupedInCell');
            equal(grid.data.length, 10);
            equal(grid.dataSource.data().length, 20);
            equal(grid.data[0].Active, false);
            equal(grid.data[1].Active, false);
            equal(grid.data[2].Active, false);
        });
</script>

</asp:Content>
