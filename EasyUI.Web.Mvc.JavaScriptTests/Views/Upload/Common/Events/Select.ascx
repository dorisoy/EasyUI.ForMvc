<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<script type="text/javascript">

test("select event fires upon file selection", function() {
    var selectFired = false;
    uploadInstance = createUpload({ "onSelect" : (function() { selectFired = true; }) });

    simulateFileSelect();

    ok(selectFired);
});

test("select event contains information for single file", function() {
    var files = null;
    uploadInstance = createUpload({ "onSelect" : (function(e) { files = e.files; }) });

    simulateFileSelect()

    assertSelectedFile(files);
});

test("select event contains information for multiple files", function() {
    var files = null;
    uploadInstance = createUpload({ "onSelect" : (function(e) { files = e.files; }) });

    simulateMultipleFileSelect();

    assertMultipleSelectedFiles(files);
});

test("cancelling select event prevents file selection", function() {
    uploadInstance = createUpload({ "onSelect" : (function(e) { e.preventDefault(); }) });

    simulateFileSelect()
    equal($(".t-upload-files li.t-file", uploadInstance.wrapper).length, 0);
});

</script>