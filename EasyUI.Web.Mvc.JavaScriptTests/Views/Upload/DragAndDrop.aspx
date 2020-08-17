<%@ Page Title="FormData (HTML5) Upload Tests" Language="C#" MasterPageFile="Upload.master"
    Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">
<script type="text/javascript">

        var uploadInstance;

        function createUpload(options) {
            copyUploadPrototype();

            $('#uploadInstance').tUpload($.extend({ async:{"saveUrl":"javascript:;",autoUpload:true,showFileList:true} }, options));

            var uploadInstance = $('#uploadInstance').data("tUpload");
            uploadInstance._module.createFormData = function() { return { } };
            uploadInstance._module.postFormData = function(url, data, fileEntry) {
                fileEntry.data("request", { abort: function() { } });
            };

            return uploadInstance;
        }

        function simulateDrop(srcFiles) {
            uploadInstance._onDrop(
            {   originalEvent: {
                    dataTransfer: {
                        files: srcFiles
                    }
                },
                stopPropagation: function() { },
                preventDefault: function() { }
            });
        }

        function moduleSetup() {
            $.easyui.upload.prototype._getSupportsFormData = function() { return true; };
            uploadInstance = createUpload();
        }

        function moduleTeardown() {
            $.mockjaxClear();
        }

        // -----------------------------------------------------------------------------------
        // -----------------------------------------------------------------------------------
        module("Upload / Drag and Drop", {
            setup: moduleSetup,
            teardown: moduleTeardown
        });

        test("enabled for Safari on Mac", function() {
            uploadInstance._getUserAgent = function() {
                return "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_7; en-us) AppleWebKit/534.16+ (KHTML, like Gecko) Version/5.0.3 Safari/533.19.4";
            };

            ok(uploadInstance._getSupportsDrop());
        });

        test("disabled for Safari on Windows", function() {
            uploadInstance._getUserAgent = function() {
                return "Mozilla/5.0 (Windows; U; Windows NT 6.1; sv-SE) AppleWebKit/533.19.4 (KHTML, like Gecko) Version/5.0.3 Safari/533.19.4";
            };

            ok(!uploadInstance._getSupportsDrop());
        });

        test("enabled for all other browsers supporting FormData", function() {
            uploadInstance._getUserAgent = function() {
                return "xxxx";
            };

            ok(uploadInstance._getSupportsDrop());
        });

        test("disabled for all browsers not supporting FormData", function() {
            $.easyui.upload.prototype._getSupportsFormData = function() { return false; };            
            uploadInstance = createUpload();

            ok(!uploadInstance._getSupportsDrop());
        });

        test("dropped file is enqueued", function () {
            if (!uploadInstance._getSupportsDrop()) {
                ok(true, "Disabled in this browser");
                return;
            }

            simulateDrop([ { name: "first.txt", size: 1 } ]);
                        
            equal($(".t-file", uploadInstance.wrapper).length, 1);
        });

        test("select event fires on drop", 1, function() {
            uploadInstance = createUpload({ "onSelect" : (function() { ok(true); }) });
            simulateDrop([ { name: "first.txt", size: 1 } ]);
        });

        test("select event contains file extension", 1, function() {
            uploadInstance = createUpload({ "onSelect" : (function(e) { equal(e.files[0].extension, ".txt"); }) });
            simulateDrop([ { name: "first.txt", size: 1 } ]);
        });

        test("select event fired on drop can be cancelled", 1, function() {
            uploadInstance = createUpload({ "onSelect" : (function(e) { e.preventDefault(); }) });
            simulateDrop([ { name: "first.txt", size: 1 } ]);

            equal($(".t-file", uploadInstance.wrapper).length, 0);
        });

        test("dropping anything that is not a file is ignored", function () {
            simulateDrop([]);
                        
            equal($(".t-file", uploadInstance.wrapper).length, 0);
        });

        module("Upload / Drag and drop / Synchronous upload", {
            setup: function() {
                $.easyui.upload.prototype._getSupportsFormData = function() { return true; };
                copyUploadPrototype();

                $('#uploadInstance').tUpload();

                uploadInstance = $('#uploadInstance').data("tUpload");
            },
            teardown: moduleTeardown
        });
        
        test("disabled in synchronous mode", function() {
            $.easyui.upload.prototype._getSupportsFormData = function() { return true; };            
            ok(!uploadInstance._getSupportsDrop());
        });

</script>

</asp:Content>