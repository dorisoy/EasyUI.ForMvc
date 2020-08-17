namespace EasyUI.Web.Mvc.Examples.Models
{
    using System.Collections.Generic;

    public static class SalesDataBuilder
    {
        public static List<SalesData> GetCollection()
        {
            return new List<SalesData>
            {
                new SalesData
                {
                    RepName = "Nancy Davolio", 
                    DateString = "Aug 2010",
                    TotalSales = 10458,
                    RepSales = 2015
                },

                new SalesData
                {
                    RepName = "Nancy Davolio", 
                    DateString = "Sept 2010",
                    TotalSales = 21598,
                    RepSales = 6003
                },

                new SalesData
                {
                    RepName = "Nancy Davolio", 
                    DateString = "Oct 2010",
                    TotalSales = 22623,
                    RepSales = 6881
                },

                new SalesData
                {
                    RepName = "Nancy Davolio", 
                    DateString = "Nov 2010",
                    TotalSales = 31167,
                    RepSales = 4060
                },

                new SalesData
                {
                    RepName = "Nancy Davolio", 
                    DateString = "Jan 2011",
                    TotalSales = 33663,
                    RepSales = 10254
                },

                new SalesData
                {
                    RepName = "Nancy Davolio", 
                    DateString = "Feb 2011",
                    TotalSales = 29896,
                    RepSales = 9546
                },

                new SalesData
                {
                    RepName = "Nancy Davolio", 
                    DateString = "Mar 2011",
                    TotalSales = 24714,
                    RepSales = 7332
                },
            };
        }

        public static List<SalesData> GetCollectionWithMissingValues()
        {
            var salesData = GetCollection();
            salesData[2].TotalSales = null;
            salesData[2].RepSales = null;
            return salesData;
        }
    }
}
