<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <% Html.EasyUI().ScriptRegistrar().DefaultGroup(g => g.Add("easyui.common.js")); %>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="TestContent" runat="server">
    <script type="text/javascript">
        var q;
        
        module("Core/Linq", {
            setup: function () {
                q = $.easyui.query;
            }
        });

        test("toArray returns the data", function () {
            var data = [];
            
            same(q(data).toArray(), data);
        });

        test("where returns the items that satisfy the predicate", function () {
            var result = q(["foo"]).where(function () {
                return true;
            }).toArray();

            equal(result[0], "foo");
            equal(result.length, 1);
        });

        test("where skips the items that do not satisfy the predicate", function () {
            var result = q(["foo"]).where(function () {
                return false;
            }).toArray();

            equal(result.length, 0);
        });

        test("select transforms the source items", function () {
            var result = q(["foo"]).select(function (value) {
                return {
                    bar: value
                }
            }).toArray();

            equal(result.length, 1);
            equal(result[0].bar, "foo");
        });

        test("where passes the current item to the predicate", function () {
            var value;

            q(["foo"]).where(function (item) {
                value = item;
            });

            equal(value, "foo");
        });

        test("where passes the current index to the predicate", function () {
            var value;

            q(["foo"]).where(function (item, index) {
                value = index;
            });

            equal(value, 0);
        });

        test("where passes the array to the predicate", function () {
            var value, data = ["foo"];

            q(data).where(function (item, index, array) {
                value = array;
            });

            same(value, data);
        });

        test("init returns new q object", function () {
            var first = q([]);
            var second = q([]);

            ok(first !== second);
        });

        test("select passes the current item to the callback", function () {
            var value;

            q(["foo"]).select(function (item) {
                value = item;

                return item;
            });

            equal(value, "foo");
        });

        test("select passes the current index to the callback", function () {
            var value;

            q(["foo"]).select(function (item, index) {
                value = index;

                return item;
            });

            equal(value, 0);
        });

        test("select passes the array to the callback", function () {
            var value, data = ["foo"];

            q(data).select(function (item, index, array) {
                value = array;

                return item;
            });

            same(value, data);
        });

        /*                
        test("select skips undefined indices", function() {
        var count = 0, data = ["foo", "bar", "baz"];
                  
        delete data[1];
                  
        q(data).select(function(item, index, array) { 
        count++;
                    
        return item;
        });
                  
        equal(count, 2);
        });
        */
        test("select does not skip undefined items", function () {
            var count = 0, data = ["foo", undefined, "baz"];

            q(data).select(function (item, index, array) {
                count++;

                return item;
            });

            equal(count, 3);
        });

        test("where does not skip undefined items", function () {
            var count = 0, data = ["foo", undefined, "baz"];

            q(data).where(function (item, index, array) {
                count++;
            });

            equal(count, 3);
        });

        test("skip returns new array starting after the specified index", function () {
            var data = ["foo", "bar", "baz"];

            var result = q(data).skip(1).toArray();

            equal(result.length, 2);
            equal(result[0], "bar");
        });

        test("skip does not modify original array", function () {
            var data = ["foo", "bar", "baz"];

            q(data).skip(1);

            equal(data.length, 3);
        });

        test("take returns specified number of items starting from the beginning", function () {
            var data = ["foo", "bar", "baz"];

            var result = q(data).take(2).toArray();

            equal(result.length, 2);
            equal(result[0], "foo");
            equal(result[1], "bar");
        });

        test("take does not modify original array", function () {
            var data = ["foo", "bar", "baz"];

            q(data).take(1);

            equal(data.length, 3);
        });

        test("orderBy sorts numbers in ascending order", function () {
            var data = [100, 10, 1];

            var result = q(data).orderBy(function (item) {
                return item;
            }).toArray();

            equal(result.length, 3);
            equal(result[0], 1);
            equal(result[1], 10);
            equal(result[2], 100);
        });

        test("orderBy sorts strings in ascending order", function () {
            var data = ["foo", "bar", "baz"];

            var result = q(data).orderBy(function (item) {
                return item;
            }).toArray();

            equal(result.length, 3);
            equal(result[0], "bar");
            equal(result[1], "baz");
            equal(result[2], "foo");
        });

        test("orderBy sorts dates in ascending order", function () {
            var data = [new Date(2011, 1, 1), new Date(2008, 1, 1), new Date(2009, 1, 1)];

            var result = q(data).orderBy(function (item) {
                return item;
            }).toArray();

            equal(result.length, 3);
            equal(result[0].getFullYear(), 2008);
            equal(result[1].getFullYear(), 2009);
            equal(result[2].getFullYear(), 2011);
        });

        test("orderBy uses selector when sorting", function () {
            var data = [{ name: "foo" }, { name: "bar" }, { name: "foo"}];

            var result = q(data).orderBy(function (item) {
                return item.name;
            }).toArray();

            equal(result.length, 3);
            equal(result[0].name, "bar");
            equal(result[1].name, "foo");
            equal(result[2].name, "foo");
        });

        test("orderBy does not modify original", function () {
            var data = [3, 2, 1];

            q(data).orderBy(function (item) {
                return item.name;
            }).toArray();

            equal(data.length, 3);
            equal(data[0], 3);
            equal(data[1], 2);
            equal(data[2], 1);
        });

        test("orderByDescending sorts numbers in descending order", function () {
            var data = [1, 100, 10];

            var result = q(data).orderByDescending(function (item) {
                return item;
            }).toArray();

            equal(result.length, 3);
            equal(result[0], 100);
            equal(result[1], 10);
            equal(result[2], 1);
        });

        test("orderByDescending sorts strings in descending order", function () {
            var data = ["foo", "bar", "baz"];

            var result = q(data).orderByDescending(function (item) {
                return item;
            }).toArray();

            equal(result.length, 3);
            equal(result[0], "foo");
            equal(result[1], "baz");
            equal(result[2], "bar");
        });

        test("orderByDescending sorts dates in descending order", function () {
            var data = [new Date(2011, 1, 1), new Date(2008, 1, 1), new Date(2009, 1, 1)];

            var result = q(data).orderByDescending(function (item) {
                return item;
            }).toArray();

            equal(result.length, 3);
            equal(result[0].getFullYear(), 2011);
            equal(result[1].getFullYear(), 2009);
            equal(result[2].getFullYear(), 2008);
        });

        test("orderByDescending uses selector when sorting", function () {
            var data = [{ name: "foo" }, { name: "bar" }, { name: "foo"}];

            var result = q(data).orderByDescending(function (item) {
                return item.name;
            })
                    .toArray();

            equal(result.length, 3);
            equal(result[0].name, "foo");
            equal(result[1].name, "foo");
            equal(result[2].name, "bar");
        });

        test("orderByDescending does not modify original", function () {
            var data = [1, 2, 3];

            q(data).orderByDescending(function (item) {
                return item.name;
            });

            equal(data[0], 1);
            equal(data[1], 2);
            equal(data[2], 3);
        });

        test("chaining", function () {
            var data = ["foo", "bar", "baz"];
            var result = q(data)
                    .where(function (item) {
                        return item.indexOf("ba") > -1;
                    })
                    .orderByDescending(function (item) {
                        return item;
                    })
                    .skip(1)
                    .take(1)
                    .toArray();

            equal(result.length, 1);
            equal(result[0], "bar");
        });    

        test("concat two queriables", function() {
            var q1 = q(["foo"]), q2 = q(["bar"]);
            
            var result = q1.concat(q2).toArray();
            
            equal(result[0], "foo");
            equal(result[1], "bar");
        });        
        
        test("concat does not modify original queriable", function() {
            var q1 = q(["foo"]), q2 = q(["bar"]);
            
            q1.concat(q2).toArray();
            
            equal(q1.toArray().length, 1);
        });

        test("count returns the length of the data", function() {
            equal(q([]).count(), 0);
        });

        test("any returns false if the data is empty", function() {
            ok(!q([]).any());
        });
                
        test("any returns true if the data is not empty", function() {
            ok(q([1]).any());
        });

        test("any accepts predicate", function() {
            var argument, index;

            ok(q([1]).any(function(value, i) {
                argument = value;
                index = i;
                return true;
            }));

            equal(argument, 1);
            equal(index, 0);
        });
    </script>
</asp:Content>
