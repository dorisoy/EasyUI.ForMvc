<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>
<asp:content contentPlaceHolderID="MainContent" runat="server">
    
    <h3>DatePicker</h3>
    <%: Html.EasyUI().DatePicker()
            .Name("DatePicker")
            .HtmlAttributes(new { id = "DatePicker_wrapper" })
    %>

	<script type="text/javascript">
	    function getDatePicker() {
	        var datePicker = $('#DatePicker').data("tDatePicker");
	        return datePicker;
        }

        function updateValue() {
            var value = $('#DatePickerValue').data("tDatePicker").value();
            getDatePicker().value(value);
	    }

	    function getValue() {
	        alert(getDatePicker().value());
	    }

	    function showCalendar(e) {
	        getDatePicker().showPopup();
	        
	        // prevent the click from bubbling, thus, closing the popup
	        if (e.stopPropagation) e.stopPropagation();
	        e.cancelBubble = true; 
	    }

	    function hideCalendar() {
	        getDatePicker().hidePopup();
	    }

	    function enableDatePicker() {
	        getDatePicker().enable();
	        $('#ShowCalendar').removeClass('t-state-disabled').removeAttr('disabled');
	        $('#HideCalendar').removeClass('t-state-disabled').removeAttr('disabled');
	    }

	    function disableDatePicker() {
	        getDatePicker().disable();
	        $('#ShowCalendar').addClass('t-state-disabled').attr('disabled', 'disabled');
	        $('#HideCalendar').addClass('t-state-disabled').attr('disabled', 'disabled');
	    }

        function minDatePicker() {
            var value = $('#DatePickerMinOrMax').data("tDatePicker").value();
	        getDatePicker().min(value);
	    }

	    function maxDatePicker() {
            var value = $('#DatePickerMinOrMax').data("tDatePicker").value();
	        getDatePicker().max(value);
	    }
	</script>

    <% using (Html.Configurator("Client API").Begin()) 
       { %>
        <ul>
            <li>
                <%: Html.EasyUI().DatePicker()
                        .Name("DatePickerValue")
                        .Value(new DateTime(2010, 1, 1)) 
                %>
                <button class="t-button" onclick="updateValue()">Select</button>
            </li>
            
            <li>
                <button class="t-button" onclick="getValue()" style="width: 100px;">Get Value</button>
            </li>
            <li>
                <button id="ShowCalendar" class="t-button" onclick="showCalendar(event)">Open</button> /
                <button id="HideCalendar" class="t-button" onclick="hideCalendar()">Close</button>
            </li>
            <li>
                <button class="t-button" onclick="enableDatePicker()">Enable</button> /
                <button class="t-button" onclick="disableDatePicker()">Disable</button>
            </li>
            <li>
                <%: Html.EasyUI().DatePicker()
                        .Name("DatePickerMinOrMax")
                %>
                <button id="SetMinDate" class="t-button" onclick="minDatePicker()">Set Min date</button> /
                <button id="SetMaxDate" class="t-button" onclick="maxDatePicker()">Set Max date</button>
            </li>
        </ul>
    <% } %>

    <h3>TimePicker</h3>
    <%: Html.EasyUI().TimePicker()
            .Name("TimePicker")
            .HtmlAttributes(new { id = "TimePicker_wrapper" })
    %>

	<script type="text/javascript">
	    function getTimePicker() {
	        var timePicker = $('#TimePicker').data("tTimePicker");
	        return timePicker;
        }

        function updateTimePickerValue() {
            var value = $('#TimePickerValue').data("tTimePicker").value();
            getTimePicker().value(value);
	    }

	    function getTimePickerValue() {
	        alert(getTimePicker().value());
	    }

	    function openTimePicker(e) {
	        getTimePicker().open();

	        // prevent the click from bubbling, thus, closing the suggestion list
	        if (e.stopPropagation) e.stopPropagation();
	        e.cancelBubble = true;
	    }

	    function closeTimePicker() {
	        getTimePicker().close();
	    }

	    function enableTimePicker() {
	        getTimePicker().enable();
	        $('#OpenTimePicker').removeClass('t-state-disabled').removeAttr('disabled');
	        $('#CloseTimePicker').removeClass('t-state-disabled').removeAttr('disabled');
	    }

	    function disableTimePicker() {
	        getTimePicker().disable();
	        $('#OpenTimePicker').addClass('t-state-disabled').attr('disabled', 'disabled');
	        $('#CloseTimePicker').addClass('t-state-disabled').attr('disabled', 'disabled');
	    }

        function minTimePicker() {
            var value = $('#TimePickerMinOrMax').data("tTimePicker").value();
	        getTimePicker().min(value);
	    }

	    function maxTimePicker() {
            var value = $('#TimePickerMinOrMax').data("tTimePicker").value();
	        getTimePicker().max(value);
	    }
	</script>

    <% using (Html.Configurator("Client API").Begin()) 
       { %>
        <ul>
            <li>
                <%: Html.EasyUI().TimePicker()
                        .Name("TimePickerValue")
                        .HtmlAttributes(new { id = "TimePickerValue_wrapper" })
                        .Value(DateTime.Now)
                %>
                <button class="t-button" onclick="updateTimePickerValue()">Select</button>
            </li>
            
            <li>
                <button class="t-button" onclick="getTimePickerValue()" style="width: 100px;">Get Value</button>
            </li>
            <li>
                <button id="OpenTimePicker" class="t-button" onmousedown="openTimePicker(event)">Open</button> /
                <button id="CloseTimePicker" class="t-button" onclick="closeTimePicker()">Close</button>
            </li>
            <li>
                <button class="t-button" onclick="enableTimePicker()">Enable</button> /
                <button class="t-button" onclick="disableTimePicker()">Disable</button>
            </li>
            <li>
                <%: Html.EasyUI().TimePicker()
                        .Name("TimePickerMinOrMax")
                %>
                <button id="SetMinTime" class="t-button" onclick="minTimePicker()">Set Min time</button> /
                <button id="SetMaxTime" class="t-button" onclick="maxTimePicker()">Set Max time</button>
            </li>
        </ul>
    <% } %>

    <h3>DateTimePicker</h3>
    <%: Html.EasyUI().DateTimePicker()
            .Name("DateTimePicker")
            .HtmlAttributes(new { id = "DateTimePicker_wrapper" })      
    %>

	<script type="text/javascript">
	    function getDateTimePicker() {
	        var dateTimePicker = $('#DateTimePicker').data("tDateTimePicker");
	        return dateTimePicker;
	    }

	    function updateDateTimePickerValue() {
	        var value = $('#DateTimePickerValue').data("tDateTimePicker").value();
	        getDateTimePicker().value(value);
	    }

	    function getDateTimePickerValue() {
	        alert(getDateTimePicker().value());
	    }

	    function openDateTimePicker(e, popup) {
	        getDateTimePicker().open(popup);

	        // prevent the click from bubbling, thus, closing the suggestion list
	        if (e.stopPropagation) e.stopPropagation();
	        e.cancelBubble = true;
	    }

	    function closeDateTimePicker() {
	        getDateTimePicker().close();
	    }

	    function enableDateTimePicker() {
	        getDateTimePicker().enable();
	        $('#OpenDateTimeCalendarPicker,#OpenDateTimeTimePicker,#CloseDateTimePicker')
                .removeClass('t-state-disabled').removeAttr('disabled');
	    }

	    function disableDateTimePicker() {
	        getDateTimePicker().disable();
	        $('#OpenDateTimeCalendarPicker,#OpenDateTimeTimePicker,#CloseDateTimePicker')
                .addClass('t-state-disabled').attr('disabled', 'disabled');
	    }

	    function minDateTimePicker() {
	        var value = $('#DatePickerMinOrMaxValue').data("tDatePicker").value();
	        getDateTimePicker().min(value);
	    }

	    function maxDateTimePicker() {
	        var value = $('#DatePickerMinOrMaxValue').data("tDatePicker").value();
	        getDateTimePicker().max(value);
	    }

        function startTimeDateTimePicker() {
	        var value = $('#TimePickerMinOrMaxValue').data("tTimePicker").value();
	        getDateTimePicker().startTime(value);
	    }

	    function endTimeDateTimePicker() {
	        var value = $('#TimePickerMinOrMaxValue').data("tTimePicker").value();
	        getDateTimePicker().endTime(value);
	    }
	</script>

    <% using (Html.Configurator("Client API").Begin()) 
       { %>
        <ul>
            <li>
                <%: Html.EasyUI().DateTimePicker()
                        .Name("DateTimePickerValue")
                        .Value(new DateTime(2010, 1, 1, 10, 0, 0))
                %>
                <button class="t-button" onclick="updateDateTimePickerValue()">Select</button>
            </li>
            
            <li>
                <button class="t-button" onclick="getDateTimePickerValue()" style="width: 100px;">Get Value</button>
            </li>
            <li>
                <button id="OpenDateTimeCalendarPicker" class="t-button" onmousedown="openDateTimePicker(event, 'date')">Open Calendar</button> /
                <button id="OpenDateTimeTimePicker" class="t-button" onmousedown="openDateTimePicker(event, 'time')">Open TimePicker</button> /
                <button id="CloseDateTimePicker" class="t-button" onclick="closeDateTimePicker()">Close</button>
            </li>
            <li>
                <button class="t-button" onclick="enableDateTimePicker()">Enable</button> /
                <button class="t-button" onclick="disableDateTimePicker()">Disable</button>
            </li>
            <li>
                <%: Html.EasyUI().DatePicker()
                        .Name("DatePickerMinOrMaxValue")
                %>
                <button id="SetMinDateTime" class="t-button" onclick="minDateTimePicker()">Set Min date</button> /
                <button id="SetMaxDateTime" class="t-button" onclick="maxDateTimePicker()">Set Max date</button>
            </li>
            <li>
                <%: Html.EasyUI().TimePicker()
                        .Name("TimePickerMinOrMaxValue")
                %>
                <button id="SetStartTime" class="t-button" onclick="startTimeDateTimePicker()">Set Start time</button> /
                <button id="SetEndTime" class="t-button" onclick="endTimeDateTimePicker()">Set End time</button>
            </li>
        </ul>
    <% } %>
			
</asp:content>

<asp:Content contentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
	    .example .configurator
	    {
	        width: 330px;
	        float: left;
	        display: inline;
	    }
	    
	    .configurator p
	    {
	        margin: 0;
	        padding: .4em 0;
	    }
	    
	    .configurator .t-button
	    {
	        margin: 0 0 1em;
	    }
	    
        #DatePicker_wrapper, #TimePicker_wrapper, #DateTimePicker_wrapper
        {
            margin: 0 250px 230px 0;
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
            margin-right: 200px;
            width: 150px;
        }
	    
	    #TimePickerValue_wrapper
	    {
	        width: 100px;
	    }
	    
	    #OpenDateTimeCalendarPicker, #OpenDateTimeTimePicker
	    {
	        width: 120px;
	    }
	    
	    #SetMinDateTime, #SetMaxDateTime,
	    #SetStartTime, #SetEndTime,
	    #SetMinTime, #SetMaxTime,
	    #SetMinDate, #SetMaxDate
	    {
	        width: 100px;
	    }
    </style>
</asp:Content>