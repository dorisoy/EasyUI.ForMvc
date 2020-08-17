<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <% Html.EasyUI().ScriptRegistrar().DefaultGroup(g => g.Add("easyui.common.js").Add("easyui.imagebrowser.js")); %>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="TestContent" runat="server">
    <script type="text/javascript">

        var reader;
        
        module("Editor/DefaultReader", {
            setup: function () {                                
                reader = new $t.fileInfoReader({});
            },
            teardown: function () {            
            }
        });       

        test("reader concatPaths baseUrl and file name", function() {
            var baseUrl = "/foo";
            var file = "bar.png";
            var result = reader.concatPaths(baseUrl, file);

            equal(result, "/foo/bar.png");
        });

        test("reader concatPaths does not add additional slash after base url", function() {
            var baseUrl = "/foo/";
            var file = "bar.png";
            var result = reader.concatPaths(baseUrl, file);

            equal(result, "/foo/bar.png");
        });

        test("reader concatPaths does add slash if base url is empty", function() {
            var baseUrl;
            var file = "bar.png";
            var result = reader.concatPaths(baseUrl, file);

            equal(result, "/bar.png");
        });

        test("size calculates megabytes", function() {
            equal(reader.size({Size: 7326629}), "6.99 MB");
        });        
        
        test("size calculates bytes", function() {
            equal(reader.size({Size: 42}), "42 bytes");
        });
        
        test("size calculates gigabytes", function() {
            equal(reader.size({Size: 1073741824}), "1 GB");
        });

        test("read is case insensitive", function() {
            equal(reader.read("foo", { foo: "bar" }), "bar");
            equal(reader.read("foo", { Foo: "bar" }), "bar");
        });

    </script>
</asp:Content>
