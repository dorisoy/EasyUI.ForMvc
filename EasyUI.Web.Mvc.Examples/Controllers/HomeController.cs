﻿namespace EasyUI.Web.Mvc.Examples
{
    using System;
    using System.Text.RegularExpressions;
    using System.Reflection;
    using System.Web.Mvc;
    using System.IO;
    using EasyUI.Web.Mvc.UI;
    using System.Web.Hosting;
    using System.Web;


    [PopulateProductSiteMap(SiteMapName = "examples", ViewDataKey = "easyui.mvc.examples")]
    public class HomeController : Controller
    {
        private static readonly Regex ForbiddenExtensions = new Regex("dll|config", RegexOptions.IgnoreCase);
        
        public ActionResult FirstLook()
        {
            return View();
        }

        public ActionResult CodeFile(string file)
        {
            if (!file.StartsWith("~", StringComparison.OrdinalIgnoreCase))
            {
                return new EmptyResult();
            }

            file = Server.MapPath(file);
            string extension = Path.GetExtension(file);

            if (!System.IO.File.Exists(file) || ForbiddenExtensions.IsMatch(extension))
            {
                return new EmptyResult();
            }
            
            return PartialView((object)System.IO.File.ReadAllText(file));
        }
    }
}