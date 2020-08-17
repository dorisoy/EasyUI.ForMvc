<%@ Page Title="CollapseDelay Tests" Language="C#" MasterPageFile="~/Views/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2>Expand / Collapse Tests</h2>

    <% Html.EasyUI().TreeView()
            .Name("myTreeView")
            .Items(treeview =>
            {
                treeview.Add().Text("Item 1")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 1.1"); 
                        item.Add().Text("Child Item 1.2"); 
                        item.Add().Text("Child Item 1.3"); 
                        item.Add().Text("Child Item 1.4"); 
                    })
                    .Expanded(false);
                treeview.Add().Text("Item 2")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 3.1");
                        item.Add().Text("Child Item 3.2");
                        item.Add().Text("Child Item 3.3");
                        item.Add().Text("Child Item 3.4");
                    })
                    .Expanded(false);
                treeview.Add().Text("Item 3")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 3.1");
                        item.Add().Text("Child Item 3.2");
                    })
                    .Expanded(false);
                treeview.Add().Text("Item 4")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 4.1");
                        item.Add().Text("Child Item 4.2");
                    })
                    .Expanded(true);
                treeview.Add().Text("Item 5")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 5.1");
                        item.Add().Text("Child Item 5.2");
                    })
                    .Expanded(true);
                treeview.Add().Text("Item 6")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 6.1");
                        item.Add().Text("Child Item 6.2");
                    })
                    .Enabled(false)
                    .Expanded(false);

                treeview.Add().Text("Item 7")
                    .LoadOnDemand(true)
                    .Content(() => {%>foo<%});
            }
            )
            .Effects(fx => fx.Toggle())
            .Render(); %>

    <script type="text/javascript">
        var treeView;
        
        function getTreeView(selector) {
            return $(selector || "#myTreeView").data("tTreeView");
        }
        
        
    </script>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">

        module("TreeView / ExpandCollapse", {
            setup: function() {
                treeView = getTreeView();
            }
        });
        
        test('clicking collapsed item not expand if it is disabled', function() {

            var item = $("ul li:nth-child(1)", treeView.element);

            item.find('.t-plus')
                .toggleClass('t-plus-disabled', true)
                .trigger('click');

            equal(item.find('.t-group').css("display"), "none");
        });

        test('clicking plus icon should toggle minus', function() {
            var item = $("ul li:nth-child(2)", treeView.element);

            item.find('.t-plus')
                .trigger('click');

            ok(item.find('.t-icon').hasClass('t-minus'));
        });

        test('clicking plus items should expand them', function() {
            var item = $("ul li:nth-child(3)", treeView.element);

            item.find('.t-plus')
                .trigger('click');

            equal(item.find('.t-group').css("display"), "block");
        });

        test('clicking minus icon should toggle plus', function() {
            var item = $("ul li:nth-child(4)", treeView.element);

            item.find('.t-minus')
                .trigger('click');

            ok(item.find('.t-icon').hasClass('t-plus'));
        });

        test('clicking minus on expanded items should collaspe them', function() {
            var item = $("ul li:nth-child(5)", treeView.element);

            item.find('.t-minus')
                .trigger('click');

            equal(item.find('.t-group').css("display"), "none");
        });

        test('double clicking disabled items does not expand them', function() {
            var item = $("ul li:nth-child(6)", treeView.element);

            item.find('.t-in.t-state-disabled')
                .trigger('dblclick');
            
            equal(item.find('.t-group').css("display"), "none");
        });

        test('items with content allow to be expanded', function() {
            var item = $("ul li:nth-child(7)", treeView.element),
                icon = item.find('.t-icon');
            
            ok(icon.css("display").indexOf("block") > -1);
        });

    </script>

</asp:Content>