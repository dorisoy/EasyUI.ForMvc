<%@ Page Title="TreeView / ClientSideRendering" Language="C#" MasterPageFile="~/Views/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <% Html.EasyUI().ScriptRegistrar()
                        .DefaultGroup(group => group
                            .Add("easyui.common.js")
                            .Add("easyui.treeview.js"));

    %>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

        var treeviewStatic;

        module("TreeView / ClientSideRendering", {
            setup: function() {
                treeviewStatic = $.easyui.treeview;
            }
        });

//        $t.treeview.getGroupHtml({
//            data: data,
//            html: groupHtml,
//            isAjax: this.isAjax(),
//            isFirstLevel: $item.hasClass('t-treeview'),
//            showCheckBoxes: this.showCheckBox,
//            groupLevel: $index.val(),
//            isExpanded: isExpanded,
//            renderGroup: isGroup,
//            elementId: this.element.id
//        });

        test('getGroupHtml with no data renders empty group', function() {
            var html = new $.easyui.stringBuilder();

            treeviewStatic.getGroupHtml({
                data: [],
                html: html,
                isAjax: null,
                isFirstLevel: false,
                showCheckBoxes: false,
                isExpanded: true
            });

            equal(html.string(), '<ul class="t-group"></ul>');
        });

        test('getGroupHtml for first level renders lines class', function() {
            var html = new $.easyui.stringBuilder();

            treeviewStatic.getGroupHtml({ 
                data: [],
                html: html,
                isAjax: null,
                isFirstLevel: true,
                showCheckBoxes: false,
                isExpanded: true
            });

            equal(html.string(), '<ul class="t-group t-treeview-lines"></ul>');
        });

        test('getGroupHtml should render hidden group if it is not expanded', function() {
            var html = new $.easyui.stringBuilder();

            treeviewStatic.getGroupHtml({
                data: [],
                html: html,
                isAjax: null,
                isFirstLevel: false,
                showCheckBoxes: false,
                isExpanded: false
            });

            equal(html.string(), '<ul class="t-group" style="display:none"></ul>');
        });

        test('getGroupHtml calls getItemHtml when data is available', function() {
            var oldGetItemHtml = treeviewStatic.getItemHtml;

            try {
                var html = new $.easyui.stringBuilder();

                var called = false;

                treeviewStatic.getItemHtml = function() { called = true; }

                treeviewStatic.getGroupHtml({
                    data: ["1"],
                    html: html,
                    isAjax: null,
                    isFirstLevel: false
                });

                ok(called);

            } finally {
                treeviewStatic.getItemHtml = oldGetItemHtml;
            }
        });

        test('getGroupHtml calls getItemHtml for each data item', function() {
            var oldGetItemHtml = treeviewStatic.getItemHtml;
            
            try {
                var html = new $.easyui.stringBuilder();

                var calls = 0;

                treeviewStatic.getItemHtml = function() { calls++; }
                
                treeviewStatic.getGroupHtml({
                    data: [{}, {}, {}],
                    html: html,
                    isAjax: null,
                    isFirstLevel: true
                });

                equal(calls, 3);

            } finally {
                treeviewStatic.getItemHtml = oldGetItemHtml;
            }
        });

