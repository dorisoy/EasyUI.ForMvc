<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content contentPlaceHolderID="MainContent" runat="server">
    <%: Html.EasyUI().Chart<ElectricitySource>()
            .Name("pieChart")
            .Theme(Html.GetCurrentTheme())
            .Title("Break-up of Spain Electricity Production for 2008")
            .Legend(legend => legend
                .Position(ChartLegendPosition.Bottom)
            )
            .Series(series => {
                series.Pie("Percentage", "Source")
                      .Labels(labels => labels.Visible((bool)ViewBag.showLabels).Template("<#= value #>%")
                          .Align((ChartPieLabelsAlign)ViewBag.align)
                          .Position((ChartPieLabelsPosition)ViewBag.position))
                      .StartAngle((int)ViewBag.startAngle).Padding((int)ViewBag.padding);
            })
            .DataBinding(dataBinding => dataBinding
                .Ajax().Select("_SpainElectricity", "Chart")
            )
            .Tooltip(tooltip => tooltip.Visible(true).Template("<#= value #>%"))
            .HtmlAttributes(new { style = "width: 500px; height: 400px;" })
    %>

    <% using (Html.Configurator("The pie chart should have...")
                  .PostTo("PieChart", "Chart")
                  .Begin())
       { %>
    <ul id="chart-options">
        <li>
            <%: Html.CheckBox("showLabels") %>
            <label for="showLabels">labels</label>
        </li>
        <li>
            <div>
                <%: Html.RadioButton("position", "OutsideEnd",
                    (ChartPieLabelsPosition)ViewBag.position == ChartPieLabelsPosition.OutsideEnd, new { id = "PositionOutsideEnd", title = "OutsideEnd" }) %>
                <label for="PositionOutsideEnd">on the outside,</label>
                <label for="align">aligned in:</label>
                <%: Html.RadioButton("align", "Column",
                    (ChartPieLabelsAlign)ViewBag.align == ChartPieLabelsAlign.Column, new { id = "AlignColumn", title = "Column" }) %>
                <label for="AlignColumn">columns</label>
                <%: Html.RadioButton("align", "Circle",
                    (ChartPieLabelsAlign)ViewBag.align == ChartPieLabelsAlign.Circle, new { id = "AlignCircle", title = "Circle" }) %>
                <label for="AlignCircle">cicle</label>
            </div>
            <div>
                <%: Html.RadioButton("position", "InsideEnd",
                    (ChartPieLabelsPosition)ViewBag.position == ChartPieLabelsPosition.InsideEnd, new { id = "PositionInsideEnd", title = "InsideEnd" }) %>
                <label for="PositionInsideEnd">near the end of the segment</label>
            </div>
            <div>
                <%: Html.RadioButton("position", "Center",
                    (ChartPieLabelsPosition)ViewBag.position == ChartPieLabelsPosition.Center, new { id = "PositionCenter", title = "Center" }) %>
                <label for="PositionCenter">at the segment center</label>
            </div>
        </li>
        <li style="margin-top: 20px;">
            <%: Html.EasyUI().Slider<int>()
                    .Name("startAngle")
                    .ShowButtons(false)
                    .Max(360)
                    .TickPlacement(SliderTickPlacement.None)
                    .HtmlAttributes(new { style = "vertical-align: top; float: right;" })
            %>
            <label for="startAngle">start angle:</label>
        </li>
        <li>
            <%: Html.EasyUI().Slider<int>()
                    .Name("padding")
                    .ShowButtons(false)
                    .Min(30)
                    .Max(100)
                    .TickPlacement(SliderTickPlacement.None)
                    .HtmlAttributes(new { style = "vertical-align: top; float: right;" })
            %>
            <label for="padding">padding:</label>
        </li>
    </ul>
    <button type="submit" class="t-button">
        Apply</button>
    <% } %>

</asp:Content>

<asp:Content contentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .example .configurator
        {
            float: right;
            margin: 0 0 0 0;
            display: inline;
        }
        
        .example .configurator ul
        {
            line-height: 1.8em;
        }
        
        .t-chart
        {
            float: left;
        }
    </style>
</asp:Content>