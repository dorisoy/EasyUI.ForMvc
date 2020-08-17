<%@ Page Title="Load on Demand tests" Language="C#" MasterPageFile="~/Views/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <%= Html.EasyUI().TreeView()
            .Name("myTreeView_clientBound")
            .DragAndDrop(true)
            .ClientEvents(evt => evt
                .OnDataBinding("onDataBinding")
            )
            .Effects(fx => fx.Toggle()) %>

    <%= Html.EasyUI().TreeView()
            .Name("myTreeView")
            .Items(treeview =>
            {
                treeview.Add().Text("Item 1")
                    .Items(item1 => {
                        item1.Add().Text("Item 1.1");
                    })
                    .Value("1")
                    .LoadOnDemand(true)
                    .Expanded(false)
                    .Url("url");
                
                treeview.Add().Text("Item 2")
                    .Value("2")
                    .LoadOnDemand(true)
                    .Expanded(false);

                treeview.Add().Text("Item 3")
                    .Value("3")
                    .LoadOnDemand(true)
                    .Expanded(false);
                
                treeview.Add().Text("Item 4")
                    .Value("4")
                    .LoadOnDemand(true)
                    .Expanded(false);

                treeview.Add().Text("Item 5")
                    .Value("5")
                    .LoadOnDemand(true)
                    .Expanded(false);
            }
            )
            .DataBinding(settings => settings.Ajax().Select("LoadOnDemand", "TreeView"))
            .Effects(fx => fx.Toggle()) %>

    <%= Html.EasyUI().TreeView()
            .Name("myTreeView_ajaxRequest")
            .DataBinding(settings => settings.Ajax().Select("LoadOnDemand", "TreeView"))
            .Items(treeview =>
            {
                treeview.Add().Text("Item X")
                    .Value("5")
                    .LoadOnDemand(true)
                    .Expanded(false);
            }
            )
            .Effects(fx => fx.Toggle()) %>

    <script type="text/javascript">
        //<![CDATA[
        
        function getTreeView(selector) {
            return $(selector || "#myTreeView").data("tTreeView");
        }

        function onDataBinding(e) {
            var treeview = getTreeView("#myTreeView_clientBound");

            if (e.item != treeview.element) {
                treeview.dataBind(e.item, [{ Text: "Abyss Node", LoadOnDemand: true, Value: "abyss" }]);
            }
        }
        
        //]]>

    </script>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">

        var treeView;

        function findItemByText(text) {
            return $('.t-in:contains(' + text + ')').closest('.t-item');
        }

        module("TreeView / LoadOnDemand", {
            setup: function() {
                treeView = getTreeView();
            }
        });
        
        test('opening ajaxified nodes with server side rendered children does not trigger ajax request', function() {
            var oldAjaxRequest = treeView.ajaxRequest;
            try {
                var called = false;

                treeView.ajaxRequest = function() { called = true; }

                treeView.expand('.t-item:eq(0)');
                
                ok(!called);
            } finally {
                treeView.ajaxRequest = oldAjaxRequest;
            }
        });
        
        test('opening ajaxified nodes with dynamic children triggers ajax request', function() {
            var oldAjaxRequest = treeView.ajaxRequest;
            try {
                var called = false;

                treeView.ajaxRequest = function() { called = true; }

                var item = $('.t-item:contains(Item 2)');

                item.append('<ul style="display: none;" class="t-group"><li class="t-item t-last"><div class="t-top t-bot"><span class="t-in">Item 2.1</span></div></li></ul>')

                treeView.nodeToggle(null, item, true);
                
                ok(called);
            } finally {
                treeView.ajaxRequest = oldAjaxRequest;
            }
        });
        
        test('opening ajaxified nodes with dynamic children inserts requested children at top', function() {
            var oldAjaxRequest = treeView.ajaxRequest;
            try {
                treeView.ajaxRequest = function($item) { treeView.dataBind($item, [{ Text: 'NewNode' }]); }

                var item = $('.t-item:contains(Item 3)');

                item.append('<ul style="display: none;" class="t-group"><li class="t-item t-last"><div class="t-top t-bot"><span class="t-in">Item 3.1</span></div></li></ul>')

                treeView.nodeToggle(null, item, true);

                equal(item.find('> .t-group').length, 1);
                equal(item.find('> .t-group').children().length, 2);
                equal(item.find('> .t-group .t-item:first > div').text(), 'NewNode');
            } finally {
                treeView.ajaxRequest = oldAjaxRequest;
            }
        });
                
        test('expanding ajaxified nodes appends group', function() {
            var oldAjaxRequest = treeView.ajaxRequest;
            try {
                treeView.ajaxRequest = function($item) { treeView.dataBind($item, [{ Text: 'NewNode' }]); }

                var item = $('.t-item:contains(Item 4)');

                treeView.nodeToggle(null, item, true);

                equal(item.find('> .t-group').length, 1);
                equal(item.find('> .t-group').children().length, 1);
                equal(item.find('> .t-group .t-item:first > div').text(), 'NewNode');
            } finally {
                treeView.ajaxRequest = oldAjaxRequest;
            }
        });
                
        test('collapsing expanded ajaxified nodes hides group', function() {
            var oldAjaxRequest = treeView.ajaxRequest;
            try {
                treeView.ajaxRequest = function($item) { treeView.dataBind($item, [{ Text: 'NewNode' }]); }

                var item = $('.t-item:contains(Item 5)');

                treeView.nodeToggle(null, item, true);

                treeView.nodeToggle(null, item, true);

                equal(item.find('> .t-group').is(':visible'), false);
            } finally {
                treeView.ajaxRequest = oldAjaxRequest;
            }
        });
                
        test('ajaxRequest rebinds treeview', function() {
            var treeview = getTreeView('#myTreeView_ajaxRequest');

            var $root = $(treeview.element);
            
            treeview.dataBind($root, [{ Text: 'NewNode' }]);
            treeview.dataBind($root, [{ Text: 'NewNode' }]);

            var group = $root.find('> .t-group');

            equal(group.children().length, 1);
            equal(group.is(':visible'), true);
            equal($root.children().length, 1);
        });

        asyncTest('ajaxRequest() clears animation flag', function() {
            var treeview = getTreeView('#myTreeView_ajaxRequest');

            var $root = $(treeview.element);
            
            treeview.dataBind($root, [{ Text: 'Foo', LoadOnDemand: true }]);

            var item = $('.t-item', treeview.element);

            $.mockjax({
                url: '<%= Url.Action("LoadOnDemand", "TreeView") %>',
                contentType: "text/json",
                responseTime: 100,
                responseText: "[{ Text: 'Bar' }]"
            });

            var counter = 0;

            $root.bind("ajaxComplete", function() {
                if (++counter == 2) {
                    // not clearing the animating flag will disable the node toggle...
                    item.find(".t-minus").trigger("click");
                    start();
                    equal(item.find(".t-plus").length, 1);
                }
            });

            treeview.ajaxRequest(item);
            treeview.ajaxRequest(item);
        });


        test('treeView ajaxBinding set item url', function() {
            equal($('.t-item a').attr('href'), "url");
        });

        test('opening lod nodes sets child loaded flags', function() {
            var treeview = getTreeView("#myTreeView_clientBound");

            treeview.bindTo([
                { Text: "Product 1", Expanded: false, LoadOnDemand: true, Value: "abyss" }
            ]);

            findItemByText('Product 1').find('> div > .t-plus').trigger('click');

            ok(!findItemByText('Abyss Node').data('loaded'));
        });

        test('ajaxRequest allows sending of custom data', function() {
            var treeview = getTreeView("#myTreeView_clientBound");

            var dataBindingHandler = function(e) {
                e.data = { foo: 'bar' };
            }

            var oldAjaxOptions = treeview.ajaxOptions;

            try {
                var data;

                treeview.ajax = true;
                treeview.ajaxOptions = function(item, options) {
                    data = options.data;
                }

                $(treeview.element).bind('dataBinding', dataBindingHandler);

                treeview.ajaxRequest();

                equal(data.foo, 'bar');

            } finally {
                treeview.ajax = false;
                treeview.ajaxOptions = oldAjaxOptions;
                $(treeview.element).unbind('dataBinding', dataBindingHandler);
            }
        });

    </script>

</asp:Content>