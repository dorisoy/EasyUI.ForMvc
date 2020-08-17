<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%@ Import Namespace="EasyUI.Web.Mvc" %>

<% //Html.EasyUI().ComboBox()
//            .Name("search")
//            .Encode(false)
//            .DataBinding(binding => binding.Ajax().Select("_Search", "Search").Cache(false))
//            .HtmlAttributes(new { style = "width: 183px; z-index:100;" })
//            .DropDownHtmlAttributes(new { id = "examples-search-popup", style = "width: 188px;" })
//            .ClientEvents(events => events.OnLoad("searchBoxLoad"))
//            .HighlightFirstMatch(true)
%>


<%  //Html.EasyUI().Menu()
//    .Name("resources")
//    .HtmlAttributes(new { @class = "menu-bar" })
//    .OpenOnClick(true)
//    .Items(menu =>
//    {
//        menu.Add().Text("技术交流")
//            .Items(resources =>
//            {
//                resources.Add().Text("在线文档").Url("http://help.mschen.com");
//                resources.Add().Text("社区").Url("http://forums.mschen.com");
//                resources.Add().Text("博客").Url("http://blogs.mschen.com");
//                resources.Add().Text("视频").Url("http://tv.mschen.com/");
//                resources.Add().Text("问题跟踪").Url("http://support.mschen.com");
//            });


//    })
//    .Render(); easyui.web.mvc.products.example
%>

<nav id="js-Bar" class="Bar">
    <%
        var style = "container";
        var with = "width:219px";
        if (ViewData["layout"] != null)
        {
            style = ViewData["layout"].ToString() == "2" ? "container2" : "container";
            with = ViewData["layout"].ToString() == "2" ? "width:219px" : "";
        }

    %>
    <div class="<%=style %>">
        <div class="Bar-table sf_cols">

            <input type="checkbox" id="Bar-controlMe">
            <label for="Bar-controlMe" class="Bar-showMe"></label>
            <label for="Bar-controlMe" class="Bar-hideMe"></label>
            <!--logo-->
            <div class="sf_colsIn Bar-logo-container" style="<%=with%>">
                <a href="/" class="Bar-logo">
                    <img alt="EasyUI For ASP.NET MVC" src="<%:Url.Content("~/Content/images/logo-reversed.png")%>" width="214" height="22">
                </a>
            </div>
            <!--menu-->
            <div class="sf_colsIn Bar-slide">
         
                <%
                    if (style == "container2")
                    {
                        //Html.EasyUI().Menu().HtmlAttributes(new { @class = "Bar-menu" }).Name("Menu_top").BindTo("easyui.web.mvc.products", (item, node) =>
                        //{
                        //    item.SpriteCssClasses = "fa fa-" + item.Text.ToLower();
                        //    item.ShowDescription = false;
                        //}).Render();


                        Html.EasyUI().Menu().UseDefaultClassStyle(false)
                                    .HtmlAttributes(new { @class = "Bar-menu" })
                                    .Name("Menu_top")
                                    .Items(items =>
                                    {
                                        items.Add().Text("Home").Url("/")
                                        .SpriteCssClasses("fa fa-home")
                                        .HtmlAttributes(new { @class = "Bar-menu-link"})
                                        .UseDefaultClassStyle(false);
                                    })
                                    .Render();
                    }
                    else
                    {
                %>
                <ul class="Bar-menu">
                    <li><a href="/calendar" class="Bar-menu-link">演示</a></li>
                    <li><a href="http://www.jeasyui.com/" class="Bar-menu-link">EasyUI官方</a></li>
                    <li><a href="http://www.jeasyui.net/" class="Bar-menu-link">EasyUI中文站</a></li>
                    <li><a href="http://bbs.jeasyuicn.com/" class="Bar-menu-link">教程</a></li>
                    <li><a href="http://www.jquery123.com/api/" class="Bar-menu-link">JQuery API</a></li>
                    <li><a href="#" class="Bar-menu-link">关于</a></li>
                </ul>
                <%} %>
            </div>
            <!--search-->
            <div class="sf_colsOut Bar-search Dropdown u-ps js-Bar-search" data-tlrk-plugin="dropdown">
                <a class="Dropdown-control Bar-navi-link" href="#search" title="#"><i class="fa fa-search"></i></a>
                <div class="sf_colsIn Dropdown-view Section Dash">
                    <span>
                        <div class="Search">
                            <input name="" type="text" class="js-search-input ac_input" placeholder="搜索" autocomplete="off" />
                            <span style="visibility: hidden;"></span>
                            <a onclick="" href="#"><i class="fa fa-search"></i></a>
                        </div>
                    </span>
                </div>
            </div>
        </div>
    </div>
</nav>
