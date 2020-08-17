namespace EasyUI.Web.Mvc.Examples
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.Examples.Models;

    public partial class ChartController
    {
        private const int POINTS = 300;
        private const double RADIANS_PER_DEGREE = Math.PI / 180;
        private const double ANGLE = 145 * RADIANS_PER_DEGREE;
        private const int PRECISION = 2;

        [SourceCodeFile("Model", "~/Models/Point.cs")]
        public ActionResult ScatterChart()
        {
            var florets = new List<PolarPoint>();

            for (var i = 0; i < POINTS; i++)
            {
                florets.Add(
                    new PolarPoint {
                        R = Math.Sqrt(i),
                        Theta = i * ANGLE
                    }
                );
            }

            return View(
                from f in florets
                select new Point {
                    X = Math.Round(f.R * Math.Cos(f.Theta), PRECISION),
                    Y = Math.Round(f.R * Math.Sin(f.Theta), PRECISION)
                }
            );
        }
    }
}