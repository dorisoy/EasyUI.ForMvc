﻿// (c) Copyright 2002-2011 EasyUI 



namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using System.Linq;

    class GridForeignKeyColumnSerializer : GridBoundColumnSerializer
    {
        private readonly IGridForeignKeyColumn column;

        public GridForeignKeyColumnSerializer(IGridForeignKeyColumn column)
            : base(column)
        {
            this.column = column;
        }

        public override IDictionary<string, object> Serialize()
        {
            var result = base.Serialize();
            SerializeSelectList(result);
            return result;
        }

        private void SerializeSelectList(IDictionary<string, object> result)
        {
            if (column.Grid.IsClientBinding)
            {
                result["data"] = column.Data.Select(i => new { Text = i.Text, Value = i.Value });
            }            
        }
    }
}
