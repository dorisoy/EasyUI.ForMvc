<%@ Page Title="Iframe Upload Tests" Language="C#" MasterPageFile="Upload.master"
    Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">
<script type="text/javascript">

        var uploadInstance,
            _getSupportsFormData,
            validJSON = "{\"status\":\"OK\"}",
            errorResponse = "ERROR!";

        function createUpload(options) {
            copyUploadPrototype();

            $('#uploadInstance').tUpload($.extend({ async:{"saveUrl":'javascript:;',"removeUrl":"/removeAction",autoUpload: true} }, options));
            return $('#uploadInstance').data("tUpload");
        }

        function triggerIframeLoad(iframeIndex) {
            $("iframe.#uploadInstance_" + iframeIndex)
                        .trigger("load");
        }

        function simulateIframeResponse(iframeIndex, response) {
            uploadInstance._module.processResponse($("iframe.#uploadInstance_" + iframeIndex), response || "");
        }

        function simulateUpload() {
            simulateFileSelect();
            triggerIframeLoad(0);

            // Clean-up iframe as if the upload as if complete
            $(".t-file:last", uploadInstance.wrapper).data("frame", null);
        }

        function simulateUploadWithResponse(response) {
            simulateFileSelect();
            simulateIframeResponse(0, response);
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

        function moduleSetup() {
            _getSupportsFormData = $.easyui.upload.prototype._getSupportsFormData;
            $.easyui.upload.prototype._getSupportsFormData = function() { return false; };
            $.easyui.upload.prototype._alert = function() { };
        }

        function moduleTeardown() {
            $.easyui.upload.prototype._getSupportsFormData = _getSupportsFormData;
            $("iframe[name^='uploadInstance'], form[target^='uploadInstance']").remove();
            $.mockjaxClear();
        }

        // -----------------------------------------------------------------------------------
        // -----------------------------------------------------------------------------------
        module("Upload / IframeUpload", {
            setup: function() {
                moduleSetup();
                uploadInstance = createUpload();
            },
            teardown: moduleTeardown
        });

        test("iframe module is selected when FormData is not supported", function() {
            equal(uploadInstance._module.name, "iframeUploadModule");
        });

        test("iframe module is not selected when FormData is supported", function() {
            $.easyui.upload.prototype._getSupportsFormData = function() { return true; };

            uploadInstance = createUpload();

            ok(uploadInstance._module.name != "iframeUploadModule");
        });

        test("iframe is created after choosing a file", function() {
            simulateFileSelect();
            equal($("iframe.#uploadInstance_0").length, 1);
        });

        test("form is created after choosing a file", function() {
            simulateFileSelect();
            equal($("form[action='" + uploadInstance.async.saveUrl + "']").length, 1);
        });

        test("input is moved to the form", function() {
            simulateFileSelect();
            equal($("form[action='" + uploadInstance.async.saveUrl + "'] input").length, 1);
        });

        test("input name is preserved", function() {
            simulateFileSelect();
            equal($("form[action='" + uploadInstance.async.saveUrl + "'] input").attr("name"), "uploadInstance");
        });

        test("input name is set to saveField", function() {
            uploadInstance.async.saveField = "field";
            simulateFileSelect();
            equal($("form[action='" + uploadInstance.async.saveUrl + "'] input").attr("name"), "field");
        });

        test("list element is created for the selected file", function() {
            simulateFileSelect();
            equal($(".t-upload-files li.t-file", uploadInstance.wrapper).length, 1);
        });

        asyncTest("iframe is removed upon success", function() {
            simulateUpload();

            window.setTimeout(function() {
                equal($("iframe.#uploadInstance_0").length, 0);
                start();
            }, 10);
        });

        asyncTest("form is removed upon success", function() {
            simulateUpload();

            window.setTimeout(function() {
                equal($("form[action='" + uploadInstance.async.saveUrl + "']").length, 0);
                start();
            }, 10);
        });

        asyncTest("input is moved back to the original form when it's submitted", function() {
            simulateFileSelect();
            $("#parentForm").trigger("submit");

            window.setTimeout(function() {
                equal($("input[name='uploadInstance']", uploadInstance.wrapper).length, 2);
                start();
            }, 10);
        });

        asyncTest("clicking cancel should remove iframe", function() {
            uploadInstance._module.onIframeLoad = function() { };
            simulateFileSelect();
            $(".t-cancel", uploadInstance.wrapper).trigger("click");

            window.setTimeout(function() {
                equal($("iframe.#uploadInstance_0").length, 0);
                start();
            }, 10);
        });

        asyncTest("clicking cancel should remove form", function() {
            uploadInstance._module.onIframeLoad = function() { };
            simulateFileSelect();
            $(".t-cancel", uploadInstance.wrapper).trigger("click");

            window.setTimeout(function() {
                equal($("form[action='" + uploadInstance.async.saveUrl + "']").length, 0);
                start();
            }, 10);
        });

        asyncTest("clicking cancel should remove file entry", function() {
            uploadInstance._module.onIframeLoad = function() { };
            simulateFileSelect();
            $(".t-cancel", uploadInstance.wrapper).trigger("click");

            window.setTimeout(function() {
                equal($(".t-file", uploadInstance.wrapper).length, 0);
                start();
            }, 10);
        });
        
        test("form is submitted when clicking retry", 1, function() {
            simulateUploadWithResponse(errorResponse);

            uploadInstance._module.performUpload = function(fileEntry) {
                ok(true);
            }

            $(".t-retry", uploadInstance.wrapper).trigger("click");
        });

        test("frame is not destroyed on failure to allow retry", function() {
            simulateUploadWithResponse(errorResponse);

            notEqual($(".t-file", uploadInstance.wrapper).data("frame"), null);
        });

        test("frame is not unregistered on failure to allow retry", function() {
            simulateUploadWithResponse(errorResponse);

            equal(uploadInstance._module.iframes.length, 1);
        });

</script>

<%= Html.Partial("Common/Async") %>
<%= Html.Partial("Common/Selection") %>
<%= Html.Partial("Common/AsyncNoMultiple") %>

<script type="text/javascript">

        // -----------------------------------------------------------------------------------
        // -----------------------------------------------------------------------------------
        module("Upload / IframeUpload / autoUpload = false", {
            setup: function() {
                moduleSetup();
                uploadInstance = createUpload({ async: {"saveUrl": 'javascript:;', "removeUrl": 'javascript:;', autoUpload: false } });
            },
            teardown: moduleTeardown
        });

        test("upload doesn't start before upload button click", function() {
            simulateFileSelect();

            equal($("iframe.#uploadInstance_0").length, 0);
        });

        test("upload starts on upload button click", function() {
            simulateFileSelect();
            $(".t-upload-selected", uploadInstance.wrapper).trigger("click");

            equal($("iframe.#uploadInstance_0").length, 1);
        });

        test("upload button is rendered on subsequent select", function() {
            simulateFileSelect();
            $(".t-upload-selected", uploadInstance.wrapper).trigger("click");
            $("iframe.#uploadInstance_0").trigger("load");
            simulateFileSelect();

            equal($(".t-upload-selected", uploadInstance.wrapper).length, 1);
        });

        asyncTest("upload button click does not start upload if it is already in progress", function() {
            simulateFileSelect();
            $(".t-upload-selected", uploadInstance.wrapper).trigger("click");

            var counter = 0;
            uploadInstance._module.performUpload = function(fileEntry) { counter++; }

            simulateFileSelect();
            $(".t-upload-selected", uploadInstance.wrapper).trigger("click");

            window.setTimeout(function() {
                equal(counter, 1);
                start();
            }, 10);
        });

        asyncTest("upload button click does not start upload after completion", function() {
            simulateFileSelect();
            $(".t-upload-selected", uploadInstance.wrapper).trigger("click");
            $("iframe.#uploadInstance_0").trigger("load");

            $(".t-file").addClass("complete");

            var counter = 0;
            uploadInstance._module.performUpload = function(fileEntry) {
                ok(fileEntry.is(":not(.complete)"), "performUpload should not be called for completed upload");
                counter++;
            }

            simulateFileSelect();
            $(".t-upload-selected", uploadInstance.wrapper).trigger("click");

            window.setTimeout(function() {
                equal(counter, 1);
                start();
            }, 10);
        });

        asyncTest("clicking remove should call remove action for completed files", function() {
            var removeCalled = false;
            uploadInstance._submitRemove = function(data, onSuccess) {
                removeCalled = true;
            };

            simulateFileSelect();
            $(".t-upload-selected", uploadInstance.wrapper).trigger("click");
            $("iframe.#uploadInstance_0").trigger("load");

            window.setTimeout(function() {
                simulateRemove();
                ok(removeCalled);
                start();
            }, 10);
        });

        test("clicking remove should remove upload form", function() {
            simulateFileSelect();
            simulateRemoveClick();

            equal($(".t-file", uploadInstance.wrapper).data("form"), null);
        });

</script>

<%= Html.Partial("Common/AsyncNoAuto") %>

<script type="text/javascript">

        // -----------------------------------------------------------------------------------
        // -----------------------------------------------------------------------------------
        module("Upload / IframeUpload / Events", {
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

            equal($("form[target='uploadInstance_0'] input[name='myId']").val(), "42");
        });

        test("Anti-Forgery Token is sent to the server", function() {
            $(document.body).append("<input type='hidden' name='__RequestVerificationToken' value='42' />");

            uploadInstance = createUpload();
            simulateFileSelect();

            equal($("form[target='uploadInstance_0'] input[name='__RequestVerificationToken']").val(), "42");

            $("input[name='__RequestVerificationToken']").remove();
        });

        test("Anti-Forgery Token with AppPath sent to the server", function() {
            $(document.body).append("<input type='hidden' name='__RequestVerificationToken_test' value='42' />");

            uploadInstance = createUpload();
            simulateFileSelect();

            equal($("form[target='uploadInstance_0'] input[name='__RequestVerificationToken_test']").val(), "42");

            $("input[name='__RequestVerificationToken_test']").remove();
        });

        test("Multiple Anti-Forgery Tokens are sent to the server", function() {
            $(document.body).append("<input type='hidden' name='__RequestVerificationToken_1' value='42' />");
            $(document.body).append("<input type='hidden' name='__RequestVerificationToken_2' value='24' />");

            uploadInstance = createUpload();
            simulateFileSelect();

            equal($("form[target='uploadInstance_0'] input[name='__RequestVerificationToken_1']").val(), "42");
            equal($("form[target='uploadInstance_0'] input[name='__RequestVerificationToken_2']").val(), "24");

            $("input[name^='__RequestVerificationToken']").remove();
        });

        test("user data set in upload event is not duplicated after retry", function() {
            uploadInstance = createUpload({ onUpload:
                function(e) {
                    e.data = { myId : 42 };
                }
            });

            simulateUploadWithResponse(errorResponse);
            $(".t-retry", uploadInstance.wrapper).trigger("click");

            equal($("form[target='uploadInstance_0'] input[name='myId']").length, 1);
        });

        test("cancelling the upload event prevents the upload operation", function() {
            uploadInstance = createUpload({ onUpload:
                function(e) {
                    e.preventDefault();
                }
            });

            simulateFileSelect();

            equal($("iframe.#uploadInstance_0").length, 0);
        });

        test("error event arguments contain XHR object with status", function() {
            var xhr = null;
            uploadInstance = createUpload({ onError:
                function(e) {
                    xhr = e.XMLHttpRequest;
                }
            });

            simulateUploadWithResponse(errorResponse);

            equal(xhr.status, "500");
        });

        test("error event arguments contain XHR object with statusText", function() {
            var xhr = null;
            uploadInstance = createUpload({ onError:
                function(e) {
                    xhr = e.XMLHttpRequest;
                }
            });

            simulateUploadWithResponse(errorResponse);

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

            triggerIframeLoad(0);

            ok(!completeFired);

            triggerIframeLoad(1);

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

            simulateIframeResponse(0, errorResponse);

            ok(!completeFired);

            triggerIframeLoad(1);

            ok(completeFired);
        });

        test("complete is fired when upload fails", 1, function() {
            uploadInstance = createUpload({ onComplete:
                function(e) {
                    ok(true);
                }
            });

            simulateFileSelect();
            simulateIframeResponse(0, errorResponse);
        });

</script>

<%= Html.Partial("Common/Events/Select") %>
<%= Html.Partial("Common/Events/Upload") %>
<%= Html.Partial("Common/Events/Success") %>
<%= Html.Partial("Common/Events/Error") %>
<%= Html.Partial("Common/Events/Cancel") %>
<%= Html.Partial("Common/Events/Remove") %>

</asp:Content>