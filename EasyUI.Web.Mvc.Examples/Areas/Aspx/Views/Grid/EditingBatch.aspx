<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>


<asp:content contentplaceholderid="MainContent" runat="server">
<%: Html.EasyUI().Grid<EditableProduct>()
        .Name("Grid")
        .DataKeys(keys => 
        {
            keys.Add(p => p.ProductID);
        })
        .ToolBar(commands => {
            commands.Insert();
            commands.SubmitChanges();
        })
        .DataBinding(dataBinding =>
            dataBinding.Ajax()
                .Select("_SelectBatchEditing", "Grid")
                .Update("_SaveBatchEditing", "Grid")
        )
        .Columns(columns =>
        {
            columns.Bound(p => p.ProductName).Width(210);
            columns.Bound(p => p.UnitPrice).Width(130).Format("{0:c}");
            columns.Bound(p => p.UnitsInStock).Width(130).Format("{0:N}");
            columns.Bound(p => p.LastSupply).Width(130).Format("{0:d}");
            columns.Bound(p => p.Discontinued)
                   .ClientTemplate("<input type='checkbox' disabled='disabled' name='Discontinued' <#= Discontinued? checked='checked' : '' #> />");
            columns.Command(commands => commands.Delete()).Width(180).Title("Delete");
        })
        .ClientEvents(events => events.OnDataBinding("Grid_onDataBinding").OnError("Grid_onError"))
        .Editable(editing => editing.Mode(GridEditMode.InCell).DefaultDataItem(new EditableProduct
            {
                LastSupply = DateTime.Today
            }))
        .Pageable()
        .Scrollable()
        .Sortable()        
%>
    <script type="text/javascript">
         function Grid_onError(args) {
            if (args.textStatus == "modelstateerror" && args.modelState) {
                var message = "Errors:\n";
                $.each(args.modelState, function (key, value) {
                    if ('errors' in value) {
                        $.each(value.errors, function() {
                            message += this + "\n";
                        });
                    }
                });
                args.preventDefault();
                alert(message);
            }
        }

        function Grid_onDataBinding(e) {
            var grid = $(this).data('tGrid');
            if (grid.hasChanges()) {
                if (!confirm('You are going to lose any unsaved changes. Are you sure?')) {
                    e.preventDefault();
                }
            }
        }
    </script>
</asp:content>

<asp:content contentplaceholderid="HeadContent" runat="server">
<style type="text/css">
    .field-validation-error
    {
        position: absolute;
        display: block;
    }
    
    * html .field-validation-error { position: relative; }
    *+html .field-validation-error { position: relative; }
    
    .field-validation-error span
    {
        position: absolute;
        white-space: nowrap;
        color: red;
        padding: 17px 5px 3px;
        background: transparent url('<%: Url.Content("~/Content/Common/validation-error-message.png") %>') no-repeat 0 0;
    }
    
    /* in-form editing */
    .t-edit-form-container
    {
        width: 350px;
        margin: 1em;
    }
    
    .t-edit-form-container .editor-label,
    .t-edit-form-container .editor-field
    {
        padding-bottom: 1em;
        float: left;
    }
    
    .t-edit-form-container .editor-label
    {
        width: 30%;
        text-align: right;
        padding-right: 3%;
        clear: left;
    }
    
    .t-edit-form-container .editor-field
    {
        width: 60%;
    }
</style>
</asp:content>
