



namespace EasyUI.Web.Mvc.UI
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Linq;
    
    using Extensions;
    using Infrastructure;
    using Infrastructure.Implementation;

    class GridBoundColumnSerializer : GridColumnSerializer
    {
        private readonly IGridBoundColumn column;

        public GridBoundColumnSerializer(IGridBoundColumn column)
            : base(column)
        {
            this.column = column;
        }

        public override IDictionary<string, object> Serialize()
        {
            var result = base.Serialize();

            FluentDictionary.For(result)
                .Add("member", column.Member)
                .Add("type", column.MemberType.ToJavaScriptType())
                .Add("format", column.Format, () => column.Format.HasValue())
                .Add("groupable", column.Groupable, true)
                .Add("encoded", column.Encoded, true);

#if MVC2 || MVC3
            string editorHtml = column.EditorHtml;

            if (column.Grid.IsSelfInitialized && editorHtml != null)
            {
                editorHtml = editorHtml.Replace("<", "%3c").Replace(">", "%3e");
            }

            FluentDictionary.For(result)
                .Add("readonly", column.ReadOnly, false)
                .Add("editor", editorHtml, () => column.Grid.Editing.Enabled && column.Grid.IsClientBinding && !column.ReadOnly);
#endif

            if (column.ClientGroupHeaderTemplate.HasValue())
            {
                result.Add("groupHeaderTemplate", Encode(column, column.ClientGroupHeaderTemplate));
            }
            
            if (column.ClientGroupFooterTemplate.HasValue())
            {
                result.Add("groupFooterTemplate", Encode(column, column.ClientGroupFooterTemplate));
            }

            SerializeAggregates(result);

            SerializeFilters(result);

            SerializeOrder(result);

            SerializeValues(result);
            
            return result;
        }
        
        private void SerializeAggregates(IDictionary<string, object> result)
        {
            if (column.Aggregates.Any())
            {
                result["aggregates"] = column.Aggregates.Select(aggregate => aggregate.AggregateMethodName.ToLowerInvariant());
            }
        }
        
        private void SerializeOrder(IDictionary<string, object> result)
        {
            var sortDescriptor = column.Grid
                 .DataProcessor
                 .SortDescriptors
                 .FirstOrDefault(s => s.Member == column.Member);
            
            if (sortDescriptor != null)
            {
                result["order"] = sortDescriptor.SortDirection == ListSortDirection.Ascending ? "asc" : "desc";
            }
        }
        
        private void SerializeValues(IDictionary<string, object> result)
        {
            if (column.MemberType != null && column.MemberType.IsEnum)
            {
                var values = new Dictionary<string, object>();
                
                foreach (var value in Enum.GetValues(column.MemberType))
                {
                    values[Enum.GetName(column.MemberType, value)] = value;
                }

                result["values"] = values;
            }
        }

        private void SerializeFilters(IDictionary<string, object> result)
        {
            var filtersForTheColumn = column.Grid.DataProcessor.FilterDescriptors
                .SelectMemberDescriptors()
                .Where(descriptor => descriptor.Member == column.Member);

            if (filtersForTheColumn.Any())
            {
                var filters = new List<IDictionary<string, object>>();

                filtersForTheColumn.Each(filter =>
                {
                    filters.Add(new Dictionary<string, object>
                    {
                        {"operator", filter.Operator.ToToken()},
                        {"value", filter.Value}
                    });
                });

                result["filters"] = filters;
            }
        }
    }
}
