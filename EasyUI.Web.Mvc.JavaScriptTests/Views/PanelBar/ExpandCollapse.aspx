<%@ Page Title="CollapseDelay Tests" Language="C#" MasterPageFile="~/Views/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        Expand / Collapse Tests</h2>
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
                    })
                    .Expanded(false);
                panelbar.Add().Text("Item 2")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 3.1");
                        item.Add().Text("Child Item 3.2");
                        item.Add().Text("Child Item 3.3");
                        item.Add().Text("Child Item 3.4");
                    })
                    .Expanded(true);
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
                    })
                    .Expanded(true);

                panelbar.Add().Text("Item 7")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 7.1");
                    });

                panelbar.Add().Text("Item 8")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 8.1");
                    })
                    .Expanded(true);
            }
            )
            .Effects(fx => fx.Toggle())
            .Render(); %>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">

        function getRootItem(index) {
            return $("#myPanelBar").find(".t-header").parent().eq(index)
        }

        test("clicking collapsed item not expand if it is disabled", function() {
        
            var item = getRootItem(0);
            
            item
                .toggleClass("t-state-default", false)
				.toggleClass("t-state-disabled", true);

            item.find("> .t-link").trigger("click");
            
            equal(item.find(".t-group").css("display"), "none");
        });

        test("clicking expanded items should toggle arrow", function() {
            var item = getRootItem(1);

            item.find("> .t-link").trigger("click");

            ok(item.find(".t-icon").hasClass("t-arrow-down"));
        });

        test("clicking collapsed items should expand them", function() {
            var item = getRootItem(2);

            item.find("> .t-link").trigger("click");

            equal(item.find(".t-group").css("display"), "block");
        });

        test("clicking collapsed items should toggle arrow", function() {
            var item = getRootItem(3);

            item.find("> .t-link").trigger("click");

            ok(item.find(".t-icon").hasClass("t-arrow-up"));
        });

        test("clicking collapsed items should not expand child groups", function() {
            var item = getRootItem(4);

            item.find("> .t-link").trigger("click");

            equal(item.find(".t-group .t-group").css("display"), "none");
        });

        test("clicking child group items should not collapse root group", function() {
            var item = getRootItem(5);

            item.find(".t-item").trigger("click");

            equal(item.find(".t-group").css("display"), "block");
        });

        test("clicking arrows toggles child groups", function() {
            var item = getRootItem(6);

            item.find("> .t-link > .t-icon").trigger("click");

            equal(item.find(".t-group").css("display"), "block");
        });

    </script>

</asp:Content>