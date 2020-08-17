<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

   <%= Html.EasyUI().Slider<int>()
           .Name("Slider")
           .Min(0)
           .Max(10)
           .Value(5)
           .SmallStep(2)
           .LargeStep(3)
   %>

   <%= Html.EasyUI().Slider<int>()
           .Name("Slider1")
           .Min(0)
           .Max(10)
           .Value(0)
           .SmallStep(3)
           .LargeStep(5)
           .HtmlAttributes(new { style="width: 156px;" })
   %>

   <%= Html.EasyUI().Slider<int>()
           .Name("Slider2")
           .Min(0)
           .Max(10)
           .Value(0)
           .SmallStep(2)
           .LargeStep(5)
           .HtmlAttributes(new { style="width: 156px;" })
   %>

   <%= Html.EasyUI().Slider<double>()
           .Name("Slider3")
           .Min(0)
           .Max(1)
           .Value(0)
           .SmallStep(0.1)
           .LargeStep(5)
           .HtmlAttributes(new { style="width: 156px;" })
   %>

   <%= Html.EasyUI().Slider<int>()
           .Name("Slider4")
           .Min(0)
           .Max(10)
           .Value(0)
           .SmallStep(1)
           .LargeStep(5)
           .HtmlAttributes(new { style="width: 157px;" })
           .ShowButtons(false)
   %>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="TestContent" runat="server">