//        $t.treeview.getItemHtml({
//            item: data[i],
//            html: html,
//            isAjax: options.isAjax,
//            isFirstLevel: isFirstLevel,
//            showCheckBoxes: options.showCheckBoxes,
//            groupLevel: options.groupLevel,
//            itemIndex: options.i,
//            itemsCount: options.len,
//            elementId: options.elementId
//        });

        test('getItemHtml renders simple items', function() {
            var html = new $.easyui.stringBuilder();

            treeviewStatic.getItemHtml({
                item: { Text: "text" },
                html: html,
                isAjax: false,
                isFirstLevel: false,
                showCheckBoxes: false,
                itemIndex: 0,
                itemsCount: 1
            });

            equal(html.string(), '<li class="t-item t-last"><div class="t-bot"><span class="t-in">text</span></div></li>');
        });

        test('getItemHtml renders links for items with NavigateUrl', function() {
            var html = new $.easyui.stringBuilder();

            treeviewStatic.getItemHtml({
                item: {
                    Text: "text",
                    NavigateUrl: "http://google.com/"
                },
                html: html,
                isAjax: false,
                isFirstLevel: false,
                showCheckBoxes: false,
                itemIndex: 0,
                itemsCount: 1
            });

            equal(html.string(), '<li class="t-item t-last"><div class="t-bot"><a href="http://google.com/" class="t-link t-in">text</a></div></li>');
        });

        test('getItemHtml renders disabled state on disabled items', function() {
            var html = new $.easyui.stringBuilder();

            treeviewStatic.getItemHtml({
                item: {
                    Text: "text",
                    Enabled: false
                },
                html: html,
                isAjax: false,
                isFirstLevel: false,
                showCheckBoxes: false,
                itemIndex: 0,
                itemsCount: 1
            });

            equal(html.string(), '<li class="t-item t-last"><div class="t-bot"><span class="t-in t-state-disabled">text</span></div></li>');
        });

        test('getItemHtml renders selected state on selected items', function() {
            var html = new $.easyui.stringBuilder();

            treeviewStatic.getItemHtml({
                item: {
                    Text: "text",
                    Selected: true
                },
                html: html,
                isAjax: false,
                isFirstLevel: false,
                showCheckBoxes: false,
                itemIndex: 0,
                itemsCount: 1
            });

            equal(html.string(), '<li class="t-item t-last"><div class="t-bot"><span class="t-in t-state-selected">text</span></div></li>');
        });

        test('getItemHtml renders collapsed items by default', function() {
            var html = new $.easyui.stringBuilder();

            treeviewStatic.getItemHtml({
                item: {
                    Text: "Collapsed",
                    Items: [
                        { Text: "Should not be visible" }
                    ]
                },
                html: html,
                isAjax: false,
                isFirstLevel: false,
                showCheckBoxes: false,
                itemIndex: 0,
                itemsCount: 1
            });
            

            equal(
'<li class="t-item t-last">\
<div class="t-bot">\
<span class="t-icon t-plus"></span><span class="t-in">Collapsed</span>\
</div>\
<ul class="t-group" style="display:none">\
<li class="t-item t-last"><div class="t-bot"><span class="t-in">Should not be visible</span></div></li>\
</ul>\
</li>', html.string());
        });

        test('getItemHtml should render span wrapper for the checkNodes', function() {
            var html = new $.easyui.stringBuilder();
            
            treeviewStatic.getItemHtml({
                item: {
                    Text: "text",
                    Checkable: true
                },
                html: html,
                isAjax: false,
                isFirstLevel: false,
                showCheckBoxes: true,
                itemIndex: 0,
                itemsCount: 1
            });

            var $item = $(html.string());

            equal($item.find('> div > .t-checkbox').length, 1, 'Does not render checkbox group wrapper');
        });

        test('getItemHtml should render checkbox and hidden input', function() {
            var html = new $.easyui.stringBuilder();

            treeviewStatic.getItemHtml({
                item: {
                    Text: "text",
                    Checkable: true
                },
                html: html,
                isAjax: false,
                isFirstLevel: false,
                showCheckBoxes: true,
                itemIndex: 0,
                itemsCount: 1
            });

            var $item = $(html.string());

            equal($item.find('.t-input[type="hidden"]').length, 1);
            equal($item.find('.t-input[type="checkbox"]').length, 1);
        });

        test('getItemHtml should render hidden input with name attr in checkbox wrapper', function() {
            var html = new $.easyui.stringBuilder();

            treeviewStatic.getItemHtml({
                item: {
                    Text: "text",
                    Checkable: true
                },
                html: html,
                isAjax: false,
                isFirstLevel: false,
                showCheckBoxes: true,
                itemIndex: 0,
                itemsCount: 1,
                elementId: "TreeView1"
            });

            var $item = $(html.string());

            equal($item.find('.t-input[type="hidden"]').attr('name'), "TreeView1_checkedNodes.Index");
        });

        test('getItemHtml should render hidden input in checkbox wrapper with value 0 if it is first level', function() {
            var html = new $.easyui.stringBuilder();
            
            treeviewStatic.getItemHtml({
                item: {
                    Text: "text",
                    Checkable: true
                },
                html: html,
                isAjax: false,
                isFirstLevel: false,
                showCheckBoxes: true,
                itemIndex: 0,
                itemsCount: 1,
                elementId: "TreeView1",
                groupLevel: ""
            });

            var $item = $(html.string());

            equal($item.find('.t-input[type="hidden"]').attr('value'), "0");
        });

        test('getItemHtml should render hidden input in checkbox wrapper with value created by group level', function() {
            var html = new $.easyui.stringBuilder();

            treeviewStatic.getItemHtml({
                item: {
                    Text: "text",
                    Checkable: true
                },
                html: html,
                isAjax: false,
                isFirstLevel: false,
                showCheckBoxes: true,
                itemIndex: 2,
                itemsCount: 3,
                elementId: "TreeView1",
                groupLevel: "1:0"
            });

            var $item = $(html.string());

            equal($item.find('.t-input[type="hidden"]').attr('value'), "1:0:2");
        });

        test('getItemHtml should render checkbox input with name attr', function() {
            var html = new $.easyui.stringBuilder();

            treeviewStatic.getItemHtml({
                item: {
                    Text: "text",
                    Checkable: true
                },
                html: html,
                isAjax: false,
                isFirstLevel: false,
                showCheckBoxes: true,
                itemIndex: 0,
                itemsCount: 1,
                elementId: "TreeView1",
                groupLevel: "0"
            });

            var $item = $(html.string());

            equal($item.find('.t-input[type="checkbox"]').attr('name'), "TreeView1_checkedNodes[0:0].Checked");
        });

        test('getItemHtml should render checkbox input with value true if item is checked', function() {
            var html = new $.easyui.stringBuilder();

            treeviewStatic.getItemHtml({
                item: {
                    Text: "text",
                    Checkable: true,
                    Checked: true
                },
                html: html,
                isAjax: false,
                isFirstLevel: false,
                showCheckBoxes: true,
                itemIndex: 0,
                itemsCount: 1,
                elementId: "TreeView1",
                groupLevel: "0"
            });

            var $item = $(html.string());

            equal($item.find('.t-input[type="checkbox"]').attr('value'), "True");
        });

        test('getItemHtml should render disabled checkbox with disabled state class', function() {
            var html = new $.easyui.stringBuilder();

            treeviewStatic.getItemHtml({
                item: {
                    Text: "text",
                    Checkable: true,
                    Checked: true,
                    Enabled: false
                },
                html: html,
                isAjax: false,
                isFirstLevel: false,
                showCheckBoxes: true,
                itemIndex: 0,
                itemsCount: 1,
                elementId: "TreeView1",
                groupLevel: "0"
            });

            var $item = $(html.string());

            equal($item.find('.t-input[type="checkbox"]').attr('disabled'), 'disabled');
        });

        test('getItemHtml should render checked checkbox Checked property is true', function() {
            var html = new $.easyui.stringBuilder();

            treeviewStatic.getItemHtml({
                item: {
                    Text: "text",
                    Checkable: true,
                    Checked: true
                },
                html: html,
                isAjax: false,
                isFirstLevel: false,
                showCheckBoxes: true,
                itemIndex: 0,
                itemsCount: 1,
                elementId: "TreeView1",
                groupLevel: "0"
            });

            var $item = $(html.string());

            equal($item.find('[type=checkbox]').attr('checked'), 'checked');
        });

        test('getItemHtml should render hidden inputs containing dataItem values if item is checked', function() {
            var html = new $.easyui.stringBuilder();

            treeviewStatic.getItemHtml({
                item: {
                    Text: "text",
                    Value: "1",
                    Checkable: true,
                    Checked: true
                },
                html: html,
                isAjax: false,
                isFirstLevel: false,
                showCheckBoxes: true,
                itemIndex: 0,
                itemsCount: 1,
                elementId: "TreeView1",
                groupLevel: "0"
            });

            var $item = $(html.string());

            equal($item.find('[type=hidden]').eq(1).val(), "1");
            equal($item.find('[type=hidden]').eq(2).val(), "text");
        });

        test('getItemHtml should render SpriteCssClasses', function() {
            var html = new $.easyui.stringBuilder();

            treeviewStatic.getItemHtml({
                item: {
                    Text: "text",
                    SpriteCssClasses: "cssClass1"
                },
                html: html,
                isAjax: false,
                isFirstLevel: false,
                showCheckBoxes: true,
                itemIndex: 0,
                itemsCount: 1,
                elementId: "TreeView1",
                groupLevel: "0"
            });

            var $item = $(html.string());

            equal($item.find('.t-sprite').length, 1);
            ok($item.find('.t-sprite').hasClass('cssClass1'));
        });

</script>

</asp:Content>