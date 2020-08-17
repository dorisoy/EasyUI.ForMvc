﻿



namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Linq;
    using EasyUI.Web.Mvc.Extensions;
    using EasyUI.Web.Mvc.Infrastructure;

    public class GridGroupingSettings : IClientSerializable
    {
        private readonly IGrid grid;

        public GridGroupingSettings(IGrid grid)
        {
            this.grid = grid;

            Groups = new List<GroupDescriptor>();
            Visible = true;
        }

        public bool Enabled
        {
            get;
            set;
        }

        public bool Visible
        {
            get;
            set;
        }

        public IList<GroupDescriptor> Groups
        {
            get;
            private set;
        }
        
        public void SerializeTo(string key, IClientSideObjectWriter writer)
        {
            if (Enabled)
            {
                if (grid.DataProcessor.GroupDescriptors.Any())
                {
                    writer.AppendCollection("groups", SerializeDescriptors());
                    writer.Append("groupBy", SerializeExpression());
                }
            }
        }

        public IEnumerable<IDictionary<string, object>> SerializeDescriptors()
        {
            var result = new List<IDictionary<string, object>>();

            grid.DataProcessor.GroupDescriptors.Each(groupDescriptor =>
            {
                var group = new Dictionary<string, object>();

                FluentDictionary.For(group)
                    .Add("member", groupDescriptor.Member)
                    .Add("order", groupDescriptor.SortDirection == ListSortDirection.Ascending ? "asc" : "desc")
                    .Add("title", grid.Columns.GroupTitleForMember(groupDescriptor.Member));

                result.Add(group);
            });

            return result;
        }

        public string SerializeExpression()
        {
            return GridDescriptorSerializer.Serialize(grid.DataProcessor.GroupDescriptors);
        }
    }
}
