




namespace EasyUI.Web.Mvc.UI.Fluent
{
    using System;

    using Infrastructure;

    public abstract class GridFilterDescriptorBuilderBase : IHideObjectMembers
    {
        protected GridFilterDescriptorBuilderBase(CompositeFilterDescriptor descriptor)
        {
            Guard.IsNotNull(descriptor, "descriptor");

            Descriptor = descriptor;
        }

        protected CompositeFilterDescriptor Descriptor { get; private set; }

        protected virtual void SetOperatorAndValue(FilterOperator filterOperator, object value)
        {
            FilterDescriptor descriptor = Descriptor.FilterDescriptors[Descriptor.FilterDescriptors.Count - 1] as FilterDescriptor;

            if (descriptor == null)
            {
                throw new InvalidCastException();
            }

            descriptor.Operator = filterOperator;
            descriptor.Value = value;
        }
    }
}