<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>
<asp:Content contentPlaceHolderID="MainContent" runat="server">

    <% Html.EasyUI().TabStrip()
           .Name("TabStrip")
           /* ViewData["sample"] contains the sitemap */
           .BindTo("sample", (item, node) => {
               if (string.IsNullOrEmpty(node.ActionName) && node.ChildNodes.Count > 0)
               {
                   if(!string.IsNullOrEmpty(node.ChildNodes[0].ControllerName))
                        item.ControllerName = node.ChildNodes[0].ControllerName;
                   
                   if(!string.IsNullOrEmpty(node.ChildNodes[0].ActionName))
                    item.ActionName =node.ChildNodes[0].ActionName;
               }
           })
           .Render();
    %>

</asp:Content>
