<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<EmployeeDto>" %>

<asp:content contentplaceholderid="MainContent" runat="server">

    <% Html.EasyUI().Editor()
            .Name("Editor")
            .Value(() =>
            {   %>
                    <p>Put the cursor after this text and use the "Insert snippet" tool.</p>
                <% 
            })
            .Tools(tools => tools
                .Clear()
                .Snippets(snippets => snippets
                        .Add("Signature", "<p>Regards,<br /> John Doe,<br /> <a href='mailto:john.doe@example.com'>john.doe@example.com</a></p>")
                        .AddFromFile("Editor Features", "~/Content/Editor/Snippets/Features.html"))
            )
            .Render();
    %>
</asp:content>
