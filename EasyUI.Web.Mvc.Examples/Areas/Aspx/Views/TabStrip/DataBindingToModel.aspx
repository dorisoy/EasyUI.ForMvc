<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<NavigationData>>" %>


<asp:content contentplaceholderid="MainContent" runat="server">

    <% Html.EasyUI().TabStrip()
           .Name("TabStrip")
           .BindTo(Model,
                   (item, navigationData) =>
                   {
                       item.Text = navigationData.Text;
                       item.ImageUrl = navigationData.ImageUrl;
                       item.Url = navigationData.NavigateUrl;
                   })
           .Render();
    %>

</asp:content>
