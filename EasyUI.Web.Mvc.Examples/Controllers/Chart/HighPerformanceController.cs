namespace EasyUI.Web.Mvc.Examples
{
    using System;
    using System.Web.Mvc;

    public partial class ChartController
    {
        const int CHART_POINTS = 20;

        public ActionResult HighPerformance()
        {
            ViewBag.StockA = RandomSeries(20);
            ViewBag.StockB = RandomSeries(40);
            ViewBag.StockC = RandomSeries(60);

            var categories = new string[CHART_POINTS];
            for (var i = 0; i < CHART_POINTS; i++)
            {
                categories[i] = "1/" + i;
            }

            ViewBag.Categories = categories;

            return View();
        }

        private double[] RandomSeries(double seed)
        {
            var result = new double[CHART_POINTS];
            var random = new Random((int) seed);
            double value = seed;

            for (var i = 0; i < CHART_POINTS; i++)
            {
                var change = (random.NextDouble() > 0.5 ? 1 : - 1) * random.NextDouble() * 10;
                result[i] = value = Math.Max(10, value + change);
            }

            return result;
        }
    }
}