




namespace EasyUI.Web.Mvc.UI
{
    using System.Collections.Generic;
    using System.Web.Script.Serialization;

    public class TreeViewItem : NavigationItem<TreeViewItem>, INavigationItemContainer<TreeViewItem>, ITreeViewItem
    {
        public TreeViewItem()
        {
            this.Items = new LinkedObjectCollection<TreeViewItem>(this);
            
            if (string.IsNullOrEmpty(Value))
            {
                Value = Text;
            }

            Checkable = true;
        }

        public IList<TreeViewItem> Items
        {
            get;
            private set;
        }

        public string Value { get; set; }

        public bool Expanded { get; set; }

        public bool Checked { get; set; }

        public bool Checkable { get; set; }

        public bool LoadOnDemand { get; set; }
    }
}