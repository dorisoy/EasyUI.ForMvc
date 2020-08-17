﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <% Html.EasyUI().ScriptRegistrar().DefaultGroup(g => g.Add("easyui.common.js").Add("easyui.imagebrowser.js")); %>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="TestContent" runat="server">
    <script type="text/javascript">

        var ul, listView, data, q;
        
        function text(li) {
            return li.find("strong").text();
        }
        
        module("Editor/FileListView", {
            setup: function () {
                q = $.easyui.query;
                ul = $('<ul />').appendTo(document.body).width(400);
                data = { path: "", directories: [ { name: "foo" }, {name:"bar"}, {name:"baz"}]};
                
                window.confirm = function() {
                    return true;
                }

                listView = new $t.fileListView(ul[0], {
                    localization : {
                        emptyFolder: "",
                        overwriteFile: ""
                    },

                    reader: {
                        directories: function (data) {
                            return data.directories;
                        },
                        files: function (data) {
                            return data.files;
                        },
                        thumbUrl: function() {
                            return "thumbnail";
                        },
                        size: function() {
                            return 42;
                        },
                        name: function(item) {
                            return item.name;
                        },
                        path: function(data) {
                            return data.path;                            
                        },
                        concatPaths: function(path, name){
                            return path + "/" + name;
                        }
                    }
                });
            },
            teardown: function () {
                ul.remove();
            }
        });

        test("bindTo directories", function () {
            listView.bindTo(data, "name");

            equal(ul.children().length, 3);
        });

        test("bindTo clears old contents", function () {

            listView.bindTo(data, "name");
            listView.bindTo(data, "name");

            equal(ul.children().length, 3);
        });        
        
        test("bindTo uses the name of the directories as text", function () {
            listView.bindTo(data, "name");
            equal(text(ul.find("li:first")), "bar");
            equal(text(ul.find("li:last")), "foo");
        });
        
        test("_process concatenates files and directories", function () {
            var result = listView._process("", q([{name:"foo"}]), q([{name:"bar"}])).toArray();
            
            equal(result.length, 2);
        });

        test("_process uses the name and path to form the url", function() {
            var result = listView._process("/foo", q([{name:"bar"}]), q([{name:"baz"}])).toArray();
            
            equal(result[0].url, "/foo/bar");
            equal(result[1].url, "/foo/baz");
        });
        
        test("_process sets the name", function() {
            var result = listView._process("/foo", q([{name:"bar"}]), q([{name:"baz"}])).toArray();
            
            equal(result[0].name, "bar");
            equal(result[1].name, "baz");
        });        
        
        test("_process sets the kind", function() {
            var result = listView._process("/foo", q([{name:"bar"}]), q([{name:"baz"}])).toArray();
            
            equal(result[0].kind, "d");
            equal(result[1].kind, "f");
        });        
        
        
        test("_process sets thumbUrl", function() {
            var result = listView._process("/foo", q([]), q([{name:"baz"}])).toArray();
            
            equal(result[0].thumbUrl, "thumbnail");
        });        
        
        test("_process sets size", function() {
            var result = listView._process("/foo", q([]), q([{name:"baz"}])).toArray();
            
            equal(result[0].size, 42);
        });

        test("bindTo match files with given name if filter is specified", function() {
            
            listView.bindTo(data, "", "foo");                  
              
            equal(ul.find("li").length, 1);
            equal(text(ul.find("li:first")), "foo");            
        });

        test("bindTo match files with given name if * filter is specified", function() {
            listView.bindTo(data, "", "f*");                  
              
            equal(ul.find("li").length, 1);
            equal(text(ul.find("li:first")), "foo");            
        });

        test("bindTo match files with name which is special regex character names if filter is specified", function() {
            listView.bindTo({ directories:[], files: [{name:"[(f|o|o)].bar"}] }, "", "[(?|?|?)].bar");                  
              
            equal(text(ul.find("li:first")), "[(f|o|o)].bar");
        });

        test("bindTo match files with given name if ? filter is specified ", function() {
            
            listView.bindTo(data, "", "f?");                  
              
            equal(ul.find("li").length, 1);
            equal(text(ul.find("li:first")), "foo");            
        });

        test("bindTo returns no items if filter is not matched", function() {
            
            listView.bindTo(data, "", "moo");                  
              
            equal(ul.find("li").length, 0);            
        });

        test("triggering the refresh event binds the listview", function() {
            ul.trigger("t:refresh", [data, "name"]);
            
            equal(ul.find("li").length, 3);
        }); 

        test("clicking a tile raises the change event", function() {
            var args;

            ul.bind("t:change", function(e) {
                args = e;
            });

            listView.bindTo(data, "name");
            
            ul.find("li:first").click();

            equal(args.url, "/bar");
            equal(args.kind, "d");
        });        
        
        test("clicking a child of the tile raises the change event", function() {
            var args;

            ul.bind("t:change", function(e) {
                args = e;
            });

            listView.bindTo(data, "name");
            
            ul.find("li:first strong").click();

            equal(args.url, "/bar");
            equal(args.kind, "d");
        });

        test("clicking a tile applies selected style", function() {
            listView.bindTo(data, "name");
            
            var li = ul.find("li:first").click();
            
            ok(li.is(".t-state-selected"));
        });        
        
        test("clicking a tile removes selected style from other tiles", function() {
            listView.bindTo(data, "name");
            
            ul.find("li:first").click();
            ul.find("li:last").click();
            
            ok(!ul.find("li:first").is(".t-state-selected"));
        });

        test("double clicking a child element raises the select event", function() {
            var args;

            ul.bind("t:select", function(e) {
                args = e;
            });

            listView.bindTo(data, "name");
            
            ul.find("li:first").trigger("dblclick");

            equal(args.url, "/bar");
            equal(args.kind, "d");
        });

        test("raising the upload event adds tiles for the file", function() {
            listView.bindTo({directories:[], files:[] });
            ul.trigger("t:upload", [{name:"foo"}]);
            
            equal(text(ul.find("li:first")), "foo");
        });
        
        test("tiles are inserted before files", function() {
            listView.bindTo({directories:[], files:[{name:"bar"}] }, "name");
            
            ul.trigger("t:upload", [{name:"baz"}]);
            
            equal(text(ul.find("li:eq(0)")), "baz");
            equal(text(ul.find("li:eq(1)")), "bar");
        });        
        
        test("tiles are inserted after directories", function() {
            listView.bindTo({directories:[{name:"foo"}], files:[] }, "name");
            
            ul.trigger("t:upload", [{name:"baz"}]);
            
            equal(text(ul.find("li:eq(0)")), "foo");
            equal(text(ul.find("li:eq(1)")), "baz");
        });

        test("empty tile is shown if no data", function() {
            listView.bindTo({directories:[], files:[] });

            var li = ul.find("li");
            equal(li.length, 1);
            ok(li.is(".t-tile-empty"))            
        });

         test("clicking a empty data tile does not raises the change event", function() {
            var called;

            ul.bind("t:change", function(e) {
                called = true;
            });

            listView.bindTo({directories:[], files:[] }, "name");
            
            ul.find("li:first").click();

            ok(!called);
        }); 

        test("raising the complete event displays complete files", function() {
            listView.bindTo({directories:[], files:[] });
            ul.trigger("t:upload", [{name:"foo"}]);
            ul.trigger("t:completeFile", [{name: "foo", path:"/bar"}]);

            var li = ul.find("li");

            equal(text(li), "foo");
            equal(li.data("kind"), "f");
            equal(li.data("url"), "/bar/foo");
        });
        
        test("raising the complete event escapes file names", function() {
            listView.bindTo({directories:[], files:[] });
            ul.trigger("t:upload", [{name:"[$f#oo^]"}]);
            ul.trigger("t:completeFile", [{name: "[$f#oo^]", path:"/bar"}]);

            var li = ul.find("li");

            equal(text(li), "[$f#oo^]");
        });

        test("raising the complete event raises change", function() {
            listView.bindTo({directories:[], files:[] });
            var changed = false;
            
            ul.bind("t:change", function() {
                changed = true;
            });

            ul.trigger("t:upload", [{name:"foo"}]);
            ul.trigger("t:completeFile", [{name: "foo", path:"/bar"}]);

            ok(changed);
        });

        test("clicking uploading file does not trigger the change event", function() {
            listView.bindTo({directories:[], files:[] });
            var changed = false;

            ul.bind("t:change", function(e) {
                changed = true;
            });
            
            ul.trigger("t:upload", [{name:"foo"}]);
            ul.find("li").click();
            ok(!changed);
        });
        
        test("double clicking uploading file does not trigger the select event", function() {
            listView.bindTo({directories:[], files:[] });
            var selected = false;

            ul.bind("t:select", function(e) {
                selected = true;
            });
            
            ul.trigger("t:upload", [{name:"foo"}]);
            ul.find("li").trigger("dblclick");
            ok(!selected);
        });

        test("upload replaces existing tile", function() {
            listView.bindTo({directories:[], files:[{name:"Foo"}] });

            ul.trigger("t:upload", [{name:"foo"}]);

            equal(ul.find("li").length, 1);
        });
        
        test("upload replaces existing tile if called multiple times", function() {
            listView.bindTo({directories:[], files:[{name:"Foo"}] });

            ul.trigger("t:upload", [{name:"foo"}]);
            ul.trigger("t:completeFile", [{name: "foo", path:"/bar"}]);
            ul.trigger("t:upload", [{name:"foo"}]);
            ul.trigger("t:completeFile", [{name: "foo", path:"/bar"}]);

            equal(ul.find("li").length, 1);
        });

        test("fileIndex returns index of the file if such exists", function() {
            listView.bindTo({directories:[], files:[{name:"Foo"}] });
            var index = listView.fileIndex("foo");

            equal(index, 0);
        });

        test("fileIndex returns -1 if file does not exist", function() {
            listView.bindTo({directories:[], files:[{name:"Foo"}] });
            var index = listView.fileIndex("bar");

            equal(index, -1);
        });

        test("canceling the overwrite does not add a loading tile", function() {
            listView.bindTo({directories:[], files:[{name:"foo"}] });
            window.confirm = function() {
                return false;
            }
            ul.trigger("t:upload", [{name:"foo"}, function() {}]);

            equal(ul.find("li .t-loading").length, 1);
        });
        
        test("canceling the overwrite calls preventDefault", function() {
            listView.bindTo({directories:[], files:[{name:"foo"}] });
            window.confirm = function() {
                return false;
            }
            
            var defaultPrevented = false;

            ul.trigger("t:upload", [{name:"foo"}, function() {
                defaultPrevented = true;
            }]);

            ok(defaultPrevented);
        });

        test("uploading a file twice asks for confirmation", function() {
            listView.bindTo({directories:[], files:[] });
            var confirmed = false;
            
            window.confirm = function() {
                confirmed = true;   
            }
            
            ul.trigger("t:upload", [{name:"foo"}, function() {}]);
            ul.trigger("t:upload", [{name:"foo"}, function() {}]);

            ok(confirmed);
        });

        test("uploading existing file adds existing attribute", function() {
            listView.bindTo({directories:[], files:[{name:"foo"}] });
            
            window.confirm = function() {
                return true;
            }
            
            ul.trigger("t:upload", [{name:"foo"}, function() {}]);

            equal(ul.find("li").data("existing"), true);
        });

        test("error after upload removes the tile", function() {
            listView.bindTo({directories:[], files:[] });
            
            ul.trigger("t:upload", [{name:"foo"}, function() {}]);
            ul.trigger("t:errorFile", [{name:"foo"}]);

            ok(ul.find("li").hasClass("t-tile-empty"));
        });
        
        test("error after upload removes the tile from data", function() {
            listView.bindTo({directories:[], files:[] });
            
            ul.trigger("t:upload", [{name:"foo"}, function() {}]);
            ul.trigger("t:errorFile", [{name:"foo"}]);
            
            equal(listView._data.toArray().length, 0);
        });

        test("error after upload does not remove the tile if it existed", function() {
            listView.bindTo({directories:[], files:[{name:"foo"}] });
            
            ul.trigger("t:upload", [{name:"foo"}, function() {}]);
            ul.trigger("t:errorFile", [{name:"foo"}]);

            ok(!ul.find("li").hasClass("t-tile-empty"));
            ok(ul.find("li").data("thumbUrl"));
        });

        test("rasing mkdir creates a new directory tile", function() {
            listView.bindTo({directories:[], files:[] });
            
            ul.trigger("t:createDirectory", [function() {}]);

            ok(!ul.find("li").hasClass("t-tile-empty"));
            equal(ul.find("li").length, 1);
        });        
        
        test("mkdir generates unique name", function() {
            listView.bindTo({directories:[ { name: "New folder" }], files:[] });
            
            ul.trigger("t:createDirectory", [function() {}]);
            
            equal(ul.find("li:last input").val(), "New folder (2)");
        });        
        
        test("mkdir generates the first available unique name ", function() {
            listView.bindTo({directories:[ { name: "New folder (2)" }], files:[] });
            
            ul.trigger("t:createDirectory", [function() {}]);
            
            equal(ul.find("li:last input").val(), "New folder");
        });
        
        test("mkdir generates the first available unique name 2", function() {
            listView.bindTo({directories:[ { name: "New folder" }, { name: "New folder (3)" }, {name: "New folder (2)"}, {name: "New folder (5)"}], files:[]}, "name");
            
            ul.trigger("t:createDirectory", [function() {}]);
            
            equal(ul.find("li:last input").val(), "New folder (4)");
        });

        test("bluring the input calls the callback", function() {
            listView.bindTo({directories:[], files:[] });
            
            var argument;

            ul.trigger("t:createDirectory", [function(name) {
                argument = name;
            }]);

            ul.find("input").val("foo").blur();
            
            equal(argument, "foo");
        });
        
        test("callback is called with trimmed value", function() {
            listView.bindTo({directories:[], files:[] });
            
            var argument;

            ul.trigger("t:createDirectory", [function(name) {
                argument = name;
            }]);

            ul.find("input").val(" foo ").blur();
            
            equal(argument, "foo");
        });
        
        test("input is replaced with strong after blur", function() {
            listView.bindTo({directories:[], files:[] });
            
            ul.trigger("t:createDirectory", [function(name) {
            }]);

            ul.find("input").val("foo").blur();
            
            equal(ul.find("input").length, 0);
            equal(ul.find("strong").text(), "foo");
        });

        test("new directories are inserted in the listview data", function() {
            listView.bindTo({directories:[], files:[] });

            ul.trigger("t:createDirectory", [function(name) {}]);
            ul.find("input").blur();
            equal(listView._data.toArray().length, 1)
        });
        
        test("new directories are inserted with default name if textbox is empty", function() {
            listView.bindTo({directories:[], files:[] });
            var argument;
            ul.trigger("t:createDirectory", [function(name) {
                argument = name;
            }]);
            
            ul.find("input").focus().val("").blur();
            equal(argument, "New folder");
        });

        test("if directory name already exists generate a new one", function() {
            listView.bindTo({directories:[{name:"foo"}], files:[] });
            var argument;
            ul.trigger("t:createDirectory", [function(name) {
                argument = name;
            }]);
            
            ul.find("input").focus().val("foo").blur();
            equal(argument, "New folder");
        });

        test("errorDirectory removes the new directory tile", function() {
            listView.bindTo({directories:[], files:[] });

            ul.trigger("t:createDirectory", [function(name) {}]);
            ul.find("input").blur();
            ul.trigger("t:errorDirectory", [{name:"New folder"}]);
            
            ok(ul.find("li").hasClass("t-tile-empty"));
        });
        
        test("errorDirectory removes the new directory from the data", function() {
            listView.bindTo({directories:[], files:[] });

            ul.trigger("t:createDirectory", [function(name) {}]);
            ul.find("input").blur();
            ul.trigger("t:errorDirectory", [{name:"New folder"}]);
            
            equal(listView._data.toArray().length, 0);
        });

        test("completeDirectory sets the data-url attribute", function() {
            listView.bindTo({directories:[], files:[] });

            ul.trigger("t:createDirectory", [function(name) {}]);
            ul.trigger("t:completeDirectory", [{name:"New folder", path:"/foo"}]);
            
            equal(ul.find("li").data("url"), "/foo/New folder");
        });

    </script>
</asp:Content>