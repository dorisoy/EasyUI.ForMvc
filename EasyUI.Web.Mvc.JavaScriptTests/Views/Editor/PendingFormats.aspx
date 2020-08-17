<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <%= Html.EasyUI().Editor().Name("Editor") %>

</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">

        var editor, PendingFormats;

        module("Editor / PendingFormats", {
            setup: function() {
                PendingFormats = $.easyui.editor.PendingFormats;
                editor = $('#Editor').data('tEditor');
                editor.focus();
            }
        });

        test('pending formats are empty by default', function() {
            var pendingFormats = new PendingFormats(editor);

            equals(pendingFormats.hasPending(), 0);
        });

        test('toggle() toggles pending format', function() {
            var pendingFormats = new PendingFormats(editor);

            pendingFormats.toggle({ name: 'italic', params: undefined });
            
            ok(pendingFormats.hasPending());

            pendingFormats.toggle({ name: 'italic', params: undefined });
            
            ok(!pendingFormats.hasPending());
        });

        test('toggle() toggles multiple formats', function() {
            var pendingFormats = new PendingFormats(editor);

            pendingFormats.toggle({ name: 'italic', params: undefined });
            
            ok(pendingFormats.hasPending());

            pendingFormats.toggle({ name: 'bold', params: undefined });
            
            ok(pendingFormats.hasPending());
        });

        test('toggle() replaces format values, if any', function() {
            var pendingFormats = new PendingFormats(editor);

            pendingFormats.toggle({ name: 'fontsize', params: { value: 'xx-large' }, command: editor.tools.fontSize.command });
            
            ok(pendingFormats.hasPending());

            pendingFormats.toggle({ name: 'fontsize', params: { value: 'xx-small' }, command: editor.tools.fontSize.command });
            
            equals(pendingFormats.getPending('fontsize').params.value, 'xx-small');
            ok(pendingFormats.hasPending());

            pendingFormats.toggle({ name: 'fontsize', params: { value: 'xx-small' }, command: editor.tools.fontSize.command });
            
            ok(!pendingFormats.hasPending());
        });

        test('clear() removes all pending formats', function() {
            var pendingFormats = new PendingFormats(editor);

            pendingFormats.toggle({ name: 'italic', params: undefined });

            pendingFormats.clear();
            
            ok(!pendingFormats.hasPending());
        });

        test('apply() applies pending format to range', function() {
            var pendingFormats = new PendingFormats(editor);
            
            pendingFormats.toggle({ name: 'italic', params: undefined, command: editor.tools.italic.command });

            editor.value('foo');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 1);
            range.setStart(editor.body.firstChild, 2);

            pendingFormats.apply(range);

            equals(editor.value(), 'f<em>o</em>o');
        });

        test('apply() applies multiple pending formats to range', function() {
            var pendingFormats = new PendingFormats(editor);
            
            pendingFormats.toggle({ name: 'italic', params: undefined, command: editor.tools.italic.command });
            pendingFormats.toggle({ name: 'bold', params: undefined, command: editor.tools.bold.command });

            editor.value('foo');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 1);
            range.setStart(editor.body.firstChild, 2);

            pendingFormats.apply(range);

            equals(editor.value(), 'f<em><strong>o</strong></em>o');
        });

        test('apply() focuses end of format after apply', function() {
            var pendingFormats = new PendingFormats(editor);
            
            pendingFormats.toggle({ name: 'italic', params: undefined, command: editor.tools.italic.command });

            editor.value('foo');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 1);
            range.setStart(editor.body.firstChild, 2);

            pendingFormats.apply(range);

            range.insertNode(editor.document.createElement('a'));

            equals(editor.value(), 'f<em>o<a></a></em>o');
        });

        test('apply() removes pending format to range', function() {
            var pendingFormats = new PendingFormats(editor);
            
            pendingFormats.toggle({ name: 'bold', params: undefined, command: editor.tools.bold.command });

            editor.value('<strong>foo</strong>');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild.firstChild, 1);
            range.setStart(editor.body.firstChild.firstChild, 2);

            pendingFormats.apply(range);

            equals(editor.value(), '<strong>f</strong>o<strong>o</strong>');
        });

        test('apply() removes multiple pending formats to range', function() {
            var pendingFormats = new PendingFormats(editor);
            
            pendingFormats.toggle({ name: 'bold', params: undefined, command: editor.tools.bold.command });
            pendingFormats.toggle({ name: 'italic', params: undefined, command: editor.tools.italic.command });

            editor.value('<em><strong>foo</strong></em>');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild.firstChild.firstChild, 1);
            range.setStart(editor.body.firstChild.firstChild.firstChild, 2);

            pendingFormats.apply(range);

            equals(editor.value(), '<em><strong>f</strong></em>o<em><strong>o</strong></em>');
        });

        test('apply() focuses end of range after remove', function() {
            var pendingFormats = new PendingFormats(editor);
            
            pendingFormats.toggle({ name: 'bold', params: undefined, command: editor.tools.bold.command });
            pendingFormats.toggle({ name: 'italic', params: undefined, command: editor.tools.italic.command });

            editor.value('<em><strong>foo</strong></em>');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild.firstChild.firstChild, 1);
            range.setStart(editor.body.firstChild.firstChild.firstChild, 2);

            pendingFormats.apply(range);

            range = editor.getRange();

            ok(range.collapsed);

            range.insertNode(editor.document.createElement('a'));

            equals(editor.value(), '<em><strong>f</strong></em>o<a></a><em><strong>o</strong></em>');
        });

        test('apply() applies format on whitespace nodes', function() {
            var pendingFormats = new PendingFormats(editor);
            
            pendingFormats.toggle({ name: 'bold', params: undefined, command: editor.tools.bold.command });

            editor.value('f o');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 2);
            range.setStart(editor.body.firstChild, 2);

            pendingFormats.apply(range);

            equals(editor.value(), 'f o');

            ok(pendingFormats.hasPending());

            range = editor.getRange();
            
            ok(range.collapsed);

            range.insertNode(editor.document.createElement('a'));

            equals(editor.value(), 'f <a></a>o');
        });

        test('apply() removes format on whitespace nodes', function() {
            var pendingFormats = new PendingFormats(editor);
            
            pendingFormats.toggle({ name: 'bold', params: undefined, command: editor.tools.bold.command });

            editor.value('<strong>f</strong>oo');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild, 1);
            range.setStart(editor.body.firstChild, 1);

            pendingFormats.apply(range);

            equals(editor.value(), 'foo');

            ok(!pendingFormats.hasPending());

            range = editor.getRange();
            
            ok(range.collapsed);

            range.insertNode(editor.document.createElement('a'));

            equals(editor.value(), 'f<a></a>oo');
        });

        test('apply() removes format at start of node', function() {
            var pendingFormats = new PendingFormats(editor);
            
            pendingFormats.toggle({ name: 'bold', params: undefined, command: editor.tools.bold.command });

            editor.value('<strong>af</strong>oo');
            var range = editor.createRange();
            range.setStart(editor.body.firstChild.firstChild, 1);
            range.setStart(editor.body.firstChild.firstChild, 1);

            pendingFormats.apply(range);

            equals(editor.value(), 'a<strong>f</strong>oo');

            ok(!pendingFormats.hasPending());

            range = editor.getRange();
            
            ok(range.collapsed);

            range.insertNode(editor.document.createElement('a'));

            equals(editor.value(), 'a<a></a><strong>f</strong>oo');
        });

        test('isPending() returns true if specified format is pending', function() {
            var pendingFormats = new PendingFormats(editor);
            
            pendingFormats.toggle({ name: 'bold', params: undefined });

            ok(pendingFormats.isPending('bold'));

            pendingFormats.clear();

            ok(!pendingFormats.isPending('bold'));
        });

        test('getPending() returns specified format if it is pending', function() {
            var pendingFormats = new PendingFormats(editor);

            var format = { name: 'fontsize', params: { value: 'xx-large' }, command: editor.tools.fontSize.command };
            
            pendingFormats.toggle(format);
        
            equals(pendingFormats.getPending('fontsize'), format);
        });
    </script>

</asp:Content>