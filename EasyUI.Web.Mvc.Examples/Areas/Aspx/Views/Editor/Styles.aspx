<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<EmployeeDto>" %>

<asp:content contentplaceholderid="MainContent" runat="server">

    <% Html.EasyUI().Editor()
            .Name("Editor")
            .HtmlAttributes(new { style = "height: 400px" })
            .Value(() =>
            {   %>
                <h1>Guide to &ldquo;Alice in Wonderland&rdquo;</h1>
                <h2>Chapter I. Down the Rabbit-hole</h2>
                <p>Alice&rsquo;s famous words:</p>
                &lt;blockquote&gt;
                    And what is the use of a book <em>without</em> pictures or conversations?
                &lt;/blockquote&gt;
                <p>depict a moment in history where rich-text formatting was not done in <abbr title="Hyper-Text Markup Language">HTML</abbr>.</p>
                <ul>
                    <li>Unordered lists</li>
                    <li>Item with sub-items
                        <ul>
                            <li>Nested unordered list</li>
                            <li>Second sub-item</li>
                        </ul>
                    </li>
                    <li>One more item</li>
                    <li>No more items</li>
                </ul>
                <% 
            })
            .Tools(tools => tools
                .Clear() /* calling clear for the sake of the example */
                .Styles(styles => styles.Add("Highlight", "highlight").Add("Code block", "code"))
                .FormatBlock()
            )
            .StyleSheets(styleSheets => styleSheets.Add("~/Content/Editor/Styles/editorStyles.css"))
            .Render();
    %>

</asp:content>
