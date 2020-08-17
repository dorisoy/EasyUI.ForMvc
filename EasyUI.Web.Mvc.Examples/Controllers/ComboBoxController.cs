namespace EasyUI.Web.Mvc.Examples
{
    using System.Web.Mvc;
    using System.ComponentModel;
    
    [AutoPopulateSourceCode]
    [PopulateProductSiteMap(SiteMapName = "examples", ViewDataKey = "easyui.mvc.examples")]
    public partial class ComboBoxController : Controller
    {
    }

    public class AjaxComboBoxAttributes
    {
        public int? FilterMode { get; set; }
        public int? MinimumChars { get; set; }
        public int? Delay { get; set; }
        public bool? Cache { get; set; }
        public bool? HighlightFirst { get; set; }
        public bool? AutoFill { get; set; }
    }

    public class AjaxAutoCompleteAttributes
    {
        public int? FilterMode { get; set; }
        public int? MinimumChars { get; set; }
        public int? Delay { get; set; }
        public bool? Cache { get; set; }
        public bool? HighlightFirst { get; set; }
        public bool? AutoFill { get; set; }

        public bool? AllowMultipleValues { get; set; }

        public string MultipleSeparator { get; set; }
    }

    public class AutoCompleteAttributes
    {
        public int? Width { get; set; }
        
        public int? FilterMode { get; set; }

        public int? MinimumChars { get; set; }

        [DisplayName("<strong>highlight</strong> its first item")]
        public bool? HighlightFirst { get; set; }

        [DisplayName("<strong>auto-fill</strong> text")]
        public bool? AutoFill { get; set; }

        [DisplayName("allow <strong>multiple</strong> values")]
        public bool? AllowMultipleValues { get; set; }

        [DisplayName("separated by")]
        public string MultipleSeparator { get; set; }
    }

    public class ComboBoxAttributes
    {
        public int? Width { get; set; }
        public int? SelectedIndex { get; set; }

        public int? FilterMode { get; set; }

        public int? MinimumChars { get; set; }
        public bool? HighlightFirst { get; set; }
        public bool? AutoFill { get; set; }
        public bool? OpenOnFocus { get; set; }
    }

    public class DropDownListAttributes
    {
        public int? Width { get; set; }

        public int? SelectedIndex { get; set; }
    }
}