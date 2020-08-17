<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" MasterPageFile="~/Views/Shared/One.Master" %>


<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <nav class="sf_cols Nav" data-tlrk-plugin="fixit" data-fixit-class-only="true" data-fixit-top="0" data-fixit-render-dummy="1">
        <div class="sf_colsIn container">
            <span id="GeneralContent_C005">
                <div class="Nav-container">

                    <header>
                        <div>
                            <span class="Nav-title">EasyUI for ASP.NET MVC
                            </span>
                        </div>
                    </header>

                    <!--<div class="Nav-sections" data-tlrk-plugin="navspy">
                                        <a href="#Features" data-href="#Features" class="Nav-anchor">
                                            特点
                                        </a>
                                        <a href="#Widgets" data-href="#Widgets" class="Nav-anchor">
                                            扩展
                                        </a>
                                        <a href="#GettingStarted" data-href="#GettingStarted" class="Nav-anchor">
                                            定制
                                        </a>

                                        <a href="#WhatsNew" data-href="#WhatsNew" class="Nav-anchor">
                                            文档
                                        </a>
                                    </div>-->

                    <div class="Nav-cta">
                        <a class="Btn Btn--sec Btn--min-w" href="#" target="_blank">演示</a>
                        <a class="Btn  Btn--prim Btn--min-w" href="#">下载试用</a>
                    </div>

                </div>
            </span>
        </div>
    </nav>

    <div class="sf_cols Section Section--pb">
        <div class="sf_colsIn container">


            <div id="Features" class="Features">
                <!-- 2014.3.1209.40 -->
                <div class="Features-grid is-visible">
                    <!--<h2 class="Section-title">丰富的特色</h2>-->
                    <ul class="List List--horizontal">
                        <li class="List-item col-4">
                            <div class="List-thumb">
                                <a href="#" class="js-open-feature">
                                    <img title="MVC下框架搭建利器" src="<%: Url.Content("~/Content/images/features-controls.png")%>" alt="MVC下框架搭建利器">
                                </a>
                            </div>
                            <div class="List-body">
                                <h4>
                                    <a href="#" class="js-open-feature List-heading">MVC下框架搭建利器</a>
                                </h4>
                                <div class="List-text Text--s">
                                    <p>直观、强悍的前端开发框架，封装完美的导航和布局，可视化数据管理，编辑和交互性控件，让ASP.MVC开发更迅速、简单。</p>
                                </div>
                            </div>
                        </li>

                        <li class="List-item col-4">
                            <div class="List-thumb">
                                <a href="#" class="js-open-feature">
                                    <img title="使用HTML5渲染" src="<%:Url.Content("~/Content/images/html5-rendering.png")%>">
                                </a>
                            </div>
                            <div class="List-body">
                                <h4>
                                    <a href="#" class="js-open-feature List-heading">使用HTML5渲染</a>
                                </h4>
                                <div class="List-text Text--s">
                                    <p>所有控件整合了流行的HTML5/JS库，同时提供服务器端和Web前端使用。 &nbsp;</p>
                                </div>
                            </div>
                        </li>

                        <li class="List-item col-4">
                            <div class="List-thumb">
                                <a href="#" class="js-open-feature">
                                    <img title="移动响应式支持" src="<%:Url.Content("~/Content/images/mobile-support_touch-support.png")%>">
                                </a>
                            </div>
                            <div class="List-body">
                                <h4>
                                    <a href="#" class="js-open-feature List-heading">移动响应式支持</a>
                                </h4>
                                <div class="List-text Text--s">
                                    <p>支持自适应响应式渲染能力，在平板电脑和智能手机上面还有 响应式CSS 可以使用。 </p>
                                </div>
                            </div>
                        </li>

                        <li class="List-item col-4">
                            <div class="List-thumb">
                                <a href="#" class="js-open-feature">
                                    <img title="简单的服务器端数据绑定" src="<%:Url.Content("~/Content/images/simple-server-side-data-binding-and-crud.png")%>" alt="简单的服务器端数据绑定">
                                </a>
                            </div>
                            <div class="List-body">
                                <h4>
                                    <a href="#" class="js-open-feature List-heading">简单的服务器端数据绑定</a>
                                </h4>
                                <div class="List-text Text--s">
                                    <p>EasyUI For ASP.NET MVC 轻而易举实现服务器端数据绑定。&nbsp; </p>
                                </div>
                            </div>
                        </li>

                        <li class="List-item col-4">
                            <div class="List-thumb">
                                <a href="#" class="js-open-feature">
                                    <img title="MVC下框架搭建利器" src="<%:Url.Content("~/Content/images/seamless-ux.png")%>">
                                </a>
                            </div>
                            <div class="List-body">
                                <h4>
                                    <a href="#" class="js-open-feature List-heading">无缝跨主流浏览器 </a>
                                </h4>
                                <div class="List-text Text--s">
                                    <p>使你的网站或移动应用程序在所有主流浏览器下工作具有外观完美。</p>
                                </div>
                            </div>
                        </li>

                        <li class="List-item col-4">
                            <div class="List-thumb">
                                <a href="#" class="js-open-feature">
                                    <img title="内置的可定制的主题" src="<%:Url.Content("~/Content/images/pixel-perfect.png")%>">
                                </a>
                            </div>
                            <div class="List-body">
                                <h4>
                                    <a href="#" class="js-open-feature List-heading">内置的可定制的主题</a>
                                </h4>
                                <div class="List-text Text--s">
                                    <p>内置可定制的主题包选择，并且还有基于web的定制工具 ThemeBuilder 使用。&nbsp; </p>
                                </div>
                            </div>
                        </li>

                    </ul>
                </div>

            </div>

        </div>
    </div>

</asp:Content>
