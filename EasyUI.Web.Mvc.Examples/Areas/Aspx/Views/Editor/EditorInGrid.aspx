<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EditableEmployee>>" %>

<asp:content contentplaceholderid="MainContent" runat="server">

<%: Html.EasyUI()
        .Grid(Model)
        .Name("Grid")
        .DataKeys(keys => keys.Add(e => e.EmployeeID).RouteKey("Id"))
        .DataBinding(dataBinding => dataBinding.Server()
           .Select("EditorInGrid", "Editor")
           .Update("UpdateEmployee", "Editor"))
        .Columns(columns =>
        {
            columns.Bound(e => e.EmployeeID).Width(100);
            columns.Bound(e => e.FirstName);
            columns.Bound(e => e.LastName);
            columns.Bound(e => e.Notes).Width(320).Encoded(false);
            columns.Command(commands => commands.Edit()).Title("Edit").Width(200);
        })
        .Pageable(paging => paging.PageSize(5))
%>

</asp:content>