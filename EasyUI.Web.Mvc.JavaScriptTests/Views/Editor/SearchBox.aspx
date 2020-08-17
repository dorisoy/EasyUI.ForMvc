<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<% Html.EasyUI().ScriptRegistrar().DefaultGroup(g => g.Add("easyui.common.js").Add("easyui.imagebrowser.js")); %>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="TestContent" runat="server">
    <script type="text/javascript">
    
    var div;

    module("Editor/SearchBox", {
            setup: function() {
                div = $('<div class="t-search-wrap" />').appendTo(document.body);
            },
            teardown: function() {
                div.remove();
            }
        });  

    test("_focus hides the label", function() {
        var searchBox = new $.easyui.searchBox(div[0]);
        
        searchBox._focus();
        
        ok(div.find("label").is(":not(:visible)"));
    });
  
    test("_blur shows the label if no value is entered", function() {
        var searchBox = new $.easyui.searchBox(div[0]);
        
        searchBox._focus();
        searchBox._blur({});
        
        ok(div.find("label").is(":visible"));
    }); 

    test("_blur does not shows the label if value is entered", function() {
        var searchBox = new $.easyui.searchBox(div[0]);
        
        searchBox._focus();
        div.find("input").val("foo");
        searchBox._blur({});
        
        ok(div.find("label").is(":not(:visible)"));
    }); 

    test("_blur raises change if the value has changed", function() {
        var searchBox = new $.easyui.searchBox(div[0]);
        
        var changeRaised = false;

        div.bind("t:change", function() {
            changeRaised = true;
        });

        searchBox._focus();
        
        div.find("input").val("foo");
        
        searchBox._blur();
        
        ok(changeRaised);
    });  
    
    test("pressing enter raises change if the value has changed", function() {
        var searchBox = new $.easyui.searchBox(div[0]);
        
        var changeRaised = false;

        div.bind("t:change", function() {
            changeRaised = true;
        });
        
        var e = $.Event();
        e.keyCode = 13;
        e.type = "keydown";

        div.find("input").focus().val("foo").trigger(e);
        
        ok(changeRaised);
    });  

    test("clicking on the button raises change", function() {
        var searchBox = new $.easyui.searchBox(div[0]);

        var changeRaised = false;

        div.bind("t:change", function() {
            changeRaised = true;
        });

        div.find("input").val("foo");

        div.find("a:first").click();

        ok(changeRaised);
    });

</script>
</asp:Content>
