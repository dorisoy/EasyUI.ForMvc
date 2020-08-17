﻿using EasyUI.Web.Mvc.Infrastructure;

namespace EasyUI.Web.Mvc.UI.Html
{
    
    
    static class GridDependencyBootstrapper
    {
        public static void Setup()
        {
            DI.Current.Register<IGridPagerButtonFactory>(() => new GridPagerButtonFactory());

            DI.Current.Register<IGridPagerInputBuilder>(() => new GridPagerInputSectionBuilder());
            DI.Current.Register<IGridPagerPageSizeSection>(() => new GridPagerPageSizeSection());

            DI.Current.Register<IGridPagerNumericSectionBuilder, IGridPagerButtonFactory>(buttonFactory => new GridPagerNumericSectionBuilder(buttonFactory));
            
            DI.Current.Register<IGridPagerPagingSectionsBuilder, IGridPagerButtonFactory, IGridPagerNumericSectionBuilder, IGridPagerInputBuilder, IGridPagerPageSizeSection>((buttonFactory, numericSectionBuilder, inputSectionBuilder, pageSizeSectionBuilder) =>
                new GridPagerPagingSectionsBuilder(buttonFactory, numericSectionBuilder, inputSectionBuilder, pageSizeSectionBuilder));

            DI.Current.Register<IGridPagerSectionsBuilder, IGridPagerPagingSectionsBuilder>(
                pagingSectionBuilder => new GridPagerSectionsBuilder(pagingSectionBuilder));

            DI.Current.Register<IGridPagerRefreshBuilder>(() => new GridPagerRefreshBuilder());

            DI.Current.Register<IGridPagerStatusBuilder>(() => new GridPagerStatusBuilder());

            DI.Current.Register<IGridPagerBuilder, IGridPagerSectionsBuilder, IGridPagerRefreshBuilder, IGridPagerStatusBuilder>(
                    (sectionsBuilder, refreshSection, statusBuilder) => new GridPagerBuilder(sectionsBuilder, refreshSection, statusBuilder));

            DI.Current.Register<IGridItemCreatorFactory>(() => new GridItemCreatorFactory());

            DI.Current.Register<IGridRowBuilderDecoratorProvider>(() => new GridRowBuilderDecoratorProvider());

            DI.Current.Register<IGridCellBuilderFactory>(() => new GridCellBuilderFactory());

            DI.Current.Register<IGridTableBulderFactory>(() => new GridTableBuilderFactory());

            DI.Current.Register<IGridRowBuilderFactory, IGridTableBulderFactory, IGridCellBuilderFactory, IGridRowBuilderDecoratorProvider>((tableBuilderFactory, cellBuilderFactory, decoratorsProvider)
                => new GridRowBuilderFactory(tableBuilderFactory, cellBuilderFactory, decoratorsProvider));

            DI.Current.Register<IGridDataSectionBuilder, IGridRowBuilderFactory, IGridItemCreatorFactory>((rowBuilderFactory, itemCreatorFactory) =>
                new GridDataSectionBuilder(rowBuilderFactory, itemCreatorFactory));

            DI.Current.Register<IGridGroupHeaderBuilder>(() => new GridGroupHeaderBuilder());
            
            DI.Current.Register<IGridToolBarBuilder>(() => new GridToolBarBuilder());

            DI.Current.Register<IGridFunctionalSectionBuilder, IGridPagerBuilder, IGridGroupHeaderBuilder, IGridToolBarBuilder>((pagerBuilder, groupHeaderBuilder, toolBarBuilder) =>
                new GridFunctionalSectionBuilder(pagerBuilder, groupHeaderBuilder, toolBarBuilder));

            DI.Current.Register<IGridHtmlBuilderFactory, IGridFunctionalSectionBuilder, IGridDataSectionBuilder, IGridTableBulderFactory>((functionalSectionBuilder, dataSectionBuilder, tableBuilderFactory)
                => new GridHtmlBuilderFactory(functionalSectionBuilder, dataSectionBuilder, tableBuilderFactory));

            DI.Current.Register<IGridActionResultAdapterFactory>(() => new GridActionResultAdapterFactory());

            DI.Current.Register<IGridActionResultFactory>(() => new GridActionResultFactory());
        }
    }
}
