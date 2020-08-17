namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;
    using System.Linq;
    using Models;
    
    using System.Collections;
    using System.Collections.Generic;

    using EasyUI.Web.Mvc.UI;

    public partial class TreeViewController : Controller
    {
        public ActionResult CheckBoxSupport()
        {
            return View(GetRootEmployees());
        }

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult CheckBoxSupport(List<TreeViewItem> TreeView1_checkedNodes)
        {
            string message = string.Empty;

            if (TreeView1_checkedNodes != null)
            {
                foreach (TreeViewItem node in TreeView1_checkedNodes)
                {
                    message += node.Text + "<br/>";
                }
            }

            ViewData["message"] = message;
            ViewData["TreeView1_checkedNodes"] = TreeView1_checkedNodes;
            return View(GetRootEmployees());
        }
    }
}