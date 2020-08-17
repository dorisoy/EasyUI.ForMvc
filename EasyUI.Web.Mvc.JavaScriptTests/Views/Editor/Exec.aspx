<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<EasyUI.Web.Mvc.JavaScriptTests.Customer>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Exec</h2>

    <%= Html.EasyUI().Editor().Name("Editor1") %>

    <iframe src="<%= Url.Action("Toolbar", "Editor") %>"></iframe>

    <script type="text/javascript">
        var editor;

        function getEditor() {
            return $('#Editor1').data("tEditor");
        }

        function assertCommand(type, name) {
            var original = editor.undoRedoStack.push
            try {
                var command;
                editor.value('foo');
                var range = editor.createRange();
                range.selectNodeContents(editor.body);
                editor.getSelection().removeAllRanges();
                editor.getSelection().addRange(range);
                editor.undoRedoStack.push = function () {
                    command = arguments[0];
                }
                editor.exec(name);

                ok(command instanceof type);
            } finally {
                editor.undoRedoStack.push = original;
            }
        }
    </script>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



        QUnit.testStart = function() {
            editor = getEditor();
            editor.focus();
        }
        
        test('exec pushes command to undo stack', function() {
            editor.value('foo');
            var range = editor.createRange();
            range.selectNodeContents(editor.body.firstChild);
            editor.getSelection().removeAllRanges();
            editor.getSelection().addRange(range);
            
            var pushArgument;

            editor.undoRedoStack.push = function() { pushArgument = arguments[0] }
            
            editor.exec('bold');

            ok(undefined !== pushArgument);
        });
        
        test('exec undo performs undo', function() {
            var original = editor.undoRedoStack.undo;
            try {
                var undoIsCalled = false;
                editor.undoRedoStack.undo = function() { undoIsCalled = true; }
                editor.exec('undo');

                ok(undoIsCalled);
            } finally {
                editor.undoRedoStack.undo = original;
            }
        });
        
        test('exec redo performs redo', function() {
            

            var original = editor.undoRedoStack.redo;
            try {
                var redoIsCalled = false;
                editor.undoRedoStack.redo = function () { redoIsCalled = true; }
                editor.exec('redo');

                ok(redoIsCalled);
            } finally {
                editor.undoRedoStack.redo = original;
            }
        });

        test('exec inline command', function() {
            $.each(['bold', 'italic', 'underline', 'strikethrough'], function() {
                assertCommand($.easyui.editor.FormatCommand, this);
            });
        });
        
        test('exec unordered list', function() {
            assertCommand($.easyui.editor.ListCommand, 'insertUnorderedList');
        });
        
        test('exec ordered list', function() {
            assertCommand($.easyui.editor.ListCommand, 'insertOrderedList');
        });

        test('exec block command', function() {
            $.each(['justifyCenter', 'justifyLeft', 'justifyRight', 'justifyFull'], function() {
                assertCommand($.easyui.editor.FormatCommand, this);
            });
        });

        test('exec insertLineBreak creates newLineCommand', function() {
            assertCommand($.easyui.editor.NewLineCommand, 'insertLineBreak');
        });
        
        test('exec insertParagraph creates paragraph command', function() {
            assertCommand($.easyui.editor.ParagraphCommand, 'insertParagraph');
        });

        test('exec createLink creates LinkCommand', function() {
            assertCommand($.easyui.editor.LinkCommand, 'createLink');
        });
        
        test('exec unlink creates UnlinkCommand', function() {
            assertCommand($.easyui.editor.UnlinkCommand, 'unlink');
        });
       
        test('exec insertImage creates image command', function() {
            assertCommand($.easyui.editor.ImageCommand, 'insertImage');
        });

        test('exec indent creates indent command', function() {
            assertCommand($.easyui.editor.IndentCommand, 'indent');
        });

        test('exec outdent creates indent command', function() {
            assertCommand($.easyui.editor.OutdentCommand, 'outdent');
        });

</script>

</asp:Content>