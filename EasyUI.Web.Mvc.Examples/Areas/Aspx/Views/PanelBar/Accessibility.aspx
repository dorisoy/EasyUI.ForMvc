<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Category>>" %>
<asp:content contentPlaceHolderID="MainContent" runat="server">
    <%: Html.EasyUI().PanelBar()
            .Name("PanelBar")
            .HtmlAttributes(new { style = "width: 300px;" })
            .BindTo(Model, mappings => 
            {
                mappings.For<Category>(binding => binding
                        .ItemDataBound((item, category) =>
                        {
                            item.Text = category.CategoryName;
                            item.Url = Url.Action("Accessibility", "PanelBar", new { itemName = category.CategoryName });
                            item.Expanded = true;
                        })
                        .Children(category => category.Products));
                mappings.For<Product>(binding => binding
                        .ItemDataBound((item, product) =>
                        {
                            item.Text = product.ProductName;
                            item.Url = Url.Action("Accessibility", "PanelBar", new { itemName = product.ProductName });
                        }));
            })
    %>

    <% if (ViewData["itemName"] != null)
       {%>
        <p>
            <strong>You have selected the following item:</strong><br />
            <span><%: ViewData["itemName"]%></span>
        </p>
    <% } %>

    <noscript>
        <p>Your browsing experience on this page will be better if you visit it with a JavaScript-enabled browser / if you enable JavaScript.</p>
    </noscript>

    <% Html.RenderPartial("AccessibilityValidation"); %>
</asp:content>