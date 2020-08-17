<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<SliderFirstLookModelView>" %>

<asp:content contentPlaceHolderID="MainContent" runat="server">

    <h3>Slider</h3>
    
    <div class="slider-container">
	    <%: Html.EasyUI().Slider<double>()
                .Name("Slider")
                .Min(Model.SliderAttributes.MinValue.Value)
                .Max(Model.SliderAttributes.MaxValue.Value)
                .SmallStep(Model.SliderAttributes.SmallStep.Value)
                .LargeStep(Model.SliderAttributes.LargeStep.Value)
                .TickPlacement(Model.SliderAttributes.TickPlacement.Value)
                .Orientation(Model.SliderAttributes.SliderOrientation.Value)
                .ShowButtons(Model.SliderAttributes.ShowButtons.Value)
                .Value(Model.SliderAttributes.Value)
	    %>
    </div>

    <% using (Html.Configurator("The slider should...")
                  .PostTo("FirstLook", "Slider")
                  .Begin())
    { %>
        <ul>
            <li>
		        <label for="SliderAttributes_Value">have initial <strong>value</strong> of</label>
                <%: Html.EasyUI().NumericTextBox()
                        .Name("SliderAttributes.Value")
                        .MinValue(-100000)
                        .MaxValue(100000)
                        .Value(Model.SliderAttributes.Value)
                %>
		    </li>
		    <li>
		        <label for="SliderAttributes_MinValue">limit the <strong>minimum</strong> value to</label>
                <%: Html.EasyUI().NumericTextBox()
                        .Name("SliderAttributes.MinValue")
                        .MinValue(-100000)
                        .MaxValue(100000)
                        .Value(Model.SliderAttributes.MinValue.Value)
                %>
		    </li>
		    <li>
		        <label for="SliderAttributes_MaxValue">limit the <strong>maximum</strong> value to</label>
                <%: Html.EasyUI().NumericTextBox()
                        .Name("SliderAttributes.MaxValue")
                        .MinValue(-100000)
                        .MaxValue(100000)
                        .Value(Model.SliderAttributes.MaxValue.Value)
                %>
            </li>
            <li>
		        <label for="SliderAttributes_SmallStep">make <strong>small steps</strong> of</label>
                <%: Html.EasyUI().NumericTextBox()
                        .Name("SliderAttributes.SmallStep")
                        .MinValue(0)
                        .MaxValue(100000)
                        .Value(Model.SliderAttributes.SmallStep.Value)
                %>
		    </li>
		    <li>
		        <label for="SliderAttributes_LargeStep">make <strong>large steps</strong> of</label>
                <%: Html.EasyUI().NumericTextBox()
                        .Name("SliderAttributes.LargeStep")
                        .MinValue(0)
                        .MaxValue(100000)
                        .Value(Model.SliderAttributes.LargeStep.Value)
                %>
            </li>
            <li>
		        <label for="SliderAttributes_TickPlacement">have <strong>ticks placed</strong></label>
                <%: Html.EasyUI().DropDownList()
                        .Name("SliderAttributes.TickPlacement")
                        .HtmlAttributes(new { style = "width: 90px" })
                        .SelectedIndex((int)Model.SliderAttributes.TickPlacement.Value)
                        .BindTo(new SelectList(Enum.GetNames(typeof(SliderTickPlacement))))
                %>
            </li>
            <li>
			    <label for="SliderAttributes_ShowButtons">show <strong>buttons</strong></label>
                <%: Html.CheckBox("SliderAttributes.ShowButtons", Model.SliderAttributes.ShowButtons.Value) %>
		    </li>
            <li>
                <%: Html.RadioButton("SliderAttributes.SliderOrientation", "Horizontal", true, new { id = "SliderHorizontal", title = "Horizontal" })%>
                <label for="SliderHorizontal">be <strong>horizontal</strong></label>
                <br />
                <%: Html.RadioButton("SliderAttributes.SliderOrientation", "Vertical", new { id = "SliderVertical", title = "Vertical" })%>
                <label for="SliderVertical">be <strong>vertical</strong></label>
            </li>
	   </ul>
		
       <button type="submit" class="t-button">Apply</button>
    <% } %>

    <h3>RangeSlider</h3>

    <div class="slider-container">
        <%: Html.EasyUI().RangeSlider<double>()
                .Name("RangeSlider")
                .Min(Model.RangeSliderAttributes.MinValue.Value)
                .Max(Model.RangeSliderAttributes.MaxValue.Value)
                .Values(Model.RangeSliderAttributes.SelectionStart.Value, Model.RangeSliderAttributes.SelectionEnd.Value)
                .SmallStep(Model.RangeSliderAttributes.SmallStep.Value)
                .LargeStep(Model.RangeSliderAttributes.LargeStep.Value)
                .TickPlacement(Model.RangeSliderAttributes.TickPlacement.Value)
                .Orientation(Model.RangeSliderAttributes.SliderOrientation.Value)
	    %>
    </div>

    <% using (Html.Configurator("The range slider should...")
                  .PostTo("FirstLook", "Slider")
                  .Begin())
    { %>
        <ul>
            <li>
		        <label for="RangeSliderAttributes_SelectionStart">have initial <strong>selection start</strong> of</label>
                <%: Html.EasyUI().NumericTextBox()
                        .Name("RangeSliderAttributes.SelectionStart")
                        .MinValue(-100000)
                        .MaxValue(100000)
                        .Value(Model.RangeSliderAttributes.SelectionStart.Value)
                %>
		    </li>
            <li>
		        <label for="RangeSliderAttributes_SelectionEnd">have initial <strong>selection end</strong> of</label>
                <%: Html.EasyUI().NumericTextBox()
                        .Name("RangeSliderAttributes.SelectionEnd")
                        .MinValue(-100000)
                        .MaxValue(100000)
                        .Value(Model.RangeSliderAttributes.SelectionEnd.Value)
                %>
		    </li>
		    <li>
		        <label for="RangeSliderAttributes_MinValue">limit the <strong>minimum</strong> value to</label>
                <%: Html.EasyUI().NumericTextBox()
                        .Name("RangeSliderAttributes.MinValue")
                        .MinValue(-100000)
                        .MaxValue(100000)
                        .Value(Model.RangeSliderAttributes.MinValue.Value)
                %>
		    </li>
		    <li>
		        <label for="RangeSliderAttributes_MaxValue">limit the <strong>maximum</strong> value to</label>
                <%: Html.EasyUI().NumericTextBox()
                        .Name("RangeSliderAttributes.MaxValue")
                        .MinValue(-100000)
                        .MaxValue(100000)
                        .Value(Model.RangeSliderAttributes.MaxValue.Value)
                %>
            </li>
            <li>
		        <label for="RangeSliderAttributes_SmallStep">make <strong>small step</strong> of</label>
                <%: Html.EasyUI().NumericTextBox()
                        .Name("RangeSliderAttributes.SmallStep")
                        .MinValue(0)
                        .MaxValue(100000)
                        .Value(Model.RangeSliderAttributes.SmallStep.Value)
                %>
		    </li>
		    <li>
		        <label for="RangeSliderAttributes_LargeStep">make <strong>large step</strong> of</label>
                <%: Html.EasyUI().NumericTextBox()
                        .Name("RangeSliderAttributes.LargeStep")
                        .MinValue(0)
                        .MaxValue(100000)
                        .Value(Model.RangeSliderAttributes.LargeStep.Value)
                %>
            </li>
            <li>
		        <label for="RangeSliderAttributes_TickPlacement">have <strong>ticks placed</strong></label>
                <%: Html.EasyUI().DropDownList()
                        .Name("RangeSliderAttributes.TickPlacement")
                        .HtmlAttributes(new { style = "width: 90px" })
                        .SelectedIndex((int)Model.RangeSliderAttributes.TickPlacement.Value)
                        .BindTo(new SelectList(Enum.GetNames(typeof(SliderTickPlacement))))
                %>
            </li>
            <li>
                <%: Html.RadioButton("RangeSliderAttributes.SliderOrientation", "Horizontal", true, new { id = "RangeSliderHorizontal", title = "Horizontal" })%>
                <label for="RangeSliderHorizontal">be <strong>horizontal</strong></label>
                <br />
                <%: Html.RadioButton("RangeSliderAttributes.SliderOrientation", "Vertical", new { id = "RangeSliderVertical", title = "Vertical" })%>
                <label for="RangeSliderVertical">be <strong>vertical</strong></label>
            </li>
	   </ul>
		
       <button type="submit" class="t-button">Apply</button>
    <% } %>

</asp:content>

<asp:content contentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        
        .slider-container
        {
            width: 200px;
            height: 200px;
            float: left;
        }
        
        .configurator
        {
            float: left;
            width: 300px;
            margin: 0 0 2.3em 10em;
        }
        
        .configurator .t-numerictextbox .t-input
        {
            width: 60px;
        }
        
        .configurator .t-dropdown
        {
            vertical-align: middle;
        }
        
        .configurator li
        {
            padding-bottom: 4px;
        }
        
    </style>
</asp:content>