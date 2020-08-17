<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content contentPlaceHolderID="MainContent" runat="server">

    <%: Html.EasyUI().Upload()
            .Name("attachments")
            .Multiple((bool) ViewData["multiple"])
            .Async(async => async
                .Save("Save", "Upload")
                .Remove("Remove", "Upload")
                .AutoUpload((bool) ViewData["autoUpload"])
            )
    %>

    <% using (Html.Configurator("The upload should...")
                  .PostTo("FirstLook", "Upload")
                  .Begin())
       { %>
	    <ul id="upload-options">
		    <li>
                <%: Html.CheckBox("autoUpload", (bool)ViewData["autoUpload"])%>
                <label for="autoUpload">upload files automatically</label>
		    </li>
		    <li>
                <%: Html.CheckBox("multiple", (bool) ViewData["multiple"])%>
                <label for="multiple">allow uploading multiple files</label>
		    </li>
	    </ul>
        <button type="submit" class="t-button">Apply</button>
    <% } %>

    <p class="note">
        Maximum allowed file size: 10 MB
    </p>

</asp:Content>

<asp:Content contentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .t-upload {
            float: left;
        }
        
        .note {
            clear: left;
            float: left;
            min-width: 300px;
        }
        
        .example .configurator
        {
            width: 400px;
            float: right;
            margin: 0 0 0 10em;
            display: inline;
        }
    </style>
</asp:Content>
