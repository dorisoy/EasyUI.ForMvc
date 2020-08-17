




namespace EasyUI.Web.Mvc.UI
{
    internal static class ChartDefaults
    {
        public static class Axis
        {
            public const int MinorTickSize = 3;
            public const int MajorTickSize = 4;
            public const ChartAxisTickType MajorTickType = ChartAxisTickType.Outside;
            public const ChartAxisTickType MinorTickType = ChartAxisTickType.None;
            public const int LineWidth = 1;
        }

        public static class Title
        {
            public const string Font = "16px Arial,Helvetica,sans-serif";
            public const ChartTitlePosition Position = ChartTitlePosition.Top;
            public const ChartTextAlignment Align = ChartTextAlignment.Center;
            public const bool Visible = true;
            public const int Margin = 10;
            public const int Padding = 0;
            public static class Border
            {
                public const int Width = 0;
                public const string Color = "#fff";
                public const ChartDashType DashType = ChartDashType.Solid;
            }
        }

        public static class Legend
        {
            public const string Font = "12px Arial,Helvetica,sans-serif";
            public const ChartLegendPosition Position = ChartLegendPosition.Right;
            public const bool Visible = true;
            public const int Margin = 10;
            public const int Padding = 0;
            public const string Color = "#000";
            public static class Border
            {
                public const int Width = 0;
                public const string Color = "#fff";
                public const ChartDashType DashType = ChartDashType.Solid;
            }
        }

        public static class Tooltip
        {
            public const string Font = "12px Arial,Helvetica,sans-serif";
            public const bool Visible = false;
            public const int Padding = 0;
            public static class Border
            {
                public const int Width = 0;
                public const string Color = "#000";
                public const ChartDashType DashType = ChartDashType.Solid;
            }
            public const double Opacity = 1;
        }

        public static class ChartArea
        {
            public const string background = "#fff";
            public const int Margin = 0;
            public static class Border
            {
                public const int Width = 0;
                public const string Color = "#fff";
                public const ChartDashType DashType = ChartDashType.Solid;
            }
        }

        public static class PlotArea
        {
            public const string background = "#fff";
            public const int Margin = 0;
            public static class Border
            {
                public const int Width = 0;
                public const string Color = "#fff";
                public const ChartDashType DashType = ChartDashType.Solid;
            }
        }

        public static class BarSeries
        {
            public const double Gap = 1.5;
            public const double Spacing = 0.4;
            public static readonly ChartBarSeriesOverlay Overlay = ChartBarSeriesOverlay.Glass;

            public static class Labels
            {
                public const ChartBarLabelsPosition Position = ChartBarLabelsPosition.OutsideEnd;
            }

            public static class Border
            {
                public const int Width = 0;
                public const string Color = "#fff";
                public const ChartDashType DashType = ChartDashType.Solid;
            }
        }

        public static class LineSeries
        {
            public static class Markers
            {
                public const int Size = 6;
                public const string Background = "#fff";
                public const bool Visible = true;
                public const ChartMarkerShape Type = ChartMarkerShape.Square;
                public static class Border
                {
                    public const int Width = 0;
                    public const string Color = "#fff";
                    public const ChartDashType DashType = ChartDashType.Solid;
                }
            }

            public const double Width = 1;
            public const ChartLineMissingValues MissingValues = ChartLineMissingValues.Gap;
            public const ChartDashType DashType = ChartDashType.Solid;
        }

        public static class ScatterLineSeries
        {
            public const double Width = 1;
            public const ChartScatterLineMissingValues MissingValues = ChartScatterLineMissingValues.Gap;
            public const ChartDashType DashType = ChartDashType.Solid;
        }

        public static class PieSeries
        {
            public static class Border
            {
                public const int Width = 0;
                public const string Color = "#fff";
                public const ChartDashType DashType = ChartDashType.Solid;
            }

            public const int StartAngle = 90;
            public const int Padding = 60;

            public static class Labels
            { 
                public const ChartPieLabelsAlign Align = ChartPieLabelsAlign.Circle;
                public const int Distance = 35;
                public const ChartPieLabelsPosition Position = ChartPieLabelsPosition.OutsideEnd;
            }

            public static class Connectors
            {
                public const int Width = 1;
                public const string Color = "#939393";
                public const int Padding = 4;
            }
        }

        public static class PointLabels
        {
            public const ChartPointLabelsPosition Position = ChartPointLabelsPosition.Above;
        }

        public static class Labels
        {
            public const string Font = "16px Arial,Helvetica,sans-serif";
            public const bool Visible = false;
            public const int Rotation = 0;
            public static class Border
            {
                public const int Width = 0;
                public const string Color = "#fff";
                public const ChartDashType DashType = ChartDashType.Solid;
            }
            public const int Margin = 0;
            public const int Padding = 0;
            public const string Color = "#000";
            public const double Opacity = 1;
        }
    }
}