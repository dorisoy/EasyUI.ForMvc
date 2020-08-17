namespace EasyUI.Web.Mvc.Examples
{
    using System;
    using System.Linq;
    using EasyUI.Web.Mvc.Extensions;

    /// <summary>
    /// 该特性用于从产品站点地图填充数据
    /// </summary>
    public class PopulateProductSiteMapAttribute : PopulateSiteMapAttribute
    {
        public override void OnResultExecuting(System.Web.Mvc.ResultExecutingContext filterContext)
        {
            base.OnResultExecuting(filterContext);

            var fullSiteMap = (XmlSiteMap)filterContext.Controller.ViewData[ViewDataKey];
            var productSiteMap = new XmlSiteMap();
            productSiteMap.RootNode = new SiteMapNode();

            foreach (SiteMapNode node in fullSiteMap.RootNode.ChildNodes)
            {
                var controller = node.ControllerName ?? node.Title;
                var action = node.ActionName ?? "firstlook";
                var clone = new SiteMapNode
                {
                    ActionName = action,
                    ControllerName = controller,
                    Title = node.Title,
                    Description = node.Description,
                    IcoStyle = node.IcoStyle

                };

                clone.Attributes.Merge(node.Attributes);
                productSiteMap.RootNode.ChildNodes.Add(clone);
            }
            //
            filterContext.Controller.ViewData["easyui.web.mvc.products"] = productSiteMap;

            var examplesSiteMap = new XmlSiteMap();
            
            var controllerName = (string)filterContext.RouteData.Values["controller"];
            var productSiteMapNode = fullSiteMap.RootNode.ChildNodes
                .FirstOrDefault(node => controllerName.Equals(node.Title, StringComparison.OrdinalIgnoreCase));

            if (productSiteMapNode != null && !controllerName.Equals("Home", StringComparison.OrdinalIgnoreCase))
            {
                //examplesSiteMap.RootNode = new SiteMapNode();
                //examplesSiteMap.RootNode.ChildNodes.Add(productSiteMapNode);

                //实例导航菜单


                //SiteMapManager.SiteMaps.Register<XmlSiteMap>("sample", sitmap => sitmap.LoadFrom("~/sample.sitemap"));
                //var  fdf= sitmap() => sitmap.LoadFrom("~/sample.sitemap");
                //Action sitmap = () => { };

                examplesSiteMap.LoadFrom("~/Web.sitemap");

                filterContext.Controller.ViewData["easyui.web.mvc.products.examples"] = examplesSiteMap;
            }
        }
    }
}
