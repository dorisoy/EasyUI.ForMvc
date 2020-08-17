<%@ Page Title="ClientAPI tests" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    
	<% Html.EasyUI().TabStrip()
            .Name("TabStrip")
            .Items(items =>
            {
                items.Add().Text("Item 1");
                items.Add().Text("Item 2");

                items.Add().Text("Item 3");
                items.Add().Text("Item 4")
                    .Enabled(false);
                items.Add().Text("Item 5");
                items.Add().Text("Item 6")
                    .Content(() => 
                    {
                        %>
                            <p>Content</p>
                        <%
                    });
                 items.Add().Text("Item 7")
                    .Content(() => 
                    {
                        %>
                            <p>Content</p>
                        <%
                    });
                items.Add().Text("AjaxItem");
                items.Add().Text("InputContent")
                     .Content("<input type='text' value='asdf'/>");
                items.Add().Text("NavigatingItem")
                     .Url("http://www.easyui.com");
            }
            ).ClientEvents(events =>
            {
                events.OnSelect("Select");
                events.OnLoad("Load");
            })
            .Render(); %>

     <% Html.EasyUI().TabStrip()
            .Name("TabStrip1")
            .Items(items =>
            {
                items.Add().Text("Item 1");
                items.Add().Text("Item 2");
            })
            .Render(); %>

     <% Html.EasyUI().TabStrip()
            .Name("TabStrip2")
            .Effects(fx => fx.Opacity().Expand().OpenDuration(1).CloseDuration(1))
            .Items(items =>
            {
                items.Add().Text("Item 1").Content("text test").Selected(true);
            })
            .Render(); %>
    
    <script type="text/javascript">

        var isRaised;

        var argsCheck = false;
        
        //handlers
        function Select(e) {
            if (argsCheck) {
                isRaised = !!e.contentElement;
                argsCheck = false;
            } else
                isRaised = true;
        }
    
        var onLoadTabStrip;
        function Load(e) {
            isRaised = true;
            onLoadTabStrip = $(this).data('tTabStrip');
        }
    </script>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">
        
        function getRootItem(index) {
            return $('#TabStrip').find('.t-item').eq(index)
        }
        
        function getTabStrip() {
            return $("#TabStrip").data("tTabStrip");
        }

        test('clicking item with url should navigate', function() {
            
            var tabstrip = getTabStrip();
            var $item = $(getRootItem(9));

            var e = new $.Event('click');
                        
            $item.find('.t-link').trigger(e);

            ok(!e.isDefaultPrevented());

            //stop navigation after assert
            e.preventDefault();
        });

        test('trigger input select should not bubble', function() {

            isRaised = false;

            var tabstrip = getTabStrip();
            var content = tabstrip.getContentElement(8)

            $(content).find('input').first().trigger('select');

            ok(!isRaised);
        });

        test('reload method should call ajaxRequest', function() { 
            var tabstrip = getTabStrip();
            var isCalled = false;
            var $item = $(getRootItem(7));

            $item.find('.t-link').data('ContentUrl', 'fake');
            tabstrip.ajaxRequest = function () { isCalled = true; };
            
            tabstrip.reload($item);

            ok(isCalled);
        });
    
        test('clicking should raise onSelect event', function() {

            var item = getRootItem(2);

            isRaised = false;

            item.find('> .t-link').trigger('click');

            ok(isRaised);
        });

        test('clicking first item should select it', function() {
            var item = getRootItem(0);

            item.find('.t-link').trigger('click');

            ok(item.hasClass('t-state-active'));
        });

        test('select method should select second item', function() {
            var tabstrip = getTabStrip();
            var item = getRootItem(1);

            tabstrip.select(item);

            ok(item.hasClass('t-state-active'));
        
        });

        test('disable method should disable item', function() {
            var tabstrip = getTabStrip();

            var item = getRootItem(4);

            tabstrip.disable(item);

            ok(item.hasClass('t-state-disabled'));
        });

        test('enable method should enable disabled item', function() {
            var tabstrip = getTabStrip();

            var item = getRootItem(3);

            tabstrip.enable(item);

            ok(item.hasClass('t-state-default'));
        });

        test('select method should show content', function() {
            var tabstrip = getTabStrip();

            var item = getRootItem(5);
            tabstrip.select(item);

            var content = $(tabstrip.getContentElement(5));
            ok(content.hasClass('t-state-active'));
        });

        test('getContentElement should return content of seveth tab', function() {
            var tabstrip = getTabStrip();
            
            var expectedContent = $(tabstrip.element).find('> .t-content').eq(1); //second content under Tab-7
            
            equal($(tabstrip.getContentElement(6)).index(), expectedContent.index());
        });

        test('getContentElement should not return tab content if passed argument is not number', function() {
            var tabstrip = getTabStrip();

            equal(tabstrip.getContentElement("a"), undefined);
        });

        test('getContentElement should not return tab content if passed argument is not in range', function() {
            var tabstrip = getTabStrip();

            equal(tabstrip.getContentElement(100), undefined);
        });

        test('getSelectedTab should return current selected tab', function() {
            var tabstrip = getTabStrip();

            var item = getRootItem(0);
            tabstrip.select(item);

            equal(tabstrip.getSelectedTabIndex(), $(item).index());
        });

        test('getSelectedTab should return negative if no selected tabs', function() {
            var tabstrip = $("#TabStrip1").data("tTabStrip")
            
            equal(tabstrip.getSelectedTabIndex(), -1);
        });

        test('click should raise select event and pass corresponding content', function() {
            argsCheck = true;

            var item = getRootItem(6);

            isRaised = false;

            item.find('> .t-link').trigger('click');

            ok(isRaised);
        });

        test('client object is available in on load', function() {
            ok(null !== onLoadTabStrip);
            ok(undefined !== onLoadTabStrip);
        });

        test('animated text-only content is opened on load', function() {
            
            equals($('#TabStrip2 .t-content').css('opacity'), '1');
        });

    </script>

</asp:Content>