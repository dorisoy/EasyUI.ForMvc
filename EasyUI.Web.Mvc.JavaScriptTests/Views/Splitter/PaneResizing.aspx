<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

    <% Html.RegisterSplitterScripts(); %>

</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">
        
        module("Splitter / PaneResizing / Horizontal", {
            teardown: function() {
                $('.t-splitter').remove();
            }
        });

        test("resizing is initialized along with splitter", function() {
            var splitter = $(getSplitterHtml()).appendTo(document.body).tSplitter(),
                resizingHandler = splitter.data("tSplitter").resizing;
            
            ok(resizingHandler);
            equals(resizingHandler.owner.element, splitter[0]);
        });
        
        test("resizing.start creates splitbar ghost", function() {
            var splitter = $(getSplitterHtml()).appendTo(document.body).tSplitter(),
                resizingHandler = splitter.data("tSplitter").resizing;

            resizingHandler.start({ $draggable: splitter.find(".t-splitbar") });

            var ghost = splitter.find(".t-ghost-splitbar");

            equals(ghost.length, 1);
            equals(resizingHandler.ghostSplitBar[0], ghost[0]);
        });
        
        test("resizing constraints calculated from previous pane", function() {
            var splitter = $(getSplitterHtml()).appendTo(document.body).tSplitter({
                    panes: [ { minSize: "35px", maxSize: "150px" }, {} ]
                }),
                resizingHandler = splitter.data("tSplitter").resizing;

            resizingHandler.start({ $draggable: splitter.find(".t-splitbar") });

            equals(resizingHandler.minSize, 35);
            equals(resizingHandler.maxSize, 150);
        });
        
        test("resizing constraints calculated from next pane", function() {
            var splitter = $(getSplitterHtml()).appendTo(document.body).tSplitter({
                    panes: [ {}, { minSize: "35px", maxSize: "150px" } ]
                }),
                resizingHandler = splitter.data("tSplitter").resizing;

            resizingHandler.start({ $draggable: splitter.find(".t-splitbar") });

            // minSize and maxSize will be calculated with the previous pane as the origin, taking splitbar width into account
            equals(resizingHandler.minSize, 50);
            equals(resizingHandler.maxSize, 165);
        });
        
        test("resizing constraints calculated from pane extremes", function() {
            var splitter = $(getSplitterHtml()).appendTo(document.body).tSplitter({
                    panes: [ { minSize: "60px", maxSize: "200px" }, { minSize: "35px", maxSize: "150px" } ]
                }),
                resizingHandler = splitter.data("tSplitter").resizing;

            resizingHandler.start({ $draggable: splitter.find(".t-splitbar") });

            equals(resizingHandler.minSize, 60);
            equals(resizingHandler.maxSize, 165);
        });
        
        test("resizing constraints for middle panes", function() {
            var splitter = $(getSplitterHtml(4)).width(421).appendTo(document.body).tSplitter(),
                resizingHandler = splitter.data("tSplitter").resizing;

            resizingHandler.start({ $draggable: splitter.find(".t-splitbar").eq(1) });

            equals(resizingHandler.minSize, 107);
            equals(resizingHandler.maxSize, 307);
        });

        test("resizing.drag moves ghost splitbar", function() {
            var splitter = $(getSplitterHtml()).appendTo(document.body).tSplitter(),
                resizingHandler = splitter.data("tSplitter").resizing,
                splitBar = splitter.find(".t-splitbar"),
                initialSplitBarPosition = parseInt(splitBar[0].style.left);

            resizingHandler.start({ $draggable: splitBar, pageX: initialSplitBarPosition });

            resizingHandler.drag({ pageX: initialSplitBarPosition + 10 });

            equals(parseInt(splitter.find(".t-ghost-splitbar")[0].style.left), initialSplitBarPosition + 10);
        });
        
        test("resizing.drag honors constraints", function() {
            var splitter = $(getSplitterHtml()).appendTo(document.body).tSplitter({
                    panes: [ { minSize: "60px", maxSize: "150px" }, {} ]
                }),
                resizingHandler = splitter.data("tSplitter").resizing,
                splitBar = splitter.find(".t-splitbar"),
                initialSplitBarPosition = parseInt(splitBar[0].style.left);

            resizingHandler.start({ $draggable: splitBar, pageX: initialSplitBarPosition });

            // override contraints so that we don't test their calculation in .start()
            resizingHandler.minSize = 60;
            resizingHandler.maxSize = 150;

            var ghost = splitter.find(".t-ghost-splitbar");

            resizingHandler.drag({ pageX: 0 });

            ok(ghost.hasClass("t-restricted-size-horizontal"));
            equals(parseInt(ghost[0].style.left), 60);

            resizingHandler.drag({ pageX: 1000 });
            
            ok(ghost.hasClass("t-restricted-size-horizontal"));
            equals(parseInt(ghost[0].style.left), 150);
        });

        test("resizing.stop modifies pane sizes", function() {
            var splitter = $(getSplitterHtml()).appendTo(document.body).tSplitter(),
                resizingHandler = splitter.data("tSplitter").resizing,
                splitBar = splitter.find(".t-splitbar"),
                initialSplitBarPosition = splitBar.offset().left,
                panes = splitter.find(".t-pane"),
                initialPaneSizes = $.map(panes, function(x) { return parseInt(x.offsetWidth); });

            resizingHandler.start({ $draggable: splitBar, pageX: initialSplitBarPosition });
            resizingHandler.drag({ pageX: initialSplitBarPosition + 5 });
            resizingHandler.stop({ $draggable: splitBar });

            equals(parseInt(panes[0].offsetWidth), initialPaneSizes[0] + 5);
            equals(parseInt(panes[1].offsetWidth), initialPaneSizes[1] - 5);
        });
        
        test("resizing.stop for middle panes", function() {
            var splitter = $(getSplitterHtml(4)).width(421).appendTo(document.body).tSplitter(),
                resizingHandler = splitter.data("tSplitter").resizing,
                splitBar = splitter.find(".t-splitbar").eq(1),
                initialSplitBarPosition = splitBar.offset().left,
                panes = splitter.find(".t-pane"),
                initialPaneSizes = $.map(panes, function(x) { return parseInt(x.offsetWidth); });

            resizingHandler.start({ $draggable: splitBar, pageX: initialSplitBarPosition });
            resizingHandler.drag({ pageX: initialSplitBarPosition + 5 });
            resizingHandler.stop({ $draggable: splitBar });

            equals(panes[1].offsetWidth, initialPaneSizes[1] + 5);
            equals(panes[2].offsetWidth, initialPaneSizes[2] - 5);
        });

        test("resizing.stop fires splitter resize", function() {
            var triggered = false,
                splitter = $(getSplitterHtml()).appendTo(document.body).tSplitter(),
                splitBar = splitter.find(".t-splitbar"),
                resizingHandler = splitter.data("tSplitter").resizing;

            splitter.bind("resize", function() { triggered = true; });
            
            resizingHandler.start({ $draggable: splitBar, pageX: 0 });
            resizingHandler.stop({ $draggable: splitBar });

            ok(triggered);
        });

        test("resizing.stop for panes with constraints", function() {
            var splitter = $(getSplitterHtml()).appendTo(document.body).tSplitter({
                    panes: [{ minSize: "50px" }, {}]
                }),
                resizingHandler = splitter.data("tSplitter").resizing,
                splitBar = splitter.find(".t-splitbar"),
                initialSplitBarPosition = splitBar.offset().left,
                panes = splitter.find(".t-pane");

            resizingHandler.start({ $draggable: splitBar, pageX: initialSplitBarPosition });
            resizingHandler.drag({ pageX: 0 });
            resizingHandler.stop({ $draggable: splitBar });

            equals(panes[0].offsetWidth, 50);
            equals(panes[1].offsetWidth, 150);
        });
        
        function isPercentageSize(size) {
            return /^\d+(\.\d+)?%$/.test(size);
        }

        function isPixelSize(size) {
            return /^\d+px$/.test(size);
        }

        function isFluid(size) {
            return !isPercentageSize(size) && !isPixelSize(size);
        }

        test("resizing.stop assigns percentage sizes when resizing fluid panes", function() {
            var splitter = $(getSplitterHtml()).appendTo(document.body).tSplitter({ panes: [{ size: "100px" }, {}] }),
                resizingHandler = splitter.data("tSplitter").resizing,
                splitBar = splitter.find(".t-splitbar"),
                initialSplitBarPosition = splitBar.offset().left,
                panes = splitter.find(".t-pane");

            resizingHandler.start({ $draggable: splitBar, pageX: initialSplitBarPosition });
            resizingHandler.drag({ pageX: initialSplitBarPosition + 5 });
            resizingHandler.stop({ $draggable: splitBar });

            ok(isPixelSize(panes.eq(0).data("pane").size));
            ok(isFluid(panes.eq(1).data("pane").size));
        });

        test("resizing.stop assigns percentage sizes when resizing fluid panes", function() {
            var splitter = $(getSplitterHtml()).appendTo(document.body).tSplitter({ panes: [{}, { size: "100px" }] }),
                resizingHandler = splitter.data("tSplitter").resizing,
                splitBar = splitter.find(".t-splitbar"),
                initialSplitBarPosition = splitBar.offset().left,
                panes = splitter.find(".t-pane");

            resizingHandler.start({ $draggable: splitBar, pageX: initialSplitBarPosition });
            resizingHandler.drag({ pageX: initialSplitBarPosition + 5 });
            resizingHandler.stop({ $draggable: splitBar });

            ok(isFluid(panes.eq(0).data("pane").size));
            ok(isPixelSize(panes.eq(1).data("pane").size));
        });
        
        module("Splitter / PaneResizing / Vertical", {
            teardown: function() {
                $('.t-splitter').remove();
            }
        });

        test("resizing is initialized along with splitter", function() {
            var splitter = $(getSplitterHtml()).appendTo(document.body).tSplitter({ orientation: "vertical" }),
                resizingHandler = splitter.data("tSplitter").resizing;
            
            ok(resizingHandler);
            equals(resizingHandler.owner.element, splitter[0]);
        });
        
        test("resizing.start creates splitbar ghost", function() {
            var splitter = $(getSplitterHtml()).appendTo(document.body).tSplitter({ orientation: "vertical" }),
                resizingHandler = splitter.data("tSplitter").resizing;

            resizingHandler.start({ $draggable: splitter.find(".t-splitbar") });

            var ghost = splitter.find(".t-ghost-splitbar");

            equals(ghost.length, 1);
            equals(resizingHandler.ghostSplitBar[0], ghost[0]);
        });
        
        test("resizing constraints calculated from previous pane", function() {
            var splitter = $(getSplitterHtml()).appendTo(document.body).height(207).tSplitter({
                    panes: [ { minSize: "35px", maxSize: "150px" }, {} ],
                    orientation: "vertical"
                }),
                resizingHandler = splitter.data("tSplitter").resizing;

            resizingHandler.start({ $draggable: splitter.find(".t-splitbar") });

            equals(resizingHandler.minSize, 35);
            equals(resizingHandler.maxSize, 150);
        });
        
        test("resizing constraints calculated from next pane", function() {
            var splitter = $(getSplitterHtml()).appendTo(document.body).height(207).tSplitter({
                    panes: [ {}, { minSize: "35px", maxSize: "150px" } ],
                    orientation: "vertical"
                }),
                resizingHandler = splitter.data("tSplitter").resizing;

            resizingHandler.start({ $draggable: splitter.find(".t-splitbar") });

            // minSize and maxSize will be calculated with the previous pane as the origin, taking splitbar height into account
            equals(resizingHandler.minSize, 50);
            equals(resizingHandler.maxSize, 165);
        });
        
        test("resizing constraints calculated from pane extremes", function() {
            var splitter = $(getSplitterHtml()).appendTo(document.body).height(207).tSplitter({
                    panes: [ { minSize: "60px", maxSize: "200px" }, { minSize: "35px", maxSize: "150px" } ],
                    orientation: "vertical"
                }),
                resizingHandler = splitter.data("tSplitter").resizing;

            resizingHandler.start({ $draggable: splitter.find(".t-splitbar") });

            equals(resizingHandler.minSize, 60);
            equals(resizingHandler.maxSize, 165);
        });
        
        test("resizing constraints for middle panes", function() {
            var splitter = $(getSplitterHtml(4)).height(421).appendTo(document.body).tSplitter({ orientation: "vertical" }),
                resizingHandler = splitter.data("tSplitter").resizing;

            resizingHandler.start({ $draggable: splitter.find(".t-splitbar").eq(1) });

            equals(resizingHandler.minSize, 107);
            equals(resizingHandler.maxSize, 307);
        });

        test("resizing.drag moves ghost splitbar", function() {
            var splitter = $(getSplitterHtml()).appendTo(document.body).tSplitter({ orientation: "vertical" }),
                resizingHandler = splitter.data("tSplitter").resizing,
                splitBar = splitter.find(".t-splitbar"),
                initialSplitBarPosition = parseInt(splitBar[0].style.top);

            resizingHandler.start({ $draggable: splitBar, pageY: initialSplitBarPosition });

            resizingHandler.drag({ pageY: initialSplitBarPosition + 10 });

            equals(parseInt(splitter.find(".t-ghost-splitbar")[0].style.top), initialSplitBarPosition + 10);
        });
        
        test("resizing.drag honors constraints", function() {
            var splitter = $(getSplitterHtml()).appendTo(document.body).tSplitter({
                    panes: [ { minSize: "60px", maxSize: "150px" }, {} ],
                    orientation: "vertical"
                }),
                resizingHandler = splitter.data("tSplitter").resizing,
                splitBar = splitter.find(".t-splitbar"),
                initialSplitBarPosition = parseInt(splitBar[0].style.top);

            resizingHandler.start({ $draggable: splitBar, pageY: initialSplitBarPosition });

            // override contraints so that we don't test their calculation in .start()
            resizingHandler.minSize = 60;
            resizingHandler.maxSize = 150;

            var ghost = splitter.find(".t-ghost-splitbar");

            resizingHandler.drag({ pageY: 0 });

            ok(ghost.hasClass("t-restricted-size-vertical"));
            equals(parseInt(ghost[0].style.top), 60);

            resizingHandler.drag({ pageY: 1000 });
            
            ok(ghost.hasClass("t-restricted-size-vertical"));
            equals(parseInt(ghost[0].style.top), 150);
        });

        test("resizing.stop modifies pane sizes", function() {
            var splitter = $(getSplitterHtml()).appendTo(document.body).tSplitter({ orientation: "vertical" }),
                resizingHandler = splitter.data("tSplitter").resizing,
                splitBar = splitter.find(".t-splitbar"),
                initialSplitBarPosition = splitBar.offset().top,
                panes = splitter.find(".t-pane"),
                initialPaneSizes = $.map(panes, function(x) { return parseInt(x.offsetHeight); });

            resizingHandler.start({ $draggable: splitBar, pageY: initialSplitBarPosition });
            resizingHandler.drag({ pageY: initialSplitBarPosition + 5 });
            resizingHandler.stop({ $draggable: splitBar });

            equals(parseInt(panes[0].offsetHeight), initialPaneSizes[0] + 5);
            equals(parseInt(panes[1].offsetHeight), initialPaneSizes[1] - 5);
        });
        
        test("resizing.stop for middle panes", function() {
            var splitter = $(getSplitterHtml(4)).height(421).appendTo(document.body).tSplitter({ orientation: "vertical" }),
                resizingHandler = splitter.data("tSplitter").resizing,
                splitBar = splitter.find(".t-splitbar").eq(1),
                initialSplitBarPosition = splitBar.offset().top,
                panes = splitter.find(".t-pane"),
                initialPaneSizes = $.map(panes, function(x) { return parseInt(x.offsetHeight); });

            resizingHandler.start({ $draggable: splitBar, pageY: initialSplitBarPosition });
            resizingHandler.drag({ pageY: initialSplitBarPosition + 5 });
            resizingHandler.stop({ $draggable: splitBar });

            equals(parseInt(panes[1].offsetHeight), initialPaneSizes[1] + 5);
            equals(parseInt(panes[2].offsetHeight), initialPaneSizes[2] - 5);
        });

        test("resizing.stop fires splitter resize", function() {
            var triggered = false,
                splitter = $(getSplitterHtml()).appendTo(document.body).tSplitter({ orientation: "vertical" }),
                splitBar = splitter.find(".t-splitbar"),
                resizingHandler = splitter.data("tSplitter").resizing;

            splitter.bind("resize", function() { triggered = true; });
            
            resizingHandler.start({ $draggable: splitBar, pageY: 0 });
            resizingHandler.stop({ $draggable: splitBar });

            ok(triggered);
        });
        
        test("resizing.stop does not resize splitter if Esc key was hit", function() {
            var splitter = $(getSplitterHtml()).appendTo(document.body).tSplitter({ orientation: "vertical" }),
                resizingHandler = splitter.data("tSplitter").resizing,
                splitBar = splitter.find(".t-splitbar"),
                initialSplitBarPosition = splitBar.offset().top,
                panes = splitter.find(".t-pane"),
                initialPaneSizes = $.map(panes, function(x) { return parseInt(x.offsetHeight); });

            resizingHandler.start({ $draggable: splitBar, pageY: initialSplitBarPosition });
            resizingHandler.drag({ pageY: initialSplitBarPosition + 5 });
            resizingHandler.stop({ keyCode: 27, $draggable: splitBar });

            equals(parseInt(panes[0].offsetHeight), initialPaneSizes[0]);
            equals(parseInt(panes[1].offsetHeight), initialPaneSizes[1]);
        });

        test("resizing.stop does not fire resize when cancelling drag with Esc", function() {
            var triggered = false,
                splitter = $(getSplitterHtml()).appendTo(document.body).tSplitter({ orientation: "vertical" }),
                splitBar = splitter.find(".t-splitbar"),
                resizingHandler = splitter.data("tSplitter").resizing;

            splitter.bind("resize", function() { triggered = true; });
            
            resizingHandler.start({ $draggable: splitBar, pageY: 0 });
            resizingHandler.stop({ keyCode: 27, $draggable: splitBar });

            ok(!triggered);
        });

        module("Nested splitters", {
            teardown: function() {
                $('.t-splitter').remove();
            }
        });

        test("splitter is bound to parent splitter resize", function() {
            var outerSplitter = $(getSplitterHtml()).height(207).appendTo(document.body).tSplitter(),
                innerSplitter = 
                    outerSplitter.find(".t-pane").eq(0)
                        .html(getSplitterHtml())
                        .find("> div").css({
                            height: "100%",
                            width: "100%",
                            border: 0,
                            overflow: "hidden"
                        })
                            .tSplitter({ orientation: "vertical" }),
                triggered = false;


            innerSplitter.bind("resize", function(e) {
                triggered = true;
            });

            outerSplitter.trigger("resize");

            ok(triggered);
        });

    </script>

</asp:Content>
