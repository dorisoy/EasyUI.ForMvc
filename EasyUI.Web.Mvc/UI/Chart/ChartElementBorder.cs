﻿




namespace EasyUI.Web.Mvc.UI
{
    /// <summary>
    /// Represents chart element border
    /// </summary>
    public class ChartElementBorder
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ChartSpacing" /> class.
        /// </summary>
        public ChartElementBorder(int width, string color, ChartDashType dashType)
        {
            Width = width;
            Color = color;
            DashType = dashType;
        }

        /// <summary>
        /// Gets or sets the width of the border.
        /// </summary>
        public int Width
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the color of the border.
        /// </summary>
        public string Color
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets the dash type of the border.
        /// </summary>
        public ChartDashType DashType
        {
            get;
            set;
        }

        /// <summary>
        /// Creates a serializer
        /// </summary>
        public IChartSerializer CreateSerializer()
        {
            return new ChartElementBorderSerializer(this);
        }
    }
}