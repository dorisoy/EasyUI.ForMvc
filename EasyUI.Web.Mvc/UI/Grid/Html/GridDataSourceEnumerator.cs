// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI.Html
{
    using System.Collections;
    using System.Collections.Generic;
    using EasyUI.Web.Mvc.Infrastructure;

    public class GridDataSourceEnumerator : IEnumerable<GridItem>
    {
        private readonly IEnumerable dataSource;
        private readonly IGridItemCreator creator;
        private readonly int groupLevel;

        protected GridDataSourceEnumerator(IEnumerable dataSource, IGridItemCreator creator, int groupLevel)
        {
            this.creator = creator;
            this.groupLevel = groupLevel;
            this.dataSource = dataSource;
        }

        public GridDataSourceEnumerator(IEnumerable dataSource, IGridItemCreator creator) 
            : this(dataSource, creator, 0)
        {
        }
        
        public IEnumerator<GridItem> GetEnumerator()
        {
            int counter = 0;
             
            var insertItem = creator.CreateInsertItem();

            if (insertItem != null && groupLevel == 0)
            {
                counter++;
                yield return insertItem;
            }
            
            if (dataSource != null)
            {
                foreach (var dataItem in dataSource)
                {
                    var result = creator.CreateItem(dataItem);
                    result.GroupLevel = groupLevel;
                    result.Index = counter++;

                    result.AsAlternating();

                    yield return result;

                    if (result.Type == GridItemType.GroupRow)
                    {
                        var group = dataItem as IGroup;
                        var enumerator = new GridDataSourceEnumerator(group.Items, creator, groupLevel + 1);

                        foreach (var item in enumerator)
                        {
                            yield return item;
                        }

                        var groupFooter = creator.CreateGroupFooterItem(group);
                        if (groupFooter != null)
                        {
                            groupFooter.Index = counter++;
                            yield return groupFooter;
                        }
                    }
                    else if ((result.State & GridItemStates.Master) == GridItemStates.Master)
                    {
                        yield return new GridDetailViewItem
                        {
                            DataItem = dataItem,
                            GroupLevel = result.GroupLevel,
                            Type = GridItemType.DetailRow,
                            Parent = result
                        };
                    }
                }
            }

            if (counter == 0)
            {
                yield return new GridItem
                {
                    Type = GridItemType.EmptyRow
                };
            }
        }
        
        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }
    }
}
