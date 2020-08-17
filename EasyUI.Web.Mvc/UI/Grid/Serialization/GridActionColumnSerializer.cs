﻿



namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using System.Linq;
    using Extensions;
    
    class GridActionColumnSerializer : GridColumnSerializer
    {
        private readonly IGridActionColumn column;
        
        public GridActionColumnSerializer(IGridActionColumn column) : base(column)
        {
            this.column = column;
        }

        public override IDictionary<string, object> Serialize()
        {
            var result = base.Serialize();
            
            result["title"] = column.Title;

            var commands = new List<IDictionary<string,object>>();
            
            column.Commands.Each(command =>
            {
                commands.Add(command.Serialize(column.Grid.UrlBuilder));
            });
        
            if (commands.Any())
            {
                result["commands"] = commands;
            }

            return result;
        }
    }
}
