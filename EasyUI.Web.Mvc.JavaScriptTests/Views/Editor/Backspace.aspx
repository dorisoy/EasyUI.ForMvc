<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

       <%= Html.EasyUI().Editor()
              .Name("Editor")
              .Value("foo")     
      %>

</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

        function getEditor() {
            return $('#Editor').data("tEditor");
        }
        
        var editor;

        module("Editor / Backspace", {
            setup: function() {
                editor = getEditor();
                editor.focus();
            }
        });

        // the keyboard event can be triggered only in mozilla
        if ($.browser.mozilla) {

            function triggerBackspace() {
                var keyEvent = editor.document.createEvent("KeyboardEvent");
                keyEvent.initKeyEvent("keydown", true, true, null, false, false, false, false, 8, 0);
                editor.document.dispatchEvent(keyEvent);
                keyEvent.initKeyEvent("keyup", true, true, null, false, false, false, false, 8, 0);
                editor.document.dispatchEvent(keyEvent);
                keyEvent.initKeyEvent("keypress", true, true, null, false, false, false, false, 8, 0);
                editor.document.dispatchEvent(keyEvent);
            }

            test('hitting backspace deletes text content', function() {
                editor.value('<p></p><p>f</p>');
                var range = editor.createRange();
                range.setStart(editor.body.lastChild.firstChild, 1);
                range.collapse(true);

                editor.selectRange(range);

                triggerBackspace();
                editor.getRange().insertNode(editor.document.createElement('a'));

                equals(editor.value(), '<p></p><p><a></a></p>');
            });

            test('hitting backspace deletes current empty paragraph and moves to previous one', function() {
                editor.value('<p></p><p></p>');
                var range = editor.createRange();
                range.setStart(editor.body.lastChild, 0);
                range.collapse(true);

                editor.selectRange(range);

                triggerBackspace();

                range = editor.getRange();

                equals(range.startContainer, editor.body.firstChild);
                equals(range.startOffset, 0);
                equals(range.collapsed, true);
            });
        }

        test('dummy', function() { ok(true) });
</script>

</asp:Content>