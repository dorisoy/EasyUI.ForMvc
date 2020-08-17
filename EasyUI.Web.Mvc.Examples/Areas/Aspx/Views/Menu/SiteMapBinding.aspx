<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>
<asp:Content contentPlaceHolderID="MainContent" runat="server">
    
<%: Html.EasyUI().Menu()
       .Name("Menu")
       .BindTo("sample")
%>
    
</asp:Content>