<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<%@ Import Namespace="Telerik.Web.Mvc.JavaScriptTests" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function defaultOptions() {
            return $.fn.tSlider.defaults;
        }
    </script>

    <input id="slider" min="1" max="3" value="2" class="class" style="float: left;" />
    <input id="slider1" />
    <input id="slider2" />
    <input id="slider3" />
    <input id="slider4" />
    <input id="slider5" />

    <% Html.Telerik().ScriptRegistrar().DefaultGroup(group => group
           .Add("telerik.common.js")
           .Add("telerik.slider.js")); 
    %>
</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">
    <script type="text/javascript">
        
        test("slider should hide input", function() {
            var slider = $('#slider').tSlider();
            equal(slider.css("display"), "none");
        });

        test("createWrapper should render wrapper", function() {
            var body = $t.slider._createWrapper($("#slider"), defaultOptions());

            equal($(body)[0].nodeName.toLowerCase(), "div");
        })

        test("createWrapper should render wrapper with our css classes", function() {
            var body = $t.slider._createWrapper($("#slider"), defaultOptions());
            
            ok($(body).hasClass("t-widget"));
            ok($(body).hasClass("t-slider"));
        });

        test("createWrapper should render wrapper with css classes", function() {
            var body = $t.slider._createWrapper($("#slider"), defaultOptions());

            ok($(body).hasClass("class"));
        });

        test("createWrapper should apply style from input to wrapper", function() {
            var body = $t.slider._createWrapper($("#slider"), defaultOptions());

            equal($(body).css("float"), "left");
        });

        test("createWrapper should apply orientation", function() {
            var body = $t.slider._createWrapper($("#slider"), { orientation: "vertical" });

            ok($(body).hasClass("t-slider-vertical"));
        });

        test("slider should render buttons when showButtons is true", function() {
            var slider = $("#slider").tSlider();
            
            equal($(slider).closest("div").find(".t-icon").length, 2);
        });

        test("slider should render buttons when showButtons is false", function() {
            var slider = $("#slider1").tSlider( { showButtons: false } );

            equal($(slider).closest("div").find(".t-icon").length, 0);
        });

        test("createButton should render button", function() {
            var type = "decrease";
            var button = $t.slider._createButton(defaultOptions(), type);

            equal(button, "<span class='t-icon t-decrease' title='Decrease'>Decrease</span>");
        });

        test("createButton should render button with title", function() {
            var type = "decrease";
            var button = $t.slider._createButton({ decreaseButtonTitle: "title" }, type);

            equal(button, "<span class='t-icon t-decrease' title='title'>title</span>");
        });

        test("createSliderItems should render ul element", function() {
            var builder = $t.slider._createSliderItems(defaultOptions());

            ok($(builder).hasClass("t-slider-items"));
            equal($(builder)[0].nodeName.toLowerCase(), "ul");
        });
        
        test("createSliderItems should render items", function() {
            var builder = $t.slider._createSliderItems({ tickFrequency: 2 });

            equal($(builder).find(".t-tick").length, 2);
        });

        test("createTrack should render divWrapper", function() {
            var builder = $t.slider._createTrack();

            ok($(builder).hasClass("t-slider-track"));
            ok($(builder)[0].nodeName.toLowerCase(), "div");
        });

        test("createTrack should render selectionDiv", function() {
            var builder = $t.slider._createTrack();

            ok($(builder).has(".t-slider-selection"));
        });

        test("createTrack should render dragHandle", function() {
            var builder = $t.slider._createTrack();

            ok($(builder).has(".t-draghandle"));
        });

        test("slider with different value option should set slider value", function() {
            var slider = $("#slider2").tSlider({ val: 1, minValue: 0, maxValue: 10 }).data("tSlider");

            equal(slider.value(), 1);
        });

        test("slider with different value option should not be null or empty string", function() {
            var slider = $("#slider3").tSlider({ val: null, minValue: 0, maxValue: 10 }).data("tSlider");

            equal(slider.value(), 0);

            var slider1 = $("#slider4").tSlider({ val: -1, minValue: 0, maxValue: 10 }).data("tSlider");

            equal(slider1.value(), 0);
        });

        test("slider with different value option should be in range", function() {
            var slider = $("#slider5").tSlider({ val: -1, minValue: 0, maxValue: 10 }).data("tSlider");

            equal(slider.value(), 0);
        });

    </script>
</asp:Content>