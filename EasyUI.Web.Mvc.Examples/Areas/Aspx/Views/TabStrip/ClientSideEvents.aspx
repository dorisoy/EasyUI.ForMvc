<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>
<asp:content contentPlaceHolderID="MainContent" runat="server">
        
	<script type="text/javascript">
	    function onSelect(e) {
			var item = $(e.item);
			$console.log('OnSelect :: ' + item.find('> .t-link').text());
        }

        function onContentLoad(e) {
			var item = $(e.item);
            $console.log('OnContentLoad :: ' + item.find('> .t-link').text());
        }

        function onLoad(e) {
            $console.log('TabStrip loaded');
        }
	</script>
	
    <div id="tabstrip-container">
	    <% Html.EasyUI().TabStrip()
                .Name("TabStrip")
                .ClientEvents(events => events
                        .OnLoad("onLoad")
                        .OnSelect("onSelect")
                        .OnContentLoad("onContentLoad")
                )
                .Items(tabstrip =>
                {
                    tabstrip.Add().Text("Based on jQuery")
                        .Content(() =>
                        {%>
                            <p>
                                The client-side code of the EasyUI Extensions for ASP.NET MVC is based on the open source
                                and Microsoft-supported jQuery JavaScript library.  By using jQuery, the EasyUI Extensions
                                minimize their client-side footprint and draw on the power of jQuery for advanced visual effects
                                as well as for an easy and reliable way to work with HTML elements.
                            </p>
                        <%});
                    tabstrip.Add().Text("Exceptional performance")
                        .Content(() =>
                        {%>
                            <p>
                                You can achieve unprecedented performance for your web application with the lightweight,
                                semantically rendered Extensions that completely leverage the ASP.NET MVC model of no postbacks,
                                no ViewState, and no page life cycle. Additional performance gains are delivered through the Extensions?
                                Web Asset Managers, which enable you to optimize the delivery of CSS and JavaScript to your pages.
                                You combine, cache, and compress resources resulting in fewer requests that your page must make to load,
                                improving page load time performance.
                            </p>
                        <%});
                    tabstrip.Add().Text("Open-source")
                        .Content(() =>
                        {%>
                            <p>
                                The EasyUI Extensions for ASP.NET MVC are licensed under the widely adopted GPLv2.
                                In fact, the complete source for the Extensions is available on CodePlex.
                                For those that need dedicated support or need to use the Extensions in an environment
                                where open source software is hard to get approved,
                                EasyUI provides a commercial license with support included.
                            </p>
                        <%});
                    tabstrip.Add().Text("Cross-browser support (dynamic)")
                        .LoadContentFrom("AjaxView_CrossBrowser", "TabStrip");
                })
                .Render();
	    %>
    </div>

    <% Html.RenderPartial("EventLog"); %>
			
</asp:content>

<asp:content contentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .event-log-wrap
        {
            margin-top: 3em;
        }
        
        #tabstrip-container
        {
            height: 150px;
        }
    </style>
</asp:content>