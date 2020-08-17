<%@ Page Title="FormData (HTML5) Upload Tests" Language="C#" MasterPageFile="Upload.master"
    Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">
<script type="text/javascript">

        var uploadInstance,
            _getSupportsFormData,
            validJSON = "{\"status\":\"OK\"}",
            errorResponse = "ERROR!",
            lastFormData;

        function createUpload(options) {
            copyUploadPrototype();

            $('#uploadInstance').tUpload($.extend({ async:{"saveUrl":"javascript:;","removeUrl":"/removeAction",autoUpload:true} }, options));

            var uploadInstance = $('#uploadInstance').data("tUpload");
            uploadInstance._module.createFormData = function() {
                lastFormData = { };

                return {
                    append: function(name, value) {
                        lastFormData[name] = value;
                    }
                } };
            uploadInstance._module.postFormData = function(url, data, fileEntry) {
                fileEntry.data("request", { abort: function() { } });
            };

            return uploadInstance;
        }

        function simulateRequestSuccess(fileIndex, response) {
            uploadInstance._module.onRequestSuccess(
                { target: { responseText: response || "", statusText: "OK", status: "200" } },
                $(".t-file", uploadInstance.wrapper).eq(fileIndex)
            );
        }

        function simulateRequestError(fileIndex, response) {
            uploadInstance._module.onRequestError(
                { target: { responseText: response || "", statusText: "error", status: "500" } },
                $(".t-file", uploadInstance.wrapper).eq(fileIndex)
            );
        }

        function simulateUpload(index) {
            simulateFileSelect();
            simulateRequestSuccess(index || 0);
        }

        function simulateUploadError() {
            simulateFileSelect();
            simulateRequestError(0);
        }

        function simulateRemove() {
            $.mockjax({
                url: "/removeAction",
                responseTime: 0,
                responseText: ""
            });

            simulateRemoveClick();
        }

        function simulateRemoveWithResponse(response) {
            $.mockjax({
                url: "/removeAction",
                responseTime: 0,
                responseText: response
            });

            simulateRemoveClick();
        }

        function simulateRemoveError() {
            $.mockjax({
                url: "/removeAction",
                status: 500,
                responseTime: 0,
                responseText: errorResponse
            });

            simulateRemoveClick();
        }

        function simulateUploadWithResponse(response) {
            simulateFileSelect();
            simulateRequestSuccess(0, response);
        }

        function moduleSetup() {
            _getSupportsFormData = $.easyui.upload.prototype._getSupportsFormData;
            $.easyui.upload.prototype._getSupportsFormData = function() { return true; };
            $.easyui.upload.prototype._alert = function() { };
        }

        function moduleTeardown() {
            $.easyui.upload.prototype._getSupportsFormData = _getSupportsFormData;
            $.mockjaxClear();
        }

        // -----------------------------------------------------------------------------------
        // -----------------------------------------------------------------------------------
        module("Upload / FormDataUpload", {
            setup: function() {
                moduleSetup();
                uploadInstance = createUpload();
            },
            teardown: moduleTeardown
        });

        test("formData module is selected when FormData is supported", function() {
            equal(uploadInstance._module.name, "formDataUploadModule");
        });

        test("formData module is not selected when FormData is not supported", function() {
            $.easyui.upload.prototype._getSupportsFormData = function() { return false; };

            uploadInstance = createUpload();

            ok(uploadInstance._module.name != "formDataUploadModule");
        });

        test("current input is hidden after choosing a file", function() {
            simulateFileSelect();
            equal($("input:not(:visible)", uploadInstance.wrapper).length, 1);
        });

        test("list element is created for each selected file", function() {
            uploadInstance._module.getInputFiles = function () { return getFileListMock() };
            simulateFileSelect();
            equal($(".t-upload-files li.t-file", uploadInstance.wrapper).length, 2);
        });

        test("file names are rendered for multiple files", function() {
            uploadInstance._module.getInputFiles = function () { return getFileListMock() };
            simulateFileSelect();

            var fileNames = $(".t-filename", uploadInstance.wrapper).map(function() { return $(this).text(); });

            equal(fileNames[0], "first.txt");
            equal(fileNames[1], "second.txt");
        });

        test("clicking cancel should remove file entry", function() {
            var requestStopped = false;
            uploadInstance._module.stopUploadRequest = function() { requestStopped = true; };

            simulateFileSelect();
            $(".t-cancel", uploadInstance.wrapper).trigger("click");

            ok(requestStopped);
        });

        test("FormData is created when a file is selected", function() {
            var createFormDataCalled = false;
            uploadInstance._module.createFormData = function() { createFormDataCalled = true; }

            simulateFileSelect();
            ok(createFormDataCalled);
        });

        test("file is passed to createFormData", function() {
            var file = null;
            uploadInstance._module.createFormData = function(sourceFile) { file = sourceFile; }

            simulateFileSelect();
            equal(file.name, "first.txt");
        });

        test("postFormData is issued when file is selected", function() {
            var postFormDataCalled = false;
            uploadInstance._module.postFormData = function() { postFormDataCalled = true; };

            simulateFileSelect();
            ok(postFormDataCalled);
        });

        test("postFormData receives form data", function() {
            var formData = null;
            uploadInstance._module.createFormData = function() { return "data"; }
            uploadInstance._module.postFormData = function(url, data) { formData = data; };

            simulateFileSelect();
            equal(formData, "data");
        });

        test("original input is removed upon success", function() {
            uploadInstance.element.addClass("marker");
            simulateFileSelect();
            uploadInstance.element.removeClass("marker");

            var fileEntry = $(".t-file:first", uploadInstance.wrapper);

            uploadInstance._module.onRequestSuccess({ target: { responseText: "" } }, fileEntry);

            equal($(".marker", uploadInstance.wrapper).length, 0);
        });

        test("original input is removed after all uploads succeed", function() {
            uploadInstance._module.getInputFiles = function () { return getFileListMock() };

            uploadInstance.element.addClass("marker");
            simulateFileSelect();
            uploadInstance.element.removeClass("marker");

            var fileEntry = $(".t-file:nth-child(1)", uploadInstance.wrapper);
            uploadInstance._module.onRequestSuccess({ target: { responseText: "" } }, fileEntry);

            equal($(".marker", uploadInstance.wrapper).length, 1);

            fileEntry = $(".t-file:nth-child(2)", uploadInstance.wrapper);
            uploadInstance._module.onRequestSuccess({ target: { responseText: "" } }, fileEntry);

            equal($(".marker", uploadInstance.wrapper).length, 0);
        });

        test("original input is not removed if some uploads fail", function() {
            uploadInstance._module.getInputFiles = function () { return getFileListMock() };

            uploadInstance.element.addClass("marker");
            simulateFileSelect();
            uploadInstance.element.removeClass("marker");

            simulateRequestError(0);
            equal($(".marker", uploadInstance.wrapper).length, 1);

            simulateRequestSuccess(1);
            equal($(".marker", uploadInstance.wrapper).length, 1);
        });

        test("progress bar is rendered on first update", function() {
            simulateFileSelect();
            uploadInstance._module.onRequestProgress({ loaded: 1, total: 1}, $(".t-file", uploadInstance.wrapper));
            equal($(".t-upload-files .t-file .t-filename .t-progress", uploadInstance.wrapper).length, 1);
        })

        test("progress indicator is updated", function() {
            simulateFileSelect();

            uploadInstance._module.onRequestProgress({ loaded: 10, total: 100}, $(".t-file", uploadInstance.wrapper));
            equal($(".t-progress-status", uploadInstance.wrapper)[0].style.width, "10%");
        });

        test("postFormData is issued when clicking retry", function() {
            simulateUploadWithResponse(errorResponse);

            var postFormDataCalled = false;
            uploadInstance._module.postFormData = function() { postFormDataCalled = true; };

            $(".t-retry", uploadInstance.wrapper).trigger("click");

            ok(postFormDataCalled);
        });

        test("formData is not cleaned-up on failure (invalid response) to allow retry", function() {
            simulateUploadWithResponse(errorResponse);

            notEqual($(".t-file", uploadInstance.wrapper).data("formData"), null);
        });

        test("formData is not cleaned-up on failure (request error) to allow retry", function() {
            simulateUploadError(errorResponse);

            notEqual($(".t-file", uploadInstance.wrapper).data("formData"), null);
        });

