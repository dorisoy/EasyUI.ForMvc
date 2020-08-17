<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        var isSliderChangeRaised;
        var isRangeSliderChangeRaised;

        function sliderChange (e) {
            isSliderChangeRaised = true;
        }

        function rangeSliderChange (e) {
            isRangeSliderChangeRaised = true;
        }

        function getSlider (selector) {
            return $(selector || "#Slider").data("tSlider");
        }

        function getRangeSlider (selector) {
            return $(selector || "#RangeSlider").data("tRangeSlider");
        }

    </script>
    
    <%= Html.EasyUI().Slider<int>()
            .Name("Slider")
            .Max(10)
	%>

    <%= Html.EasyUI().Slider<int>()
            .Name("Slider1")
            .Max(10)
            .ShowButtons(false)
            .ClientEvents(events => events.OnChange("sliderChange"))
	%>

    <%= Html.EasyUI().Slider<int>()
            .Name("Slider2")
            .Value(1)
            .Max(10)
	%>

    <%= Html.EasyUI().Slider<int>()
            .Name("Slider3")
            .Value(-1)
            .Min(-5)
	%>

    <%= Html.EasyUI().RangeSlider<int>()
            .Name("RangeSlider")
            .Values(1, 3)
            .Max(10)
	%>

    <%= Html.EasyUI().RangeSlider<int>()
            .Name("RangeSlider1")
            .Values(1, 3)
            .Max(10)
            .ClientEvents(events => events.OnChange("rangeSliderChange"))
	%>

