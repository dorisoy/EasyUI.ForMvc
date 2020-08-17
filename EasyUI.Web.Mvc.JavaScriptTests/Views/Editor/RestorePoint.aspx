<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <%= Html.EasyUI().Editor().Name("Editor1") %>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">
        var RestorePoint;
        var editor;
        var htmlTagIsFirstChild;

        function getEditor() {
            return $('#Editor1').data("tEditor");
        }

        /***************************************************************************/

        function crossBrowserOffset(offset) {
            if (htmlTagIsFirstChild)
                return offset;
            
            var indices = offset.split(',');
            indices.pop(); 
            indices.push(1); // in IE the <html> element is not the first child but the second (after the DOCTYPE)
            return indices.join(',');
        }

        module("Editor / RestorePoint", {
            setup: function() {
                RestorePoint = $.easyui.editor.RestorePoint;
                editor = getEditor();

                htmlTagIsFirstChild = editor.document.firstChild == editor.body.parentNode;
            }
        });
        
        test('restorePoint initializes for body', function() {
            editor.value('<p>foo</p>');

            var range = editor.createRange();
            range.selectNode(editor.body.firstChild);
            
            var restorePoint = new RestorePoint(range);
            
            equal(restorePoint.startContainer.length, 2);
            equal(restorePoint.startOffset, 0);
            equal(restorePoint.endContainer.length, 2);
            equal(restorePoint.endOffset, 1);
        });
        
        test('restorePoint initializes for root node', function() {
            editor.value('<p>foo</p>');

            var range = editor.createRange();
            range.selectNodeContents(editor.body.firstChild);
            
            var restorePoint = new RestorePoint(range);
            
            equal(restorePoint.startContainer.toString(), crossBrowserOffset('0,1,0'));
            equal(restorePoint.startOffset, 0);
            equal(restorePoint.endContainer.toString(), crossBrowserOffset('0,1,0'));
            equal(restorePoint.endOffset, 1);
        });
        
        test('restorePoint initializes for root node contents', function() {
            editor.value('<p>foo</p>');

            var range = editor.createRange();
            range.setStart(editor.body.firstChild.firstChild, 0);
            range.setEnd(editor.body.firstChild.firstChild, 3);
            
            var restorePoint = new RestorePoint(range);
            
            equal(restorePoint.startContainer.toString(), crossBrowserOffset('0,0,1,0'));
            equal(restorePoint.startOffset, 0);
            equal(restorePoint.endContainer.toString(), crossBrowserOffset('0,0,1,0'));
            equal(restorePoint.endOffset, 3);
        });
        
        test('restorePoint initializes for different start and end containers', function() {

            editor.value('<p>foo</p><p>bar</p>');

            var range = editor.createRange();
            range.setStart(editor.body.firstChild.firstChild, 1);
            range.setEnd(editor.body.lastChild.firstChild, 2);
            
            var restorePoint = new RestorePoint(range);
            
            equal(restorePoint.startContainer.toString(), crossBrowserOffset('0,0,1,0'));
            equal(restorePoint.startOffset, 1);
            equal(restorePoint.endContainer.toString(), crossBrowserOffset('0,1,1,0'));
            equal(restorePoint.endOffset, 2);
        });
        
        test('toRange returns body range', function() {

            editor.value('<p>foo</p>');

            var range = editor.createRange();
            range.selectNode(editor.body.firstChild);

            var restorePoint = new RestorePoint(range);

            range.collapse(true);
            
            var restorePointRange = restorePoint.toRange();
            
            equal(restorePointRange.startContainer, editor.body);
            equal(restorePointRange.startOffset, 0);
            equal(restorePointRange.endContainer, editor.body);
            equal(restorePointRange.endOffset, 1);
        });
        
        test('toRange returns root node', function() {
            editor.value('<p>foo</p>');

            var range = editor.createRange();
            range.selectNodeContents(editor.body.firstChild);

            var restorePoint = new RestorePoint(range);

            range.collapse(true);
            
            var restorePointRange = restorePoint.toRange();
            
            equal(restorePointRange.startContainer, editor.body.firstChild);
            equal(restorePointRange.startOffset, 0);
            equal(restorePointRange.endContainer, editor.body.firstChild);
            equal(restorePointRange.endOffset, 1);
        });
        
        test('toRange returns root node contents', function() {
            editor.value('<p>foo</p>');

            var range = editor.createRange();
            range.setStart(editor.body.firstChild.firstChild, 0);
            range.setEnd(editor.body.firstChild.firstChild, 3);

            var restorePoint = new RestorePoint(range);

            range.collapse(true);
            
            var restorePointRange = restorePoint.toRange();
            
            equal(restorePointRange.startContainer, editor.body.firstChild.firstChild);
            equal(restorePointRange.startOffset, 0);
            equal(restorePointRange.endContainer, editor.body.firstChild.firstChild);
            equal(restorePointRange.endOffset, 3);
        });
        
        test('toRange returns different start and end containers', function() {

            editor.value('<p>foo</p><p>bar</p>');

            var range = editor.createRange();
            range.setStart(editor.body.firstChild.firstChild, 1);
            range.setEnd(editor.body.lastChild.firstChild, 2);

            var restorePoint = new RestorePoint(range);

            range.collapse(true);
            
            var restorePointRange = restorePoint.toRange();
            
            equal(restorePointRange.startContainer, editor.body.firstChild.firstChild);
            equal(restorePointRange.startOffset, 1);
            equal(restorePointRange.endContainer, editor.body.lastChild.firstChild);
            equal(restorePointRange.endOffset, 2);
        });
        
        test('toRange does not modify restore point', function() {
            editor.value('<p>foo</p><p>bar</p>');

            var range = editor.createRange();
            range.setStart(editor.body.firstChild.firstChild, 1);
            range.setEnd(editor.body.lastChild.firstChild, 2);

            var restorePoint = new RestorePoint(range);
            
            restorePoint.toRange();
            
            equal(restorePoint.startContainer.toString(), crossBrowserOffset('0,0,1,0'));
            equal(restorePoint.startOffset, 1);
            equal(restorePoint.endContainer.toString(), crossBrowserOffset('0,1,1,0'));
            equal(restorePoint.endOffset, 2);
        });

        test('denormalized content', function() {
            editor.value('');
            var node = editor.document.createTextNode('foo');
            editor.body.appendChild(node);
            node = editor.document.createTextNode('bar');
            editor.body.appendChild(node);
            var range = editor.createRange();
            range.setStart(node, 3);
            range.collapse(true);
            var restorePoint = new RestorePoint(range);
            equal(restorePoint.startContainer.toString(), crossBrowserOffset('0,1,0'));
            equal(restorePoint.startOffset, 6);

            range = restorePoint.toRange();
            equal(range.startContainer.nodeValue, node.nodeValue);
            equal(range.startOffset, 3);
            ok(range.collapsed);
        });

    </script>

</asp:Content>