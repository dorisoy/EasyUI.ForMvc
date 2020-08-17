<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>
<asp:content contentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">
        //DatePicker client-side events.

        function onChangeDatePicker(e) {
            $console.log('OnChange :: to ' + formatDate(e.value) + ' from ' + formatDate(e.previousValue));
        }

        function onLoadDatePicker(e) {
            $console.log('DatePicker loaded');
        }

        function OnOpenDatePicker(e) {
		    $console.log('OnOpen :: date view drop-down opening');
		}

		function OnCloseDatePicker(e) {
		    $console.log('OnClose :: date view drop-down closing');
		}

	    //TimePicker client-side events.

        function onChangeTimePicker(e)
        {
            $console.log('OnChange :: to ' + formatTime(e.value) + ' from ' + formatTime(e.previousValue));
        }

        function onLoadTimePicker(e)
        {
            $console.log('TimePicker loaded');
        }

        function OnOpenTimePicker(e)
        {
            $console.log('OnOpen :: time view drop-down opening');
        }

        function OnCloseTimePicker(e)
        {
            $console.log('OnClose :: time view drop-down closing');
        }

        //DateTimePicker client-side events.

        function onChangeDateTimePicker(e) {
            $console.log('OnChange :: to ' + formatDateTime(e.value) + ' from ' + formatDateTime(e.previousValue));
        }

        function onLoadDateTimePicker(e) {
            $console.log('DateTimePicker loaded');
        }

        function OnOpenDateTimePicker(e) {            
            $console.log('OnOpen :: ' + e.popup + ' view drop-down opening');
        }

        function OnCloseDateTimePicker(e) {
            $console.log('OnClose :: ' + e.popup + ' view drop-down closing');
        }

        function formatDate(date)
        {
            return $.easyui.formatString('{0:dd/MM/yyyy}', date);
        }

        function formatTime(date) {
            return $.easyui.formatString('{0:h:mm tt}', date);
        }

        function formatDateTime(date) {
            return $.easyui.formatString('{0:dd/MM/yyyy/h:mm tt}', date);
        }
    </script>

    <%: Html.EasyUI().DatePicker()
            .Name("DatePicker")
            .ClientEvents(events => events
                     .OnLoad("onLoadDatePicker")
                     .OnChange("onChangeDatePicker")
                     .OnOpen("OnOpenDatePicker")
                     .OnClose("OnCloseDatePicker")
            )
            .HtmlAttributes(new { style = "margin-bottom: 1.3em" })
    %>

    <%: Html.EasyUI().TimePicker()
            .Name("TimePicker")
            .Min(new DateTime(2000, 1, 1, 10,0,0))
            .ClientEvents(events => events
                    .OnLoad("onLoadTimePicker")
                    .OnChange("onChangeTimePicker")
                    .OnOpen("OnOpenTimePicker")
                    .OnClose("OnCloseTimePicker")
            )
            .HtmlAttributes(new { style = "margin-bottom: 1.3em" })
    %>

    <%: Html.EasyUI().DateTimePicker()
            .Name("DateTimePicker")
            .ClientEvents(events => events
                    .OnLoad("onLoadDateTimePicker")
                    .OnChange("onChangeDateTimePicker")
                    .OnOpen("OnOpenDateTimePicker")
                    .OnClose("OnCloseDateTimePicker")
            )
    %>
    	
    <% Html.RenderPartial("EventLog"); %>

</asp:content>
