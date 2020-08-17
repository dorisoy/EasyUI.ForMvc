﻿namespace EasyUI.Web.Mvc.UI.Tests.UITests
{
    using Moq;
    using System.Collections.Generic;
    using System.Web.Mvc;
    using EasyUI.Web.Mvc.Infrastructure;
    using Xunit;

    public class NavigationHtmlBuilderBaseTests
    {
        private Mock<IClientSideObjectWriterFactory> rendererFactory;
        private TComponentTestDouble component;
        NavigationHtmlBuilderBaseTestDouble builder;

        public NavigationHtmlBuilderBaseTests()
        {
            var viewContext = TestHelper.CreateViewContext();
            rendererFactory = new Mock<IClientSideObjectWriterFactory>();
            component = new TComponentTestDouble(viewContext, rendererFactory.Object);
            builder = new NavigationHtmlBuilderBaseTestDouble(component, null);
        }

        [Fact]
        public void ImageHtmlAttributes_set_the_attributes_of_the_image_tag()
        {
            const string value = "imageAlternativeName";

            NavigationItemTestDouble item = new NavigationItemTestDouble();

            item.ImageHtmlAttributes.Add("alt", value);
            item.ImageUrl = "#";

            IHtmlNode imageTag = builder.ImageTag(item);

            Assert.Equal(value, imageTag.Attribute("alt"));
        }

        [Fact]
        public void ImageTag_should_output_image_tag_with_alt_attribute_value_set_to_predifined_string()
        {
            const string value = "image";

            NavigationItemTestDouble item = new NavigationItemTestDouble();

            item.ImageUrl = "#";

            IHtmlNode imageTag = builder.ImageTag(item);

            Assert.Equal(value, imageTag.Attribute("alt"));
        }
    }

    public class NavigationHtmlBuilderBaseTestDouble : NavigationHtmlBuilderBase<TComponentTestDouble, NavigationItemTestDouble>
    {
        public NavigationHtmlBuilderBaseTestDouble(TComponentTestDouble component, IActionMethodCache cache)
            : base(component, cache)
        {

        }
    }

    public class TComponentTestDouble : ViewComponentBase, INavigationItemComponent<NavigationItemTestDouble>
    {
        public TComponentTestDouble(ViewContext viewContext, IClientSideObjectWriterFactory clientSideObjectWriterFactory)
            : base(viewContext, clientSideObjectWriterFactory)
        {
        }

        public IList<TComponentTestDouble> Items
        {
            get;
            set;
        }

        public IUrlGenerator UrlGenerator
        {
            get;
            set;
        }

        IList<NavigationItemTestDouble> INavigationItemContainer<NavigationItemTestDouble>.Items
        {
            get { throw new System.NotImplementedException(); }
        }

        #region INavigationItemComponent<NavigationItemTestDouble> Members


        public System.Action<NavigationItemTestDouble> ItemAction
        {
            get
            {
                throw new System.NotImplementedException();
            }
            set
            {
                throw new System.NotImplementedException();
            }
        }

        public INavigationItemAuthorization Authorization
        {
            get { throw new System.NotImplementedException(); }
        }

        #endregion
    }
}