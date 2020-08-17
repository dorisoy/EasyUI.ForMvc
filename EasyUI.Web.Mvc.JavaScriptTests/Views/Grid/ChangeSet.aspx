<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <%= Html.EasyUI().Grid(Model)
            .Name("Grid1")
            .DataKeys(keys => keys.Add(c => c.Name))
            .ToolBar(toolbar => toolbar.Insert())
            .Columns(columns => 
                {
                    columns.Bound(c => c.Name);
                    columns.Bound(c => c.BirthDate);
                    columns.Bound(c => c.ReadOnly);
                    columns.Command(commands =>
                    {
                        commands.Edit();
                        commands.Delete();
                    });
                })
            .DataBinding(binding => binding.Ajax()
                .Select("Select", "Dummy")
                .Insert("Insert", "Dummy")
                .Delete("Delete", "Dummy")
                .Update("Update", "Dummy")
            )
            .Editable(editing => editing.Mode(GridEditMode.InCell))
            .Pageable(pager => pager.PageSize(10))
    %>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="TestContent" runat="server">
    <script type="text/javascript">
        var ChangeLog, changeLog, nop = function () { };

        module("Grid / ChangeLog", {
            setup: function () {
                ChangeLog = $.easyui.grid.ChangeLog;
            }
        });

        function createChangeLog(size) {
            return new ChangeLog(size || 10);
        }

        test("update inserts item in modified", function() {
            changeLog = createChangeLog();
            
            changeLog.update(0, {foo:"bar"}, {foo:"baz"});

            ok(changeLog.updated[0]);
        });
        
        test("update merges original and update values", function() {
            changeLog = createChangeLog();
            
            changeLog.update(0, {foo:"bar", bar:"bar"}, {foo:"baz"});

            equal(changeLog.updated[0].foo, "baz");
            equal(changeLog.updated[0].bar, "bar");
        });        
        
        test("update inserts at specified position", function() {
            changeLog = createChangeLog();
            
            changeLog.update(1, {foo:1}, {foo:2});

            ok(changeLog.updated[1]);
        });
        
        test("update accumulates updates", function() {
            changeLog = createChangeLog();

            changeLog.update(0, {foo:"foo1", bar:"bar1"}, {foo: "foo2"});
            
            changeLog.update(0, {foo:"foo1", bar:"bar1"}, {bar: "bar2"});

            equal(changeLog.updated[0].foo, "foo2");
            equal(changeLog.updated[0].bar, "bar2");
        });        
        
        test("clear removes all updated items", function() {
            changeLog = createChangeLog();

            changeLog.update(0, {foo:"foo1", bar:"bar1"}, {foo: "foo2"});
            
            changeLog.clear();

            equal(changeLog.updated[0], undefined);
        });        
        
        test("clear removes all inserted items and resizes array to original size", function() {
            changeLog = createChangeLog();

            changeLog.insert(0, {foo:"foo1", bar:"bar1"});
            
            changeLog.clear();

            equal(changeLog.inserted[0], undefined);
        });

        test("dirty returns true if there are modified items", function() {
            changeLog = createChangeLog();

            changeLog.update(0, {foo:"foo1", bar:"bar1"}, {foo: "foo2"});

            ok(changeLog.dirty());
        });        
        
        test("dirty returns false if there are no modified items", function() {
            changeLog = createChangeLog();

            ok(!changeLog.dirty());
        });

        test("update does not insert item in modified if original and update are the same", function() {
            changeLog = createChangeLog();

            changeLog.update(0, {foo:"foo1"}, {foo: "foo1"});

            ok(!changeLog.dirty());
        });        
        
        test("update does not modify original", function() {
            changeLog = createChangeLog();

            var original = {foo:"foo1"};
            changeLog.update(0, original, {foo: "foo2"});

            equal(original.foo, "foo1");
        });
        
        test("update inserts item in modified when original is null", function() {
            changeLog = createChangeLog();

            changeLog.update(0, null, {foo: "foo1"});

            ok(changeLog.dirty());
        });
        
        test("insert inserts item in inserted", function() {
            changeLog = createChangeLog();

            changeLog.insert(0, {foo: "foo1"});

            equal(changeLog.inserted[0].foo, "foo1");
        });
        
        test("insert inserts item in inserted", function() {
            changeLog = createChangeLog();

            changeLog.insert(0, {foo: "foo1"});

            equal(changeLog.inserted[0].foo, "foo1");
        });
                
        test("insert updates item in inserted", function() {
            changeLog = createChangeLog();

            changeLog.insert(0, {foo: "foo1"});
            changeLog.insert(0, {bar: "bar1"});

            equal(changeLog.inserted[0].foo, "foo1");
            equal(changeLog.inserted[0].bar, "bar1");
        });        
        

        test("update after insert modifies the index", function() {
            changeLog = createChangeLog();

            changeLog.insert(0, {foo: "foo1"});
            changeLog.update(1, {foo: "foo1"}, {foo: "foo2"});

            equal(changeLog.updated[0].foo, "foo2");
        });

        test("erase adds item to deleted array", function() {
            changeLog = createChangeLog();

            changeLog.erase(0, {foo: "foo1"});

            equal(changeLog.deleted[0].foo, "foo1");
        });
        
        test("erase removes inserted item and does not add it to the deleted array", function() {
            changeLog = createChangeLog();

            changeLog.insert(0, {foo: "foo1"});
            changeLog.erase(0, {foo: "foo1"});

            equal(changeLog.inserted[0], undefined);
            equal(changeLog.inserted.length, 0);
            equal(changeLog.deleted[0], undefined);
        });
        
        test("erase removes updated item and adds it to the deleted array", function() {
            changeLog = createChangeLog();

            changeLog.update(0, {foo: "foo1"}, {foo: "foo2" });
            changeLog.erase(0, {foo: "foo1"});

            equal(changeLog.updated[0], undefined);
            equal(changeLog.deleted[0].foo, "foo1");
        });        
        
        test("erase removes updated item after inserting and adds it to the deleted array", function() {
            changeLog = createChangeLog();

            changeLog.insert(0, {foo: "foo1"});
            changeLog.update(1, {foo: "foo1"}, {foo: "foo2" });
            changeLog.erase(1, {foo: "foo1"});

            equal(changeLog.updated[0], undefined);
            equal(changeLog.deleted[0].foo, "foo1");
        });

        test("dirty returns true if items are inserted", function() {
            changeLog = createChangeLog();

            changeLog.insert(0, {foo: "foo1"});

            ok(changeLog.dirty());
        });     
        
        test("dirty returns true if items are erased", function() {
            changeLog = createChangeLog();

            changeLog.erase(0, {foo: "foo1"});

            ok(changeLog.dirty());
        });

        test("clear cleans deleted items", function() {
            changeLog = createChangeLog();

            changeLog.erase(0, {foo: "foo1"});
            changeLog.clear();

            equal(changeLog.deleted[0], undefined);
        });

        test("serialize returns indexed data", function() {
            changeLog = createChangeLog();

            changeLog.updated[0] = {foo:1};
            
            var result = changeLog.serialize([], changeLog.updated, []);
            
            equal(result["updated[0].foo"], 1);
        });        
        
        test("serialize returns inserted items", function() {
            changeLog = createChangeLog();

            changeLog.inserted[0] = {foo:1};
            
            var result = changeLog.serialize(changeLog.inserted, [], []);
            
            equal(result["inserted[0].foo"], 1);
        });        
        
        test("serialize returns deleted items", function() {
            changeLog = createChangeLog();

            changeLog.deleted[0] = {foo:1};
            
            var result = changeLog.serialize([], [], changeLog.deleted);
            
            equal(result["deleted[0].foo"], 1);
        });
        
        test("serialize returns zero based indexed data", function() {
            changeLog = createChangeLog();

            changeLog.updated[1] = {foo:1};
            var result = changeLog.serialize([], changeLog.updated, []);
            
            equal(result["updated[0].foo"], 1);
        });
        
        test("serialize flattens complex objects", function() {
            changeLog = createChangeLog();

            changeLog.updated[0] = {foo: {bar: 1 }};

            var result = changeLog.serialize([], changeLog.updated, []);
            
            equal(result["updated[0].foo.bar"], 1);
        });

    </script>
</asp:Content>
