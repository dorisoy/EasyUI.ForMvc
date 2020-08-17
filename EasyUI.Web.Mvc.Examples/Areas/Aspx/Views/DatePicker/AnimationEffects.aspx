<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>
<asp:content contentPlaceHolderID="MainContent" runat="server">

    <%: Html.EasyUI().DatePicker()
            .Name("DatePicker")
            .Effects(fx =>
		    {
                if (ViewData["animation"].ToString() == "slide")
                {
                    fx.Slide();
                }
                else if (ViewData["animation"].ToString() == "expand")
                {
                    fx.Expand();
                }
			    else
			    {
				    /* activate only toggle, so that the items show */
				    fx.Toggle();
			    }
                
			    if ((bool)ViewData["enableOpacityAnimation"])
				    fx.Opacity();

                fx.OpenDuration((int)ViewData["openDuration"])
                  .CloseDuration((int)ViewData["closeDuration"]);
		    })
    %>

<% using (Html.Configurator("Animate with...")
              .PostTo("AnimationEffects", "DatePicker")
              .Begin())
   { %>
    <ul>
        <li>
            <%: Html.RadioButton("animation", "toggle", new { id = "toggle", title = "toggle" })%>
            <label for="toggle"><strong>toggle</strong> animation</label>
            <br />
            <%: Html.RadioButton("animation", "slide", new { id = "slide", title = "slide" })%>
            <label for="slide"><strong>slide</strong> animation</label>
            <br />
            <%: Html.RadioButton("animation", "expand", new { id = "expand", title = "expand" })%>
            <label for="expand"><strong>expand</strong> animation</label>
            <br />
            <%: Html.CheckBox("enableOpacityAnimation", ( bool )ViewData[ "enableOpacityAnimation" ], new { title = "enableOpacityAnimation" })%>
            <label for="enableOpacityAnimation"><strong>opacity</strong> animation</label>
        </li>
        <li>
            <ul>
                <li>
                    <label for="openDuration">open for</label>
                    <%: Html.EasyUI().NumericTextBox()
                            .Name("openDuration")
                            .DecimalDigits(0)
                            .NumberGroupSeparator("")
                            .MinValue(0).MaxValue(10000)
                            .Value(Convert.ToDouble(ViewData["openDuration"]))
                    %> ms
                </li>
                <li>
                    <label for="closeDuration">close for</label>
                    <%: Html.EasyUI().NumericTextBox()
                            .Name("closeDuration")
                            .DecimalDigits(0)
                            .NumberGroupSeparator("")
                            .MinValue(0).MaxValue(10000)
                            .Value(Convert.ToDouble(ViewData["closeDuration"]))
                    %> ms
                </li>
            </ul>
        </li>
    </ul>
    
    <button class="t-button" type="submit">Apply</button>
<% } %>

<% Html.EasyUI().ScriptRegistrar().OnDocumentReady(() => {%>
	/* client-side validation */
    $('.configurator button').click(function(e) {
        $('.configurator :text').each(function () {
            if ($(this).hasClass('t-state-error')) {
                alert("TextBox `" + this.name + "` has an invalid param!");
                e.preventDefault();
            }
        });
    });
<%}); %>
				
</asp:content>


<asp:Content contentPlaceHolderID="HeadContent" runat="server">
	<style type="text/css">
	    .t-datepicker
	    {
	        float: left;
	    }
	    
	    .example .configurator
	    {
	        width: 300px;
	        float: left;
	        margin: 0 0 0 10em;
	        display: inline;
	    }
	    
	    .example form {
            display:inline-block;
            *display:inline;
            zoom: 1;
            vertical-align:top;
        }
	    
	    .configurator li
		{
		    padding: 3px 0;
		}
	    
	    #openDuration .t-input
	    {
	        width: 50px;
	    }
	    
	    #closeDuration .t-input
	    {
	        width: 50px;
	    }
	   		
		.configurator ul ul
		{
		    padding-left: 24px;
		    margin: 0;
		}
		
		.configurator ul ul label
		{
		    width: 48px;
		    margin: 0;
		}
	</style>
</asp:Content>