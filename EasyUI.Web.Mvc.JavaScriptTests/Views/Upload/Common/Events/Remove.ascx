﻿<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<script type="text/javascript">

    test("remove fired when clicking remove", function() {
        var removeFired = false;
        uploadInstance = createUpload({ onRemove:
            function(e) {
                removeFired = true;
            }
        });

        simulateUpload();
        simulateRemove();

        ok(removeFired);
    });

    test("remove event arguments contain list of files", function() {
        var files = false;
        uploadInstance = createUpload({ onRemove:
            function(e) {
                files = e.files;
            }
        });

        simulateUpload();
        simulateRemove();

        assertSelectedFile(files);
    });

    test("user data set in remove event is sent to server", 1, function() {
        var files = false;
        uploadInstance = createUpload({ onRemove:
            function(e) {
                e.data = { id: 1 };
            }
        });

        simulateUpload();

        $.mockjax(function(s) {
            equals(s.data.id, 1);
            return {
                url: "/removeAction",
                responseTime: 0,
                responseText: ""
            };
        });

        simulateRemoveClick();
    });

    test("cancelling remove aborts remove operation", function() {
        uploadInstance = createUpload({ onRemove:
            function(e) {
                e.preventDefault();
            }
        });

        var removeCalled = false;
        uploadInstance._submitRemove = function(data, onSuccess) {
            removeCalled = true;
        };

        simulateUpload();
        simulateRemove();

        ok(!removeCalled);
    });

</script>