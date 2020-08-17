namespace EasyUI.Web.Mvc.Examples.Models
{
    using System.Collections.Generic;

    public static class SpainElectricityStatsBuilder
    {
        public static List<ElectricitySource> GetCollection()
        {
            return new List<ElectricitySource>
            {
                new ElectricitySource
                {
                    Source = "Hydro",
                    Percentage = 22
                },

                new ElectricitySource
                {
                    Source = "Solar",
                    Percentage = 2
                },

                new ElectricitySource
                {
                    Source = "Nuclear",
                    Percentage = 49
                },

                new ElectricitySource
                {
                    Source = "Wind",
                    Percentage = 27
                }
            };
        }
    }
}