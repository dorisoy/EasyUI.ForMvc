<%@ Page Title="CollapseDelay Tests" Language="C#" MasterPageFile="~/Views/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <% Html.EasyUI().Menu()
            .Name("myMenu")
            .OpenOnClick(true)
            .Items(menu =>
            {
                menu.Add().Text("Item 1")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 1.1");
                        item.Add().Text("Child Item 1.2");
                        item.Add().Text("Child Item 1.3");
                        item.Add().Text("Child Item 1.4");
                    });
                menu.Add().Text("Item 2")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 2.1");
                        item.Add().Text("Child Item 2.2");
                        item.Add().Text("Child Item 2.3");
                        item.Add().Text("Child Item 2.4");
                    });
                menu.Add().Text("Item 4")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 4.1")
                            .Items(subitem =>
                            {
                                subitem.Add().Text("Grand Child Item 4.1.1");
                                subitem.Add().Text("Grand Child Item 4.1.2");
                            });

                        item.Add().Text("Child Item 4.2");
                    });
                menu.Add().Text("Item 5").Action("Index", "Home").Enabled(false);
            }
            )
            .Render(); %>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

        function getMenu(selector) {
            return $(selector || "#myMenu").data("tMenu");
        }

        var open;
        var close;
        var menu;
        
        module("Menu / OpenOnClick", {
            setup: function() {
                menu = getMenu();
                open = menu.open;
                close = menu.close;
            },
            teardown: function() {
                menu.clicked = false;
                menu.open = open;
                menu.close = close;
            }
        });

        test('open on click is serialized', function() {
            ok(menu.openOnClick);
        });

        test('hovering root item does not open it', function() {
            var opend = false;

            menu.open = function() { opend = true }
            menu.mouseenter({}, $("li:first", menu.element)[0]);

            ok(!opend);
        });

        test('clicking root item should open it', function() {
            var opend = false;
            menu.open = function() { opend = true }
            menu.click({ preventDefault: function () { }, stopPropagation: function () { } }, $("li:first", menu.element)[0]);
            ok(opend);
            ok(menu.clicked);
        });

        test('leaving opened item does not close it', function() {
            var opend = false;
            menu.clicked = true;
            menu.open = function() { opend = true }

            menu.mouseleave({}, $("li:first", menu.element)[0]);

            ok(!opend);
        });

        test('leaving opened and hovering a sibling closes it and opens the sibling', function() {
            menu.clicked = true;
            menu.open = function() { opend = true }

            var element = $("li:first", menu.element)[0];
            menu.mouseenter({ relatedTarget: element, indexOf: function() { }, type:'mouseenter' }, element.nextSibling);

            ok(opend);
        });

        test('clicking the document closes the open item', function() {
            var closed = false;
            menu.clicked = true;
            menu.close = function() { closed = true }
            menu.documentClick({ target: document.body}, document);
            ok(closed);
        });

</script>

</asp:Content>