</script>

<%= Html.Partial("Common/Async") %>
<%= Html.Partial("Common/Selection") %>
<%= Html.Partial("Common/AsyncNoMultiple") %>

<script type="text/javascript">

        // -----------------------------------------------------------------------------------
        // -----------------------------------------------------------------------------------
        module("Upload / FormDataUpload / autoUpload = false", {
            setup: function() {
                moduleSetup();
                uploadInstance = createUpload({ async: {"saveUrl": 'javascript:;', "removeUrl": 'javascript:;', autoUpload: false } });
            },
            teardown: moduleTeardown
        });

        test("upload doesn't start before upload button click", function() {
            var postFormDataCalled = false;
            uploadInstance._module.postFormData = function() { postFormDataCalled = true; };

            simulateFileSelect();

            ok(!postFormDataCalled);
        });

        test("upload starts on upload button click", function() {
            var postFormDataCalled = false;
            uploadInstance._module.postFormData = function() { postFormDataCalled = true; };

            simulateFileSelect();
            $(".t-upload-selected", uploadInstance.wrapper).trigger("click");

            ok(postFormDataCalled);
        });

        test("upload button is rendered on subsequent select", function() {
            simulateFileSelect();
            $(".t-upload-selected", uploadInstance.wrapper).trigger("click");
            uploadInstance._module.onRequestSuccess({ target: { responseText: "" } }, $(".t-file", uploadInstance.wrapper));
            simulateFileSelect();

            equal($(".t-upload-selected", uploadInstance.wrapper).length, 1);
        });

        test("upload button click does not start upload if it is already in progress", function() {
            simulateFileSelect();
            $(".t-upload-selected", uploadInstance.wrapper).trigger("click");

            var counter = 0;
            uploadInstance._module.performUpload = function(fileEntry) { counter++; }

            simulateFileSelect();
            $(".t-upload-selected", uploadInstance.wrapper).trigger("click");

            equal(counter, 1);
        });

        test("upload button click does not start upload after completion", function() {
            simulateFileSelect();
            $(".t-upload-selected", uploadInstance.wrapper).trigger("click");
            uploadInstance._module.onRequestSuccess({ target: { responseText: "" } }, $(".t-file", uploadInstance.wrapper));

            $(".t-file").addClass("complete");

            var counter = 0;
            uploadInstance._module.performUpload = function(fileEntry) {
                ok(fileEntry.is(":not(.complete)"), "performUpload should not be called for completed upload");
                counter++;
            }

            simulateFileSelect();
            $(".t-upload-selected", uploadInstance.wrapper).trigger("click");

            equal(counter, 1);
        });

        test("upload button click does not start upload after completion", function() {
            simulateFileSelect();
            $(".t-upload-selected", uploadInstance.wrapper).trigger("click");

            var postFormDataCalled = false;
            uploadInstance._module.postFormData = function() { postFormDataCalled = true; };

            $(".t-upload-selected", uploadInstance.wrapper).trigger("click");

            ok(!postFormDataCalled);
        });

        test("upload button click does not start upload if it is already in progress", function() {
            simulateFileSelect();
            $(".t-upload-selected", uploadInstance.wrapper).trigger("click");
            uploadInstance._module.onRequestSuccess({ target: { responseText: "" } }, $(".t-file", uploadInstance.wrapper));

            var postFormDataCalled = false;
            uploadInstance._module.postFormData = function() { postFormDataCalled = true; };

            $(".t-upload-selected", uploadInstance.wrapper).trigger("click");

            ok(!postFormDataCalled);
        });

        test("clicking remove should call remove action for completed files", function() {
            var removeCalled = false;
            uploadInstance._submitRemove = function(data, onSuccess) {
                removeCalled = true;
            };

            simulateFileSelect();
            $(".t-upload-selected", uploadInstance.wrapper).trigger("click");
            uploadInstance._module.onRequestSuccess({ target: { responseText: "" } }, $(".t-file", uploadInstance.wrapper));

            $(".t-delete", uploadInstance.wrapper).trigger("click");
            ok(removeCalled);
        });

        test("clicking remove should remove original file input", function() {
            uploadInstance.element.addClass("marker");
            simulateFileSelect();
            uploadInstance.element.removeClass("marker");

            simulateRemoveClick();

            equal($(".marker", uploadInstance.wrapper).length, 0);
        });

        test("clicking remove should remove original file input when all related files are removed", function() {
            uploadInstance._module.getInputFiles = function () { return getFileListMock() };

            uploadInstance.element.addClass("marker");
            simulateFileSelect();
            uploadInstance.element.removeClass("marker");

            simulateRemoveClick();
            simulateRemoveClick();

            equal($(".marker", uploadInstance.wrapper).length, 0);
        });

        test("clicking remove should not remove original file input if some related files are not uploaded", function() {
            uploadInstance._module.getInputFiles = function () { return getFileListMock() };

            uploadInstance.element.addClass("marker");
            simulateFileSelect();
            uploadInstance.element.removeClass("marker");

            simulateRemoveClick();

            equal($(".marker", uploadInstance.wrapper).length, 1);
        });

