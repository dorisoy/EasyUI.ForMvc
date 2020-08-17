<%@ Page Title="Single Expand / Collapse Tests" Language="C#" MasterPageFile="~/Views/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        Single Expand / Collapse Tests</h2>
        
    <% Html.EasyUI().PanelBar()
            .Name("myPanelBar")
            .Items(panelbar =>
            {
                panelbar.Add().Text("Item 1")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 1.1");
                        item.Add().Text("Child Item 1.2");
                        item.Add().Text("Child Item 1.3");
                        item.Add().Text("Child Item 1.4");
                    }).Expanded(false);
                panelbar.Add().Text("Item 2")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 3.1");
                        item.Add().Text("Child Item 3.2");
                        item.Add().Text("Child Item 3.3");
                        item.Add().Text("Child Item 3.4");
                    });
                panelbar.Add().Text("Item 3")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 3.1");
                        item.Add().Text("Child Item 3.2");
                    });
                panelbar.Add().Text("Item 4")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 4.1");
                        item.Add().Text("Child Item 4.2");
                    });
                panelbar.Add().Text("Item 5")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 5.1")
                            .Items(childitem =>
                            {
                                childitem.Add().Text("Grand Child Item 5.1.1");
                                childitem.Add().Text("Grand Child Item 5.1.2");
                            });
                    });
                panelbar.Add().Text("Item 6")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 6.1");
                    });
                panelbar.Add().Text("Item 7");
            }
            )
            .Effects(effect=>effect.Toggle())
            .ExpandMode(PanelBarExpandMode.Single)
            .Render(); %>

    <script type="text/javascript">

        function getRootItem(index) {
            return $('#myPanelBar').find('.t-header').parent().eq(index)
        }
    </script>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



        test('clicking second item should collapse other', function() {

            var item = getRootItem(0);
            var item2 = getRootItem(1);

            item2.find('> .t-link').trigger('click');

            equal(item.find('.t-group').css("display"), "none");
        });

        test('clicking item twice should not collapse it', function() {

            var item = getRootItem(0);

            item.find('> .t-link').trigger('click');
            item.find('> .t-link').trigger('click');

            equal(item.find('.t-group').css("display"), "block");
        });

        test('clicking subItem should not collapse headerItem', function() {
            
            var item = getRootItem(4);
            var subItem = item.find('> .t-group').children()[0];

            item.find('> .t-link').trigger('click');
            $(subItem).find('> .t-link').trigger('click');

            equal(item.find('.t-group').css("display"), "block");
        });

        test('clicking not expandable item should not collapse expanded item', function() {

            var item = getRootItem(4);
            var item2 = getRootItem(6);

            item.find('> .t-link').trigger('click');
            item2.find('> .t-link').trigger('click');

            equal(item.find('.t-group').css("display"), "block");
        });

</script>

</asp:Content>