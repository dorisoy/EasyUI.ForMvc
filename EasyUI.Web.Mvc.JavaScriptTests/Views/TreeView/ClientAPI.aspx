<%@ Page Title="CollapseDelay Tests" Language="C#" MasterPageFile="~/Views/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <%= Html.EasyUI().TreeView()
            .Name("ClientSideTreeView")
            .ShowCheckBox(true)
            .Effects(fx => fx.Toggle()) %>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

        var treeview;

        module("TreeView / ClientAPI", {
            setup: function() {
                treeview = $('#ClientSideTreeView').data('tTreeView');
            }
        });

        test('disable disables checkboxes', function() {
            treeview.bindTo([
                { Text: 'foo' }
            ]);

            treeview.disable('.t-item');

            ok($(':checkbox', treeview.element).is('[disabled]'));
        });

        test('enable enables checkboxes', function() {
            treeview.bindTo([
                { Text: 'foo', Enabled: false }
            ]);

            treeview.enable('.t-item');

            ok($(':checkbox', treeview.element).is(':not([disabled])'));
        });

        test('disable disables expand collapse icon', function() {
            treeview.bindTo([
                {
                    Text: 'foo', Expanded: false,
                    Items: [{ Text: 'bar' }]
                }
            ]);

            treeview.disable('.t-item');

            ok($('.t-item:first > div > .t-icon').hasClass('t-plus-disabled'));
            ok(!($('.t-item:first > div > .t-icon').hasClass('t-plus')));
        });

        test('enable enables expand collapse icon', function() {
            treeview.bindTo([
                {
                    Text: 'foo', Expanded: false, Enabled: false,
                    Items: [{ Text: 'bar' }]
                }
            ]);

            treeview.enable('.t-item');

            ok($('.t-item:first > div > .t-icon').hasClass('t-plus'));
            ok(!($('.t-item:first > div > .t-icon').hasClass('t-plus-disabled')));
        });

        test('checking node should set value of the checkbox input to true', function () {
            treeview.bindTo([
                { Text: 'foo' }
            ]);
            
            var checkbox = $(':checkbox', treeview.element);
            var item = checkbox.closest('.t-item');
            treeview.nodeCheck(item[0], true);

            equal(checkbox.attr('checked'), 'checked', 'value of the checkbox was not updated');
        });

        test('unchecking node should set value of the checkbox input to false', function () {
            treeview.bindTo([
                { Text: 'foo', Checked: true }
            ]);
            
            var checkbox = $(':checkbox', treeview.element);
            var item = checkbox.closest('.t-item');
            treeview.nodeCheck(item[0], false);

            ok(!checkbox.attr('checked'), 'value of the checkbox was not updated');
        });

        test('dynamically adding subnodes with checkboxes generates valid checkbox ids', function() {
            treeview.bindTo([
                { Text: 'foo', Checkable: false },
                { Text: 'bar', Checkable: false, Expanded: true, Items: [
                    { Text: 'baz', Checkable: false }
                ] }
            ]);
                
            treeview.dataBind($('.t-item:first', treeview.element), [{ Text: 'qux' }]);
            treeview.dataBind($('.t-item:last', treeview.element), [{ Text: 'qux' }]);

            var checkboxes = $(":checkbox");

            equal(checkboxes.eq(0).attr('name'), 'ClientSideTreeView_checkedNodes[0:0].Checked');
            equal(checkboxes.eq(1).attr('name'), 'ClientSideTreeView_checkedNodes[1:0:0].Checked');
        });

        test('nodeCheck() on non-visible items does not delete checkboxes', function() {
            treeview.bindTo([
                { Text: 'foo', Expanded: false, Items: [
                    { Text: 'bar', Checked: true }
                ] }
            ]);

            treeview.nodeCheck($('.t-item:last', treeview.element), false);

            equal($(":checkbox").length, 2);
        });

        test('bindTo() clears items, if necessary', function() {
            treeview.bindTo([]);

            equal($(treeview.element).find(".t-item").length, 0);
        });

        test('dataBind() removes subgroups', function() {
            treeview.bindTo([
                { Text: 'foo', Expanded: false, Items: [
                    { Text: 'bar', Checked: true }
                ] }
            ]);

            treeview.dataBind($(treeview.element).find(".t-item"), []);

            equal($(treeview.element).find(".t-item .t-group").length, 0);
        });

        test('dataBind() shows icon, if necessary', function() {
            treeview.bindTo([
                { Text: 'foo', Expanded: false }
            ]);

            treeview.dataBind($(treeview.element).find(".t-item"), [{ Text: 'bar', Checked: true }]);

            var rootItemIcon = $(treeview.element).find("> ul > li > div > .t-icon");

            equal($(treeview.element).find(".t-item .t-group").length, 1);
            equal(rootItemIcon.length, 1);
            ok(rootItemIcon.hasClass("t-minus"));
        });

        test('findByText() finds single item', function() {
            treeview.bindTo([
                { Text: 'foo' },
                { Text: 'bar' },
                { Text: 'baz' }
            ]);

            var result = treeview.findByText('foo'),
                items = $(treeview.element).find(".t-item");

            equal(result.length, 1);
            equal(result[0], items[0]);
        });

        test('findByText() does not search in substrings', function() {
            treeview.bindTo([
                { Text: 'foo' },
                { Text: 'bar' },
                { Text: 'baz' }
            ]);
            
            ok(!treeview.findByText('fo').length);
        });

        test('findByText() returns multiple items', function() {
            treeview.bindTo([
                { Text: 'foo' },
                { Text: 'bar' },
                { Text: 'foo' }
            ]);

            var result = treeview.findByText('foo'),
                items = $(treeview.element).find(".t-item");
            
            equals(result.length, 2);
            equals(result[0], items[0]);
            equals(result[1], items[2]);
        });

        test('findByValue() finds single item', function() {
            treeview.bindTo([
                { Text: 'foo', Value: 1 },
                { Text: 'bar', Value: 2 },
                { Text: 'baz', Value: 3 }
            ]);

            var result = treeview.findByValue(2),
                items = $(treeview.element).find(".t-item");

            equal(result.length, 1);
            equal(result[0], items[1]);
        });

        test('findByValue() returns multiple items', function() {
            treeview.bindTo([
                { Text: 'foo', Value: 1 },
                { Text: 'bar', Value: 2 },
                { Text: 'baz', Value: 1 }
            ]);

            var result = treeview.findByValue(1),
                items = $(treeview.element).find(".t-item");
            
            equals(result.length, 2);
            equals(result[0], items[0]);
            equals(result[1], items[2]);
        });

</script>

</asp:Content>