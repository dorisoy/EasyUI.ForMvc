<%@ Page Title="ClientAPI tests" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <h2>Client API Tests</h2>
    
	<% Html.EasyUI().Menu()
            .Name("Menu")
            .Items(items =>
            {
                items.Add().Text("Item 1")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 1.1");
                        item.Add().Text("Child Item 1.2");
                        item.Add().Text("Child Item 1.3");
                        item.Add().Text("Child Item 1.4").Enabled(false);
                    });
                items.Add().Text("Item 2")
                                  .ImageHtmlAttributes(new { alt = "testImage", height = "10px", width = "10px" })
                                  .ImageUrl(Url.Content("~/Content/Images/easyui.png"));

                items.Add().Text("Item 3")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 3.1");
                        item.Add().Text("Child Item 3.2");
                        item.Add().Text("Child Item 3.3");
                        item.Add().Text("Child Item 3.4");
                    });
                items.Add().Text("Item 4")
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
                items.Add().Text("Item 5")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 5.1");
                    });
                items.Add().Text("Item 6")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 6.1");
                    });
                items.Add().Text("Item7");
                items.Add().Text("Item8").Enabled(false);
            }
            ).ClientEvents(events =>
            {
                events.OnOpen("Open");
                events.OnClose("Close");
                events.OnSelect("Select");
                events.OnLoad("Load");
            })
            .Effects(effects=> effects.Toggle())
            .Render(); %>

     <% Html.EasyUI().Menu()
            .Name("Menu2")
            .Items(items =>
            {
                items.Add().Text("Item 1").Url("http://www.easyui.com");
            }
            ).ClientEvents(events =>
            {
                events.OnSelect("select_prevented");
            })
            .Render(); 
    %>
    
   <script type="text/javascript">

       var isRaised;
        
        function getRootItem(index) {
			return $('#Menu').find('> .t-item').eq(index)
        }

        function getMenu() {
            return $("#Menu").data("tMenu");
        }

        //handlers
        function Open() {
            isRaised = true;
        }

        function Close() {
            isRaised = true;
        }

        function Select() {
            isRaised = true;
        }

        function select_prevented(e) {
            e.preventDefault();
        }

        var onLoadMenu;

        function Load() {
            isRaised = true;
            onLoadMenu = $(this).data('tMenu');
        }
   </script>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

        test('click method should call preventDefault method', function() {
            var item = getRootItem(7);
            var isCalled = false;

            var e = { preventDefault: function () { isCalled = true; }, stopPropagation: function () { } }

            getMenu().click(e, item);

            ok(isCalled);
        });

        test('click method should call preventDefault method if select event handler is stopped', function() {
            var item = $('#Menu2').find('> .t-item').eq(0),
                menu = $('#Menu2').data('tMenu'),
                isCalled = false;

            var e = { preventDefault: function () { isCalled = true; }, stopPropagation: function () { } }

            menu.click(e, item);

            ok(isCalled);
        });

        test('click method should call stopPropagation method always', function() {
            var item = getRootItem(7);
            var isCalled = false;

            var e = { stopPropagation: function () { isCalled = true; }, preventDefault: function () { } }

            getMenu().click(e, item);

            ok(isCalled);
        });

        test('clicking should raise onSelect event', function() {
            var item = getRootItem(6);

            isRaised = false;

            item.find('> .t-link').trigger('click');

            ok(isRaised);
        });

        test('clicking disabled item should not raise onSelect event on parent item', function() {
            var item = getRootItem(0);

            isRaised = false;

            item.find('.t-item > .t-link').eq(3).trigger('click');

            ok(!isRaised);
        });

        test('open should not open item is disabled', function() {
            var menu = getMenu();

            var item = getRootItem(3);

            menu.open(item);

            equal(item.find('> .t-group').css("display"), "none");
        });      

        test('disable method should disable enabled item', function() {
            var menu = getMenu();

            var item = getRootItem(2);

            menu.disable(item);
            
            ok(item.hasClass('t-state-disabled'));
        });

        test('enable method should enable disabled item', function() {
            var menu = getMenu();

            var item = getRootItem(3);

            menu.enable(item);

            ok(item.hasClass('t-state-default'));
        });

        test('client object is available in on load', function() {
            ok(null !== onLoadMenu);
            ok(undefined !== onLoadMenu);
        });

</script>

</asp:Content>