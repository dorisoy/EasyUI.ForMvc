<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="configurator">
        <ul>
            <li><kbd>Alt</kbd> + <kbd>F10</kbd> - move focus to the first button in the toolbar</li>
            <li><kbd>Left</kbd> or <kbd>Right</kbd> - move between toolbar buttons</li>
            <li><kbd>Down</kbd> or <kbd>Up</kbd> - move between options in toolbar lists</li>
        </ul>
        <ul>
            <li><kbd>Enter</kbd> - execute the current command</li>
            <li><kbd>Esc</kbd> - move focus to the content area to continue typing</li>
        </ul>
        <p>
            For more details, <a class="t-link" href="#code-viewer-tabs">see the description</a>
            below.</p>
    </div>
    <% Html.EasyUI().Editor()
           .Name("editor")
           .HtmlAttributes(new { style = "height:400px" })
           .Value(() =>
           { %>
                &lt;p&gt;&nbsp;
                    &lt;img src=&quot;<%: Url.Content("~/Content/Editor/editor.png") %>&quot;
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

                &lt;p&gt;Features include:&lt;/p&gt;

                &lt;ul&gt;
                    &lt;li&gt;Text formatting &amp; alignment&lt;/li&gt;
                    &lt;li&gt;Bulleted and numbered lists&lt;/li&gt;
                    &lt;li&gt;Hyperlink and image dialogs&lt;/li&gt;
                    &lt;li&gt;Cross-browser support&lt;/li&gt;
                    &lt;li&gt;Identical HTML output across browsers&lt;/li&gt;
                    &lt;li&gt;Gracefully degrades to a &lt;code&gt;textarea&lt;/code&gt;
                              when JavaScript is turned off&lt;/li&gt;
                &lt;/ul&gt;

                &lt;p&gt;
                    Read &lt;a href=&quot;http://www.easyui.com/products/aspnet-mvc/editor.aspx&quot;&gt;more details&lt;/a&gt;
                    or send us your
                    &lt;a href=&quot;http://www.easyui.com/community/forums/aspnet-mvc.aspx&quot;&gt;feedback&lt;/a&gt;!
                &lt;/p&gt;
            <% })
               .Render();
    %>
</asp:Content>

<asp:content contentplaceholderid="HeadContent" runat="server">
    <style type="text/css">
        .configurator
        {
            margin: 0 0 2.3em;
        }
        
        .configurator ul
        {
            float: left;
            width: 48%;
            padding: 1.5em 0 0;
        }
    
        .configurator p
        {
            clear: both;
            padding: 2em 0 0;
        }
    </style>
</asp:content>