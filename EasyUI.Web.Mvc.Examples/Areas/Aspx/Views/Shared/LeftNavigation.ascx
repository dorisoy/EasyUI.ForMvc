<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%@ Import Namespace="EasyUI.Web.Mvc" %>
<% 
        if (ViewData["easyui.web.mvc.products.examples"] != null)
        {
            Html.EasyUI().PanelBar()
                .Name("navigation-product-examples")
                //.HtmlAttributes(new { @class = "demos-navigation" })
                .HtmlAttributes(new { style = "width:250px;" })
                .BindTo("easyui.web.mvc.products.examples", (item, node) =>
                {
                    if (!string.IsNullOrEmpty(node.ControllerName) && !string.IsNullOrEmpty(node.ActionName))
                    {
                        item.ControllerName = node.ControllerName.ToLower();
                        item.ActionName = node.ActionName.ToLower();
                    }

                    item.SpriteCssClasses = "fa fa-" + item.Text.ToLower();
                     item.ShowDescription = true;
                //if ("true".Equals(node.Attributes["isNew"]))
                //{
                //    item.Text += "<span class='isNew'>new</span>";
                //    item.Encoded = false;
                //}
            })
                .HighlightPath(true)
                .ItemAction(item =>
                {
                    if (!item.Items.Any() && !string.IsNullOrEmpty(Request.QueryString["theme"]))
                    {
                        item.RouteValues.Add("theme", Request.QueryString["theme"]);
                    }

                    if (item.Selected)
                    {
                        item.HtmlAttributes["class"] = "active-page";
                    }

                    if (item.Parent != null)
                    {
                        item.SpriteCssClasses = "";
                    }
                })
                .Render();
        }


        if (ViewData["easyui.web.mvc.products"] != null)
        {
        Html.EasyUI().PanelBar()
            .Name("navigation-controls")
             //.HtmlAttributes(new { @class = "demos-navigation" })
             .HtmlAttributes(new { style = "width:250px;" })
            .BindTo("easyui.web.mvc.products", (item, node) =>
            {
                if (!string.IsNullOrEmpty(node.ControllerName) && !string.IsNullOrEmpty(node.ActionName))
                {
                    item.ControllerName = node.ControllerName.ToLower();
                    item.ActionName = node.ActionName.ToLower();
                }
                item.SpriteCssClasses = "fa fa-" + item.Text.ToLower();
                 item.ShowDescription = true;
                //if ("true".Equals(node.Attributes["isNew"]))
                //{
                //    item.Text += "<span class='isNew'>new</span>";
                //    item.Encoded = false;
                //}
            })
            .ItemAction(item =>
            {
                if (!item.Items.Any() && !string.IsNullOrEmpty(Request.QueryString["theme"]))
                {
                    item.RouteValues.Add("theme", Request.QueryString["theme"]);
                }
            })
            .Render();
    }
%>
