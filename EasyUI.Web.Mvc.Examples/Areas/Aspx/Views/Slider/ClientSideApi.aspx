<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:content contentPlaceHolderID="MainContent" runat="server">

    <div class="slider-container">

        <h3>Slider</h3>

	    <%: Html.EasyUI().Slider<int>()
                .Name("Slider")
                .Value(4)
                .Max(20)
                .TickPlacement(SliderTickPlacement.None)
	    %>

    </div>

    <script type="text/javascript"> 

        // Slider
        
        function getSlider () {
            return $("#Slider").data("tSlider");
        }

        function setSliderValue () {
            var slider = getSlider();
            slider.value($("#value").val());
        }
        
        function getSliderValue () {
            var slider = getSlider();
            alert(slider.value());
        }

        function enableSlider () {
            var slider = getSlider();
            slider.enable();
        }

        function disableSlider () {
            var slider = getSlider();
            slider.disable();
        }

        // RangeSlider

        function getRangeSlider () {
            return $("#RangeSlider").data("tRangeSlider");
        }

        function setSelectionStart () {
            var rangeSlider = getRangeSlider();
            var selectionStart = $("#selectionStart").val();
            var selectionEnd = rangeSlider.values()[1];
            rangeSlider.values(selectionStart, selectionEnd);
        }

        function setSelectionEnd () {
            var rangeSlider = getRangeSlider();
            var selectionStart = rangeSlider.values()[0];
            var selectionEnd = $("#selectionEnd").val();
            rangeSlider.values(selectionStart, selectionEnd);
        }
        
        function getRangeSliderValue () {
            var rangeSlider = getRangeSlider();
            alert(rangeSlider.values());
        }

        function enableRangeSlider () {
            var rangeSlider = getRangeSlider();
            rangeSlider.enable();
        }

        function disableRangeSlider () {
            var rangeSlider = getRangeSlider();
            rangeSlider.disable();
        }
    
    </script>

    <% using (Html.Configurator("The slider should...")
                  .Begin())
    { %>
        <ul>
            <li>
                <%: Html.EasyUI().NumericTextBox()
                        .Name("value")
                        .MinValue(0)
                        .MaxValue(20)
                %>
                <button onclick="setSliderValue()" class="t-button">Set Value</button>
                <button onclick="getSliderValue()" class="t-button">Get Value</button>
            </li>
            <li>
                <button onclick="enableSlider()" class="t-button">Enable</button> / 
                <button onclick="disableSlider()" class="t-button">Disable</button>
            </li>
        </ul>
    <% } %>

    <div class="slider-container">

        <h3>RangeSlider</h3>

        <%: Html.EasyUI().RangeSlider<int>()
                .Name("RangeSlider")
                .Values(new int[] { 4, 16 })
                .Max(20)
                .TickPlacement(SliderTickPlacement.None)
	    %>

    </div>

    <% using (Html.Configurator("The range slider should...")
                  .Begin())
    { %>
        <ul>
            <li>
                <%: Html.EasyUI().NumericTextBox()
                        .Name("selectionStart")
                        .MinValue(0)
                        .MaxValue(20)
                %>
                <button onclick="setSelectionStart()" class="t-button">Set SelectionStart</button>
            </li>
            <li>
                <%: Html.EasyUI().NumericTextBox()
                        .Name("selectionEnd")
                        .MinValue(0)
                        .MaxValue(20)
                %>
                <button onclick="setSelectionEnd()" class="t-button">Set SelectionEnd</button>
            </li>
            <li>
            
                <button onclick="getRangeSliderValue()" class="t-button">Get Value</button>
            </li>
            <li>
                <button onclick="enableRangeSlider()" class="t-button">Enable</button> / 
                <button onclick="disableRangeSlider()" class="t-button">Disable</button>
            </li>
        </ul>
    <% } %>

</asp:content>

<asp:content contentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        
        .slider-container
        {
            width: 200px;
            height: 200px;
            float: left;
            clear: left;
        }
        
        .configurator
        {
            float: left;
            width: 300px;
            margin-left: 10em;
        }
        
        .configurator .t-numerictextbox .t-input
        {
            width: 120px;
        }
        
        .configurator .t-dropdown
        {
            vertical-align: middle;
        }
        
        .configurator .t-button
        {
            width: auto;
        }
        
        .configurator li
        {
            padding-bottom: 4px;
        }
        
    </style>
</asp:content>