<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<%
    Html.EasyUI().Editor()
        .Name("Editor")
        .Value(() =>
                   {%>
                &lt;p&gt;&nbsp;
                    &lt;img src=&quot;<%:Url.Content("~/Content/Editor/editor.png")%>&quot;
                            alt=&quot;Editor for ASP.NET MVC logo&quot;
                            style=&quot;display:block;margin-left:auto;margin-right:auto;&quot; /&gt;
                    EasyUI Editor for ASP.NET MVC allows your users to edit HTML in a familiar,
                    user-friendly way.&lt;br /&gt;
                    In this version, the Editor provides the core HTML editing engine, which includes
                    basic text formatting, hyperlinks, lists, and image handling.
                    The extension &lt;strong&gt;outputs identical HTML&lt;/strong&gt;
                    across all major browsers, follows accessibility standards
                    and provides an extended programming API for content manipulation.
                &lt;/p&gt;
                <%
                   })
        .Tools(tools => tools.Clear().InsertImage())
        .FileBrowser(t => t.Browse("Browse", "ImageBrowser")
               .Thumbnail("Thumbnail", "ImageBrowser")
               .Upload("Upload", "ImageBrowser")
               .DeleteFile("DeleteFile", "ImageBrowser")
               .DeleteDirectory("DeleteDirectory", "ImageBrowser")
               .CreateDirectory("CreateDirectory", "ImageBrowser"))
        .Render();
%>
</asp:Content>