</script>

<%= Html.Partial("Common/AsyncNoAuto") %>

<script type="text/javascript">

        // -----------------------------------------------------------------------------------
        // -----------------------------------------------------------------------------------
        module("Upload / FormDataUpload / Events", {
            setup: moduleSetup,
            teardown: moduleTeardown
        });

        test("user data set in upload event is sent to the server", function() {
            uploadInstance = createUpload({ onUpload:
                function(e) {
                    e.data = { myId : 42 };
                }
            });

            simulateFileSelect();

            equal(lastFormData.myId, 42);
        });

        test("Anti-Forgery Token is sent to the server", function() {
            $(document.body).append("<input type='hidden' name='__RequestVerificationToken' value='42' />");

            uploadInstance = createUpload();
            simulateFileSelect();

            equal(lastFormData["__RequestVerificationToken"], "42");

            $("input[name='__RequestVerificationToken']").remove();
        });

        test("Anti-Forgery Token with AppPath sent to the server", function() {
            $(document.body).append("<input type='hidden' name='__RequestVerificationToken_test' value='42' />");

            uploadInstance = createUpload();
            simulateFileSelect();

            equal(lastFormData["__RequestVerificationToken_test"], "42");

            $("input[name='__RequestVerificationToken_test']").remove();
        });

        test("Multiple Anti-Forgery Tokens are sent to the server", function() {
            $(document.body).append("<input type='hidden' name='__RequestVerificationToken_1' value='42' />");
            $(document.body).append("<input type='hidden' name='__RequestVerificationToken_2' value='24' />");

            uploadInstance = createUpload();
            simulateFileSelect();

            equal(lastFormData["__RequestVerificationToken_1"], "42");
            equal(lastFormData["__RequestVerificationToken_2"], "24");

            $("input[name^='__RequestVerificationToken']").remove();
        });

        test("cancelling upload event prevents the upload operation", function() {
            uploadInstance = createUpload({ onUpload:
                function(e) {
                    e.preventDefault();
                }
            });

            var uploadStarted = false;
            uploadInstance._module.postFormData = function () { uploadStarted = true; };

            simulateFileSelect();

            ok(!uploadStarted);
        });

        test("error is fired when server returns error", function() {
            var errorFired = false;
            uploadInstance = createUpload({ onError:
                function() {
                    errorFired = true;
                }
            });

            simulateUploadError();

            ok(errorFired);
        });

        test("error event arguments contain original XHR when the server returns error", function() {
            var xhr = null;
            uploadInstance = createUpload({ onError:
                function(e) {
                    xhr = e.XMLHttpRequest;
                }
            });

            simulateUploadError();

            notEqual(xhr, null);
        });

        test("error event arguments contain XHR object with status when server returns non-JSON", function() {
            var xhr = null;
            uploadInstance = createUpload({ onError:
                function(e) {
                    xhr = e.XMLHttpRequest;
                }
            });

            simulateUploadWithResponse(errorResponse);

            equal(xhr.status, "200");
        });

        test("error event arguments contain XHR object with status when server returns error", function() {
            var xhr = null;
            uploadInstance = createUpload({ onError:
                function(e) {
                    xhr = e.XMLHttpRequest;
                }
            });

            simulateUploadError();

            equal(xhr.status, "500");
        });

        test("error event arguments contain XHR object with statusText when server returns non-JSON", function() {
            var xhr = null;
            uploadInstance = createUpload({ onError:
                function(e) {
                    xhr = e.XMLHttpRequest;
                }
            });

            simulateUploadWithResponse(errorResponse);

            equal(xhr.statusText, "OK");
        });

        test("error event arguments contain XHR object with statusText when server returns error", function() {
            var xhr = null;
            uploadInstance = createUpload({ onError:
                function(e) {
                    xhr = e.XMLHttpRequest;
                }
            });

            simulateUploadError();

            equal(xhr.statusText, "error");
        });

        test("complete is fired when all uploads complete successfully", function() {
            var completeFired = false;
            uploadInstance = createUpload({ onComplete:
                function(e) {
                    completeFired = true;
                }
            });

            simulateFileSelect();
            simulateFileSelect();

            simulateRequestSuccess(0);

            ok(!completeFired);

            simulateRequestSuccess(1);

            ok(completeFired);
        });

        test("complete is fired when all uploads complete either successfully or with error", function() {
            var completeFired = false;
            uploadInstance = createUpload({ onComplete:
                function(e) {
                    completeFired = true;
                }
            });

            simulateFileSelect();
            simulateFileSelect();

            simulateRequestSuccess(0);

            ok(!completeFired);

            simulateRequestError(1);

            ok(completeFired);
        });

        test("complete is fired when upload fails", 1, function() {
            uploadInstance = createUpload({ onComplete:
                function(e) {
                    ok(true);
                }
            });

            simulateFileSelect();
            simulateRequestError(0);
        });

</script>

<%= Html.Partial("Common/Events/Select")%>
<%= Html.Partial("Common/Events/Upload")%>
<%= Html.Partial("Common/Events/Success") %>
<%= Html.Partial("Common/Events/Error") %>
<%= Html.Partial("Common/Events/Cancel") %>
<%= Html.Partial("Common/Events/Remove") %>

</asp:Content>