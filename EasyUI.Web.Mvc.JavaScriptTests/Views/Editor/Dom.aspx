<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Dom</h2>
     <%= Html.EasyUI().Editor().Name("Editor") %>
    <script type="text/javascript" src="<%= Url.Content("~/Scripts/editorTestHelper.js") %>"></script>
    <script type="text/javascript">

        var editor;

        var Dom;
        var enumerator;

    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

        QUnit.testStart = function() {
            editor = getEditor();
            Dom = $.easyui.editor.Dom;
        }

        test('commonAncestor returns common ancestor for root nodes returns body', function() {
            editor.value('<span>foo</span><span>bar</span>');
            equal(Dom.commonAncestor(editor.body.firstChild.firstChild, editor.body.lastChild.lastChild), editor.body);
        });
        
        test('commonAncestor single node returns same element', function() {
            editor.value('<span>foo</span><span>bar</span>');
            equal(Dom.commonAncestor(editor.body.firstChild.firstChild), editor.body.firstChild.firstChild);
        });

        test('commonAncestor returns common ancestor for parent and child', function() {
            editor.value('<span>foo</span>');
            equal(Dom.commonAncestor(editor.body.firstChild.firstChild, editor.body.firstChild), editor.body.firstChild);
        });

        test('commonAncestor returns null when called with empty arguments', function() {
            ok(null === Dom.commonAncestor());
        });

        test('style applies specified style', function() {
            var element = document.createElement('span');
            Dom.style(element, {color:'red'});
            equal(element.style.color, 'red');
        });

        test('style does nothing if no style specified', function() {
            var element = document.createElement('span');
            Dom.style(element);
            equal(element.style.cssText, '');
        });

        test('unstyle does nothing if no style specified', function() {
            var element = document.createElement('span');
            Dom.style(element, {color:'red'});
            Dom.unstyle(element);
            equal(element.style.color, 'red');
        });

        test('unstyle removes the specified attributes', function() {
            var element = document.createElement('span');
            Dom.style(element, { color: 'red' });
            Dom.unstyle(element, { color: 'red' });
            equal(element.style.cssText, '');
        });

        test('createElement creates element', function() {
            var element = Dom.create(document, 'span');
            ok(undefined !== element);
            equal(element.tagName.toLowerCase(), 'span');
        });

        test('createElement creates element and sets attributes', function() {
            var element = Dom.create(document, 'span', {className:'test'});
            equal(element.className, 'test');
        });
        
        test('createElement can set style', function() {
            var element = Dom.create(document, 'span', { style: {color:'red'}});
            equal(element.style.color, 'red');
        });

        test('change tag updates the element tag name', function() {
            var source = Dom.create(document, 'div');
            document.body.appendChild(source);
            var result = Dom.changeTag(source, 'span');
            equal(result.tagName.toLowerCase(), 'span');
            equal(result.parentNode, document.body);
        });

        test('change tag clones attributes', function() {
            var source = Dom.create(document, 'div', {className:'test'});
            document.body.appendChild(source);
            
            var result = Dom.changeTag(source, 'span');
            equal(result.className, 'test');
        });
        
        test('change tag clones style', function() {
            var source = Dom.create(document, 'div', { style: {textAlign:'center'}});
            
            document.body.appendChild(source);
            var result = Dom.changeTag(source, 'span');
            equal(result.style.textAlign, 'center');
        });

        test('find last text node single node', function() {
            var node = Dom.create(document, 'div');
            node.innerHTML = 'foo';

            equal(Dom.lastTextNode(node), node.firstChild);
        });
        
        test('find last text node when it is first', function() {
            var node = Dom.create(document, 'div');
            node.innerHTML = 'foo<span></span>';
            
            equal(Dom.lastTextNode(node), node.firstChild);
        });
        
        test('find last text node when it is child of child', function() {
            var node = Dom.create(document, 'div');
            node.innerHTML = '<span>foo</span>';
            
            equal(Dom.lastTextNode(node), node.firstChild.firstChild);
        });
        
        test('find last text returns null', function() {
            var node = Dom.create(document, 'div');
            node.innerHTML = '<span></span>';

            equal(Dom.lastTextNode(node), null);
        });

        test('find last text node first child of child', function() {
            var node = Dom.create(document, 'div');
            node.innerHTML = '<span>foo<span></span></span>';
            
            equal(Dom.lastTextNode(node), node.firstChild.firstChild);
        });

        test("normalize of empty node", function() {
            var node = Dom.create(document, "div");
            Dom.normalize(node);
            equal(node.childNodes.length, 0);
            equal(node.innerHTML, "");
        });        
        
        test("normalize one text node", function() {
            var node = Dom.create(document, "div");
            node.appendChild(document.createTextNode("foo"));
            Dom.normalize(node);
            equal(node.childNodes.length, 1);
            equal(node.innerHTML, "foo");
        });        
        
        test("normalize two text nodes", function() {
            var node = Dom.create(document, "div");
            node.appendChild(document.createTextNode("foo"));
            node.appendChild(document.createTextNode("bar"));
            Dom.normalize(node);
            equal(node.childNodes.length, 1);
            equal(node.innerHTML, "foobar");
        });        
        
        test("normalize mixed content nodes", function() {
            var node = Dom.create(document, "div");
            node.appendChild(document.createTextNode("foo"));
            node.appendChild(document.createTextNode("bar"));
            
            node.appendChild(document.createElement("span"));
            
            node.appendChild(document.createTextNode("foo"));
            node.appendChild(document.createTextNode("bar"));
            
            Dom.normalize(node);
            equal(node.childNodes.length, 3);
            equal(node.innerHTML.toLowerCase(), "foobar<span></span>foobar");
        });

</script>

</asp:Content>