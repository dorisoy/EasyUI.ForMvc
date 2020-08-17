namespace EasyUI.Web.Mvc.Examples
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Web;
    using System.Web.Mvc;

    /// <summary>
    /// �����������Զ����Դ����
    /// </summary>
    [AttributeUsage(AttributeTargets.Class, Inherited = true, AllowMultiple = false)]
    public class AutoPopulateSourceCodeAttribute : FilterAttribute, IResultFilter
    {
        private const string ViewPath = "~/Views/";
        private const string AspxViewPath = "~/Areas/Aspx/Views/";
        private const string ControllerPath = "~/Controllers/";
        private const string DescriptionPath = "~/Content/";
        private const string MasterPagePath = AspxViewPath + "Shared/Tow.Master";
        private const string LayoutPagePath = ViewPath + "Shared/_Layout.cshtml";

        public void OnResultExecuting(ResultExecutingContext filterContext)
        {
            ViewResult viewResult = filterContext.Result as ViewResult;

            if (viewResult != null)
            {
                HttpServerUtilityBase server = filterContext.HttpContext.Server;
                //��������
                string controllerName = filterContext.RouteData.GetRequiredString("controller");
                //��ͼ��
                string viewName =
                    !string.IsNullOrEmpty(viewResult.ViewName)
                        ? viewResult.ViewName
                        : filterContext.RouteData.GetRequiredString("action");
                //��ͼ����·��
                string baseViewPath = filterContext.IsAspxView() ? AspxViewPath : ViewPath;
                //��ͼ��չ��
                string viewExtension = filterContext.IsAspxView() ? ".aspx" : ".cshtml";
                //��ǰ��ͼ��·��
                string currentViewPath = baseViewPath + controllerName + Path.AltDirectorySeparatorChar + viewName + viewExtension;
                //��ǰʾ��������·��
                string exampleControllerPath = ControllerPath + controllerName + Path.AltDirectorySeparatorChar + viewName + "Controller.cs";
                //����·��
                string descriptionPath =
                    server.MapPath(DescriptionPath + Path.AltDirectorySeparatorChar + controllerName + 
                    Path.AltDirectorySeparatorChar + "Descriptions" + 
                    Path.AltDirectorySeparatorChar + viewName + ".html");
                //��ͼ����
                var viewData = filterContext.Controller.ViewData;

                if (System.IO.File.Exists(descriptionPath))
                {
                    var descriptionText = System.IO.File.ReadAllText(descriptionPath);
//#if MVC3
//                    viewData["Description"] = new HtmlString(descriptionText);
//#else
//                    viewData["Description"] = descriptionText;
//#endif
                    viewData["Description"] = new HtmlString(descriptionText);
                }

                var codeFiles = new Dictionary<string, string>();
                codeFiles["View"] = currentViewPath;
                codeFiles["Controller"] = exampleControllerPath;
                RegisterLayoutPages(filterContext, codeFiles);
                viewData["codeFiles"] = codeFiles;
            }
        }

        private void RegisterLayoutPages(ResultExecutingContext filterContext, Dictionary<string, string> codeFiles)
        {
            if (filterContext.IsAspxView())
            {
                codeFiles["Master"] = MasterPagePath;
            }
            else
            {
                codeFiles["_Layout.cshtml"] = LayoutPagePath;
            }
        }

        public void OnResultExecuted(ResultExecutedContext filterContext)
        {
            // Do Nothing
        }
    }
}