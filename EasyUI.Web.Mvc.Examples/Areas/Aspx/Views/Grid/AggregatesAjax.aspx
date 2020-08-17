<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="maincontent" runat="server">
    <%: Html.EasyUI().Grid<Product>()
            .Name("Grid")
            .Columns(columns =>
            {
                columns.Bound(o => o.ProductName)
                       .Aggregate(aggregates => aggregates.Count())
                       .ClientFooterTemplate("Total Count: <#= Count #>")
                       .ClientGroupFooterTemplate("Count: <#= Count #>");
            
                columns.Bound(o => o.UnitPrice)
                       .Width(200)
                       .Aggregate(aggreages => aggreages.Sum())
                       .Format("{0:c}")
                       .ClientFooterTemplate("Total Sum: <#= $.easyui.formatString('{0:c}', Sum) #>")
                       .ClientGroupFooterTemplate("Sum: <#= $.easyui.formatString('{0:c}', Sum) #>");
            
                columns.Bound(o => o.UnitsOnOrder)
                       .Width(200)
                       .Aggregate(aggregates => aggregates.Average())
                       .ClientFooterTemplate("Average: <#= Average #>")
                       .ClientGroupFooterTemplate("Average: <#= Average #>");
                   
                columns.Bound(o => o.UnitsInStock)
                       .Width(100)
                       .Aggregate(aggregates => aggregates.Count().Min().Max())
                       .ClientFooterTemplate(
                            "<div>Min: <#= Min #></div>" +
                            "<div>Max: <#= Max #></div>"
                       )
                       .ClientGroupHeaderTemplate("<#= Title #>: <#= Key #> (Count: <#= Count #>)");
            })
            .DataBinding(dataBinding => dataBinding.Ajax().Select("AggregatesAjax_Select", "Grid"))
            .Sortable()
            .Pageable()
            .Groupable(settings => settings.Groups(groups => groups.Add(o => o.UnitsInStock)).Visible(false))
    %>
</asp:Content>
