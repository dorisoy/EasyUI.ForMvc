namespace EasyUI.Web.Mvc.Examples
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.UI;

    public partial class GridController : Controller
    {
        public ActionResult ColumnReordering(string positions)
        {
            // Default column settings with initial positions
            var columnSettings = new List<GridColumnSettings>()
            {
                new GridColumnSettings
                {
                    Member = "OrderID",
                    Width = "100px"
                },
                new GridColumnSettings
                {
                    Member = "ContactName",
                    Width = "200px",
                },
                new GridColumnSettings
                {
                    Member = "ShipAddress",
                    Width = "450px"
                },
                new GridColumnSettings
                {
                    Member = "OrderDate",
                    Width = "130px",
                    Format = "{0:d}"
                },
            };

            //'positions' contains comma separated column members e.g. 'OrderID,ContactName,ShipAddress,OrderDate'

            // comma separated values are converted to string array
            var columnPositions = (positions ?? "").Split(",".ToCharArray(), StringSplitOptions.RemoveEmptyEntries);

            if (columnPositions.Any())
            {
                for (var position = 0; position < columnPositions.Length; position++)
                {
                    // find the column setting by member
                    var setting = columnSettings.FirstOrDefault(c => c.Member == columnPositions[position]);

                    if (setting != null)
                    {
                        // reorder the column setting
                        columnSettings.Remove(setting);
                        columnSettings.Insert(position, setting);
                    }
                }
            }

            ViewData["Columns"] = columnSettings;
            
            return View(GetOrderDto());
        }

        [GridAction]
        public ActionResult _ColumnReordering()
        {
            return View(new GridModel(GetOrderDto()));
        }
    }
}