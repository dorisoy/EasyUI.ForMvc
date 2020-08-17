<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content contentPlaceHolderID="MainContent" runat="server">
    <div class="t-rtl">
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
    </div>
</asp:Content>