<%@ Page Title="" Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Employee>>" %>
<asp:content contentPlaceHolderID="maincontent" runat="server">
    <%: Html.EasyUI().TreeView()
        .Name("TreeView")
        .BindTo(Model, mappings =>
        {
            mappings.For<Employee>(binding => binding
                    .ItemDataBound((item, employee) =>
                    {
                        item.Text = employee.FirstName + " " + employee.LastName;
                        item.Url = Url.Action("Accessibility", "TreeView", new { employeeName = employee.FirstName + " " + employee.LastName });
                        item.Expanded = true;
                    })
                    .Children(category => category.Employees));
        })
    %>

    <noscript>
        <p>Your browsing experience on this page will be better if you visit it with a JavaScript-enabled browser / if you enable JavaScript.</p>
    </noscript>

    <% Html.RenderPartial("AccessibilityValidation"); %>

    <% if (ViewData["employeeName"] != null)
       {%>
        <p>
            <strong>You have selected the following item:</strong><br />
            <span><%: ViewData["employeeName"]%></span>
        </p>
    <% } %>
</asp:content>