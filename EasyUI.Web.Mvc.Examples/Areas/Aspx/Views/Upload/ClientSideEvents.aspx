<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content contentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">
        function onLoad(e) {
            $console.log("Upload loaded");
        }

        function onSelect(e) {
            $console.log("Select :: " + getFileInfo(e));
        }

        function onUpload(e) {
            $console.log("Upload :: " + getFileInfo(e));
        }

        function onSuccess(e) {
            $console.log("Success (" + e.operation + ") :: " + getFileInfo(e));
        }

        function onError(e) {
            $console.log("Error (" + e.operation + ") :: " + getFileInfo(e));
            e.preventDefault(); // Suppress error message
        }

        function onComplete(e) {
            $console.log("Complete");
        }

        function onCancel(e) {
            $console.log("Cancel :: " + getFileInfo(e));
        }
 
        function onRemove(e) {
            $console.log("Remove :: " + getFileInfo(e));
        }

        function getFileInfo(e) {
            return $.map(e.files, function(file) {
                var info = file.name;
                
                // File size is not available in all browsers
                if (file.size > 0) {
                    info  += " (" + Math.ceil(file.size / 1024) + " KB)";
                }

                return info;
            }).join(", ");
        }
    </script>

    <%: Html.EasyUI().Upload()
            .Name("attachments")
            .Async(async => async
                .Save("Save", "Upload")
                .Remove("Remove", "Upload")
            )
            .ClientEvents(events => events
                .OnLoad("onLoad")
                .OnSelect("onSelect")
                .OnUpload("onUpload")
                .OnSuccess("onSuccess")
                .OnError("onError")
                .OnComplete("onComplete")
                .OnCancel("onCancel")
                .OnRemove("onRemove"))
    %>

    <p class="note">
        Maximum allowed file size: 10 MB
    </p>
    
    <% Html.RenderPartial("EventLog"); %>

</asp:Content>