</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">
    <script type="text/javascript">
        module("Slider/ClientSideAPI", {
            setup: function () {
                isSliderChangeRaised = false;
                isRangeSliderChangeRaised = false;
            }
        });
        
        test("value should set slider value", function() {
            var slider = getSlider();

            slider.value(9);

            equal(slider.value(), 9);
        });

        test("value should not be null or empty string and should return old value", function() {
            var slider = getSlider();
            
            slider.value(2)

            slider.value(" ");

            equal(slider.value(), 2);

            slider.value(null);

            equal(slider.value(), 2);
        });

        test("value should be in range", function() {
            var slider = getSlider("#Slider1");

            slider.value(11);

            equal(slider.value(), 0);

            slider.value(-1);

            equal(slider.value(), 0);
        });

        test("value should set slider position selectionDiv", function () {
            var slider = getSlider("#Slider2");

            var selectionDiv = slider.wrapper.find(".t-slider-selection");

            slider.value(10);

            equal(selectionDiv.width(), 144);
        });

        test("value should be in range", function() {
            var slider = getSlider("#Slider1");

            var selectionDiv = slider.wrapper.find(".t-slider-selection");

            slider.value(11);

            equal(selectionDiv.width(), 0);

            slider.value(-1);

            equal(selectionDiv.width(), 0);
        });

        test("when value is string slider should set slider value", function() {
            var slider = getSlider("#Slider1");

            slider.value("1");

            equal(1, slider.value());
        });

        test("value should not trigger change event", function() {
            var slider = getSlider("#Slider1");
            slider.value(1);

            isSliderChangeRaised = false;

            slider.value(2);

            ok(!isSliderChangeRaised);
        });

        test("value should set value to the input", function() {
            var slider = getSlider("#Slider2");

            var value = 2;

            slider.value(value);

            equal($(slider.element).val(), value);
        });

        test("disable method should disable slider", function () {
            var slider = getSlider("#Slider2");

            slider.enable();
            slider.disable();

            ok(slider.wrapper.attr("disabled"));
            ok(!slider.enabled);
        });

        test("enable method should enable slider", function () {
            var slider = getSlider("#Slider2");

            slider.disable();
            slider.enable();

            ok(!slider.wrapper.attr("disabled"));
            ok(slider.enabled);
        });

        test("disable should unbind click event of the buttons of the slider", function () {
            var slider = getSlider("#Slider2");

            slider.enable();
            slider.disable();

            var buttons = slider.wrapper.find(".t-button");

            ok(!(buttons.first().data("events").mousedown[0].handler !== $.easyui.preventDefault));
            ok(!(buttons.last().data("events").mousedown[0].handler !== $.easyui.preventDefault));
        });

        test("enable should bind click event of the buttons of the slider", function () {
            var slider = getSlider("#Slider2");

            slider.disable();
            slider.enable();

            var buttons = slider.wrapper.find(".t-button");

            ok((buttons.first().data("events").mousedown[0].handler !== $.easyui.preventDefault));
            ok((buttons.last().data("events").mousedown[0].handler !== $.easyui.preventDefault));
        });

        test("disable method should add state disabled to the slider", function () {
            var slider = getSlider("#Slider2");

            slider.enable();
            slider.disable();

            ok(slider.wrapper.hasClass("t-state-disabled"));
        });

        test("enable method should remove state disabled from the slider", function () {
            var slider = getSlider("#Slider2");

            slider.disable();
            slider.enable();

            ok(!slider.wrapper.hasClass("t-state-disabled"));
        });

        test("refresh method should not select minimum when slider increase his value from -1 to 0", function () {
            var slider = getSlider("#Slider3");

            slider.value(0)

            ok(slider.value, 0);
        });

        test('slider should not trigger change if we decrease value with 1 step and value is equal to min value', function () {
            var downArrow = "40"; // down arrow
            var leftArrow = "37"; // left arrow
            var slider = $("#Slider1").data("tSlider");
            var dragHandle = slider.wrapper.find(".t-draghandle");

            isSliderChangeRaised = false;

            slider.value(slider.minValue);

            dragHandle.trigger({ type: "keydown", keyCode: downArrow });

            ok(!isSliderChangeRaised);
        
            dragHandle.trigger({ type: "keydown", keyCode: leftArrow });

            ok(!isSliderChangeRaised);
        });

        //
        // RangeSlider
        //

        test("values should set rangeSlider selectionStart and selectionEnd", function () {
            var rangeSlider = getRangeSlider();

            rangeSlider.values(0, 9);

            equal(rangeSlider.selectionStart, 0);
            equal(rangeSlider.selectionEnd, 9);

            rangeSlider.values(1, 3);
        });

        test("values should return array of selectionStart and selectionEnd", function () {
            var rangeSlider = getRangeSlider();

            rangeSlider.values(0, 9);
            var values = rangeSlider.values();

            equal(values[0], 0);
            equal(values[1], 9);

            rangeSlider.values(1, 3);
        });

        test("values should not be null or empty string and should return old values", function () {
            var rangeSlider = getRangeSlider();

            var values = rangeSlider.values(" ");

            equal(values[0], 1);
            equal(values[1], 3);

            values = rangeSlider.values(null);

            equal(values[0], 1);
            equal(values[1], 3);
        });

        test("values should be in range", function () {
            var rangeSlider = getRangeSlider();

            rangeSlider.values(-1, 11);
            var values = rangeSlider.values();

            equal(values[0], 1);
            equal(values[1], 3);
        });

        test("values should set rangeSlider position selectionDiv", function () {
            var rangeSlider = getRangeSlider();

            var selectionDiv = rangeSlider.wrapper.find(".t-slider-selection");

            rangeSlider.values(0, 10);

            equal(selectionDiv.width(), 198);
        });

        test("values should not trigger change event", function () {
            var rangeSlider = getRangeSlider("#RangeSlider1");
            rangeSlider.values(1, 3);

            isRangeSliderChangeRaised = false;

            rangeSlider.values(1, 4);

            ok(!isRangeSliderChangeRaised);
        });

        test("values should set values to the inputs", function () {
            var rangeSlider = getRangeSlider();

            var selectionStart = 2;
            var selectionEnd = 5;

            rangeSlider.values(selectionStart, selectionEnd);

            var inputs = $(rangeSlider.element).find("input");

            equal(inputs.eq(0).val(), selectionStart);
            equal(inputs.eq(1).val(), selectionEnd);
        });

        test("values should set selectionStart and selectionEnd values from string parameters", function() {
            var rangeSlider = getRangeSlider();

            rangeSlider.values("1", "2");
            var values = rangeSlider.values();

            equal(1, values[0]);
            equal(2, values[1]);
        });

        test("values should set z-index to first handle", function() {
            var rangeSlider = getRangeSlider();
            var dragHandles = rangeSlider.wrapper.find(".t-draghandle");
            var firstDragHandle = dragHandles.eq(0);

            rangeSlider.values(10, 10);
            equal(1, firstDragHandle.css("z-index"));
        });

        test("disable method should disable range slider", function () {
            var rangeSlider = getRangeSlider();

            rangeSlider.enable();
            rangeSlider.disable();

            ok(rangeSlider.wrapper.attr("disabled"));
            ok(!rangeSlider.enabled);
        });

        test("enable method should enable range slider", function () {
            var rangeSlider = getRangeSlider();

            rangeSlider.disable();
            rangeSlider.enable();

            ok(!rangeSlider.wrapper.attr("disabled"));
            ok(rangeSlider.enabled);
        });

        test("disable method should add state disabled to the range slider", function () {
            var rangeSlider = getRangeSlider();

            rangeSlider.enable();
            rangeSlider.disable();

            ok(rangeSlider.wrapper.hasClass("t-state-disabled"));
        });

        test("enable method should remove state disabled from the range slider", function () {
            var rangeSlider = getRangeSlider();

            rangeSlider.disable();
            rangeSlider.enable();

            ok(!rangeSlider.wrapper.hasClass("t-state-disabled"));
        });

        test('range slider should not trigger change if we decrease selectionStart with 1 step and selectionStart is equal to min value', function () {
            var downArrow = "40"; // down arrow
            var leftArrow = "37"; // left arrow
            var rangeSlider = $("#RangeSlider1").data("tRangeSlider");
            var dragHandles = rangeSlider.wrapper.find(".t-draghandle");

            isSliderChangeRaised = false;

            rangeSlider.values(rangeSlider.minValue, rangeSlider.minValue);

            dragHandles.eq(0).trigger({ type: "keydown", keyCode: downArrow });

            ok(!isRangeSliderChangeRaised);
        
            dragHandles.eq(0).trigger({ type: "keydown", keyCode: leftArrow });

            ok(!isRangeSliderChangeRaised);
        });

    </script>
</asp:Content>