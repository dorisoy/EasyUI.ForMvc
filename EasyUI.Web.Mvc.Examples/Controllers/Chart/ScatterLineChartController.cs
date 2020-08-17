namespace EasyUI.Web.Mvc.Examples
{
    using System;
    using System.Collections.Generic;
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.Examples.Models;

    public partial class ChartController
    {
        [SourceCodeFile("Model", "~/Models/Point.cs")]
        public ActionResult ScatterLineChart()
        {
            const double MIN = 0;
            const double MAX = 38;
            const double POINTS = 100;
            const double STEP = (MAX - MIN) / POINTS;
            const int PRECISION = 4;

            var points = new List<Point[]>();

            for (double i = MIN; i < MAX; i = Math.Round(STEP + i, PRECISION))
            {
                points.Add(
                    new Point[] {
                        new Point {
                            X = Math.Round(Math.Exp(-0.1 * i) * Math.Sin(i), PRECISION),
                            Y = i
                        },
                        new Point {
                            X = Math.Round(Math.Exp(-0.1 * i), PRECISION),
                            Y = i
                        },
                        new Point {
                            X = Math.Round(-Math.Exp(-0.1 * i), PRECISION),
                            Y = i
                        }
                    }
                );
            }

            return View(points);
        }
    }
}