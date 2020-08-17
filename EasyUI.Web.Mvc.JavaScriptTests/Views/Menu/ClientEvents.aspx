<%@ Page Title="ClientEvemts tests" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

	<%= Html.Telerik().Menu()
            .Name("Menu")
            .Items(items =>
            {
                items.Add().Text("Item 1");
            })
            .Effects(effects => effects.Toggle())
    %>

</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">
        
        function getRootItem(index) {
			return $('> .t-item', menu.element).eq(index);
        }

        var menu;

        module("Menu / ClientEvents", {
            setup: function() {
                menu = $("#Menu").data("tMenu");
            },
            teardown: function() {
                $(menu.element).unbind("select");
            }
        });

        test("select is triggered when menu element is clicked", function() {
            var item = getRootItem(0),
                triggerCount = 0;

            $(menu.element).bind("select", function() {
                triggerCount++;
            });

            item.trigger("click");

            equals(triggerCount, 1);
        });

    </script>

</asp:Content>