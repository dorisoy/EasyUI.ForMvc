<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<FirstLookModelView>" %>
<asp:content contentPlaceHolderID="MainContent" runat="server">

    <h3>DatePicker</h3>
    <%: Html.EasyUI().DatePicker()
            .Name("DatePicker")
            .HtmlAttributes(new { id = "DatePicker_wrapper"})
            .Min(Model.DatePickerAttributes.MinDate.Value)
            .Max(Model.DatePickerAttributes.MaxDate.Value)
            .ShowButton(Model.DatePickerAttributes.ShowButton.Value)
            .Value(Model.DatePickerAttributes.SelectedDate.Value)
            .OpenOnFocus(Model.DatePickerAttributes.OpenOnFocus.Value)
    %>
    
    <% using (Html.Configurator("The date picker should...")
                  .PostTo("FirstLook", "DatePicker")
                  .Begin())
       { %>
	    <ul>
		    <li>
                <%: Html.CheckBox("DatePickerAttributes.ShowButton", Model.DatePickerAttributes.ShowButton.Value)%>
                <label for="DatePickerAttributes_ShowButton">show a popup button</label>
		    </li>
		    <li>
                <%: Html.CheckBox("DatePickerAttributes.OpenOnFocus", Model.DatePickerAttributes.OpenOnFocus)%>
                <label for="DatePickerAttributes_OpenOnFocus">open calendar on textbox focus</label>
		    </li>
		    <li>
			    <label for="DatePickerAttributes_MinDate">show dates between</label>
                <%: Html.EasyUI().DatePicker()
                        .Name("DatePickerAttributes.MinDate")
                        .Min(new DateTime(999, 1, 1))
                        .Value(Model.DatePickerAttributes.MinDate.Value)
                %>
			    <label for="DatePickerAttributes_MaxDate">and</label>
                <%: Html.EasyUI().DatePicker()
                        .Name("DatePickerAttributes.MaxDate")
                        .Max(new DateTime(2999, 12, 31))
                        .Value(Model.DatePickerAttributes.MaxDate.Value)
                %>
		    </li>
		    <li>
			    <label for="DatePickerAttributes_SelectedDate">have pre-selected</label>
                <%: Html.EasyUI().DatePicker()
                        .Name("DatePickerAttributes.SelectedDate")
                        .Min(Model.DatePickerAttributes.MinDate.Value)
                        .Max(Model.DatePickerAttributes.MaxDate.Value)
                        .Value(Model.DatePickerAttributes.SelectedDate.Value)
                %>
		    </li>
	    </ul>
        <button type="submit" class="t-button">Apply</button>
    <% } %>

    <h3>TimePicker</h3>
    <%: Html.EasyUI().TimePicker()
            .Name("TimePicker")
            .HtmlAttributes(new { id = "TimePicker_wrapper" })
            .Min(Model.TimePickerAttributes.MinTime.Value)
            .Max(Model.TimePickerAttributes.MaxTime.Value)
            .ShowButton(Model.TimePickerAttributes.ShowButton.Value)
            .Interval(Model.TimePickerAttributes.Interval.Value)
            .Value(Model.TimePickerAttributes.SelectedDate.Value)
            .OpenOnFocus(Model.TimePickerAttributes.OpenOnFocus.Value)
    %>

    <% using (Html.Configurator("The time picker should...")
                  .PostTo("FirstLook", "DatePicker")
                  .Begin())
       { %>
	    <ul>
		    <li>
                <%: Html.CheckBox("TimePickerAttributes.ShowButton", Model.TimePickerAttributes.ShowButton.Value)%>
                <label for="TimePickerAttributes_ShowButton">show a popup button</label>
		    </li>
		    <li>
                <%: Html.CheckBox("TimePickerAttributes.OpenOnFocus", Model.TimePickerAttributes.OpenOnFocus)%>
                <label for="TimePickerAttributes_OpenOnFocus">open timeview on textbox focus</label>
		    </li>
		    <li>
			    <label for="TimePickerAttributes_MinTime">show time between</label>
                <%: Html.EasyUI().TimePicker()
                        .Name("TimePickerAttributes.MinTime")
                        .Value(Model.TimePickerAttributes.MinTime.Value)
                %>
			    <label for="TimePickerAttributes_MaxTime">and</label>
                <%: Html.EasyUI().TimePicker()
                        .Name("TimePickerAttributes.MaxTime")
                        .Value(Model.TimePickerAttributes.MaxTime.Value)
                %>
		    </li>
		    <li>
			    <label for="TimePickerAttributes_SelectedDate">have pre-selected</label>
                <%: Html.EasyUI().TimePicker()
                        .Name("TimePickerAttributes.SelectedDate")
                        .Min(Model.TimePickerAttributes.MinTime.Value)
                        .Max(Model.TimePickerAttributes.MaxTime.Value)
                        .Value(Model.TimePickerAttributes.SelectedDate.Value)
                %>
		    </li>
            <li>
			    <label for="TimePickerAttributes_Interval">leave a </label>
                <%:  Html.EasyUI().IntegerTextBox()
                         .Name("TimePickerAttributes.Interval")
                         .MinValue(0)
                         .MaxValue(60)
                         .Value(Model.TimePickerAttributes.Interval.Value)
                %> minute interval between values
		    </li>
	    </ul>
        <button type="submit" class="t-button">Apply</button>
    <% } %>

    <h3>DateTimePicker</h3>
    <%: Html.EasyUI().DateTimePicker()
            .Name("DateTimePicker")
            .HtmlAttributes(new { id = "DateTimePicker_wrapper" })
            .Min(Model.DateTimePickerAttributes.MinDate.Value)
            .Max(Model.DateTimePickerAttributes.MaxDate.Value)
            .Interval(Model.DateTimePickerAttributes.Interval.Value)
            .Value(Model.DateTimePickerAttributes.SelectedDate.Value)
    %>

    <% using (Html.Configurator("The date time picker should...")
                  .PostTo("FirstLook", "DatePicker")
                  .Begin())
       { %>
	    <ul>
		    <li>
			    <label for="DateTimePickerAttributes_MinDate">show time between</label>
                <%: Html.EasyUI().DateTimePicker()
                        .Name("DateTimePickerAttributes.MinDate")
                        .Value(Model.DateTimePickerAttributes.MinDate.Value)
                %>
			    <label for="DateTimePickerAttributes_MaxDate">and</label>
                <%: Html.EasyUI().DateTimePicker()
                        .Name("DateTimePickerAttributes.MaxDate")
                        .Value(Model.DateTimePickerAttributes.MaxDate.Value)
                %>
		    </li>
		    <li>
			    <label for="DateTimePickerAttributes_SelectedDate">have pre-selected</label>
                <%: Html.EasyUI().DateTimePicker()
                        .Name("DateTimePickerAttributes.SelectedDate")
                        .Min(Model.DateTimePickerAttributes.MinDate.Value)
                        .Max(Model.DateTimePickerAttributes.MaxDate.Value)
                        .Value(Model.DateTimePickerAttributes.SelectedDate.Value)
                %>
		    </li>
            <li>
			    <label for="DateTimePickerAttributes_Interval">leave a </label>
                <%:  Html.EasyUI().IntegerTextBox()
                         .Name("DateTimePickerAttributes.Interval")
                         .MinValue(0)
                         .MaxValue(60)
                         .Value(Model.DateTimePickerAttributes.Interval.Value)
                %> minute interval between values
		    </li>
	    </ul>
        <button type="submit" class="t-button">Apply</button>
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

<asp:content contentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        #DatePicker_wrapper, #TimePicker_wrapper, #DateTimePicker_wrapper
        {
            margin: 0 150px 230px 0;
            float: left;
            width: 100px;
        }
		
		#TimePicker_wrapper,
		#DateTimePicker_wrapper
        {
            clear: both;
        }
		
		#DateTimePicker_wrapper
        {
            margin-right: 100px;
            width: 150px;
        }
		
	    .example .configurator
	    {
	        width: 500px;
	        float: left;
	        margin: 0;
	        display: inline;
	    }
	    
	    #TimePickerAttributes_Interval .t,
	    #DateTimePickerAttributes_Interval .t
	    {
	        width: 40px;
	    }
	    
	    .configurator p
	    {
	        margin: 0;
	        padding: .7em 0;
	    }
    </style>
</asp:content>
