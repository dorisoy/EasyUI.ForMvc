




namespace EasyUI.Web.Mvc.UI
{
    /// <summary>
    /// Represents the client-side events of the <see cref="Chart{T}"/> component.
    /// </summary>
    public class ChartClientEvents
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ChartClientEvents" /> class.
        /// </summary>
        public ChartClientEvents()
        {
            OnLoad = new ClientEvent();
            OnDataBound = new ClientEvent();
            OnSeriesClick = new ClientEvent();
        }

        /// <summary>
        /// Defines the Load client-side event handler
        /// </summary>
        public ClientEvent OnLoad
        {
            get;
            private set;
        }

        /// <summary>
        /// Defines the DataBound client-side event handler
        /// </summary>
        public ClientEvent OnDataBound
        {
            get;
            private set;
        }

        /// <summary>
        /// Defines the SeriesClick client-side event handler
        /// </summary>
        public ClientEvent OnSeriesClick
        {
            get;
            private set;
        }

        /// <summary>
        /// Serializes the client-side events.
        /// </summary>
        /// <param name="writer">The writer object to serialize to.</param>
        public void SerializeTo(IClientSideObjectWriter writer)
        {
            writer.AppendClientEvent("onLoad", OnLoad);
            writer.AppendClientEvent("onDataBound", OnDataBound);
            writer.AppendClientEvent("onSeriesClick", OnSeriesClick);
        }
    }
}
