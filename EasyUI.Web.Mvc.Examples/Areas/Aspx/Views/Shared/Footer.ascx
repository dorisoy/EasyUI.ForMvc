﻿<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>

<div class="sfContentBlock">
    <div class="sf_cols Footer" >
        <%
            var style = "";
            if (ViewData["layout"] != null)
            {
                style = ViewData["layout"].ToString() == "2" ? "padding-top:20px" : "";
            }

         %>
        <div class="sf_colsOut sf_1col_1_100 container" style="<%=style%>">
            <div class="sf_colsIn sf_1col_1in_100">

                <div class="sf_cols row">
                    <div class="sf_colsIn col-4">
                        <div class="Footer-credits">
                            <div class="Footer-end">
                                <div class="QuickLinks">
                                    <a class="Text--b7" href="#" data-gtm-event="footer-nav, text, terms-of-use">使用条款</a>
                                    <a class="Text--b7" href="#" data-gtm-event="footer-nav, text, feedback">站点反馈</a>
                                    <a class="Text--b7" href="#" data-gtm-event="footer-nav, text, privacy-policy">协议声明</a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="sf_colsIn col-8">
                        <div class="sf_cols row">
                            <div class="sf_colsIn col-6">
                                <div class="Footer-credits">
                                    <p>Copyright © 2008-<%: DateTime.Now.Year %> EasyUI. All Rights Reserved.</p>
                                </div>
                            </div>
                            <div class="sf_colsIn col-6">
                                <div class="Footer-credits">
                                    <p class="powered-by">Powered by EasyUI <%:Html.ProductVersion()%></p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


</div>

