namespace EasyUI.Web.Mvc.Examples
{
    using System;
    using System.Collections.Generic;
    using System.Web.Mvc;
    using System.IO;

    [AttributeUsage(AttributeTargets.Method, Inherited = false, AllowMultiple = true)]
    public class SourceCodeFileAttribute : FilterAttribute, IResultFilter
    {
        public string Caption
        {
            get;
            set;
        }

        public string FileName
        {
            get;
            set;
        }

        public string AspxFileName
        {
            get;
            set;
        }

        public SourceCodeFileAttribute()
        {
        }

        public SourceCodeFileAttribute(string caption, string filename)
        {
            Caption = caption;
            FileName = filename;
        }

        public void OnResultExecuting(ResultExecutingContext filterContext)
        {
            var codeFiles = filterContext.Controller.ViewData.Get<Dictionary<string, string>>("codeFiles");
            var currentFileName = GetCurrentFileName(filterContext);
            var currentCaption = Caption;
            if (string.IsNullOrEmpty(currentCaption))
            {
                currentCaption = Path.GetFileName(currentFileName);
            }

            codeFiles[currentCaption] = currentFileName;
        }

        public void OnResultExecuted(ResultExecutedContext filterContext)
        {
            // Do Nothing
        }

        private string GetCurrentFileName(ResultExecutingContext filterContext)
        {
            if (string.IsNullOrEmpty(AspxFileName))
            {
                return FileName;
            }
            else
            {
                return filterContext.IsAspxView() ? AspxFileName : FileName;
            }
        }
    }
}