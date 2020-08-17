<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <%: Html.EasyUI().NumericTextBox()
        .Name("NumericTextBox")
    %>
    <% using (Html.Configurator("Client API").Begin()) { %>
    <ul>
        <li>
            <%: Html.TextBox("newValue", "", new { title = "newValue" }).ToHtmlString()%><br />
        </li>
        <li>
            <button onclick="setValue()" class="t-button">Set Value</button> /
            <button onclick="getValue()" class="t-button">Get Value</button>
        </li>
        <li>
            <button onclick="enableNumericTextBox()" class="t-button">Enable</button> / 
            <button onclick="disableNumericTextBox()" class="t-button">Disable</button>
        </li>
   </ul>
   <% } %>

        <script type="text/javascript">

            function setValue() {
                var input = $("#NumericTextBox").data("tTextBox");

                input.value($("#newValue").val());
            }

            function getValue() {
                var input = $("#NumericTextBox").data("tTextBox");

                alert(input.value());
            }

            function enableNumericTextBox() {
                $("#NumericTextBox").data("tTextBox").enable();
            }

            function disableNumericTextBox() {
                $("#NumericTextBox").data("tTextBox").disable();
            }

        </script>
</asp:Content>
<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
		
	    .example .configurator
	    {
	        width: 300px;
	        display: inline-block;
	        *display: inline;
	        zoom: 1;
	        margin-left: 5em;
	        vertical-align: top;
	    }
	    
	    .configurator input
	    {
	        margin: 1.4em 0 .4em;
	    }
	    
	    .example .t-numerictextbox
	    {
	        vertical-align: top;
	        margin-top: 1.3em;
	    }
	    
	    .configurator .t-button
	    {
	    	display:inline-block;
	    	width:auto;
	    }
	    
    </style>
</asp:Content>
