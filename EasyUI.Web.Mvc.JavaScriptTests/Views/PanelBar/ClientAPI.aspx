<%@ Page Title="ClientAPI tests" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

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
                    });
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
					.Enabled(false);
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
                panelBarItem.Add().Text("Item 6")
                  .Items(item =>
                  {
                      item.Add().Text("Child Item 6.1")
                          .Items(subitem =>
                          {
                              subitem.Add().Text("Grand Child Item 6.1.1");
                              subitem.Add().Text("Grand Child Item 6.1.2");
                          });

                      item.Add().Text("Child Item 6.2");
                  }).Enabled(false);
                
                panelBarItem.Add().Text("InputContent")
                            .Content("<input type='text' value='asdf'/>");
            }
            ).ClientEvents(events =>
            {
                events.OnExpand("Expand");
                events.OnCollapse("Collapse");
                events.OnSelect("Select");
                events.OnLoad("Load");
            })
            .Effects(effects => effects.Toggle())
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
    
        var onLoadPanelBar;
        function Load(e) {
            isRaised = true;
            onLoadPanelBar = $(this).data('tPanelBar');
        }
   </script>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



        test('trigger input select should not bubble', function() {

            isRaised = false;

            var item = getRootItem(6);

            $(item).find('input').first().trigger('select');

            ok(!isRaised);
        });

        test('clicking should raise onSelect event', function() {

            var item = getRootItem(1);

            isRaised = false;

            item.find('> .t-link').trigger('click');

            ok(isRaised);
        });

        test('collapse should raise onCollapse event', function() {

            var panel = getPanelBar();

            isRaised = false;

            var item = getRootItem(0);
            
            item.find('> .t-link').trigger('click');

            ok(isRaised);
        });
        
        test('expand should raise onExpand event', function() {

            var panel = getPanelBar();
            
            isRaised = false;

            var item = getRootItem(0);

            item.find('> .t-link').trigger('click');

            ok(isRaised);
        });   

        test('disable method should disable disabled item', function() {
            var panel = getPanelBar();

            var item = getRootItem(2);

            panel.disable(item);

            ok(item.hasClass('t-state-disabled'));
        });

        test('enable method should enable disabled item', function() {
            var panel = getPanelBar();

            var item = getRootItem(3);

            panel.enable(item);

            ok(item.hasClass('t-state-default'));
        });

        test('collapse method should collapse last item', function() {
        
            var panel = getPanelBar();

            var item = getRootItem(4);

            panel.collapse(item);

            equal(item.find('> .t-group').css("display"), "none");
        });

        test('expand method should expand last item', function() {
        
            var panel = getPanelBar();

            var item = getRootItem(4);

            panel.expand(item);

            equal(item.find('> .t-group').css("display"), "block");
        });

         test('client object is available in on load', function() {
            ok(null !== onLoadPanelBar);
            ok(undefined !== onLoadPanelBar);
        });

</script>

</asp:Content>