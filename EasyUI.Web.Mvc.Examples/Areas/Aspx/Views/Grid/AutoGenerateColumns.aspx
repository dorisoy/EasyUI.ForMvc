<%@ Page Title="Auto generate columns" Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EditableCustomer>>" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <%: Html.EasyUI().Grid(Model)
        .Name("Grid")
        .DataKeys(keys => keys.Add(c => c.CustomerID))
        .Columns(columns =>
                     {   
                         columns.AutoGenerate(column =>
                                                  {
                                                      //customize autogenereted column's settings
                                                      column.Width = "130px";
                                                      if (column.Member == "CustomerID")
                                                          column.Visible = false;
                                                  });
                         columns.Command(command =>
                         {
                             command.Edit().ButtonType(GridButtonType.ImageAndText);
                             command.Delete().ButtonType(GridButtonType.ImageAndText);
                         }).Width(150);
                     })
        .DataBinding(binding => binding.Ajax()
                                           .Update("_SaveAutoColumnsEditing", "Grid")
                                           .Delete("_DeleteAutoColumnsEditing", "Grid")
                                           .Select("_SelectAutoGenerateColumns", "Grid")
                                       )
        .Sortable()
        .Pageable()
    %>
</asp:Content>
