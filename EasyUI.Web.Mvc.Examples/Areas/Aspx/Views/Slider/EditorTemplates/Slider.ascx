<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<decimal>" %>

<%: Html.EasyUI().Slider<decimal>()
        .Name(ViewData.TemplateInfo.GetFullHtmlFieldName(string.Empty))
        .Max(20)
        .SmallStep(0.1m)
        .ShowButtons(false)
        .HtmlAttributes(new { style="width:132px;" })
        .Value(Model)
        .TickPlacement(SliderTickPlacement.None)
        .ClientEvents(events => events
            .OnSlide("onSlide")
            .OnChange("onChange")
        )
%>
 
<div class="currentValueWrapper">
    <div id="currentValueDiv" class="t-widget" style="width:40px; height:20px; line-height:20px; text-align:center;"><%: Convert.ToDouble(Model) %></div>
</div>

<script type="text/javascript">

    function onSlide(e) {
        $("#currentValueDiv").html(e.value);
    }

    function onChange(e) {
        $("#currentValueDiv").html(e.value);
    }

</script>