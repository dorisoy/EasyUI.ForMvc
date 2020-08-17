<%@ Page Title="CollapseDelay Tests" Language="C#" MasterPageFile="~/Views/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2>ClientEvents tests</h2>
    
    <%= Html.EasyUI().TreeView()
            .Name("ClientSideTreeView")
            .ClientEvents(ce => 
                            ce.OnDataBinding("onDataBinding_ClientSideTreeView")
                              .OnSelect("onSelect")
                              .OnLoad("onLoad"))
            .Effects(fx => fx.Toggle()) %>

    <%= Html.EasyUI().TreeView()
            .Name("DisabledTreeView")
            .Items(treeview =>
            {
                treeview.Add().Text("Item 1")
                    .Items(item =>
                    {
                        item.Add().Text("Child Item 1.1");
                        item.Add().Text("Child Item 1.2");
                    })
                    .Enabled(false);
            })
            .Effects(fx => fx.Toggle()) %>

    <%= Html.EasyUI().TreeView()
            .Name("ContentTreeView")
            .Items(treeview =>
            {
                treeview.Add().Text("InputContent")
                        .Content("<input type='text' value='asdf'/>");
            })
            .ClientEvents(ce => ce.OnSelect("onSelectInput"))
            .Effects(fx => fx.Toggle()) %>

    <script type="text/javascript">
        var onLoadTreeView;
        
        function onLoad() {
            onLoadTreeView = $(this).data('tTreeView');
        }

        var isRaised;
        var selectedItem;

        function onDataBinding_ClientSideTreeView(e) {
            var treeview = $('#ClientSideTreeView').data('tTreeView');
            var jsonObject;

            if (e.item == treeview.element) {
                jsonObject = [
                    { Text: "LoadOnDemand", LoadOnDemand: true, Value: "abyss" }
                ];

                    treeview.bindTo(jsonObject);

                    selectedItem = e.item;
            }
        }

        function onSelect(e) {
            selectedItem = null;
            selectedItem = e.item;
        }

        function onSelectInput(e) {
            isRaised = true;
        }

        function getItemHtml(item) {
            var html = new $.easyui.stringBuilder();
                          
            $.easyui.treeview.getItemHtml({
                item: item,
                html: html,
                isFirstLevel: false,
                groupLevel: 0,
                itemIndex: 0,
                itemsCount: 1
            });

            return html.string();
        }
        
    </script>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">


        
        test('client object is available in on load', function() {
            ok(null !== onLoadTreeView);
            ok(undefined !== onLoadTreeView);
        });

        test('clicking item should raise onselect event return selected item', function() {
            
            var treeview = $("#ClientSideTreeView").data("tTreeView");

            var nodeToClick = $(treeview.element).find('.t-item');

            nodeToClick.find('.t-in').click();

            ok($(selectedItem).hasClass('t-item'));
        });

        test('trigger input select should not bubble', function() {
            
            isRaised = false;

            var treeview = $("#ContentTreeView").data("tTreeView");

            var $input = $(treeview.element).find('.t-item').find('input').last();

            $input.trigger('select');

            ok(!isRaised);
        });
        
        test('clicking load on demand nodes triggers databinding event', function() {
            var treeview = $("#ClientSideTreeView").data("tTreeView"),
                node = $(treeview.element).find('.t-item'),
                hasCalledDataBinding = false,
                eventContainsItem = false;
        
            $(treeview.element).bind('dataBinding', function(e) {
                hasCalledDataBinding = true;
                eventContainsItem = e.item == node[0];
            });
            
            treeview.nodeToggle(null, node, true);
            
            ok(hasCalledDataBinding, "DataBinding event should be fired when elements with LoadOnDemand are clicked.");
            ok(eventContainsItem, "DataBinding event should contain item in event data");
        });

        test('reload method should remove items group', function() {
            var treeview = $("#ClientSideTreeView").data("tTreeView"),
                $item = $(getItemHtml({ Text: 'Steven Buchanan', Items: [{ Text: 'Michael Suyama' }] }));

            treeview.reload($item);

            equal($item.find('.t-group').length, 0);
        });

        test('reload method should call ajaxRequest method', function() {
            var treeview = $("#ClientSideTreeView").data("tTreeView"),
                oldAjaxRequest = treeview.ajaxRequest,
                isCalled = false;

            try {
                treeview.ajaxRequest = function () { isCalled = true; };
            
                treeview.reload($('<li></li>'));

                ok(isCalled);

            } finally {
                treeview.ajaxRequest = oldAjaxRequest;
            }
        });

        test('clicking disabled items does not trigger select event', function() {
            var treeviewElement = $("#DisabledTreeView"),
                isCalled = false;
                
            try {
                treeviewElement.bind('select', function(e) { isCalled = true; });

                treeviewElement.find('.t-in.t-state-disabled').trigger('click');

                ok(!isCalled);
            } finally {
                treeviewElement.unbind('select');
            }
        });

        test('expanding load on demand nodes triggers expand event', function() {
            var treeviewElement = $("#ClientSideTreeView"),
                treeview = treeviewElement.data("tTreeView"),
                node = treeviewElement.find('.t-item:first'),
                expandTrigggered = false,
                eventContainsItem = false;
        
            try {
                treeviewElement.bind('expand', function(e) {
                    expandTrigggered = true;
                    eventContainsItem = e.item == node[0];
                });
            
                treeview.nodeToggle(null, node, true);
            
                ok(expandTrigggered, "Expand event should be fired when elements with LoadOnDemand are expanded.");
                ok(eventContainsItem, "Expand event should contain item in event data");
            } finally {
                treeviewElement.unbind('expand');
            }
        });

        test('dataBound event reports which node has been databound', function() {
            var treeview = $("#ClientSideTreeView").data("tTreeView"),
                node = $(treeview.element).find('.t-item');

            expect(1);
        
            $(treeview.element).bind("dataBound", function(e) {
                equal(e.item, node[0]);
            });

            treeview.dataBind(node, [{ Text: "Foo" }]);

            $(treeview.element).unbind("dataBound");
        });

</script>

</asp:Content>