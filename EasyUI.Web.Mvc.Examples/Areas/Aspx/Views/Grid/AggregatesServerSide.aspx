<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Product>>" %>

<asp:Content ContentPlaceHolderID="maincontent" runat="server">
    <% Html.EasyUI().Grid(Model)
        .Name("Grid")
        .Columns(columns =>
        {
            columns.Bound(o => o.ProductName)
                   .Aggregate(aggregates => aggregates.Count())
                   .FooterTemplate(result =>
                   {
                        %>Total Count: <%: result.Count %><%     
                   })
                   .GroupFooterTemplate(result =>
                   {
                        %>Count: <%: result.Count %><%     
                   });
            
            columns.Bound(o => o.UnitPrice)
                   .Width(200)
                   .Aggregate(aggreages => aggreages.Sum())
                   .Format("{0:c}")
                   .FooterTemplate(result =>
                   {
                        %>Total Sum: <%: result.Sum.Format("{0:c}") %><%
                   })
                   .GroupFooterTemplate(result =>
                   {
                        %>Sum: <%: result.Sum.Format("{0:c}") %><%
                   });
            
            columns.Bound(o => o.UnitsOnOrder)
                   .Width(200)
                   .Aggregate(aggregates => aggregates.Average())
                   .FooterTemplate(result =>
                   {
                       %>Average: <%: result.Average%><%
                   })
                   .GroupFooterTemplate(result =>
                   {
                       %>Average: <%: result.Average%><%
                   });
                   
            columns.Bound(o => o.UnitsInStock)
                   .Width(100)
                   .Aggregate(aggregates => aggregates.Count().Min().Max())
                   .FooterTemplate(result =>
                   {
                       %>
                            <div>Min: <%: result.Min%></div>
                            <div>Max: <%: result.Max%></div>
                       <%
                   })
                   .GroupHeaderTemplate(result =>
                   {
                        %><%: result.Title%>: <%: result.Key %> (Count: <%: result.Count %>)<%
                   });
        })
        .Sortable()
        .Pageable()
        .Groupable(settings => settings.Groups(groups => groups.Add(o => o.UnitsInStock)).Visible(false))
        .Render();
    %>
</asp:Content>
