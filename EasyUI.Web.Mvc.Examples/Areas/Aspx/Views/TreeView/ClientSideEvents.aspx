<%@ Page Title="" Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Employee>>" %>
<asp:content contentPlaceHolderID="MainContent" runat="server">
    
        <%: Html.EasyUI().TreeView()
                .Name("TreeView")
                .HtmlAttributes(new { style = "width: 300px; float: left; margin-bottom: 30px;" })
                .ShowCheckBox(true)      
                .ClientEvents(events => events
                        .OnLoad("onLoad")
                        .OnSelect("onSelect")
                        .OnCollapse("onCollapse")
                        .OnExpand("onExpand")
                        .OnChecked("onChecked")
                        
                        // drag & drop related
                        .OnNodeDragStart("onNodeDragStart")
                        .OnNodeDragging("onNodeDragging")
                        .OnNodeDrop("onNodeDrop")
                        .OnNodeDropped("onNodeDropped")
                        .OnNodeDragCancelled("onNodeDragCancelled")
                )
                            .DragAndDrop(true)
                    .BindTo(Model, (item, employee) =>
                    {
                        // bind initial data - can be omitted if there is none
                        item.Text = employee.FirstName + " " + employee.LastName;
                        item.Value = employee.EmployeeID.ToString();
                        item.LoadOnDemand = employee.Employees.Count > 0;
                    })
                    .DataBinding(dataBinding => dataBinding
                            .Ajax().Select("_AjaxLoading", "TreeView")
                    )
      %>
        
    <script type="text/javascript">
        function treeView() {
            return $('#TreeView').data('tTreeView');
        }    
    
        function onSelect(e) {
            $console.log('OnSelect :: ' + treeView().getItemText(e.item));
        }
        
        function onCollapse(e) {
            $console.log('OnCollapse :: ' + treeView().getItemText(e.item));
        }

        function onExpand(e) {
            $console.log('OnExpand :: ' + treeView().getItemText(e.item));
        }

        function onNodeDragStart(e) {
            $console.log('OnNodeDragStart :: ' + treeView().getItemText(e.item));
        }
        
        function onNodeDragging(e) {
            // no logging - too verbose
        }

        function onNodeDragCancelled(e) {
            $console.log('OnNodeDragCancelled :: ' + treeView().getItemText(e.item));
        }

        function onNodeDrop(e) {
            $console.log('OnNodeDrop :: `' + treeView().getItemText(e.item) + '` '
                                        + e.dropPosition +
                                        ' `' + treeView().getItemText(e.destinationItem) + '` '
                                        + (e.isValid ? '(valid)' : '(not valid)'));
        }

        function onNodeDropped(e) {
            $console.log('OnNodeDropped :: `' + treeView().getItemText(e.item) + '` '
                                        + e.dropPosition +
                                        ' `' + treeView().getItemText(e.destinationItem) + '`');
        }

        function onChecked(e) {
            $console.log('OnChecked :: ' + treeView().getItemText(e.item) +
                         ' (' + (e.checked ? 'checked' : 'unchecked') + ')');
        }

        function onLoad(e) {
            $console.log('TreeView loaded');
        }
        
    </script>
 
    <% Html.RenderPartial("EventLog"); %>
            
</asp:content>

<asp:content contentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .event-log-wrap
        {
            float: left;
            display: inline;
            width: 468px;
            margin-left: 10em;
        }
    </style>
</asp:content>
