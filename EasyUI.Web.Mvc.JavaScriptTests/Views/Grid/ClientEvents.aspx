<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid")
            .DataKeys(keys => keys.Add(c => c.IntegerValue))
            .Columns(columns => 
            {
                columns.Bound(c => c.Name);
                columns.Command(commands => 
                {
                    commands.Edit();
                    commands.Delete();
                });
            })
            .Editable(settings => settings.DisplayDeleteConfirmation(false))
            .ToolBar(commands => commands.Insert())
            .DataBinding(binding => binding.Ajax().Select("foo", "bar").Update("foo","bar").Insert("foo","bar").Delete("foo", "bar"))
            .ClientEvents(events => events.OnLoad("onLoad").OnEdit("onEdit").OnSave("onSave").OnDelete("onDelete").OnRowSelect("onRowSelect"))
            .Pageable(pager => pager.PageSize(10))
            .Selectable()
    %>
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid3")
            .DataKeys(keys => keys.Add(c => c.IntegerValue))
            .Columns(columns => 
            {
                columns.Bound(c => c.Name);
                columns.Command(commands => commands.Edit());
            })
            .ToolBar(commands => commands.Insert())
            .DataBinding(binding => binding.Ajax().Select("foo", "bar").Update("foo","bar").Insert("foo","bar").Delete("foo", "bar"))
            .ClientEvents(events => events.OnSave("cancelSave"))
            .Pageable(pager => pager.PageSize(10))
    %>
    
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid1")
            .DataKeys(keys => keys.Add(c => c.IntegerValue))
            .ToolBar(commands => commands.Insert())
            .Columns(columns => 
            {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.Active);
                columns.Command(commands => commands.Edit());
            })
            .DataBinding(binding => binding.Ajax().Select("foo", "bar").Update("foo", "bar").Insert("foo", "bar").Delete("foo", "bar"))
            .ClientEvents(events => events.OnEdit("onEdit").OnSave("onSave"))
            .Editable(editing => editing.Mode(GridEditMode.InForm))
    %>
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid2")
            .DataKeys(keys => keys.Add(c => c.IntegerValue))
            .ToolBar(commands => commands.Insert())
            .Columns(columns => 
            {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.Active); 
                columns.Command(commands => commands.Edit());
            })
            .DataBinding(binding => binding.Ajax().Select("foo", "bar").Update("foo", "bar").Insert("foo", "bar").Delete("foo", "bar"))
            .ClientEvents(events => events.OnEdit("onEdit").OnSave("onSave"))
            .Editable(editing => editing.Mode(GridEditMode.PopUp))
    %>
    <% Html.EasyUI().Grid(Model)
            .Name("Grid4")
            .Columns(columns =>
            {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.Active);
            })
            .ClientEvents(events => events.OnDetailViewExpand("onDetailViewExpand").OnDetailViewCollapse("onDetailViewCollapse"))
            .DataBinding(binding => binding.Ajax().Select("foo", "bar"))
            .DetailView(detailView => detailView.Template(c =>
                {
                    %> Details for :<%= c.Name %> <%
                })
                .ClientTemplate("<#= Name #>"))
           .Render();
    %>    
    
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid5")
            .DataKeys(keys => keys.Add(c => c.IntegerValue))
            .ToolBar(commands => {
                commands.Insert();
                commands.SubmitChanges();
            })
            .Columns(columns => 
            {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.Active); 
                columns.Command(commands => commands.Edit());
                columns.Command(commands => commands.Delete());
            })
            .DataBinding(binding => binding.Ajax().Select("foo", "bar").Update("foo", "bar").Insert("foo", "bar").Delete("foo", "bar"))
            .ClientEvents(events => events.OnEdit("onEdit").OnSave("onSave").OnSubmitChanges("onSubmitChanges").OnDelete("onDelete"))
            .Editable(editing => editing.Mode(GridEditMode.InCell))
    %>
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid6")
            .DataKeys(keys => keys.Add(c => c.IntegerValue))
            .ToolBar(commands => {
                commands.Insert();
                commands.SubmitChanges();
            })
            .Columns(columns => 
            {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.Active); 
                columns.Command(commands => commands.Edit());
                columns.Command(commands => commands.Delete());
            })
            .DataBinding(binding => binding.Ajax().Select("foo", "bar").Update("foo", "bar").Insert("foo", "bar").Delete("foo", "bar"))
            .ClientEvents(events => events.OnCommand("onCommand").OnEdit("onEdit").OnSave("onSave").OnSubmitChanges("onSubmitChanges").OnDelete("onDelete"))
            .Editable(editing => editing.Mode(GridEditMode.InCell))
    %>    
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid7")
            .DataKeys(keys => keys.Add(c => c.IntegerValue))
            .ToolBar(commands => {
                commands.Insert();
                commands.Custom().Text("Custom").Action("foo", "bar").Ajax(true).Name("custom");
            })
            .Columns(columns => 
            {
                columns.Bound(c => c.Name);
                columns.Bound(c => c.Active); 
                columns.Command(commands => commands.Edit());
                columns.Command(commands => commands.Delete());
            })
            .DataBinding(binding => binding.Ajax().Select("foo", "bar").Update("foo", "bar").Insert("foo", "bar").Delete("foo", "bar"))
            .ClientEvents(events => events.OnCommand("onCommand").OnEdit("onEdit").OnSave("onSave").OnSubmitChanges("onSubmitChanges").OnDelete("onDelete"))
    %>
    <script type="text/javascript">
        var onLoadGrid;
        var onEditArguments;
        var onSaveArguments;
        var onSubmitChangesArguments;
        var onDeleteArguments;
        var onDetailViewExpandArguments;
        var onDetailViewCollapseArguments;
        var onSelectArguments;
        var onCommandArguments;
        
        function onSubmitChanges(e) {
            onSubmitChangesArguments = e;
        }

        function onCommand(e) {
            onCommandArguments = e;
        }

        function onRowSelect(e) {
            onSelectArguments = e;
        }

        function onDelete(e) {
            e.preventDefault();
            onDeleteArguments = e;
        }

        function onLoad() {
            onLoadGrid = $(this).data('tGrid');
        }
        
        function onEdit(e) {
            onEditArguments = e;    
        }

        function onSave(e) {
            onSaveArguments = e;
        }

        function cancelSave(e) {
            e.preventDefault();
        }
        
        function onDetailViewExpand(e) {
            onDetailViewExpandArguments = e;
        }
        
        function onDetailViewCollapse(e) {
            onDetailViewCollapseArguments = e;
        }
    </script>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

        function getGrid(selector) {
            
            var grid = $(selector || '#Grid').data('tGrid');
            return grid;
        }

        module("Grid / Client events", {
            setup: function() {
                onSubmitChangesArguments = onDetailViewCollapseArguments = onDetailViewExpandArguments = onDeleteArguments = onSaveArguments = onEditArguments = onSelectArguments = onCommandArguments = undefined;
                getGrid().sendValues = function() {};
                $.ajax = $.noop;
            },
            teardown: function() {
                var wnd = $('.t-window').data('tWindow');
            
                if (wnd) wnd.destroy();
            }
        });

        test('client object is available in on load', function() {
            ok(null !== onLoadGrid);
            ok(undefined !== onLoadGrid);

        });
        
        test('clicking a cell raises onEdit', function() {
            $('#Grid5 tbody td:first').click();
            ok(undefined !== onEditArguments);
            ok(undefined !== onEditArguments.form);
            ok(undefined !== onEditArguments.dataItem);
            equal($('#Grid5 tbody td:first')[0], onEditArguments.cell);
        });
        
        test('clicking outside of edit cell raises onSave', function() {
            $('#Grid5 tbody td:first').click();
            $('#Grid5 tbody td:last').mousedown();
            ok(undefined !== onSaveArguments);
            ok(undefined !== onSaveArguments.form);
            ok(undefined !== onSaveArguments.dataItem);
            ok(undefined !== onSaveArguments.values);
            equal($('#Grid5 tbody td:first')[0], onSaveArguments.cell);
        });
        
        test('clicking submitChanges button raises onSubmitChanges', function() {
            $('#Grid5 tbody td:first').click();
            $('#Grid5 tbody td:first :input').val('foo');
            $('#Grid5 tbody td:last').mousedown();
            $('#Grid5 .t-grid-save-changes').click();
            ok(undefined !== onSubmitChangesArguments);
            ok(undefined !== onSubmitChangesArguments.inserted);
            ok(undefined !== onSubmitChangesArguments.updated);
            ok(undefined !== onSubmitChangesArguments.deleted);
            ok(undefined !== onSubmitChangesArguments.deleted);
        });
        
        test('clicking insert raises onSave informs mode', function() {
            $('#Grid1 .t-grid-add:first').click();
            $('#Grid1form #Name').val('test');
            $('#Grid1 .t-grid-insert:first').click();
            $('#Grid1 .t-grid-insert:first').click();
            getGrid('#Grid1').cancelRow($('#Grid1form').closest('tr'));
            ok(undefined !== onSaveArguments);
            ok(undefined !== onSaveArguments.form);
            ok(undefined !== onSaveArguments.values);
        });

        test('clicking insert raises onSave popup mode', function() {
            $('#Grid2 .t-grid-add:first').click();
            $('#Grid2form #Name').val('test');
            $('#Grid2form .t-grid-insert:first').click();
            getGrid('#Grid2').cancelRow($('#Grid2form').closest('tr'));
            ok(undefined !== onSaveArguments);
            ok(undefined !== onSaveArguments.form);
            ok(undefined !== onSaveArguments.values);
        });

        test('clicking edit raises onEdit popup mode', function() {
            $('#Grid2 .t-grid-edit:first').click();
            ok(undefined !== onEditArguments);
            ok(undefined !== onEditArguments.form);
            equal(onEditArguments.dataItem, getGrid('#Grid2').data[0]);
        });
        
        test('clicking save raises onSave popup mode', function() {
            $('#Grid2 .t-grid-edit:first').click();
            $('#Grid2form .t-grid-update:first').click();
            ok(undefined !== onSaveArguments);
            ok(undefined !== onSaveArguments.form);
            equal(onSaveArguments.dataItem, getGrid('#Grid2').data[0]);
            ok(undefined !== onSaveArguments.values);
        });
        
        test('clicking edit raises onEdit inline mode', function() {
            $('#Grid .t-grid-edit:first').click();
            ok(undefined !== onEditArguments);
            equal(onEditArguments.mode, 'edit');
            ok(undefined !== onEditArguments.form);
            equal(onEditArguments.dataItem, getGrid().data[0]);
        });
        
        test('clicking add raises onEdit inline mode', function() {
            $('#Grid .t-grid-add:first').click();
            ok(undefined !== onEditArguments);
            equal(onEditArguments.mode, 'insert');
            ok(undefined !== onEditArguments.form);
        });
        
        test('clicking save raises onSave inline mode', function() {
            $('#Grid .t-grid-edit:first').click();
            $('#Grid .t-grid-update:first').click();
            ok(undefined !== onSaveArguments);
            ok(undefined !== onSaveArguments.form);
            equal(onSaveArguments.mode, 'edit');
            ok(undefined !== onSaveArguments.dataItem);
            ok(undefined !== onSaveArguments.values);
        });
        
        test('cancelling save prevents send values', function() {
            var called = false;
            getGrid('#Grid3').sendValues = function() {
                called=true;
            }
            $('#Grid3 .t-grid-edit:first').click();
            $('#Grid3 .t-grid-update:first').click();
            ok(!called);
        });
        test('cancelling insert prevents send values', function() {
            var called = false;
            getGrid('#Grid3').sendValues = function () {
                called = true;
            }
            $('#Grid3 .t-grid-add:first').click();
            $('#Grid3form #Name').val('test');
            $('#Grid3 .t-grid-insert:first').click();
            ok(!called);
        });
        
        test('clicking insert raises onSave inline mode', function() {
            $('#Grid .t-grid-add:first').click();
            $('#Gridform #Name').val('test');
            $('#Grid .t-grid-insert:first').click();
            
            ok(undefined !== onSaveArguments);
            equal(onSaveArguments.mode, 'insert');
            ok(undefined !== onSaveArguments.form);
            ok(undefined !== onSaveArguments.values);
        });
        
        test('clicking edit raises onEdit informs mode', function() {
            $('#Grid1 .t-grid-edit:first').click();
            $('#Grid1 .t-grid-cancel:first').click();
            
            ok(undefined !== onEditArguments);
            ok(undefined !== onEditArguments.form);
            equal(onEditArguments.dataItem, getGrid('#Grid1').data[0]);
        });
        
        test('clicking add raises onEdit informs mode', function() {
            $('#Grid1 .t-grid-add:first').click();
            ok(undefined !== onEditArguments);
            ok(undefined !== onEditArguments.form);
        });
        
        test('clicking save raises onSave informs mode', function() {
            $('#Grid1 .t-grid-edit:first').click();
            $('#Grid1 .t-grid-update:first').click();
            
            ok(undefined !== onSaveArguments);
            ok(undefined !== onSaveArguments.form);
            equal(onSaveArguments.dataItem, getGrid('#Grid1').data[0]);
            ok(undefined !== onSaveArguments.values);
        });

        test('clicking add raises onEdit popup mode', function() {
            $('#Grid2 .t-grid-add:first').click();
            ok(undefined !== onEditArguments);
            ok(undefined !== onEditArguments.form);
        });

        test('clicking delete raises on delete', function() {
            $('#Grid .t-grid-delete:first').click();
            ok(undefined !== onDeleteArguments);
            ok(undefined !== onDeleteArguments.dataItem);
            ok(undefined !== onDeleteArguments.values);
        });

        test('clicking delete raises on delete in cell mode', function() {
            $('#Grid5 .t-grid-delete:first').click();
            ok(undefined !== onDeleteArguments);
            ok(undefined !== onDeleteArguments.dataItem);
            ok(undefined !== onDeleteArguments.values);
        });

        test('cancelling delete in cell mode', function() {            
            $('#Grid5 .t-grid-delete:first').click();
            ok($('#Grid5 .t-grid-delete:first').closest("tr").is(":visible"));
        });

        test('cancelling delete', function() {
            var called = false;
            getGrid('#Grid').sendValues = function () {
                called = true;
            }
            $('#Grid .t-grid-delete:first').click();
            ok(!called);
        });

        test('detail view expand', function() {
            $('#Grid4 .t-plus:first').click();
            ok(undefined !== onDetailViewExpandArguments);
            equal(onDetailViewExpandArguments.masterRow, getGrid('#Grid4').$tbody[0].rows[0]);
            equal(onDetailViewExpandArguments.detailRow, getGrid('#Grid4').$tbody[0].rows[1]);
        });

        test('detail view collapse', function() {
            $('#Grid4 .t-plus:first').click();
            $('#Grid4 .t-minus:first').click();
            ok(undefined !== onDetailViewCollapseArguments);
            equal(onDetailViewCollapseArguments.masterRow, getGrid('#Grid4').$tbody[0].rows[0]);
            equal(onDetailViewCollapseArguments.detailRow, getGrid('#Grid4').$tbody[0].rows[1]);
        });

        test('onRowSelect is not raised when the row is in edit mode', function() {
            $('#Grid .t-grid-edit:first').click();
            $('#Grid tbody td:first td:first').click();
            ok(undefined == onSelectArguments);
        });

        test('onCommand is raised when the edit button is clicked', function() {
            $('#Grid6 .t-grid-edit:first').click();
            ok(onCommandArguments);
            equal(onCommandArguments.name, "edit");
        });

        test('onCommand is raised when the delete button is clicked', function() {
            $('#Grid6 .t-grid-delete:first').click();
            ok(onCommandArguments);
            equal(onCommandArguments.name, "delete");
        });

        test('onCommand is raised when the add button is clicked', function() {
            $('#Grid6 .t-grid-add:first').click();
            ok(onCommandArguments);
            equal(onCommandArguments.name, "add");
        });

        test('onCommand is raised when the cancel button is clicked', function() {
            $('#Grid7 .t-grid-edit:first').click();
            $('#Grid7 .t-grid-cancel:first').click();
            ok(onCommandArguments);
            equal(onCommandArguments.name, "cancel");
        });

        test('onCommand is raised when the update button is clicked', function() {
            $('#Grid7 .t-grid-edit:first').click();
            $('#Grid7 .t-grid-update:first').click();
            ok(onCommandArguments);
            equal(onCommandArguments.name, "update");
        });

        test('onCommand is raised when the insert button is clicked', function() {
            $('#Grid7 .t-grid-add:first').click();
            $('#Grid7 .t-grid-insert:first').click();
            ok(onCommandArguments);
            equal(onCommandArguments.name, "insert");
        });

        test('onCommand is raised when the submit changes button is clicked', function () {
            $('#Grid6 .t-grid-save-changes').click();
            ok(onCommandArguments);
            equal(onCommandArguments.name, "submitChanges");
        });

        test('onCommand is raised when the cancel changes button is clicked', function () {
            $('#Grid6 .t-grid-cancel-changes').click();
            ok(onCommandArguments);
            equal(onCommandArguments.name, "cancelChanges");
        });

        test('onCommand is raised when a custom toolbar command is clicked', function () {
            $('#Grid7 .t-grid-custom').click();
            ok(onCommandArguments);
            equal(onCommandArguments.name, "custom");
        });
</script>

</asp:Content>
