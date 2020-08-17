namespace EasyUI.Web.Mvc.Examples
{
    using System;
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.UI;

    public partial class SliderController : Controller
    {
        public ActionResult FirstLook(SliderFirstLookModelView model)
        {
            model.SliderAttributes.SliderOrientation = model.SliderAttributes.SliderOrientation ?? SliderOrientation.Horizontal;
            model.SliderAttributes.SmallStep = model.SliderAttributes.SmallStep ?? 1;
            model.SliderAttributes.LargeStep = model.SliderAttributes.LargeStep ?? 5;
            model.SliderAttributes.MinValue = model.SliderAttributes.MinValue ?? 0;
            model.SliderAttributes.MaxValue = model.SliderAttributes.MaxValue ?? 10;
            model.SliderAttributes.ShowButtons = model.SliderAttributes.ShowButtons ?? true;
            model.SliderAttributes.TickPlacement = model.SliderAttributes.TickPlacement ?? SliderTickPlacement.Both;
            model.SliderAttributes.Value = model.SliderAttributes.Value ?? 5;

            model.RangeSliderAttributes.SliderOrientation = model.RangeSliderAttributes.SliderOrientation ?? SliderOrientation.Horizontal;
            model.RangeSliderAttributes.SmallStep = model.RangeSliderAttributes.SmallStep ?? 1;
            model.RangeSliderAttributes.LargeStep = model.RangeSliderAttributes.LargeStep ?? 5;
            model.RangeSliderAttributes.MinValue = model.RangeSliderAttributes.MinValue ?? 0;
            model.RangeSliderAttributes.MaxValue = model.RangeSliderAttributes.MaxValue ?? 10;
            model.RangeSliderAttributes.TickPlacement = model.RangeSliderAttributes.TickPlacement ?? SliderTickPlacement.Both;
            model.RangeSliderAttributes.SelectionStart = model.RangeSliderAttributes.SelectionStart ?? 3;
            model.RangeSliderAttributes.SelectionEnd = model.RangeSliderAttributes.SelectionEnd ?? 7;

            return View(model);
        }
    }

    public class SliderFirstLookModelView
    {
        public SliderFirstLookModelView()
        {
            SliderAttributes = new SliderAttributes();
            RangeSliderAttributes = new RangeSliderAttributes();
        }

        public SliderAttributes SliderAttributes { get; set; }
        public RangeSliderAttributes RangeSliderAttributes { get; set; }
    }
}