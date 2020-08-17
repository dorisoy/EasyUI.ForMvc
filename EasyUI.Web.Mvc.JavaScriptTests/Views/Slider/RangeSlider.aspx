<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

   <%= Html.EasyUI().RangeSlider<int>()
           .Name("RangeSlider")
           .Min(0)
           .Max(10)
           .Values(3, 6)
           .SmallStep(1)
           .LargeStep(3)
   %>

   <%= Html.EasyUI().RangeSlider<int>()
           .Name("RangeSlider1")
           .Min(0)
           .Max(10)
           .Values(1, 8)
           .SmallStep(1)
           .LargeStep(3)
   %>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="TestContent" runat="server">
<script type="text/javascript">

    test('range slider should decrease value with a small step when down and left arrow keyboard is clicked', function () {
        var downArrow = "40"; // down arrow
        var leftArrow = "37"; // left arrow
        var isDefaultPrevent = false;
        var rangeSlider = $("#RangeSlider").data("tRangeSlider");
        var dragHandles = rangeSlider.wrapper.find(".t-draghandle");
        var values;

        //left drag handle
        dragHandles.eq(0).trigger({ type: "keydown",
            keyCode: downArrow,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

        ok(isDefaultPrevent);
        values = rangeSlider.values();
        equal(2, values[0]);
        equal(6, values[1]);

        rangeSlider.values(3, 6);
        isDefaultPrevent = false;

        dragHandles.eq(0).trigger({ type: "keydown",
            keyCode: leftArrow,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

        values = rangeSlider.values();
        ok(isDefaultPrevent);
        equal(2, values[0]);
        equal(6, values[1]);

        rangeSlider.values(3, 6);

        //right drag handle
        isDefaultPrevent = false;
        dragHandles.eq(1).trigger({ type: "keydown",
            keyCode: downArrow,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

        values = rangeSlider.values();
        ok(isDefaultPrevent);
        equal(3, values[0]);
        equal(5, values[1]);

        rangeSlider.values(3, 6);
        isDefaultPrevent = false;

        dragHandles.eq(1).trigger({ type: "keydown",
            keyCode: leftArrow,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

        values = rangeSlider.values();
        ok(isDefaultPrevent);
        equal(3, values[0]);
        equal(5, values[1]);

        rangeSlider.values(3, 6);
    });

    test('range slider should increase value with a small step when down and left arrow keyboard is clicked', function () {
        var upArrow = "38"; // up arrow
        var rightArrow = "39"; // right arrow
        var isDefaultPrevent = false;
        var rangeSlider = $("#RangeSlider").data("tRangeSlider");
        var dragHandles = rangeSlider.wrapper.find(".t-draghandle");
        var values;

        // left drag handle
        dragHandles.eq(0).trigger({ type: "keydown",
            keyCode: upArrow,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

        values = rangeSlider.values();
        ok(isDefaultPrevent);
        equal(4, values[0]);
        equal(6, values[1]);

        rangeSlider.values(3, 6);
        isDefaultPrevent = false;

        dragHandles.eq(0).trigger({ type: "keydown",
            keyCode: rightArrow,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

        values = rangeSlider.values();
        ok(isDefaultPrevent);
        equal(4, values[0]);
        equal(6, values[1]);

        rangeSlider.values(3, 6);

        // right drag handle
        isDefaultPrevent = false;
        dragHandles.eq(1).trigger({ type: "keydown",
            keyCode: upArrow,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

        values = rangeSlider.values();
        ok(isDefaultPrevent);
        equal(3, values[0]);
        equal(7, values[1]);

        rangeSlider.values(3, 6);
        isDefaultPrevent = false;

        dragHandles.eq(1).trigger({ type: "keydown",
            keyCode: rightArrow,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

        values = rangeSlider.values();
        ok(isDefaultPrevent);
        equal(3, values[0]);
        equal(7, values[1]);

        rangeSlider.values(3, 6);
    });

    test('range slider should increase value with a large step when page up keyboard is clicked', function () {
        var pageUp = "33"; // page up
        var isDefaultPrevent = false;
        var rangeSlider = $("#RangeSlider").data("tRangeSlider");
        var dragHandles = rangeSlider.wrapper.find(".t-draghandle");
        var values;

        // left drag handle
        dragHandles.eq(0).trigger({ type: "keydown",
            keyCode: pageUp,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

        values = rangeSlider.values();
        ok(isDefaultPrevent);
        equal(6, values[0]);
        equal(6, values[1]);

        rangeSlider.values(3, 6);

        // right drag handle
        isDefaultPrevent = false;
        dragHandles.eq(1).trigger({ type: "keydown",
            keyCode: pageUp,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

        values = rangeSlider.values();
        ok(isDefaultPrevent);
        equal(3, values[0]);
        equal(9, values[1]);

        rangeSlider.values(3, 6);
    });

    test('range slider should decrease value with a large step when page down keyboard is clicked', function () {
        var pageDown = "34"; // page down
        var isDefaultPrevent = false;
        var rangeSlider = $("#RangeSlider").data("tRangeSlider");
        var dragHandles = rangeSlider.wrapper.find(".t-draghandle");
        var values;

        //left drag handle
        dragHandles.eq(0).trigger({ type: "keydown",
            keyCode: pageDown,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

        values = rangeSlider.values();
        ok(isDefaultPrevent);
        equal(0, values[0]);
        equal(6, values[1]);

        rangeSlider.values(3, 6);

        //right drag handle
        isDefaultPrevent = false;
        dragHandles.eq(1).trigger({ type: "keydown",
            keyCode: pageDown,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

         values = rangeSlider.values();
        ok(isDefaultPrevent);
        equal(3, values[0]);
        equal(3, values[1]);

        rangeSlider.values(3, 6);
    });

    test('range slider should increase value to maximum value when end keyboard is clicked', function () {
        var end = "35"; // end
        var isDefaultPrevent = false;
        var rangeSlider = $("#RangeSlider").data("tRangeSlider");
        var dragHandles = rangeSlider.wrapper.find(".t-draghandle");
        var values;

        // left drag hangle
        dragHandles.eq(0).trigger({ type: "keydown",
            keyCode: end,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

        values = rangeSlider.values();
        ok(isDefaultPrevent);
        equal(10, values[0]);
        equal(10, values[1]);

        rangeSlider.values(6, 6);

        //right drag handle
        isDefaultPrevent = false;
        dragHandles.eq(1).trigger({ type: "keydown",
            keyCode: end,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

        values = rangeSlider.values();
        ok(isDefaultPrevent);
        equal(6, values[0]);
        equal(10, values[1]);

        rangeSlider.values(3, 6);
    });

    test('range slider should decrease value to minimum value when home keyboard is clicked', function () {
        var home = "36"; // home
        var isDefaultPrevent = false;
        var rangeSlider = $("#RangeSlider").data("tRangeSlider");
        var dragHandles = rangeSlider.wrapper.find(".t-draghandle");

        //left drag handle
        dragHandles.eq(0).trigger({ type: "keydown",
            keyCode: home,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

        ok(isDefaultPrevent);
        values = rangeSlider.values();
        equal(0, values[0]);
        equal(6, values[1]);

        rangeSlider.values(3, 6);

        //right drag handle
        dragHandles.eq(1).trigger({ type: "keydown",
            keyCode: home,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

        ok(isDefaultPrevent);
        values = rangeSlider.values();
        equal(0, values[0]);
        equal(0, values[1]);

        rangeSlider.values(3, 6);
    });

    test('RangeSlider should have array of number values', function () {
        var values = $("#RangeSlider1").data("tRangeSlider").values();

        equal(typeof (values[0]), "number");
        equal(typeof (values[1]), "number");
    });

    test('RangeSlider should have integer number value', function () {
        $("#RangeSlider1").data("tRangeSlider").values(5, 9);

        equal($("#RangeSlider1").find("input").eq(0).val(), "5");
        equal($("#RangeSlider1").find("input").eq(1).val(), "9");
    });

</script>
</asp:Content>