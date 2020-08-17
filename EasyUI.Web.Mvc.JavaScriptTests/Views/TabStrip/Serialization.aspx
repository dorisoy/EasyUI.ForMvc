<%@ Page Title="Serialization tests" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    
	<%= Html.EasyUI().TabStrip()
            .Name("TabStrip_without_contentUrls")
            .Items(items =>
            {
                items.Add().Text("Item 1");
                items.Add().Text("EasyUI website").Url("http://www.easyui.com");
            }) %>

     <%= Html.EasyUI().TabStrip()
            .Name("TabStrip_invisible_contentUrl")
            .Items(items =>
            {
                items.Add().Text("Item 1");
                items.Add().Text("Item 2").LoadContentFrom("AjaxView1", "TabStrip").Visible(false);
                items.Add().Text("Item 3");
            }) %>

     <%= Html.EasyUI().TabStrip()
            .Name("TabStrip_contentUrl")
            .Items(items =>
            {
                items.Add().Text("Item 1");
                items.Add().Text("Item 2").LoadContentFrom("AjaxView1", "TabStrip");
                items.Add().Text("Item 3").Url("http://google.com").LoadContentFrom("AjaxView2", "TabStrip");
            }) %>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">
        
        function getTabStrip(id) {
            return $(id).data("tTabStrip");
        }
        
        test('tabstrip without contentUrls does not serialize contentUrls array at all', function() {
            var tabstrip = getTabStrip('#TabStrip_without_contentUrls');
          
            same(tabstrip.contentUrls, undefined);
        });
        
        test('tabstrip with invisible contentUrl tabs does not serialize contentUrls array at all', function() {
            var tabstrip = getTabStrip('#TabStrip_invisible_contentUrl');
            
            same(tabstrip.contentUrls, undefined);
        });

        test('tabstrip with contentUrl serializes it to contentUrls property', function() {
            var tabstrip = getTabStrip('#TabStrip_contentUrl');
            
            same(tabstrip.contentUrls, ['','<%= Url.Action("AjaxView1", "TabStrip") %>','<%= Url.Action("AjaxView2", "TabStrip") %>']);
        });

    </script>

</asp:Content>