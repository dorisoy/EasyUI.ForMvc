namespace EasyUI.Web.Mvc.JavaScriptTests.Controllers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.Mvc;

    public class GridController : Controller
    {
        public ActionResult Paging()
        {
            ViewData["lessData"] = TestData(2);
            ViewData["moreData"] = TestData(20);

            return View();
        }

        public ActionResult Navigation()
        {
            ViewData["moreData"] = TestData(20);

            return View(TestData(20));
        }

        public ActionResult FormContainerBuilder()
        {
            return View(TestData(20));
        }         
        
        public ActionResult ChangeSet()
        {
            return View(TestData(20));
        } 
        
        public ActionResult CellEditor()
        {
            return View(TestData(20));
        }         
        
        public ActionResult Editor()
        {
            return View(TestData(20));
        }         
        
        
        public ActionResult PopUpEditor()
        {
            return View(TestData(20));
        }         
        
        public ActionResult ButtonBuilders()
        {
            return View(TestData(20));
        }        
        
        public ActionResult DataCellBuilder()
        {
            return View(TestData(20));
        }

        public ActionResult ErrorView()
        {
            return View(TestData(20));
        }

        public ActionResult ClientEvents()
        {
            return View(TestData(20));
        }

        public ActionResult ColumnHiding()
        {
            return View(TestData(20));
        }

        public ActionResult Grouping()
        {
            return View(TestData(20));
        }

        public ActionResult Localization()
        {
            return View(TestData(20));
        }

        public ActionResult Sorting()
        {
            var data = TestData(2);

            return View(data);
        }

        public ActionResult Selection()
        {
            return View(TestData(20));
        }        
        
        public ActionResult FormViewBinder()
        {
            return View(TestData(20));
        }        
        
        public ActionResult ModelBinder()
        {
            return View(TestData(20));
        }

        public ActionResult Binding()
        {
            return View(TestData(20));
        }

        public ActionResult Filtering()
        {
            return View(TestData(20));
        }

        public ActionResult Editing()
        {
            return View(TestData(20));
        }         
        
        public ActionResult ModelStateErrors()
        {
            return View(TestData(20));
        }        
        
        public ActionResult ClientTemplates()
        {
            return View(TestData(20));
        }

        public ActionResult Layout()
        {
            return View(TestData(11));
        }

        [GridAction]
        public ActionResult GroupingAjax()
        {
            return View(new GridModel(TestData(11)));
        }

        private List<Customer> TestData(int rowCount)
        {
            List<Customer> data = new List<Customer>();
            DateTime date = new DateTime(1980, 1, 1);

            for (int i = 0; i < rowCount; i++)
            {
                data.Add(new Customer{ Name = "Customer" + (i + 1), BirthDate = date.AddDays(i), IntegerValue = i });
            }
            data.First().Active = true;
            return data;
        }
    }
}
