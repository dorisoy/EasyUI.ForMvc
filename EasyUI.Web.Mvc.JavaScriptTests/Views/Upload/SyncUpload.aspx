<%@ Page Title="Synchronous Upload Tests" Language="C#" MasterPageFile="Upload.master"
    Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">
        var uploadInstance, _getSupportsMultiple;
        
        function createUpload(options) {
            copyUploadPrototype();

            $('#uploadInstance').tUpload(options);
            return $('#uploadInstance').data("tUpload");
        }

        function moduleSetup() {
            _getSupportsMultiple = $.easyui.upload.prototype._getSupportsMultiple;
        }

        function moduleTeardown() {
            $.easyui.upload.prototype._getSupportsMultiple = _getSupportsMultiple;
        }

        // -----------------------------------------------------------------------------------
        // -----------------------------------------------------------------------------------
        module("Upload / SyncUpload", {
            setup: function() {
                moduleSetup();
                uploadInstance = createUpload();
            },
            teardown: moduleTeardown
        });

        test("current input is hidden after choosing a file", function() {
            simulateFileSelect();
            equal($("input:not(:visible)", uploadInstance.wrapper).length, 1);
        });

        test("list element is created for the selected file", function() {
            simulateFileSelect();
            equal($(".t-upload-files li.t-file", uploadInstance.wrapper).length, 1);
        });

        test("clicking remove should remove file entry", function() {
            simulateFileSelect();
            simulateFileSelect();
            $(".t-delete:first", uploadInstance.wrapper).trigger("click");
            equal($(".t-upload-files li.t-file", uploadInstance.wrapper).length, 1);
        });
        
        test("disable prevents clicking remove", function () {
            simulateFileSelect();
            uploadInstance.disable();
            $(".t-delete:first", uploadInstance.wrapper).trigger("click");
            equal($(".t-file", uploadInstance.wrapper).length, 1);
        });

        test("clicking remove should remove file input", function() {
            simulateFileSelect();
            $(".t-delete", uploadInstance.wrapper).trigger("click");
            equal($("input", uploadInstance.wrapper).length, 1);
        });

        test("removing last file should remove list", function() {
            simulateFileSelect();
            $(".t-delete", uploadInstance.wrapper).trigger("click");
            equal($(".t-upload-files", uploadInstance.wrapper).length, 0);            
        });

        test("list element is re-created after removing all files", function() {
            simulateFileSelect();
            $(".t-delete", uploadInstance.wrapper).trigger("click");
            simulateFileSelect();
            equal($(".t-upload-files li.t-file", uploadInstance.wrapper).length, 1);
        });

        test("the empty input is disabled when the parent form is submitted", function() {
            $("#parentForm").trigger("submit");

            equal(uploadInstance.element.attr("disabled"), "disabled");
        });

        asyncTest("the empty input is restored when the parent submit is completed", function() {
            $("#parentForm").trigger("submit");

            setTimeout(function() {
                ok(!uploadInstance.element.attr("disabled"));
                start();
            }, 50);
        });

        test("enctype is set on parent form", function() {
            equal($("#parentForm").attr("enctype"), "multipart/form-data");
        });

</script>

<%= Html.Partial("Common/Selection") %>

<script type="text/javascript">

        // -----------------------------------------------------------------------------------
        // -----------------------------------------------------------------------------------
        module("Upload / SyncUpload / Events", {
            setup: moduleSetup,
            teardown: moduleTeardown
        });

        test("load event fires", 1, function() {
            uploadInstance = createUpload({ "onLoad" : (function() { ok(true); }) });
        });
        
        test("upload instance can be obtained during load event", 1, function() {
            uploadInstance = createUpload({ "onLoad" : (function() {
                    equals(typeof $(this).data("tUpload"), "object");
                })
            });
        });
        
        test("remove event fires upon remove", function() {
            var removeFired = false;

            uploadInstance = createUpload({ "onRemove" : (function() { removeFired = true; }) });

            simulateFileSelect();
            simulateRemoveClick();

            ok(removeFired);
        });

        test("cancelling remove prevents file from being removed", function() {
            uploadInstance = createUpload({ "onRemove" : (function(e) { e.preventDefault(); }) });

            simulateFileSelect();
            simulateRemoveClick();

            equal($(".t-upload-files li.t-file", uploadInstance.wrapper).length, 1);
        });
</script>

<%= Html.Partial("Common/Events/Select") %>

</asp:Content>