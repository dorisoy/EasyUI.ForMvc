<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:content contentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">
        
        // Slider client-side events.
        function onLoadSlider(e) {
            $console.log('Slider loaded.');
        }
        
        function onChangeSlider(e) {
            $console.log("OnChange :: new value is: " + e.value);
        }

        function onSlideSlider(e) {
            $console.log("Slide :: new slide value is: " + e.value);
        }
        
        // RangeSlider client-side events.
        function onLoadRangeSlider(e) {
            $console.log('Range slider loaded.');
        }
        
        function onChangeRangeSlider(e) {
            $console.log("OnChange :: new values are: " + e.values.toString().replace(',', ' - '));
        }
        
        function onSlideRangeSlider(e) {
            $console.log("Slide :: new slide value are: " + e.values.toString().replace(',', ' - '));
        }

    </script>

    <div class="slider-container">

        <h3>Slider</h3>

	    <%: Html.EasyUI().Slider<int>()
                .Name("Slider")
                .TickPlacement(SliderTickPlacement.None)
                .Value(4)
                .ClientEvents(events => events
                          .OnLoad("onLoadSlider")
                          .OnChange("onChangeSlider")
                          .OnSlide("onSlideSlider"))
	    %>

    </div>

    <div class="slider-container">

        <h3>RangeSlider</h3>

        <%: Html.EasyUI().RangeSlider<int>()
                .Name("RangeSlider")
                .TickPlacement(SliderTickPlacement.None)
                .Values(new int[] { 2, 8 })
                .ClientEvents(events => events
                          .OnLoad("onLoadRangeSlider")
                          .OnChange("onChangeRangeSlider")
                          .OnSlide("onSlideRangeSlider"))
	    %>

    </div>

    <% Html.RenderPartial("EventLog"); %>

</asp:content>

<asp:content contentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        
        .slider-container
        {
            float: left;
            width: 300px;
        }
        
        .event-log-wrap
        {
            clear: left;
            padding-top: 4em;
        }
        
    </style>
</asp:content>