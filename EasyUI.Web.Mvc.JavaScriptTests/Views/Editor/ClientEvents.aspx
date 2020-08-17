<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <%= Html.EasyUI().Editor()
              .Name("Editor")
              .Value("foo")
              .ClientEvents(events => events
                  .OnLoad("onLoad")
                  .OnSelectionChange("onSelectionChange")
                  .OnChange("onChange")
                  .OnExecute("onExecute"))
    %>
    <script type="text/javascript">
        var editor;

        function getEditor() {
            return $('#Editor').data("tEditor");
        }

        function onLoad() {
            loadRaised = true;
        }

        function onSelectionChange() {
            onSelectionChangeRaised = true;
        }

        function onChange() {
            onChangeRaised = true;
        }

        function onExecute() {
            onExecuteRaised = true;
        }

        var changeRaised = false;
        var loadRaised = false;
        var onSelectionChangeRaised = false;
        var onChangeRaised = false;
        var onExecuteRaised = false;

        function type(keyCode, ctrl, alt, shift) {
            var e = $.Event();
            e.keyCode = keyCode;
            e.ctrlKey = !!ctrl;
            e.altKey = !!alt;
            e.shiftKey = !!shift;
            e.type = 'keyup';

            var editor = getEditor();
            $(editor.document).trigger(e);
        }

    </script>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">

        module("Editor / ClientEvents", {
            setup: function() {
                changeRaised = false;
                editor = getEditor();

                $(editor.element).bind('selectionChange', function () {
                    changeRaised = true;
                });

                editor.focus();
            }
        });

        test('onChange executed', function() {
            editor.value('bar');
            editor.body.innerHTML = 'foo';
            $(editor.window).trigger('blur');
            ok(onChangeRaised);
        });

        test('onload executed', function() {
            ok(loadRaised);
        });

        test('on selection change executed', function() {
            onSelectionChangeRaised = false;
            $(getEditor().element).trigger('selectionChange');
            ok(onSelectionChangeRaised);
        });

        test('exec raises onExecute', function() {
            editor.exec('undo');
            ok(onExecuteRaised);
        });

        test('up arrow raises selection change', function() {
            type(38);

            ok(changeRaised);
        });

        test('mouseup raises selection change', function() {
            $(getEditor().document).mouseup();
            ok(changeRaised);
        });

        test('down arrow raises selection change', function() {
            type(40);

            ok(changeRaised);
        });

        test('left arrow raises selection change', function() {
            type(37);

            ok(changeRaised);
        });

        test('right arrow raises selection change', function() {
            type(39);

            ok(changeRaised);
        });

        test('home raises selection change', function() {
            type(36);

            ok(changeRaised);
        });

        test('end raises selection change', function() {
            type(35);

            ok(changeRaised);
        });

        test('pgup raises selection change', function() {
            type(33);

            ok(changeRaised);
        });

        test('pgdown raises selection change', function() {
            type(34);

            ok(changeRaised);
        });

        test('insert raises selection change', function() {
            type(45);

            ok(changeRaised);
        });

        test('backspace raises selection change', function() {
            type(9);

            ok(changeRaised);
        });
        
        test('ctrl+a raises selection change', function() {
            type(65, true);

            ok(changeRaised);
        });
        
        test('ctrl+shift+a, ctrl+alt+a, and ctrl+shift+alt+a do not raise selection change', function() {
            type(65, true, true);
            type(65, true, false, true);
            type(65, true, true, true);

            ok(!changeRaised);
        });

        test('exec raises selection change', function() {
            var editor = getEditor();
            editor.value('foo');
            var range = editor.createRange();
            range.selectNodeContents(editor.body.firstChild);
            editor.getSelection().removeAllRanges();
            editor.getSelection().addRange(range);

            editor.exec('bold');
            ok(changeRaised);
        });

        test('undo raises selection change', function() {
            var editor = getEditor();
            editor.exec('undo');

            ok(changeRaised);
        });

        test('redo raises selection change', function() {
            var editor = getEditor();
            editor.exec('redo');

            ok(changeRaised);
        });
        
        test('exec supplies command name and object', function() {
            var e;
            $(editor.element).bind('execute', function() {
                e = arguments[0];
            });

            editor.value('foo');
            var range = editor.createRange();
            range.selectNodeContents(editor.body.firstChild);
            editor.getSelection().removeAllRanges();
            editor.getSelection().addRange(range);

            editor.exec('bold');

            equal(e.name, 'bold');
            ok(e.command instanceof $.easyui.editor.FormatCommand);
        });

    </script>

</asp:Content>