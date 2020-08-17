<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage"%>

<asp:content contentPlaceHolderID="MainContent" runat="server">

    <%: Html.EasyUI().Calendar()
            .Name("Calendar")
            .HtmlAttributes(new { style = "width: 294px;" })
            .Value(new DateTime(2011, 8, 31))
    %>

    <% Html.RenderPartial("CulturePicker"); %>

    <% Html.EasyUI().ScriptRegistrar().Globalization(true); %>

</asp:Content>

<asp:Content contentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        
        #Calendar
        {
            float: left;
            margin-bottom: 1.3em;
        }
		
	    .example .configurator
	    {
	        float: left;
	        margin: 0 0 0 10em;
	        display: inline;
	    }
    </style>
</asp:Content>