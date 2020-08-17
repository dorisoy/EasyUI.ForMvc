<%@ Page Title="Serialization tests" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    
	<%= Html.EasyUI().PanelBar()
            .Name("PanelBar_without_contentUrls")
            .Items(items =>
            {
                items.Add().Text("Item 1");
                items.Add().Text("EasyUI website").Url("http://www.easyui.com");
            }) %>

     <%= Html.EasyUI().PanelBar()
            .Name("PanelBar_invisible_contentUrl")
            .Items(items =>
            {
                items.Add().Text("Item 1");
                items.Add().Text("Item 2").LoadContentFrom("AjaxView1", "PanelBar").Visible(false);
                items.Add().Text("Item 3");
            }) %>

     <%= Html.EasyUI().PanelBar()
            .Name("PanelBar_contentUrl")
            .Items(items =>
            {
                items.Add().Text("Item 1");
                items.Add().Text("Item 2").LoadContentFrom("AjaxView1", "PanelBar");
                items.Add().Text("Item 3").Url("http://google.com").LoadContentFrom("AjaxView2", "PanelBar");
            }) %>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">
        
        function getPanelBar(id) {
            return $(id).data("tPanelBar");
        }
        
        test('panelbar without contentUrls does not serialize contentUrls array at all', function() {
            var panelbar = getPanelBar('#PanelBar_without_contentUrls');
          
            same(panelbar.contentUrls, undefined);
        });
        
        test('panelbar with invisible contentUrl tabs does not serialize contentUrls array at all', function() {
            var panelbar = getPanelBar('#PanelBar_invisible_contentUrl');
            
            same(panelbar.contentUrls, undefined);
        });

        test('panelbar with contentUrl serializes it to contentUrls property', function() {
            var panelbar = getPanelBar('#PanelBar_contentUrl');
            
            same(panelbar.contentUrls, ['','<%= Url.Action("AjaxView1", "PanelBar") %>','<%= Url.Action("AjaxView2", "PanelBar") %>']);
        });

    </script>

</asp:Content>