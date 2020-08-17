<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content contentPlaceHolderID="MainContent" runat="server">

    <div class="t-rtl">
        <%: Html.EasyUI().Upload()
                .Name("attachments")
                .Async(async => async
                    .Save("Save", "Upload")
                    .Remove("Remove", "Upload")
                )
        %>
    
        <p class="note">
            Maximum allowed file size: 10 MB
        </p>
    
    </div>

</asp:Content>

