




namespace EasyUI.Web.Mvc.UI.Fluent
{
    using System;

    public class GridFilterCompositeBuilder<TBuilder> : GridFilterCompositeBuilderBase where TBuilder : GridFilterDescriptorBuilderBase
    {
        public GridFilterCompositeBuilder(CompositeFilterDescriptor descriptor) : base(descriptor)
        {
        }

        public virtual TBuilder And()
        {
            FilterDescriptor previous = Descriptor.FilterDescriptors[Descriptor.FilterDescriptors.Count - 1] as FilterDescriptor;

            if (previous == null)
            {
                throw new InvalidCastException();
            }

            FilterDescriptor descriptor = new FilterDescriptor { Member = previous.Member };

            Descriptor.FilterDescriptors.Add(descriptor);

            TBuilder builder = (TBuilder) Activator.CreateInstance(typeof(TBuilder), new object[] { Descriptor });

            return builder;
        }
    }
}