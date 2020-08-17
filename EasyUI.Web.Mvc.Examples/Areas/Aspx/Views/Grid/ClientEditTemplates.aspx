<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

   <%: Html.EasyUI().Grid<ClientEditableOrder>()
           .Name("Grid")
           .DataKeys(keys =>
           {
               keys.Add(o => o.OrderID);
           })
           .DataBinding(dataBinding =>
           {
               dataBinding.Ajax()
                   .Select("_ClientEditTemplate", "Grid")
                   .Update("_UpdateOrder", "Grid");
           })
           .Columns(columns =>
           {
               columns.Bound(o => o.OrderID).Width(100);
               columns.Bound(o => o.Employee).Width(230);
               columns.Bound(o => o.OrderDate).Width(150);
               columns.Bound(o => o.Freight).Width(220);
               columns.Command(commands => commands.Edit()).Title("Edit").Width(200);
           })
           .ClientEvents(events=>events.OnEdit("onEdit"))
           .Pageable()
    %>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">

<script type="text/javascript">
    function onEdit(e) {
        $(e.form).find('#Employee').data('tDropDownList').select(function (dataItem) {
            return dataItem.Text == e.dataItem['Employee'];
        });
    }
</script>

</asp:Content>