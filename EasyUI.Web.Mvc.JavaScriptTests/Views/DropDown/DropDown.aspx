<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <input id="testInput" />

    <% Html.EasyUI().ScriptRegistrar()
           .Scripts(scripts => scripts
               .Add("easyui.common.js")
               .Add("easyui.list.js")); %>
</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">
        var dropDownObject;
        var $component;
        var position;
        var $input;
        var $t;

        module("DropDown / DropDown", {
            setup: function() {
                $t = $.easyui;
                dropDownObject = new $t.dropDown({
                    attr: 'width: 200px',
                    effects: $t.fx.toggle.defaults()
                });

                dropDownObject.dataBind([{ Text: 'text1', Value: '1' },
                                         { Text: 'text2', Value: '2' },
                                         { Text: 'text3', Value: '3'}]);

                $input = $('#testInput');

                position = {
                    offset: $input.offset(),
                    outerHeight: $input.outerHeight(),
                    outerWidth: $input.outerWidth(),
                    zIndex: $t.getElementZIndex($input[0])
                }
            }
        });

        test('dropDown should create $element with passed attributes', function() {
            
            var dropDown = new $t.dropDown({
                attr: 'style="width: 300px; overflow-y: visible"'
            });
            
            dropDown.$element.appendTo(document.body);
            equal(dropDown.$element.css('width'), '300px');
            equal(dropDown.$element.css('overflow-y'), 'visible');
        });


        test('dropDown should create $element with passed attr and preserve default classes', function() {

            var dropDown = new $t.dropDown({
                attr: 'class="bob"'
            });

            equal(dropDown.$element.attr('class'), 'bob t-popup t-group');
        });

        test('dropDown should set width property and overflow auto when open', function() {

            var position1 = {
                offset: $input.offset(),
                outerHeight: $input.outerHeight(),
                outerWidth: 200, //2 pixels are always extracted in the constructor of dropDown
                zIndex: $t.getElementZIndex($input[0])
            }

            dropDownObject.open(position1)

            equal(dropDownObject.$element.css('width'), '198px');
            equal(dropDownObject.$element.css('overflow-y'), 'auto');
        });

        test('dataBind should render null item as empty text (&nbsp)', function () {
            dropDownObject.dataBind([{ Text: 'text1', Value: '1' },
                                     null,
                                     { Text: 'text3', Value: '3'}]);

            equal(dropDownObject.$items.length, 3);
            equal(dropDownObject.$items.eq(1).html(), '&nbsp;');
        });

        test('dataBind should create empty li', function () {

            dropDownObject.dataBind([{ Text: '', Value: '1' },
                                     { Text: 'text2', Value: '2' },
                                     { Text: 'text3', Value: '3'}]);

            equal(dropDownObject.$items.eq(0).html(), '&nbsp;');
        });

        test('dataBind should create li items depending on passed data', function() {
            
            dropDownObject.dataBind([{ Text: 'text1', Value: '1' },
                                     { Text: 'text2', Value: '2' }, 
                                     { Text: 'text3', Value: '3'}]);
                                     
            equal(dropDownObject.$items.length, 3);
        });

        test('dataBind should fill list with 2 li items', function() {
            
            dropDownObject.dataBind([{ Text: 'text1', Value: '1' },
                                     { Text: 'text2', Value: '2' }]);

            equal(dropDownObject.$element.find('.t-item').length, 2);
        });

        test('dataBind should height to auto if items are less then 10', function() {

            dropDownObject.dataBind([{ Text: 'text1', Value: '1' },
                                     { Text: 'text2', Value: '2'}]);
            
            dropDownObject.$element.appendTo(document.body);

            equal(dropDownObject.$element[0].style.height, 'auto');
        });

        test('dataBind should height to 200px if items are more than 10 and dropDown does not have set height', function() {

            var dropDown = new $t.dropDown({
                outerWidth: 200
            });

            dropDown.dataBind([{ Text: 'text1', Value: '1' },
                                     { Text: 'text2', Value: '2' },
                                     { Text: 'text2', Value: '2' },
                                     { Text: 'text2', Value: '2' },
                                     { Text: 'text2', Value: '2' },
                                     { Text: 'text2', Value: '2' },
                                     { Text: 'text2', Value: '2' },
                                     { Text: 'text2', Value: '2' },
                                     { Text: 'text2', Value: '2' },
                                     { Text: 'text2', Value: '2' },
                                     { Text: 'text2', Value: '2' },
                                     { Text: 'text2', Value: '2' },
                                     { Text: 'text2', Value: '2' },
                                     { Text: 'text2', Value: '2' } ]);

            dropDown.$element.appendTo(document.body);
            equal(dropDown.$element.css('height'), '200px');
        });

        test('dataBind should set height to the one from attr', function() {

            var dropDown = new $t.dropDown({
                attr: 'style="height: 300px"'
            });

             dropDown.dataBind([{ Text: 'text1', Value: '1' },
                                { Text: 'text2', Value: '2' },
                                { Text: 'text2', Value: '2' },
                                { Text: 'text2', Value: '2' },
                                { Text: 'text2', Value: '2' },
                                { Text: 'text2', Value: '2' },
                                { Text: 'text2', Value: '2' },
                                { Text: 'text2', Value: '2' },
                                { Text: 'text2', Value: '2' },
                                { Text: 'text2', Value: '2' },
                                { Text: 'text2', Value: '2' },
                                { Text: 'text2', Value: '2' },
                                { Text: 'text2', Value: '2' },
                                { Text: 'text2', Value: '2'}]);

             dropDown.$element.appendTo(document.body);
             equal(dropDown.$element.css('height'), '300px');
        });

        test('itemCrate method should be called twice', function() {
            var count = 0;
            
            dropDownObject.onItemCreate = function () {
                count += 1;
            }

            dropDownObject.dataBind([{ Text: 'text1', Value: '1' },
                                     { Text: 'text2', Value: '2'}]);

            equal(count, 2);
        });

        test('highlight method should select second item', function() {
            
            dropDownObject.dataBind([{ Text: 'text1', Value: '1' },
                                     { Text: 'text2', Value: '2' },
                                     { Text: 'text3', Value: '3' }]);

            dropDownObject.highlight(dropDownObject.$items[1]);

            var $selected = dropDownObject.$items.filter('.t-state-selected');

            equal($selected.length, 1);
            equal($selected.first().text(), 'text2');
        });

        test('open method should call open callback', function() {
            var isCalled = false;

            dropDownObject.onOpen = function () { isCalled = true; }

            dropDownObject.open(position);

            ok(isCalled);
        });

        test('open should apply offset and outerHeight to the animation container', function () {
            var position1 = {
                offset: { top: 180, left: 100 },
                outerHeight: 20,
                outerWidth: $input.outerWidth(),
                zIndex: 10
            }

            dropDownObject.open(position1);

            var animationContainer = dropDownObject.$element.parent();

            equal(animationContainer.css('zIndex').toString(), '10')
            equal(animationContainer[0].offsetTop, 200) //outerHeight + offset.Top
            equal(animationContainer[0].offsetLeft, 100)
        });

        test('open method should call scrollTo item if there is selected item', function() {
            var isCalled = false;
            var scrollTo = dropDownObject.scrollTo;

            dropDownObject.highlight(dropDownObject.$items.last());
            dropDownObject.scrollTo = function () { isCalled = true; }
            dropDownObject.open(position);

            ok(isCalled);

            dropDownObject.scrollTo = scrollTo;
        });

        test('click item should pass clicked item to click callback', function() {
            var item;

            var dropDown = new $t.dropDown({
                offset: { left: 100, top: 100 },
                outerHeight: 100,
                outerWidth: 200,
                zIndex: 10,
                effects: $t.fx.toggle.defaults()
            });

            dropDown.dataBind([{ Text: 'text1', Value: '1' },
                               { Text: 'text2', Value: '2' },
                               { Text: 'text3', Value: '3'}]);

            dropDown.onClick = function (e) { item = e.item; }
            dropDown.open(position);

            dropDown.$items.last().trigger('click');

            equal($(item).text(), 'text3');
        });

        test('dataBind should render &amp;nbsp; if Text is white space', function () {
            var dropDown = new $t.dropDown({
                attr: 'width: 200px',
                effects: $t.fx.toggle.defaults()
            });

            dropDown.dataBind([{ Text: ' ', Value: '1' },
                               { Text: 'text2', Value: '2' },
                               { Text: 'text3', Value: '3'}]);

            equal(dropDown.$items.eq(0).html(), '&nbsp;');
        });

</script>

</asp:Content>