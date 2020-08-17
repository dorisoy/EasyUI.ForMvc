﻿<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<script type="text/javascript">

    test("cancel fired when clicking cancel", function() {
        var cancelFired = false;
        uploadInstance = createUpload({ onCancel:
            function(e) {
                cancelFired = true;
            }
        });

        simulateFileSelect();
        $(".t-cancel", uploadInstance.wrapper).trigger("click");

        ok(cancelFired);
    });

    test("cancel event arguments contain list of files", function() {
        var files = false;
        uploadInstance = createUpload({ onCancel:
            function(e) {
                files = e.files;
            }
        });

        simulateFileSelect();
        $(".t-cancel", uploadInstance.wrapper).trigger("click");

        assertSelectedFile(files);
    });

</script>