<script type="text/javascript">

    test('slider should decrease value with a small step when down and left arrow keyboard is clicked', function () {
        var downArrow = "40"; // down arrow
        var leftArrow = "37"; // left arrow
        var isDefaultPrevent = false;
        var slider = $("#Slider").data("tSlider");
        var dragHandle = slider.wrapper.find(".t-draghandle");

        dragHandle.trigger({ type: "keydown",
            keyCode: downArrow,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

        ok(isDefaultPrevent);
        equal(3, slider.value());

        slider.value(5);
        isDefaultPrevent = false;

        dragHandle.trigger({ type: "keydown",
            keyCode: leftArrow,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

        ok(isDefaultPrevent);
        equal(3, slider.value());

        slider.value(5);
    });

    test('slider should increase value with a small step when down and left arrow keyboard is clicked', function () {
        var upArrow = "38"; // up arrow
        var rightArrow = "39"; // right arrow
        var isDefaultPrevent = false;
        var slider = $("#Slider").data("tSlider");
        var dragHandle = slider.wrapper.find(".t-draghandle");

        dragHandle.trigger({ type: "keydown",
            keyCode: upArrow,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

        ok(isDefaultPrevent);
        equal(7, slider.value());

        slider.value(5);
        isDefaultPrevent = false;

        dragHandle.trigger({ type: "keydown",
            keyCode: rightArrow,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

        ok(isDefaultPrevent);
        equal(7, slider.value());

        slider.value(5);
    });

    test('slider should increase value with a large step when page up keyboard is clicked', function () {
        var end = "33"; // page up
        var isDefaultPrevent = false;
        var slider = $("#Slider").data("tSlider");
        var dragHandle = slider.wrapper.find(".t-draghandle");

        dragHandle.trigger({ type: "keydown",
            keyCode: end,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

        ok(isDefaultPrevent);
        equal(8, slider.value());

        slider.value(5);
    });

    test('slider should decrease value with a large step when page down keyboard is clicked', function () {
        var home = "34"; // page down
        var isDefaultPrevent = false;
        var slider = $("#Slider").data("tSlider");
        var dragHandle = slider.wrapper.find(".t-draghandle");

        dragHandle.trigger({ type: "keydown",
            keyCode: home,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

        ok(isDefaultPrevent);
        equal(2, slider.value());

        slider.value(5);
    });
    
    test('slider should increase value to maximum value when end keyboard is clicked', function () {
        var end = "35"; // end
        var isDefaultPrevent = false;
        var slider = $("#Slider").data("tSlider");
        var dragHandle = slider.wrapper.find(".t-draghandle");

        dragHandle.trigger({ type: "keydown",
            keyCode: end,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

        ok(isDefaultPrevent);
        equal(10, slider.value());

        slider.value(5);
    });

    test('slider should increase value to minimum value when home keyboard is clicked', function () {
        var home = "36"; // home
        var isDefaultPrevent = false;
        var slider = $("#Slider").data("tSlider");
        var dragHandle = slider.wrapper.find(".t-draghandle");

        dragHandle.trigger({ type: "keydown",
            keyCode: home,
            preventDefault: function () {
                isDefaultPrevent = true;
            }
        });

        ok(isDefaultPrevent);
        equal(0, slider.value());

        slider.value(5);
    });

    test('getValueFromPosition with small step 3 and mouse position 100 should return max value', function () {
        var slider = $("#Slider1").data("tSlider");
        var mousePosition = 100;
        var dragableArea = {
            startPoint: 0,
            endPoint: slider.maxSelection
        };

        var value = $t.slider.getValueFromPosition(mousePosition, dragableArea, slider);

        equal(value, 10);
    });

    test('getValueFromPosition with small step 2 and mouse position 94 should return 9', function () {
        var slider = $("#Slider2").data("tSlider");
        var mousePosition = 89;
        var dragableArea = {
            startPoint: 0,
            endPoint: slider.maxSelection
        };

        var value = $t.slider.getValueFromPosition(mousePosition, dragableArea, slider);

        equal(value, 8);
    });

    test('getValueFromPosition with small step 3 and mouse position 90 should return 10', function () {
        var slider = $("#Slider1").data("tSlider");
        var mousePosition = 90;
        var dragableArea = {
            startPoint: 0,
            endPoint: slider.maxSelection
        };

        var value = $t.slider.getValueFromPosition(mousePosition, dragableArea, slider);

        equal(value, 9);
    });

    test('getValueFromPosition with small step 2 and mouse position 60 should return 3', function () {
        var slider = $("#Slider2").data("tSlider");
        var mousePosition = 60;
        var dragableArea = {
            startPoint: 0,
            endPoint: slider.maxSelection
        };

        var value = $t.slider.getValueFromPosition(mousePosition, dragableArea, slider);

        equal(value, 6);
    });

    test('getValueFromPosition with small step 2 and mouse position 95 should return 10', function () {
        var slider = $("#Slider2").data("tSlider");
        var mousePosition = 95;
        var dragableArea = {
            startPoint: 0,
            endPoint: slider.maxSelection
        };

        var value = $t.slider.getValueFromPosition(mousePosition, dragableArea, slider);

        equal(value, 10);
    });

    test('getValueFromPosition with small step 2 and mouse position 10 should return 1', function () {
        var slider = $("#Slider2").data("tSlider");
        var mousePosition = 10;
        var dragableArea = {
            startPoint: 0,
            endPoint: slider.maxSelection
        };

        var value = $t.slider.getValueFromPosition(mousePosition, dragableArea, slider);

        equal(value, 0);
    });

    test('getValueFromPosition with small step 0.1 mouse position 40 should return 0.4', function () {
        var slider = $("#Slider3").data("tSlider");
        var mousePosition = 40;
        var dragableArea = {
            startPoint: 0,
            endPoint: slider.maxSelection
        };

        var value = $t.slider.getValueFromPosition(mousePosition, dragableArea, slider);

        equal(value, 0.4);
    });

    test('getValueFromPosition with small step 0.1 mouse position 30 should return 0.3', function () {
        var slider = $("#Slider3").data("tSlider");
        var mousePosition = 30;
        var dragableArea = {
            startPoint: 0,
            endPoint: slider.maxSelection
        };

        var value = $t.slider.getValueFromPosition(mousePosition, dragableArea, slider);

        equal(value, 0.3);
    });

    test('getValueFromPosition with small step 0.1 mouse position 50 should return 0.5', function () {
        var slider = $("#Slider3").data("tSlider");
        var mousePosition = 50;
        var dragableArea = {
            startPoint: 0,
            endPoint: slider.maxSelection
        };

        var value = $t.slider.getValueFromPosition(mousePosition, dragableArea, slider);

        equal(value, 0.5);
    });

    test('Slider should have number value', function () {
        var value = $("#Slider3").data("tSlider").value();

        equal(typeof (value), "number");
    });

    test('Slider should have integer number value', function () {
        $("#Slider3").data("tSlider").value(1);
        equal($("#Slider3").val(), "1");
    });

</script>
</asp:Content>