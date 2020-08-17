<%@ Page Title="" Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Employee>>" %>
<asp:content contentPlaceHolderID="maincontent" runat="server">
<% using (Html.BeginForm("CheckBoxSupport", "TreeView", FormMethod.Post))
{ %>
        <% List<TreeViewItem> checkedNodes = ViewData["TreeView1_checkedNodes"] as List<TreeViewItem>; %>
        
        <%: Html.EasyUI().TreeView()
            .Name("TreeView1")
            .ShowCheckBox(true)
            .BindTo(Model, mappings =>
            {
                mappings.For<Employee>(binding => binding
                        .ItemDataBound((item, employee) =>
                        {
                            item.Text = employee.FirstName + " " + employee.LastName;
                            item.Value = employee.EmployeeID.ToString();

                            if (checkedNodes != null)
                            {
                                var checkedNode = checkedNodes
                                                    .Where(e => e.Value.Equals(employee.EmployeeID.ToString()))
                                                    .FirstOrDefault();

                                item.Checked = checkedNode != null ? checkedNode.Checked : false;
                            }

                            item.Expanded = true;
                        })
                        .Children(category => category.Employees));
                
                mappings.For<Employee>(binding => binding
                        .ItemDataBound((item, employee) =>
                        {
                            item.Text = employee.FirstName + " " + employee.LastName;
                            item.Value = employee.EmployeeID.ToString();

                            if (checkedNodes != null)
                            {
                                var checkedNode = checkedNodes
                                                    .Where(e => e.Value.Equals(employee.EmployeeID.ToString()))
                                                    .FirstOrDefault();

                                item.Checked = checkedNode != null ? checkedNode.Checked : false;
                            }
                            
                        }));
            })
        %>
    <p>
        <button type="submit" class="t-button">Save</button>
    </p>
    
    <% if (checkedNodes != null && checkedNodes.Count > 0){%>
        <p>
            <strong>You have selected the following items:</strong><br />
            <span><%: ViewData["message"]%></span>
        </p>
    <% } %>
<%}%>

</asp:content>