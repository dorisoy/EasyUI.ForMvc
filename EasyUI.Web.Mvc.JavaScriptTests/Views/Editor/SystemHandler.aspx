<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

     <%= Html.EasyUI().Editor().Name("Editor") %>
    
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

        var SystemHandler;

        var editor;

        module("Editor / SystemHandler", {
            setup: function() {
                SystemHandler = $.easyui.editor.SystemHandler;
                editor = $('#Editor').data('tEditor');
                editor.focus();
            }
        });

        test('keydown calls endTyping if typing in progress', function() {
             var force = false;
             editor.keyboard = {
                isModifierKey: function() { return true},
                endTyping: function () { force = arguments[0]; },
                startTyping: function () {},
                typingInProgress: function() { return true}
            };
            var handler = new SystemHandler(editor);
            handler.keydown();

            ok(force);
        });
        
        test('keydown does not call endTyping if not modifier key', function() {
            var called = false;
            editor.keyboard = {
                isModifierKey: function () { return false },
                isSystem:function() { return false},
                endTyping: function () { called = true },
                startTyping: function () { },
                typingInProgress: function () { return true }
            };

            var handler = new SystemHandler(editor);
            handler.keydown();

            ok(!called);
        });
        
        test('keydown does not call endTyping if typing not in progress', function() {
            var called = false;
            editor.keyboard = {
                isModifierKey: function() { return true},
                endTyping: function () { called = true; },
                startTyping: function () { },
                typingInProgress: function () { return true }
            };

            var handler = new SystemHandler(editor);
            handler.keydown();

            ok(called);
        });


        test('keydown if modifier key creates start restore point', function() {
            editor.keyboard = {
                isModifierKey: function() { return true},
                typingInProgress: function () { return false }
            };

            var handler = new SystemHandler(editor);
            handler.keydown();

            ok(undefined !== handler.startRestorePoint);
        });
        
        test('keydown returns true if modifier key', function() {
            editor.keyboard = {
                isModifierKey: function () { return true },
                typingInProgress: function () { return false }
            };

            var handler = new SystemHandler(editor);
            ok(handler.keydown())
        });

        test('keydown if system command and changed creates end restore point', function() {
            editor.keyboard = {
                isModifierKey: function () { return true },
                typingInProgress: function () { return false },
                isSystem:function(){ return true}
            };

            var handler = new SystemHandler(editor);
            handler.changed = function() {
                return true;
            }
            
            handler.keydown();
            editor.keyboard.isModifierKey = function() { return false};
            handler.keydown();

            ok(undefined !== handler.endRestorePoint);
        });
        
        test('keydown if system command and changed sets start restore point to end restore point', function() {
            editor.keyboard = {
                isModifierKey: function () { return true },
                typingInProgress: function () { return false },
                isSystem: function () { return true }
            };

            var handler = new SystemHandler(editor);
            handler.changed = function () {
                return true;
            }

            handler.keydown();
            editor.keyboard.isModifierKey = function () { return false };
            handler.keydown();

            equal(handler.startRestorePoint, handler.endRestorePoint);
        });
        test('keydown returns true if system command and changed', function() {
            editor.keyboard = {
                isModifierKey: function () { return true },
                typingInProgress: function () { return false },
                isSystem: function () { return true }
            };

            var handler = new SystemHandler(editor);
            handler.changed = function () {
                return true;
            }
            handler.keydown();
            editor.keyboard.isModifierKey = function() { return false};
            ok(handler.keydown());
        });

        test('keydown creates undo command if system command and changed', function() {
            editor.keyboard = {
                isModifierKey: function () { return true },
                typingInProgress: function () { return false },
                isSystem: function () { return true }
            };

            var handler = new SystemHandler(editor);
            handler.changed = function () {
                return false;
            }
            var command;
            
            editor.undoRedoStack.push = function() {
                command = arguments[0];
            }
            handler.keydown()
            editor.keyboard.isModifierKey = function() { return false};
            handler.changed = function () {
                return true;
            }
            handler.keydown()
            
            ok(undefined !== command);
        });

        test('changed returns false if editor contents remain the same', function() {
            editor.keyboard = {
                isModifierKey: function() { return true},
                typingInProgress: function () { return false }
            };

            var handler = new SystemHandler(editor);
            handler.keydown();

            ok(!handler.changed());
        });

        test('changed returns false if editor contents changed', function() {
            editor.keyboard = {
                isModifierKey: function () { return true },
                typingInProgress: function () { return false }
            };

            var handler = new SystemHandler(editor);
            handler.keydown();
            editor.body.innerHTML = 'foo';
            ok(handler.changed());
        });


        test('keyup creates undo command if system command and changed', function() {
            editor.keyboard = {
                isModifierKey: function () { return true },
                typingInProgress: function () { return false },
                isSystem: function () { return true }
            };

            var handler = new SystemHandler(editor);
            handler.changed = function () {
                return false;
            }
            var command;
            
            editor.undoRedoStack.push = function() {
                command = arguments[0];
            }
            
            handler.keydown()
            editor.keyboard.isModifierKey = function() { return false};
            handler.keydown()
            handler.changed = function () {
                return true;
            }
            
            handler.keyup()
            
            ok(undefined !== command);
        });

        
        test('keyup does not create undo command if system command and changed', function() {
            editor.keyboard = {
                isModifierKey: function () { return true },
                typingInProgress: function () { return false },
                isSystem: function () { return true }
            };

            var handler = new SystemHandler(editor);
            handler.changed = function () {
                return true;
            }
            var command;
            
            editor.undoRedoStack.push = function() {
                command = arguments[0];
            }
            
            handler.keyup()
            
            ok(undefined === command);
        });

</script>

</asp:Content>