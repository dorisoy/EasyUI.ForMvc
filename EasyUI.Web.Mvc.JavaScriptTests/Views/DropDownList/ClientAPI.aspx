<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<%@ Import Namespace="EasyUI.Web.Mvc.JavaScriptTests" %>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        DropDown Rendering</h2>
    <script type="text/javascript">

        function getDropDownList(id) {
            return $('#' + (id || 'DropDownList')).data('tDropDownList');
        }

    </script>

    <%= Html.EasyUI().DropDownList()
            .Name("DropDownList")
            .Items(items =>
            {
                items.Add().Text("Item1").Value("1");
                items.Add().Text("Item2").Value("2");
                items.Add().Text("Item3").Value("3");
                items.Add().Text("Item4").Value("4");
                items.Add().Text("Item5").Value("5");
                items.Add().Text("Item6").Value("6");
                items.Add().Text("Item7").Value("7");
                items.Add().Text("Item8").Value("8");
                items.Add().Text("Item9").Value("9");
                items.Add().Text("Item10").Value("10");
                items.Add().Text("Item11").Value("11");
                items.Add().Text("Item12").Value("12");
                items.Add().Text("Item13").Value("13");
                items.Add().Text("Item14").Value("14");
            })
            .Effects(effects => effects.Toggle())
    %>

    <%= Html.EasyUI().DropDownList()
            .Name("DDL2")
            .Items(items =>
            {
                items.Add().Text("Item1");
                items.Add().Text("Item2").Value("2");
                items.Add().Text("Item3").Value("3");
                items.Add().Text("Item4").Value("4");
                items.Add().Text("Item5").Value("5");
                items.Add().Text("Item6").Value("6");
                items.Add().Text("Item7").Value("7");
                items.Add().Text("Item8").Value("8");
                items.Add().Text("Item9").Value("9");
                items.Add().Text("Item10").Value("10");
                items.Add().Text("Item11").Value("11");
                items.Add().Text("Item12").Value("12");
                items.Add().Text("Item13").Value("13");
                items.Add().Text("Item14").Value("14");
            })
            .Effects(effects => effects.Toggle())
    %>

    <% Html.EasyUI().ScriptRegistrar()
           .Scripts(scripts => scripts
           .Add("easyui.common.js")
           .Add("easyui.list.js")); 
    %>

    <br />
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

        test('dataBind method should preserve selectedItem depending on Selected property even selectedIndex is present', function() {
            var ddl = getDropDownList();
            var data = [{ Text: 'Item1', Value: '1', Selected: false },
                        { Text: 'Item2', Value: '2', Selected: false },
                        { Text: 'Item3', Value: '3', Selected: false },
                        { Text: 'Item4', Value: '4', Selected: false },
                        { Text: 'Item5', Value: '5', Selected: true }];
            ddl.index = 1;
            
            ddl.dataBind(data);

            equal(ddl.index, 4);
        });

        test('dataBind method should preserve selectedItem depending on Selected property even selectedIndex is present', function () {
            var ddl = getDropDownList();
            var data = [{ Text: 'Item1', Value: '1', Selected: false },
                        { Text: 'Item2', Value: '2', Selected: false },
                        { Text: 'Item3', Value: '3', Selected: true  },
                        { Text: 'Item4', Value: '4', Selected: false },
                        { Text: 'Item5', Value: '5', Selected: false }];
            
            ddl.index = 1;

            ddl.dataBind(data);

            equal(ddl.index, 2);
            ok(ddl.dropDown.$items.eq(2).hasClass("t-state-selected"));
        });

        test('dataBind method should override selectedIndex there is no Selected true', function() {
            var ddl = getDropDownList();
            var data = [{ Text: 'Item1', Value: '1', Selected: false },
                        { Text: 'Item2', Value: '2', Selected: false },
                        { Text: 'Item3', Value: '3', Selected: false },
                        { Text: 'Item4', Value: '4', Selected: false },
                        { Text: 'Item5', Value: '5', Selected: false}];

            ddl.index = 1;

            ddl.dataBind(data);

            equal(ddl.index, 1);
        });

        test('dataBind method should override selectedIndex there is no Selected defined', function() {
            var ddl = getDropDownList();
            var data = [{ Text: 'Item1', Value: '1' },
                        { Text: 'Item2', Value: '2' },
                        { Text: 'Item3', Value: '3' },
                        { Text: 'Item4', Value: '4' },
                        { Text: 'Item5', Value: '5' }];

            ddl.index = 2;

            ddl.dataBind(data);

            equal(ddl.index, 2);
        });

        test('dataBind method should clear current component status', function() {
            var ddl = getDropDownList();
            var data = [{ Text: 'Item1', Value: '1', Selected: false },
                        { Text: 'Item2', Value: '2', Selected: false },
                        { Text: 'Item3', Value: '3', Selected: true },
                        { Text: 'Item4', Value: '4', Selected: false },
                        { Text: 'Item5', Value: '5', Selected: false}];

            ddl.select(1);
            
            ddl.dataBind(data);

            equal(ddl.text(), '&nbsp;');
            equal(ddl.value(), '');
        });

        test('dataBind method can preserve component status', function() {
            var ddl = getDropDownList();
            var data = [{ Text: 'Item1', Value: '1', Selected: false },
                        { Text: 'Item2', Value: '2', Selected: false },
                        { Text: 'Item3', Value: '3', Selected: false },
                        { Text: 'Item4', Value: '4', Selected: false },
                        { Text: 'Item5', Value: '5', Selected: false}];

            ddl.select(1);

            ddl.dataBind(data, true /*should preserve status*/);

            equal(ddl.text(), 'Item2');
            equal(ddl.value(), '2');
        });

        test('fill method should select third item even when selectedIndex is different', function () {
            var ddl = getDropDownList();
            ddl.data = [{ Text: 'Item1', Value: '1', Selected: false },
                        { Text: 'Item2', Value: '2', Selected: false },
                        { Text: 'Item3', Value: '3', Selected: true },
                        { Text: 'Item4', Value: '4', Selected: false },
                        { Text: 'Item5', Value: '5', Selected: false}];

            ddl.index = 1;
            ddl.dropDown.$items = null;
            ddl.fill();

            equal(ddl.index, 2);
            ok(ddl.dropDown.$items.eq(2).hasClass('t-state-selected'), 'item is not selected');
        });

        test('fill method should select second item if value update selected index', function () {
            var ddl = getDropDownList();
            ddl.data = [{ Text: 'Item1', Value: '1', Selected: false },
                        { Text: 'Item2', Value: '2', Selected: false },
                        { Text: 'Item3', Value: '3', Selected: false },
                        { Text: 'Item4', Value: '4', Selected: false },
                        { Text: 'Item5', Value: '5', Selected: false}];

            ddl.index = 4;
            ddl.selectedValue = "2";
            ddl.dropDown.$items = null;
            ddl.fill();

            equal(ddl.selectedIndex, 1);
            ok(ddl.dropDown.$items.eq(1).hasClass('t-state-selected'), 'item is selected');
        });

        test('value method should select item depending on its value', function() {
            var ddl = getDropDownList('DDL2');
            
            ddl.value('2');
            
            equal(ddl.text(), ddl.dropDown.$items.eq(1).text())
            equal(ddl.value(), ddl.data[1].Value)
        });

        test('value method should select item depending on its text if item value is not set', function() {
            var ddl = getDropDownList('DDL2');

            ddl.value('Item1');

            equal(ddl.data[0].Value, null)
            equal(ddl.text(), ddl.data[0].Text)
            equal(ddl.value(), ddl.data[0].Text)
        });

        test('value method should not select item if no such text or value', function() {
            var ddl = getDropDownList('DDL2');

            ddl.value('3');

            ddl.value('Illegal');

            equal(ddl.text(), ddl.data[2].Text)
            equal(ddl.value(), ddl.data[2].Value)
        });

        test('disable method should disable dropDownList', function() {
            var ddl = getDropDownList('DDL2');

            ddl.enable();
            ddl.disable();
            
            ok(ddl.$wrapper.hasClass('t-state-disabled'));
            equal(ddl.$element.attr('disabled'), 'disabled');
        });

        test('enable method should enable dropDownList', function () {
            var ddl = getDropDownList('DDL2');
            
            ddl.disable();
            ddl.enable();

            ok(!ddl.$wrapper.hasClass('t-state-disabled'));
            ok(!ddl.$element.attr('disabled'));
        });

        test('text method should set &nbsp; if text is empty string', function () {
            var ddl = getDropDownList('DDL2');

            ddl.text("");

            equal(ddl.text(), "&nbsp;")
        });

        test('text method should set &nbsp; if text is white space', function () {
            var ddl = getDropDownList('DDL2');
            
            ddl.text(" ");

            equal(ddl.text(), "&nbsp;")
        });

        test('select method should return selected index', function () {
            var ddl = getDropDownList();
            var index = ddl.select(1);
            equal(index, ddl.selectedIndex);
        });

        test('value method should update correctly previousValue', function () {
            var ddl = getDropDownList();
            var data = [{ Text: 'Item1', Value: '1', Selected: false },
                        { Text: 'Item2', Value: '2', Selected: false },
                        { Text: 'Item3', Value: '3', Selected: false },
                        { Text: 'Item4', Value: '4', Selected: false },
                        { Text: 'Item5', Value: '5', Selected: false}];

            ddl.dataBind(data);

            ddl.value("Item3");

            equal(ddl.previousValue, "3");
        });

</script>

</asp:Content>