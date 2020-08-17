<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<style>

.t-breadcrumbs
{
    
}

.t-breadcrumbs div
{
    position:absolute;
}

.t-breadcrumbs a
{
    display: inline-block;
    overflow: hidden;
}

</style>
<% Html.EasyUI().ScriptRegistrar().DefaultGroup(g => g.Add("easyui.common.js").Add("easyui.imagebrowser.js")); %>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="TestContent" runat="server">
    <script type="text/javascript">
    
    var div;

    module("Editor/Breadcrumbs", {
            setup: function() {
                div = $('<div class="t-breadcrumbs" />').appendTo(document.body).width(400);
            },
            teardown: function() {
                div.remove();
            }
        });
    
    test("_path concatenates the text of the breadcrumb trail", function() {
        var breadcrumbs = new $.easyui.breadcrumbs(null,{});

        equal(breadcrumbs._path($("<a>foo</a><a>bar</a>")), "/foo/bar")
    });
    
    test("_path returns slash if there are no breadcrumbs", function() {
        var breadcrumbs = new $.easyui.breadcrumbs(null,{});

        equal(breadcrumbs._path([]), "/");
    });

    test("_focus hides the breadcrumbs", function() {
        var breadcrumbs = new $.easyui.breadcrumbs(div[0], { path: "/foo" });
        
        breadcrumbs._focus();
        
        ok(div.find("div").is(":not(:visible)"));
    });
    
    test("_focus sets the value of the input", function() {
        var breadcrumbs = new $.easyui.breadcrumbs(div[0], { path: "/foo" });
        
        breadcrumbs._focus();
        
        equal(div.find("input").val(), "/foo");
    });
    
    
    test("_blur clears the input", function() {
        var breadcrumbs = new $.easyui.breadcrumbs(div[0], { path: "/foo" });
        
        breadcrumbs._focus();
        breadcrumbs._blur({});
        
        equal(div.find("input").val(), "");
    });
    
    test("_blur shows the breadcrumbs", function() {
        var breadcrumbs = new $.easyui.breadcrumbs(div[0], { path: "/foo" });
        
        breadcrumbs._focus();
        breadcrumbs._blur({});
        
        ok(div.find("div").is(":visible"));
    });

    test("_click changes the value", function() {
        var breadcrumbs = new $.easyui.breadcrumbs(div[0], { path: "/foo/bar" });
        
        breadcrumbs._click({ target: div.find("a:first") });
        
        equal(breadcrumbs.value(), "/foo/bar");
    });
    
    test("_click does not raise change if the value is not changed", function() {
        var breadcrumbs = new $.easyui.breadcrumbs(div[0], { path: "/foo/bar" });
        
        var changeRaised = false;

        div.bind("t:change", function() {
            changeRaised = true;
        });

        breadcrumbs._click({ target: div.find("a:last") });
        
        ok(!changeRaised);
    });

    test("_blur raises change if the value has changed", function() {
        var breadcrumbs = new $.easyui.breadcrumbs(div[0], { path: "/foo/bar" });
        
        var changeRaised = false;

        div.bind("t:change", function() {
            changeRaised = true;
        });

        breadcrumbs._focus();
        
        div.find("input").val("/foo/bar/baz");
        
        breadcrumbs._blur();
        
        ok(changeRaised);
    });    
    
    test("pressing enter raises the change event", function(){
        var breadcrumbs = new $.easyui.breadcrumbs(div[0], { path: "/foo/bar" });
        
        var changeRaised = false;

        div.bind("t:change", function() {
            changeRaised = true;
        });

        var e = $.Event();
        e.type = "keydown";
        e.keyCode = 13;
        
        div.find("input").val("/foo/bar/baz").trigger(e);
        
        ok(changeRaised);
    });

    test("triggering refresh updates the breadcrumbs", function() {
        new $.easyui.breadcrumbs(div[0], { path: "/foo/bar" });

        div.val("/foo/bar/baz");
        div.trigger("t:refresh");

        equal(div.find("a").length, 2);
    });

    test("should hide breadcrumbs if they are too long", function() {
        div.width(100);
        
        new $.easyui.breadcrumbs(div[0], { path: "/foo/bar/baz" });
        
        equal(div.find("a:visible").length, 1);
    });

    test("clicking the last breadcrumb when the rest are hidden sets the value", function() {
        div.width(100);
        
        var breadcrumbs = new $.easyui.breadcrumbs(div[0], { path: "/foo/bar/baz" });
        
        breadcrumbs._click({ target: div.find("a:last") });

        equal(div.val(), "/foo/bar/baz");
    });

    test("should set the width of the last link if it is wider than the container", function() {
        div.width(100);
        
        new $.easyui.breadcrumbs(div[0], { path: "/foofoofoofoofoofoofoofoofoo" });

        ok(div.find("a").width() < div.width());
    });

    test("should condense adjacent slashes", function() {
        new $.easyui.breadcrumbs(div[0], { path: "///foo///bar///baz" });
        equal(div.find("a").length, 1);
        equal(div.val(), "/foo/bar/baz");
    });    
    
    test("should condense adjacent slashes entered by the user", function() {
        var breadcrumbs = new $.easyui.breadcrumbs(div[0], { path: "/foo/bar" });
        
        breadcrumbs._focus();
        
        div.find("input").val("///foo///bar//baz");
        
        breadcrumbs._blur();
        
        equal(div.val(), "/foo/bar/baz");
    });

    test("should initialize base path", function() {
        var breadcrumbs = new $.easyui.breadcrumbs(div[0], { path: "/foo/bar" });
        
        equal(breadcrumbs._basePath, "/foo/bar");
    });

    test("should set value to base path if empty", function() {
        var breadcrumbs = new $.easyui.breadcrumbs(div[0], { path: "/foo/bar" });

        breadcrumbs._focus();
        
        div.find("input").val("");
        
        breadcrumbs._blur();
        
        equal(div.val(), "/foo/bar");
    });

    test("should set value to base path if invalid", function() {
        var breadcrumbs = new $.easyui.breadcrumbs(div[0], { path: "/foo/bar" });

        breadcrumbs._focus();
        
        div.find("input").val("/baz");
        
        breadcrumbs._blur();
        
        equal(div.val(), "/foo/bar");
    });

    test("breadcrumbs for the base path are not created", function() {
        new $.easyui.breadcrumbs(div[0], { path: "/foo/bar" });

        equal(div.find("a").length, 1);
    });

    test("selecting item from the drop down fires change event", function() {
        var breadcrumbs = new $.easyui.breadcrumbs(div[0], { path: "/foo/bar", roots: ["/foo/","/baz/"] });

        var changeRaised = false;

        div.bind("t:change", function() {
            changeRaised = true;
        });

        div.find(".t-select").click();
        $(".t-popup .t-item:eq(1)").click();

        ok(changeRaised);
        equal(breadcrumbs.value(), "/baz/");
    });
</script>
</asp:Content>
