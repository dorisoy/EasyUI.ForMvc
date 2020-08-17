namespace EasyUI.Web.Mvc.Examples.Models
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;
    using System.Xml;

    public static class ExampleRepository
    {
        private static IList<XmlNode> ExamplesAsXmlNodes
        {
            get
            {
                IList<XmlNode> exampleList = (IList<XmlNode>)HttpRuntime.Cache["ExamplesXmlNodes"];
                if (exampleList == null)
                {
                    HttpRuntime.Cache["ExamplesXmlNodes"] = exampleList = new List<XmlNode>();
                    XmlDocument examples = new XmlDocument();
                    examples.Load(HttpContext.Current.Server.MapPath("~/Web.sitemap"));

                    foreach (XmlNode node in examples.SelectNodes("//siteMapNode"))
                    {
                        if (node.Attributes["controller"] == null)
                            continue;

                        if (node.Attributes["controller"].Value.ToLowerInvariant() == "home")
                            continue;

                        exampleList.Add(node);
                    }
                }

                return exampleList;
            }
        }

        private static bool ContainsIgnoreCase(this string source, string reference)
        {
            return source.ToUpperInvariant().Contains(reference.ToUpperInvariant());
        }

        public static IEnumerable<SearchResult> Filter(string text)
        {
            if (string.IsNullOrEmpty(text.Trim()))
            {
                return new List<SearchResult>();
            }

            IEnumerable<SearchResult> results = ExamplesAsXmlNodes.Select(example =>
                        new SearchResult
                        {
                            Text = string.Format("{0} &raquo; {1}", example.Attributes["controller"].Value, example.Attributes["title"].Value),
                            Url = string.Format("{0}/{1}", example.Attributes["controller"].Value.ToLowerInvariant(), example.Attributes["action"].Value.ToLowerInvariant())
                        });

            foreach (string token in text.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries))
            {
                results = results.Where(result => result.Text.ContainsIgnoreCase(token.Trim())).ToList();
            }

            return results;
        }
    }
}