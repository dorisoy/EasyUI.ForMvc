﻿using System.Collections.Generic;

namespace EasyUI.Web.Mvc.UI.Tests
{
    public class XYData
    {
        public float X { get; set; }
        public float Y { get; set; }
    }

    public static class XYDataBuilder
    {
        public static List<XYData> GetCollection()
        {
            return new List<XYData>
            {
                new XYData
                {
                    X = 1, 
                    Y = 2
                },

                new XYData
                {
                    X = 3, 
                    Y = 4
                }
            };
        }
    }
}