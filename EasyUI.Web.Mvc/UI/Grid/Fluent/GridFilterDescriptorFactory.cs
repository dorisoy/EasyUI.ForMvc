




namespace EasyUI.Web.Mvc.UI.Fluent
{
    using System;
    using System.Collections.Generic;
    using System.Linq.Expressions;

    using Extensions;
    using Infrastructure;

    public class GridFilterDescriptorFactory<TModel> : IHideObjectMembers where TModel : class
    {
        public GridFilterDescriptorFactory(IList<CompositeFilterDescriptor> filters)
        {
            Guard.IsNotNull(filters, "filters");

            Filters = filters;
        }

        protected IList<CompositeFilterDescriptor> Filters { get; private set; }

        public virtual GridFilterEqualityDescriptorBuilder<bool> Add(Expression<Func<TModel, bool>> expression)
        {
            CompositeFilterDescriptor filter = CreateFilter(expression);

            return new GridFilterEqualityDescriptorBuilder<bool>(filter);
        }

        public virtual GridFilterEqualityDescriptorBuilder<bool?> Add(Expression<Func<TModel, bool?>> expression)
        {
            CompositeFilterDescriptor filter = CreateFilter(expression);

            return new GridFilterEqualityDescriptorBuilder<bool?>(filter);
        }

        public virtual GridFilterComparisonDescriptorBuilder<TValue> Add<TValue>(Expression<Func<TModel, TValue>> expression)
        {
            CompositeFilterDescriptor filter = CreateFilter(expression);

            return new GridFilterComparisonDescriptorBuilder<TValue>(filter);
        }

        public virtual GridFilterStringDescriptorBuilder Add(Expression<Func<TModel, string>> expression)
        {
            CompositeFilterDescriptor filter = CreateFilter(expression);

            return new GridFilterStringDescriptorBuilder(filter);
        }

        protected virtual CompositeFilterDescriptor CreateFilter<TValue>(Expression<Func<TModel, TValue>> expression)
        {
            CompositeFilterDescriptor composite = new CompositeFilterDescriptor
                                                            {
                                                                LogicalOperator = FilterCompositionLogicalOperator.And
                                                            };

            FilterDescriptor descriptor = new FilterDescriptor { Member = expression.MemberWithoutInstance() };

            composite.FilterDescriptors.Add(descriptor);

            Filters.Add(composite);

            return composite;
        }
    }
}