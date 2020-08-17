




namespace EasyUI.Web.Mvc.UI
{
    /// <summary>
    /// Represents chart series
    /// </summary>
    public interface IChartSeries
    {
        /// <summary>
        /// The series name.
        /// </summary>
        string Name 
        { 
            get;
            set; 
        }

        /// <summary>
        /// The series opacity
        /// </summary>
        double Opacity
        {
            get;
            set;
        }

        /// <summary>
        /// The series base color
        /// </summary>
        string Color
        {
            get;
            set;
        }

        /// <summary>
        /// Creates a serializer for the series
        /// </summary>
        IChartSerializer CreateSerializer();        
    }
}