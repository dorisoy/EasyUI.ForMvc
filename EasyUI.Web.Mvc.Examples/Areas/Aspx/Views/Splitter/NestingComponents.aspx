<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content contentPlaceHolderID="MainContent" runat="server">

    <%  Html.EasyUI().Splitter().Name("Splitter")
            .Orientation(SplitterOrientation.Horizontal)
            .Panes(hPanes =>
            {
                hPanes.Add()
                    .Size("200px")
                    .MinSize("100px")
                    .MaxSize("300px")
                    .Collapsible(true)
                    .Scrollable(false)
                    .Content(() =>
                    {
                        Html.EasyUI().Splitter()
                            .Name("NestedSplitter")
                            .HtmlAttributes(new { style = "height: 100%; border: 0;" })
                            .Orientation(SplitterOrientation.Vertical)
                            .Panes(vPanes =>
                            {
                                vPanes.Add()
                                    .Content(() =>
                                    {
                                        Html.EasyUI().PanelBar()
                                                .Name("PanelBar")
                                                .HtmlAttributes(new { style = "height: 100%; border: 0;" })
                                                .Items(panelbar =>
                                                {
                                                    panelbar.Add()
                                                        .Text("Show orders...")
                                                        .Expanded(true)
                                                        .Items(customers =>
                                                        {
                                                            customers.Add()
                                                                .Text("... sorted by customer name")
                                                                .Action("NestingComponents", "Splitter", new { view = "sortedByName" })
                                                                .Selected(((string)ViewData["view"]) == "sortedByName");

                                                            customers.Add()
                                                                .Text("... sorted by order date")
                                                                .Action("NestingComponents", "Splitter", new { view = "sortedByDate" })
                                                                .Selected(((string)ViewData["view"]) == "sortedByDate");

                                                            customers.Add()
                                                                .Text("... grouped by customer")
                                                                .Action("NestingComponents", "Splitter", new { view = "groupedByCustomer" })
                                                                .Selected(((string)ViewData["view"]) == "groupedByCustomer");
                                                        });
                                                }).Render();
                                    });

                                vPanes.Add()
                                    .Size("70px")
                                    .MinSize("60px")
                                    .MaxSize("150px")
                                    .Content("<p style='text-align: center; padding: .5em;'>Select a view from the list above.</p>");
                            })
                            .Render();
                    });

                hPanes.Add()
                    .Scrollable(false)
                    .Content(() =>
                    {
                        Html.EasyUI().Grid<Order>()
                            .Name("Grid")
                            .HtmlAttributes(new { style = "border: 0;" })
                            .Columns(columns =>
                            {
                                columns.Bound(o => o.OrderID).Width(100);

                                columns.Bound(o => o.Customer.ContactName).Width(200)
                                    .Visible(((string)ViewData["view"]) != "groupedByCustomer");

                                columns.Bound(o => o.ShipAddress);

                                columns.Bound(o => o.OrderDate).Format("{0:MM/dd/yyyy}").Width(120);
                            })
                            .DataBinding(dataBinding => dataBinding.Ajax().Select("_AjaxBinding", "Grid"))
                            .Pageable(paging => paging.PageSize(20))
                            .Scrollable(scrollable => scrollable.Height("246px"))
                            .Sortable(config => config
                                .OrderBy(order => order
                                    .Add(((string)ViewData["view"]) == "sortedByDate" ? "OrderDate" : "Customer.ContactName")
                                )
                            )
                            .Groupable(grouping =>
                            {

                                grouping.Visible(false);

                                if (((string)ViewData["view"]) == "groupedByCustomer")
                                {
                                    grouping
                                        .Groups(groups => groups.Add(order => order.Customer.ContactName));
                                }
                            })
                            .Render();
                    });
            })
            .Render();
    %>

</asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="HeadContent">

    <style type="text/css">
        #PanelBar .t-group
        {
            border-bottom: 0;
        }
    </style>

</asp:Content>
