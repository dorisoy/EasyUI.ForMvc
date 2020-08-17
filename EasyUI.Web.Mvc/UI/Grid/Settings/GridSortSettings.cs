




namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using System.Linq;

    public class GridSortSettings : IClientSerializable
    {
        private readonly IGrid grid;

        public GridSortSettings(IGrid grid)
        {
            this.grid = grid;
            
            OrderBy = new List<SortDescriptor>();
        }

        public bool Enabled
        {
            get;
            set;
        }

        public GridSortMode SortMode
        {
            get;
            set;
        }

        public IList<SortDescriptor> OrderBy
        {
            get;
            private set;
        }

        public void SerializeTo(string key, IClientSideObjectWriter writer)
        {
            if (Enabled)
            {
                writer.Append("sortMode", SortMode == GridSortMode.MultipleColumn ? "multi" : "single");
                if (grid.DataProcessor.SortDescriptors.Any())
                {
                    writer.Append("orderBy", GridDescriptorSerializer.Serialize(grid.DataProcessor.SortDescriptors));
                }
            }
        }
    }
}