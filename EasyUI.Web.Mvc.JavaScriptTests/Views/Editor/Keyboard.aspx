<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        Keyboard</h2>
    <%= Html.EasyUI().Editor().Name("Editor") %>
    <script type="text/javascript">
        var Keyboard;

        var editor;
    </script>
</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">


        QUnit.testStart = function() {
            Keyboard = $.easyui.editor.Keyboard;
            editor = $('#Editor').data('tEditor');
        }

        test('editor has keyboard', function() {
            ok(undefined !== editor.keyboard);
        });

        test('keydown calls clearTimeout', function() {
            
            var originalKeyDown = editor.keyboard.keydown;
            var originalClearTimeout = editor.keyboard.clearTimeout;
            try {
                editor.keyboard.keydown = function () {
                }
                var called = false;
                editor.keyboard.clearTimeout = function() {
                    called = true;
                }
                var e = new $.Event();
                e.keyCode = 18;
                e.type = 'keydown';
                
                $(editor.document).trigger(e);

                ok(called);
            } finally {
                editor.keyboard.keydown = originalKeyDown;
                editor.keyboard.clearTimeout = originalClearTimeout;
            }
        });
        test('keydown calls keyboard keydown', function() {
            var originalKeyDown = editor.keyboard.keydown;
            var originalClearTimeout = editor.keyboard.clearTimeout;
            try {
                
                var called = false;
                
                editor.keyboard.clearTimeout = function () {
                }

                editor.keyboard.keydown = function () {
                    called = true;
                }
                var e = new $.Event();
                e.keyCode = 18;
                e.type = 'keydown';

                $(editor.document).trigger(e);

                ok(called);
            } finally {
                editor.keyboard.keydown = originalKeyDown;
                editor.keyboard.clearTimeout = originalClearTimeout;
            }
        });
        test('keyup calls keyboard keyup', function() {
            var originalKeyUp = editor.keyboard.keyup;
            try {
                var called = false;

                editor.keyboard.keyup = function () {
                    called = true;
                }
                var e = new $.Event();
                e.keyCode = 18;
                e.type = 'keyup';

                $(editor.document).trigger(e);

                ok(called);
            } finally {
                editor.keyboard.keyup = originalKeyUp;
            }
        });

        test('isTypingKey returns true if char is typed', function() {
            var e = {
                keyCode: 'B'.charCodeAt(0)
            };

            var keyboard = new Keyboard();

            ok(keyboard.isTypingKey(e));
        });

        test('isTypingKey returns true if backspace is typed', function() {
            var e = {
                keyCode: 8
            };

            var keyboard = new Keyboard();

            ok(keyboard.isTypingKey(e));
        });

        test('isTypingKey returns true if delete is typed', function() {
            var e = {
                keyCode: 46
            };

            var keyboard = new Keyboard();

            ok(keyboard.isTypingKey(e));
        });

        test('isTypingKey returns false if ctrl and char is typed', function() {
            var e = {
                keyCode: 'B'.charCodeAt(0),
                ctrlKey: true
            };

            var keyboard = new Keyboard();

            ok(!keyboard.isTypingKey(e));
        });

        test('isTypingKey returns false if alt and char is typed', function() {
            var e = {
                keyCode: 'B'.charCodeAt(0),
                altKey: true
            };

            var keyboard = new Keyboard();

            ok(!keyboard.isTypingKey(e));
        });

        test('isTypingKey returns true if shift and char is typed', function() {
            var e = {
                keyCode: 'B'.charCodeAt(0),
                shiftKey: true
            };

            var keyboard = new Keyboard();

            ok(keyboard.isTypingKey(e));
        });

        test('isTypingKey returns false if shift and delete is typed', function() {
            var e = {
                keyCode: 46,
                shiftKey: true
            };

            var keyboard = new Keyboard();

            ok(!keyboard.isTypingKey(e));
        });

        test('isTypingKey returns false if ctrl and delete is typed', function() {
            var e = {
                keyCode: 46,
                ctrlKey: true
            };

            var keyboard = new Keyboard();

            ok(!keyboard.isTypingKey(e));
        });

        test('isTypingKey returns false if alt and delete is typed', function() {
            var e = {
                keyCode: 46,
                altKey: true
            };

            var keyboard = new Keyboard();

            ok(!keyboard.isTypingKey(e));
        });

        test('isTypingKey returns false if ctrl is typed', function() {
            var e = {
                keyCode: 17
            };

            var keyboard = new Keyboard();

            ok(!keyboard.isTypingKey(e));
        });

        test('isTypingKey returns false if shift is typed', function() {
            var e = {
                keyCode: 16
            };

            var keyboard = new Keyboard();

            ok(!keyboard.isTypingKey(e));
        });

        test('isTypingKey returns false if alt is typed', function() {
            var e = {
                keyCode: 18
            };

            var keyboard = new Keyboard();

            ok(!keyboard.isTypingKey(e));
        });

        test('typingInProgress returns false initially', function() {
            var keyboard = new Keyboard();

            ok(!keyboard.typingInProgress());
        });

        test('typingInProgress returns true after startTyping', function() {
            var keyboard = new Keyboard();

            keyboard.startTyping();
            ok(keyboard.typingInProgress());
        });

        test('typingInProgress returns false after endTyping', function() {
            var keyboard = new Keyboard();
            var original = window.setTimeout;

            keyboard.startTyping(function () { });
            try {

                window.setTimeout = function () {
                    arguments[0]();
                }

                keyboard.endTyping();
                ok(!keyboard.typingInProgress());
            } finally {
                window.setTimeout = original;
            }
        });
        test('typingInProgress does not immediately return false after endTyping', function() {
            var keyboard = new Keyboard();
            var original = window.setTimeout;

            keyboard.startTyping(function () { });
            try {

                window.setTimeout = function () {
                }

                keyboard.endTyping();
                ok(keyboard.typingInProgress());
            } finally {
                window.setTimeout = original;
            }
        });
        
        test('typingInProgress return false after forced endTyping', function() {
            var keyboard = new Keyboard();
            var original = window.setTimeout;

            keyboard.startTyping(function () { });
            try {

                window.setTimeout = function () {
                }

                keyboard.endTyping(true);
                ok(!keyboard.typingInProgress());
            } finally {
                window.setTimeout = original;
            }
        });

        test('end typing calls callback specified in start typing', function() {
            var keyboard = new Keyboard();
            var callbackInvoked = false;

            var original = window.setTimeout;
            try {

                window.setTimeout = function () {
                    arguments[0]();
                }

                keyboard.startTyping(function () {
                    callbackInvoked = true;
                });

                ok(!callbackInvoked);
                keyboard.endTyping();
                ok(callbackInvoked);
            } finally {
                window.setTimeout = original;
            }
        });
        
        test('endTyping creates timeout', function() {
            var original = window.setTimeout;

            try {
                var setTimeoutArgument;
                window.setTimeout = function () {
                    setTimeoutArgument = arguments[0];
                }

                var keyboard = new Keyboard();
                var callback = function () { }
                keyboard.startTyping(callback);
                keyboard.endTyping();
                ok(undefined !== setTimeoutArgument);
            } finally {
                window.setTimeout = original;
            }
        });
        test('endTyping calls clear timeout', function() {
            var original = window.setTimeout;
            try {
                window.setTimeout = function () {
                }

                var keyboard = new Keyboard();
                var called = false;
                keyboard.clearTimeout = function() {
                    called = true;
                }
                keyboard.endTyping();
                ok(called);
            } finally {
                window.setTimeout = original;
            }
        });


        test('isModifierKey returns true for ctrl', function() {
            var keyboard = new Keyboard();
            ok(keyboard.isModifierKey({ keyCode: 17 }));
        });

        test('isModifierKey returns true for shift', function() {
            var keyboard = new Keyboard();
            ok(keyboard.isModifierKey({ keyCode: 16 }));
        });

        test('isModifierKey returns true for alt', function() {
            var keyboard = new Keyboard();
            ok(keyboard.isModifierKey({ keyCode: 18 }));
        });

        test('isModifierKey returns false for character', function() {
            var keyboard = new Keyboard();
            ok(!keyboard.isModifierKey({ keyCode: 'B'.charCodeAt(0) }));
        });

        test('isModifierKey returns false for character and ctrl', function() {
            var keyboard = new Keyboard();
            ok(!keyboard.isModifierKey({ keyCode: 'B'.charCodeAt(0), ctrlKey: true }));
        });

        test('isModifierKey returns false for ctrl and shift', function() {
            var keyboard = new Keyboard();
            ok(!keyboard.isModifierKey({ keyCode: 17, shiftKey: true }));
        });

        test('isModifierKey returns false for ctrl and alt', function() {
            var keyboard = new Keyboard();
            ok(!keyboard.isModifierKey({ keyCode: 17, altKey: true }));
        });

        test('isModifierKey returns false for shift and ctrl', function() {
            var keyboard = new Keyboard();
            ok(!keyboard.isModifierKey({ keyCode: 16, ctrlKey: true }));
        });

        test('isModifierKey returns false for shift and alt', function() {
            var keyboard = new Keyboard();
            ok(!keyboard.isModifierKey({ keyCode: 16, altKey: true }));
        });

        test('isModifierKey returns false for alt and ctrl', function() {
            var keyboard = new Keyboard();
            ok(!keyboard.isModifierKey({ keyCode: 18, ctrlKey: true }));
        });

        test('isModifierKey returns false for alt and shift', function() {
            var keyboard = new Keyboard();
            ok(!keyboard.isModifierKey({ keyCode: 18, shiftKey: true }));
        });

        test('isSystem returns true for ctrl and del', function() {
            var keyboard = new Keyboard();
            ok(keyboard.isSystem({ keyCode: 46, ctrlKey: true }));
        });
        
        test('isSystem returns false for ctrl and del and alt', function() {
            var keyboard = new Keyboard();
            ok(!keyboard.isSystem({ keyCode: 46, ctrlKey: true, altKey: true }));
        });

        test('isSystem returns false for ctrl and del and shift', function() {
            var keyboard = new Keyboard();
            ok(!keyboard.isSystem({ keyCode: 46, ctrlKey: true, shiftKey: true }));
        });

        test('keydown calls the keydown method of the handlers', function() {
            var calls = 0;
            var handlers = [
                { keydown: function () { calls++ } },
                { keydown: function () { calls++ } }
            ];

            var keyboard = new Keyboard(handlers);
            keyboard.keydown();
            equal(calls, 2)
        });

        test('keydown calls the keydown breaks if some handler returns true', function() {
            var calls = 0;
            var handlers = [
                { keydown: function () { calls++; return true; } },
                { keydown: function () { calls++ } }
            ];

            var keyboard = new Keyboard(handlers);
            keyboard.keydown();
            equal(calls, 1)
        });

        test('keydown passes the argument to handler', function() {
            var e = {};
            var arg;
            var handlers = [
                { keydown: function () { arg = arguments[0] } }
            ];

            var keyboard = new Keyboard(handlers);
            keyboard.keydown(e);
            equal(arg, e)
        });

        test('keyup calls the keydup method of the handlers', function() {
            var calls = 0;
            var handlers = [
                { keyup: function () { calls++ } },
                { keyup: function () { calls++ } }
            ];

            var keyboard = new Keyboard(handlers);
            keyboard.keyup();
            equal(calls, 2)
        });

        test('keyup calls the keyup breaks if some handler returns true', function() {
            var calls = 0;
            var handlers = [
                { keyup: function () { calls++; return true; } },
                { keyup: function () { calls++ } }
            ];

            var keyboard = new Keyboard(handlers);
            keyboard.keyup();
            equal(calls, 1)
        });

        test('keyup passes the argument to handler', function() {
            var e = {};
            var arg;
            var handlers = [
                { keyup: function () { arg = arguments[0] } }
            ];

            var keyboard = new Keyboard(handlers);
            keyboard.keyup(e);
            equal(arg, e)
        });

</script>

</asp:Content>