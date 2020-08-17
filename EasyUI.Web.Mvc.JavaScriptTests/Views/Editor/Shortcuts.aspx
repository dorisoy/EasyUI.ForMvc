<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Shortcuts</h2>
    <%= Html.EasyUI().Editor().Name("Editor") %>

    <script type="text/javascript">
        var editor;

        function makeEvent(keyCode) {
            var e = new $.Event();
            e.keyCode = keyCode ? keyCode : 'B'.charCodeAt(0);
            e.shiftKey = false;
            e.ctrlKey = false;
            e.altKey = false;
            return e;
        }
    </script>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">


        
        QUnit.testStart = function() {
            editor = $('#Editor').data('tEditor')
        }


        test('find shorcut by single character', function() {
            var commands = {bold:{key:'B'}}

            var e = makeEvent();
                
            var command = editor.keyboard.toolFromShortcut(commands, e);

            equal(command, 'bold');
        });

        test('find shorcut with ctrl', function() {
            var commands = { bold: { ctrl: true, key: 'B' } };

            var e = makeEvent();
            e.ctrlKey = true;
            
            var command = editor.keyboard.toolFromShortcut(commands, e);

            equal(command, 'bold');
        });

        test('should not find shorcut with ctrl when ctrl is not pressed', function() {
            var commands = { bold: { ctrl: true, key: 'B'} };

            var e = makeEvent();

            var command = editor.keyboard.toolFromShortcut(commands, e);

            ok(undefined === command);
        });
        
        test('should find shortcut with alt', function() {
            var commands = { bold: { alt: true, key: 'B' } };

            var e = makeEvent();
            e.altKey = true;

            var command = editor.keyboard.toolFromShortcut(commands, e);

            equal(command, 'bold');
        });
        
        test('should find shortcut with shift', function() {
            var commands = { bold: { shift: true, key: 'B'} };

            var e = makeEvent();
            e.shiftKey  = true;

            var command = editor.keyboard.toolFromShortcut(commands, e);

            equal(command, 'bold');
        });

        test('should find shortcut with all modifiers shift', function() {
            var commands = { bold: { shift: true, alt: true, ctrl: true, key: 'B'} };

            var e = makeEvent();

            e.shiftKey = true;
            e.altKey = true;
            e.ctrlKey = true;

            var command = editor.keyboard.toolFromShortcut(commands, e);

            equal(command, 'bold');
        });

        test('editor dispatches shortcuts to exec', function() {
            var command = null;
            
            editor.exec = function() {
                command = arguments[0];
            }

            var e = makeEvent();
            e.ctrlKey = true;
            e.type = 'keydown';
            
            $(editor.document).trigger(e);

            equal(command, 'bold');
        });

        test('ctrl z calls undo', function() {
            var command = null;

            editor.exec = function () {
                command = arguments[0];
            }

            var e = makeEvent('Z'.charCodeAt(0));
            e.ctrlKey = true;
            e.type = 'keydown';

            $(editor.document).trigger(e);

            equal(command, 'undo');
        });
        
        test('ctrl y calls redo', function() {
            var command = null;

            editor.exec = function() {
                command = arguments[0];
            }

            var e = makeEvent('Y'.charCodeAt(0));
            e.ctrlKey = true;
            e.type = 'keydown';

            $(editor.document).trigger(e);

            equal(command, 'redo');
        });
        
        test('shift enter calls new line', function() {
            var command = null;

            editor.exec = function () {
                command = arguments[0];
            }

            var e = makeEvent(13);
            e.shiftKey = true;
            e.type = 'keydown';

            $(editor.document).trigger(e);

            equal(command, 'insertLineBreak');
        });

        test('enter calls paragraph', function() {
            var command = null;

            editor.exec = function () {
                command = arguments[0];
            }

            var e = makeEvent(13);
            e.type = 'keydown';

            $(editor.document).trigger(e);

            equal(command, 'insertParagraph');
        });

        test('editor prevents default if shortcut is known', function() {
            editor.exec = function() {};
            var e = makeEvent();
            e.ctrlKey = true;
            e.type = 'keydown';
            
            $(editor.document).trigger(e);

            ok(e.isDefaultPrevented());
        });

</script>

</asp:Content>