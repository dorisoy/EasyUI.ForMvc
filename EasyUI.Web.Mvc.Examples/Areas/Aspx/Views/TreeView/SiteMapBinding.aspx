<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>
<asp:Content contentPlaceHolderID="MainContent" runat="server">
    
<%: Html.EasyUI().TreeView()
       .Name("TreeView")
       .BindTo("sample")
%>
    
</asp:Content>