<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

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

</asp:Content>



<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">

        function getGrid(selector) {
            return $(selector || "#Grid1").data("tGrid");
        }

        var errorView;
    
        module("Grid / ErrorView", {
            setup: function() {
                errorView = new $.easyui.grid.ErrorView();
            }
        });

        test('should set inner text of validation span', function() {
            var $ui = $('<div><span id="ProductName_validationMessage" class="field-validation-valid"></span></div>')
            errorView.bind($ui, {ProductName:{errors:['Error']}});
            equal($ui.find('span').html(), 'Error');
        });
    
        test('should set the className of the validation span', function() {
            var $ui = $('<div><span id="ProductName_validationMessage" class="field-validation-valid"></span></div>')
            errorView.bind($ui, {ProductName:{errors:['Error']}});
            equal($ui.find('span').attr('class'), 'field-validation-error');
        });

        test('should set all validators', function() {
            var $ui = $('<div><span id="ProductName_validationMessage" class="field-validation-valid"></span><span id="ProductID_validationMessage" class="field-validation-valid"></span></div>')
        
            errorView.bind($ui, {ProductName:{errors:['Error']}, ProductID:{errors:['Error']}});
        
            equal($ui.find('span:eq(0)').html(), 'Error');
            equal($ui.find('span:eq(0)').attr('class'), 'field-validation-error');
            equal($ui.find('span:eq(1)').html(), 'Error');
            equal($ui.find('span:eq(1)').attr('class'), 'field-validation-error');
        });

        test('should not update validators which dont have errors', function() {
            var $ui = $('<div><span id="ProductName_validationMessage" class="field-validation-valid"></span></div>')
            errorView.bind($ui, {ProductName:{errors:[]}});
            equal($ui.find('span').html(), '');
            equal($ui.find('span').attr('class'), 'field-validation-valid');
        });    
    
        test('should not update validators when there are no errors', function() {
            var $ui = $('<div><span id="ProductName_validationMessage" class="field-validation-valid"></span></div>')
            errorView.bind($ui, {ProductName:{}});
            equal($ui.find('span').html(), '');
            equal($ui.find('span').attr('class'), 'field-validation-valid');
        });

        test('should clear previous validation errors', function() {
            var $ui = $('<div><span id="ProductName_validationMessage" class="field-validation-error">Error</span></div>');
            errorView.bind($ui, {ProductName:{}});
            equal($ui.find('span').html(), '');
            equal($ui.find('span').attr('class'), 'field-validation-valid');
        });

        test('should set className of textbox', function() {
            var $ui = $('<div><input id="ProductName" /></div>');
        
            errorView.bind($ui, {ProductName:{errors:['Error']}});
        
            equal($ui.find('input').attr('class'), 'input-validation-error');
        });
    
        test('should remove valid from the className of textbox', function() {
            var $ui = $('<div><input id="ProductName" class="textbox valid" /></div>');
        
            errorView.bind($ui, {ProductName:{errors:['Error']}});
        
            ok(!$ui.find('input').hasClass('valid'), 'valid');
        });

        test('should clear invalid class and restore valid class', function() {
            var $ui = $('<div><input id="ProductName" class="textbox input-validation-error" /></div>');
        
            errorView.bind($ui, {ProductName:{}});
        
            ok($ui.find('input').hasClass('valid'));
            ok(!$ui.find('input').hasClass('input-validation-error'));
        });

        test('display errors calls error view', function() {
            var $form;
            var modelState;
        
            var grid = getGrid();

            grid.errorView.bind = function() {
                $form = arguments[0];
                modelState = arguments[1];
            }
        
            $('#Grid1 .t-grid-edit:first').click();
            grid.displayErrors({modelState:{}});
        
            ok(undefined !== modelState);
            equal($form.attr('id'), 'Grid1form');
        });

    </script>

</asp:Content>