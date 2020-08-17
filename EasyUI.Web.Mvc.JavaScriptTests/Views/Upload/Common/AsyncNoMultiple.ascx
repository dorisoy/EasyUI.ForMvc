<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>

<script type="text/javascript">
    
    test("adding a second file should call remove action (multiple = false)", 1, function() {
        uploadInstance = createUpload({ multiple: false, async: {"saveUrl":'javascript:;',"removeUrl":'javascript:;'} });

        uploadInstance._submitRemove = function(data, onSuccess) { 
            ok(true);
        };

        simulateUpload(0);
        simulateUpload(1);
    });
    
    test("adding a second file should not call remove action if it is not configured (multiple = false)", function() {
        uploadInstance = createUpload({ multiple: false, async: {"saveUrl":'javascript:;'} });

        var removeCalled = false;            
        uploadInstance._submitRemove = function(data, onSuccess) { 
            removeCalled = true;
        };

        simulateUpload(0);
        simulateUpload(1);

        ok(!removeCalled);
    });

</script>