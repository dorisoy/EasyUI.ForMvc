<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:content contentplaceholderid="MainContent" runat="server">

<% Html.EasyUI().TreeView()
        .Name("TreeView")
        .Items(treeview =>
        {
            treeview.Add()
                .Text("UI Components")
                .Expanded(true)
                .Content(() =>
                {%>
                    <ul>
                        <li>
                            <img src="<%: Url.Content("~/Content/Common/Icons/Suites_32/AJAX.png") %>" alt="Ajax" />
                            RadControls for ASP.NET AJAX
                        </li>
                        <li>
                            <img src="<%: Url.Content("~/Content/Common/Icons/Suites_32/MVC.png") %>" alt="MVC" />
                            EasyUI Extensions for ASP.NET MVC
                        </li>
                        <li>
                            <img src="<%: Url.Content("~/Content/Common/Icons/Suites_32/SL.png") %>" alt="SL" />
                            RadControls for Silverlight
                        </li>
                        <li>
                            <img src="<%: Url.Content("~/Content/Common/Icons/Suites_32/WinForms.png") %>" alt="WinForms" />
                            RadControls for WinForms
                        </li>
                        <li>
                            <img src="<%: Url.Content("~/Content/Common/Icons/Suites_32/WPF.png") %>" alt="WPF" />
                            RadControls for WPF
                        </li>
                    </ul>
                <%});
            
            treeview.Add()
                .Text("Productivity")
                .Content(() =>
                {%>
                    <ul>
                        <li>
                            <img src="<%: Url.Content("~/Content/Common/Icons/Suites_32/JustCode.png") %>" alt="JustCode Icon" />
                            JustCode
                        </li>
                    </ul>
                <%});
            
            treeview.Add()
                .Text("Data")
                .Content(() =>
                {%>
                    <ul>
                        <li>
                            <img src="<%: Url.Content("~/Content/Common/Icons/Suites_32/ORM.png") %>" alt="ORM" />
                            OpenAccess ORM
                        </li>
                        <li>
                            <img src="<%: Url.Content("~/Content/Common/Icons/Suites_32/REP.png") %>" alt="REP" />
                            Reporting
                        </li>
                    </ul>
                <%});
            
            treeview.Add()
                .Text("TFS Tools")
                .Content(() =>
                {%>
                    <ul>
                        <li>
                            <img src="<%: Url.Content("~/Content/Common/Icons/Suites_32/TFS.png") %>" alt="TFS" />
                            Work Item Manager
                        </li>
                        <li>
                            <img src="<%: Url.Content("~/Content/Common/Icons/Suites_32/PD.png") %>" alt="PD" />
                            Project Dashboard
                        </li>
                    </ul>
                <%});
            
            treeview.Add()
                .Text("Automated Testing")
                .Content(() =>
                {%>
                    <ul>
                        <li>
                            <img src="<%: Url.Content("~/Content/Common/Icons/Suites_32/Test.png") %>" alt="Test" />
                            Web Testing Tools
                        </li>
                    </ul>
                <%});
            
            treeview.Add()
                .Text("ASP.NET CMS")
                .Content(() =>
                {%>
                    <ul>
                        <li>
                            <img src="<%: Url.Content("~/Content/Common/Icons/Suites_32/CMS.png") %>" alt="CMS" />
                            Sitefinity CMS
                        </li>
                    </ul>
                <%});

        }).Render();
%>

</asp:content>

<asp:content contentPlaceHolderId="HeadContent" runat="server">
    <style type="text/css">
        #TreeView .t-content li
        {
            line-height: 32px;
            font-size: 1.2em;
            padding: 3px 0;
            list-style-type: circle;
        }
        
        #TreeView .t-content img
        {
            vertical-align: middle;
        }
    </style>
</asp:content>
