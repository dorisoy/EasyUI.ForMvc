<%@ Page Title="Upload Rendering Tests" Language="C#" MasterPageFile="Upload.master"
    Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">

    var uploadInstance, _getSupportsMultiple, _getSupportsDrop;
        
    function createUpload(options) {
        copyUploadPrototype();

        $('#uploadInstance').tUpload(options);
        return $('#uploadInstance').data("tUpload");
    }

    function moduleSetup() {
        _getSupportsMultiple = $.easyui.upload.prototype._getSupportsMultiple;
        _getSupportsDrop = $.easyui.upload.prototype._getSupportsDrop;
    }

    function moduleTeardown() {
        $.easyui.upload.prototype._getSupportsMultiple = _getSupportsMultiple;
        $.easyui.upload.prototype._getSupportsDrop = _getSupportsDrop;
    }

    // -----------------------------------------------------------------------------------
    // -----------------------------------------------------------------------------------
    module("Upload / Rendering", {
        setup: function() {
            moduleSetup();
            uploadInstance = createUpload();
        },
        teardown: moduleTeardown
    });

    test("multiple attribute rendered when multiple is set to true", function() {
        $.easyui.upload.prototype._getSupportsMultiple = function() { return true; };
        createUpload();

        equal($("#uploadInstance").attr("multiple"), 'multiple');
    });

    test("multiple attribute not rendered when multiple is set to false", function() {
        createUpload({ multiple: false });    
        ok(!$("#uploadInstance").attr("multiple"));
    });

    test("multiple attribute not rendered when multiple is not supported", function() {
        $.easyui.upload.prototype._getSupportsMultiple = function() { return false; };
        createUpload();    
        ok(!$("#uploadInstance").attr("multiple"));
    });

    test("disable renders t-state-disabled class", function () {
        uploadInstance.disable();
        ok(uploadInstance.wrapper.hasClass("t-state-disabled"));
    });

    test("enable removes t-state-disabled class", function () {
        uploadInstance.disable();
        uploadInstance.enable();
        ok(!uploadInstance.wrapper.hasClass("t-state-disabled"));
    });

    test("initially disabled state is applied", function () {
        uploadInstance = createUpload({ enabled: false });
        ok(uploadInstance.wrapper.hasClass("t-state-disabled"));
    });

    test("toggle alternates between states", function() {
        uploadInstance.toggle();
        ok(uploadInstance.wrapper.hasClass("t-state-disabled"));
        uploadInstance.toggle();
        ok(!uploadInstance.wrapper.hasClass("t-state-disabled"));
    });

    test("remove icon is rendered", function() {
        simulateFileSelect();
        equal($(".t-upload-files li.t-file button.t-upload-action span.t-delete", uploadInstance.wrapper).length, 1);                    
    });

    test("file name is rendered", function() {
        simulateFileSelect();
        equal($(".t-filename", uploadInstance.wrapper).text(), "first.txt");                    
    });

    test("file name is rendered as tooltip", function() {
        simulateFileSelect();
        equal($(".t-filename", uploadInstance.wrapper).attr("title"), "first.txt");                    
    });

    // -----------------------------------------------------------------------------------
    // -----------------------------------------------------------------------------------
    module("Upload / Rendering / Drag and drop", {
        setup: function() {
            $.easyui.upload.prototype._getSupportsDrop = function() { return true; };

            moduleSetup();
            uploadInstance = createUpload({ async: { showFileList: true } });
        },
        teardown: moduleTeardown
    });

    test("drop zone is rendered when supported by the browser", function() {
        equal($("> .t-dropzone", uploadInstance.wrapper).length, 1);
    });
    
    test("drop zone is not rendered when not supported by the browser", function() {
        $.easyui.upload.prototype._getSupportsDrop = function() { return false; };
        uploadInstance = createUpload();

        equal($("> .t-dropzone", uploadInstance.wrapper).length, 0);
    });

    test("drop zone label is rendered", function() {
        equal($("> .t-dropzone > em", uploadInstance.wrapper).length, 1);
    });

    test("drop zone label text is rendered", function() {
        equal($("> .t-dropzone > em", uploadInstance.wrapper).text(), "drop files here to upload");
    });

    test("drop zone is not active initially", function() {
        equal($(".t-dropzone-active", uploadInstance.wrapper).length, 0);
    });

    test("t-dropzone-active is rendered when dragging over the document", function() {
        $(document).trigger("dragenter");
        equal($(".t-dropzone-active", uploadInstance.wrapper).length, 1);
    });

    asyncTest("t-dropzone-active is removed when dragging out of the document", function() {
        $(document).trigger("dragenter");
        setTimeout(function() {
            equal($(".t-dropzone-active", uploadInstance.wrapper).length, 0);
            start();
        }, 250);
    });

    test("t-dropzone-hovered is rendered when dragging over the zone", function() {
        $(".t-dropzone").trigger("dragenter");
        equal($(".t-dropzone-hovered", uploadInstance.wrapper).length, 1);
    });

    asyncTest("t-dropzone-hovered is removed when dragging out of the zone", function() {
        $(".t-dropzone").trigger("dragenter");
        setTimeout(function() {
            equal($(".t-dropzone-hovered", uploadInstance.wrapper).length, 0);
            start();
        }, 250);
    });

    // -----------------------------------------------------------------------------------
    // -----------------------------------------------------------------------------------
    module("Upload / Rendering / Client Component Mode", {
        setup: function() {
            moduleSetup();
            $("<div id='cc'><input type='file' id='fileInput' name='fileInput' /></div>").appendTo(document.body);
            $('#fileInput').tUpload();
            _getSupportsDrop = function() { return false; };
        },
        teardown: function() {
            moduleTeardown();
            $("#cc").remove();
        }
    });

    test("should render wrapper div", function() {
        equals($("#cc > div.t-widget.t-upload").length, 1);
    });

    test("should render upload button", function() {
        equals($("#cc > .t-upload > div.t-button.t-upload-button").length, 1);
    });

    test("should render upload button text", function() {
        equals($("#cc > .t-upload > .t-button span").text(), "Select...");
    });

    test("should wrap input", function() {
        equals($("#cc > .t-upload > .t-button > input").length, 1);
    });

</script>

</asp:Content>