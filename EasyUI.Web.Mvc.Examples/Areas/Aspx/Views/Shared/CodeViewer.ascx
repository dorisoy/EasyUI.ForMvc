<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>

<div id="about-example">
    <h2>
        <span class="viewengine-switch">
        <span class="selected-engine">ASPX</span>
        <%: Html.ActionLink("Razor", (string)Html.ViewContext.RouteData.Values["action"], new { area = "", controller = (string)Html.ViewContext.RouteData.Values["controller"] }, new { @class = "t-link" })%>
        </span>
    </h2>

    <% Html.EasyUI().TabStrip()
            .Name("code-viewer-tabs")
            .Items(tabstrip =>
           {
               var hasDescription = !string.IsNullOrEmpty(Convert.ToString(ViewData.Get<object>("Description")));
               //Description
               if (hasDescription)
               {
                   tabstrip.Add()
                       .Text("描述")
                       .Content(() =>
                       {
                            %>
                            <div class="description"><%:ViewData["Description"] %></div>
                            <%
                       });
               }
               //View Controller Site.Master
               var codeFiles = ViewData.Get<Dictionary<string, string>>("codeFiles");
               foreach (var codeFile in codeFiles)
               {
                   tabstrip.Add()
                           .Text(codeFile.Key)
                           .LoadContentFrom("CodeFile", "Home", new { file = codeFile.Value });
               }
           })
            .SelectedIndex(0)
            .ClientEvents(events => events.OnLoad("codeTabLoad"))
            .Render(); 
    %>
</div>


<div id="api-example">
    <h2>API参考</h2>

    <% Html.EasyUI().TabStrip()
            .Name("code-viewer-tabs")
            .Items(tabstrip =>
           {
               var hasDescription = !string.IsNullOrEmpty(Convert.ToString(ViewData.Get<object>("Description")));

               if (hasDescription)
               {
                   tabstrip.Add()
                       .Text("Methods")
                       .Content(() =>
                       {
                            %>
                            <div class="description">手册增补中...</div>
                            <%
                       });
               }
           })
            .SelectedIndex(0)
            //.ClientEvents(events => events.OnLoad("codeTabLoad"))
            .Render(); 
    %>
</div>