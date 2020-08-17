﻿<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<script type="text/javascript">

    // -----------------------------------------------------------------------------------
    // -----------------------------------------------------------------------------------
    test("success is fired when upload action succeeds", function() {
        var successFired = false;
        uploadInstance = createUpload({ onSuccess:
            function() {
                successFired = true;
            }
        });

        simulateUpload();

        ok(successFired);
    });

    test("success is fired on a subsequent upload after cancelling the upload event", function() {
        var successFired = false,
            shouldPreventUpload = true;
        uploadInstance = createUpload({
            onUpload: function(e) {
                if (shouldPreventUpload) {
                    e.preventDefault();
                }
            },
            onSuccess: function() {
                successFired = true;
            }
        });

        simulateFileSelect();
        shouldPreventUpload = false;
        simulateUpload();

        ok(successFired);
    });
 
    test("success event arguments contain upload operation name", function() {
        var operation;
        uploadInstance = createUpload({ onSuccess:
            function(e) {
                operation = e.operation;
            }
        });

        simulateUpload();

        equal(operation, "upload");
    });
   
    test("success event arguments contain list of uploaded files", function() {
        var files = null;
        uploadInstance = createUpload({ onSuccess:
            function(e) {
                files = e.files;
            }
        });

        simulateUpload();

        assertSelectedFile(files);
    });

    test("success event arguments contain server response", function() {
        var response = null;
        uploadInstance = createUpload({ onSuccess:
            function(e) {
                response = e.response;
            }
        });

        simulateUploadWithResponse(validJSON);

        equal(response.status, "OK");
    });

    test("success event arguments contain original XHR", function() {
        var xhr = null;
        uploadInstance = createUpload({ onSuccess:
            function(e) {
                xhr = e.XMLHttpRequest;
            }
        });

        simulateUploadWithResponse(validJSON);

        notEqual(xhr, null);
    });

    test("success event arguments contains XHR object with responseText", function() {
        var xhr = null;
        uploadInstance = createUpload({ onSuccess:
            function(e) {
                xhr = e.XMLHttpRequest;
            }
        });

        simulateUploadWithResponse(validJSON);

        equal(xhr.responseText, validJSON);
    });

    test("success event arguments contains XHR object with status", function() {
        var xhr = null;
        uploadInstance = createUpload({ onSuccess:
            function(e) {
                xhr = e.XMLHttpRequest;
            }
        });

        simulateUploadWithResponse(validJSON);

        equal(xhr.status, "200");
    });

    test("success event arguments contains XHR object with statusText", function() {
        var xhr = null;
        uploadInstance = createUpload({ onSuccess:
            function(e) {
                xhr = e.XMLHttpRequest;
            }
        });

        simulateUploadWithResponse(validJSON);

        equal(xhr.statusText, "OK");
    });

    // -----------------------------------------------------------------------------------
    // -----------------------------------------------------------------------------------
    test("success is fired when remove action succeeds", function() {
        var successFired;
        stop(1000);
        uploadInstance = createUpload({ onSuccess:
            function(e) {
                successFired = true;
            }
        });

        simulateUpload();
        successFired = false;
        simulateRemove();

        setTimeout(function() {
            ok(successFired);
            start();
        }, 100);
    });

    test("success event arguments contain list of removed files", function() {
        stop(1000);

        uploadInstance = createUpload({ onSuccess:
            function(e) {
                assertSelectedFile(e.files);
                start();
            }
        });

        simulateUpload();
        simulateRemove();
    });

    test("success event arguments contain remove operation name", function() {
        var operation = null;
        stop(1000);
        uploadInstance = createUpload({ onSuccess:
            function(e) {
                operation = e.operation;
            }
        });

        simulateUpload();
        simulateRemove();

        setTimeout(function() {
            equal(operation, "remove");
            start();
        }, 100);
    });

    test("success event arguments contain remove action response", function() {
        var data = null;
        stop(1000);
        uploadInstance = createUpload({ onSuccess:
            function(e) {
                data = e.response;
            }
        });

        simulateUpload();
        simulateRemoveWithResponse(validJSON);

        setTimeout(function() {
            equal(data.status, "OK");
            start();
        }, 100);
    });

    test("success event arguments contain original XHR for remove action", function() {
        var xhr = null;
        stop(1000);
        uploadInstance = createUpload({ onSuccess:
            function(e) {
                xhr = e.XMLHttpRequest;
            }
        });

        simulateUpload();
        xhr = null;
        simulateRemove();

        setTimeout(function() {
            notEqual(xhr, null);
            start();
        }, 100);
    });
    
    test("success event arguments contain XHR with responseText for remove action", function() {
        var responseText;
        stop(1000);
        uploadInstance = createUpload({ onSuccess:
            function(e) {
                responseText = e.XMLHttpRequest.responseText;
            }
        });

        simulateUpload();
        simulateRemoveWithResponse(validJSON);

        setTimeout(function() {
            equal(responseText, validJSON);
            start();
        }, 100);
    });
    
    test("success event arguments contain XHR with status for remove action", function() {
        var status;
        stop(1000);
        uploadInstance = createUpload({ onSuccess:
            function(e) {
                status = e.XMLHttpRequest.status;
            }
        });

        simulateUpload();
        simulateRemove();

        setTimeout(function() {
            equal(status, "200");
            start();
        }, 100);
    });

</script>