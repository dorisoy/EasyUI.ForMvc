// (c) Copyright 2002-2009 EasyUI 


            
namespace EasyUI.Web.Mvc.UI.Fluent
{
    public class GridReorderingSettingsBuilder: IHideObjectMembers
    {
        private readonly GridReorderingSettings settings;

        public GridReorderingSettingsBuilder(GridReorderingSettings settings)
        {
            this.settings = settings;
        }

        public GridReorderingSettingsBuilder Columns(bool value)
        {
            settings.Enabled = value;

            return this;
        }
    }
}
