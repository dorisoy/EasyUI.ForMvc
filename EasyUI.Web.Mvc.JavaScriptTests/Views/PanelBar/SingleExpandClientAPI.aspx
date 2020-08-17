<%@ Page Title="SingleExpandItem ClientAPI tests" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <h2>Client API Tests</h2>
    
	<% Html.EasyUI().PanelBar()
            .Name("myPanelBar")
            .Items(panelBarItem =>
            {
                panelBarItem.Add().Text("Item 1")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 1.1");
                        item.Add().Text("Child Item 1.2");
                        item.Add().Text("Child Item 1.3");
                        item.Add().Text("Child Item 1.4");
                    }).Expanded(true);
                panelBarItem.Add().Text("Item 2")
                                  .ImageHtmlAttributes(new { alt = "testImage", height = "10px", width = "10px" })
                                  .ImageUrl(Url.Content("~/Content/Images/easyui.png"));

				panelBarItem.Add().Text("Item 3")
					.Items(item =>
					{
						item.Add().Text("Child Item 3.1");
						item.Add().Text("Child Item 3.2");
						item.Add().Text("Child Item 3.3");
						item.Add().Text("Child Item 3.4");
					})
					.Enabled(true);
                panelBarItem.Add().Text("Item 4")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 4.1")
                            .Items(subitem =>
                            {
                                subitem.Add().Text("Grand Child Item 4.1.1");
                                subitem.Add().Text("Grand Child Item 4.1.2");
                            });

                        item.Add().Text("Child Item 4.2");
                    }).Enabled(false);
                panelBarItem.Add().Text("Item 5")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 5.1");
                    });
            }
            ).ClientEvents(events =>
            {
                events.OnExpand("Expand");
                events.OnCollapse("Collapse");
                events.OnSelect("Select");
                events.OnLoad("Load");
            })
            .Effects(ef=>ef.Toggle())
            .ExpandMode(PanelBarExpandMode.Single)
            .Render(); %>
    
   <script type="text/javascript">

       var isRaised;
        
        function getRootItem(index) {
			return $('#myPanelBar').find('.t-header').parent().eq(index)
        }

        function getPanelBar() {
            return $("#myPanelBar").data("tPanelBar");
        }

        //handlers
        function Expand(sender, args) {
            isRaised = true;
        }

        function Collapse(sender, args) {
            isRaised = true;
        }

        function Select(sender, args) {
            isRaised = true;
        }

        function Load(sender, args) {
            isRaised = true;
        }
   </script>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">


        
        test('expand should collapse other opened items', function() {
           
            var panel = getPanelBar();

            var item = getRootItem(0);
            var item2 = getRootItem(2);

            panel.expand(item2);

            equal(item.find('> .t-group').css("display"), "none");
        });

        test('expand should not collapse item which is already expanded', function() {
        
            var panel = getPanelBar();

            var item = getRootItem(2);

            panel.expand(item);
            panel.expand(item);

            equal(item.find('> .t-group').css("display"), "block");
        });

</script>

</asp:Content>