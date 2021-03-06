<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FirstLookModelView>" %>
<asp:content contentPlaceHolderID="MainContent" runat="server">
    

    <%: Html.EasyUI().DatePicker()
            .Name("DatePicker")
            .HtmlAttributes(new { id = "DatePicker_wrapper", style = "margin-bottom: 230px" })
    %>
    
    <% using (Html.Configurator("Try entering...").Begin()) { %>
        <ul class="humanReadableExamples">
            <li><a href="#" class="t-link"><%: DateTime.Today.ToShortDateString() %></a></li>
            <li><a href="#" class="t-link">today</a></li>
            <li><a href="#" class="t-link">tomorrow</a></li>
        </ul>
        <ul class="humanReadableExamples">
            <li><a href="#" class="t-link">next Tuesday</a></li>
            <li><a href="#" class="t-link">last March</a></li>
        </ul>
    <% } %>
    
    <% Html.EasyUI().ScriptRegistrar().OnDocumentReady(() => {%>
        $('.humanReadableExamples a').click(function(e) {
            e.preventDefault();

            $('#DatePicker')
                .focus()
                .val($(this).text())
                .trigger('change')
                .val($(this).text());
        });
    <%}); %>
    
</asp:content>

<asp:content contentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        
        #DatePicker_wrapper
        {
            margin-bottom: 230px;
            float: left;
        }
		
	    .example .configurator
	    {
	        width: 300px;
	        float: left;
	        margin: 0 0 0 15em;
	        display: inline;
	    }
	    
	    .right-aligned
	    {
	        width: 82px;
	        text-align: right;
	        padding-right: 5px;
	    }
	    
	    .configurator p
	    {
	        margin: 0;
	        padding: .4em 0;
	    }
	    
	    .configurator .humanReadableExamples
	    {
	        float: left; width: 120px;
	        padding-left: 20px;
	    }
    </style>
</asp:content>
