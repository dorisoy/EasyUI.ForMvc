<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <% Html.EasyUI().PanelBar()
            .Name("myPanelBar")
            .Items(panelbar =>
            {
                panelbar.Add().Text("Item 1");
                panelbar.Add().Text("Item 2")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 2.1");
                        item.Add().Text("Child Item 2.2");
                        item.Add().Text("Child Item 2.3");
                        item.Add().Text("Child Item 2.4");
                    })
                    .Expanded(true);
                panelbar.Add().Text("Item 3")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 3.1");
                        item.Add().Text("Child Item 3.2");
                    });
                panelbar.Add().Text("Item 4");
                panelbar.Add().Text("Item 5");
                panelbar.Add().Text("Item 6");
            }
            )
            .Effects(fx => fx.Toggle())
            .Render(); %>
            
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">


        var panelbar;
            
        function getRootItem(index) {
            return $('#myPanelBar').find('.t-header').parent().eq(index)
        }
        
        module("PanelBar / Selection", {
            setup: function() {
                panelbar = $('#myPanelBar').data('tPanelBar');
            }
        });

        test('clicking root items selects them', function() {
            var firstLink = getRootItem(0).find('> .t-link');
        
            firstLink.trigger({ type: 'click' });

            ok(firstLink.hasClass('t-state-selected'));
        });

        test('selecting root items deselects their siblings', function() {
            var firstLink = getRootItem(0).find('> .t-link');
            var secondLink = getRootItem(1).find('> .t-link');
        
            firstLink.trigger({ type: 'click' });
            secondLink.trigger({ type: 'click' });

            equal($(panelbar.element).find('.t-state-selected').length, 1);
        });

</script>

</asp:Content>