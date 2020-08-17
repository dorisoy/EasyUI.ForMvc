// (c) Copyright EasyUI Corp. 
// This source is subject to the Microsoft Public License. 
// See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL. 


namespace EasyUI.Web.Mvc.UI.Tests
{
    using System.Web.Mvc;

    using Infrastructure;

    using Moq;
    using Xunit;

    public class HtmlHelperExtensionTests
    {
        //[Fact]
        //public void EasyUI_should_always_return_the_same_instance()
        //{
        //    Mock<IServiceLocator> locator = new Mock<IServiceLocator>();

        //    locator.Setup(l => l.Resolve<ScriptWrapperBase>()).Returns(new Mock<ScriptWrapperBase>().Object);
        //    locator.Setup(l => l.Resolve<IUrlGenerator>()).Returns(new Mock<IUrlGenerator>().Object);
        //    locator.Setup(l => l.Resolve<INavigationItemAuthorization>()).Returns(new Mock<INavigationItemAuthorization>().Object);
        //    locator.Setup(l => l.Resolve<IClientSideObjectWriterFactory>()).Returns(new Mock<IClientSideObjectWriterFactory>().Object);
        //    locator.Setup(l => l.Resolve<IConfigurationManager>()).Returns(new Mock<IConfigurationManager>().Object);

        //    ServiceLocator.SetCurrent(() => locator.Object);

        //    HtmlHelper helper = TestHelper.CreateHtmlHelper();

        //    ViewComponentFactory factory1 = helper.EasyUI();
        //    ViewComponentFactory factory2 = helper.EasyUI();

        //    Assert.Same(factory1, factory2);
        //}
#if MVC2 || MVC3
        //[Fact]
        //public void EasyUI_TModel_should_always_return_the_same_instance_if_the_model_is_same()
        //{
        //    Mock<IServiceLocator> locator = new Mock<IServiceLocator>();

        //    locator.Setup(l => l.Resolve<ScriptWrapperBase>()).Returns(new Mock<ScriptWrapperBase>().Object);
        //    locator.Setup(l => l.Resolve<IUrlGenerator>()).Returns(new Mock<IUrlGenerator>().Object);
        //    locator.Setup(l => l.Resolve<INavigationItemAuthorization>()).Returns(new Mock<INavigationItemAuthorization>().Object);
        //    locator.Setup(l => l.Resolve<IClientSideObjectWriterFactory>()).Returns(new Mock<IClientSideObjectWriterFactory>().Object);
        //    locator.Setup(l => l.Resolve<IConfigurationManager>()).Returns(new Mock<IConfigurationManager>().Object);

        //    ServiceLocator.SetCurrent(() => locator.Object);

        //    HtmlHelper<TestModel> helper = TestHelper.CreateHtmlHelper<TestModel>();

        //    ViewComponentFactory factory1 = helper.EasyUI<TestModel>();
        //    ViewComponentFactory factory2 = helper.EasyUI <TestModel>();

        //    Assert.Same(factory1, factory2);
        //}

        public class TestModel 
        {
            public int ID { get; set; }
            public double DoubleProperty { get; set; }
        }
#endif
    }
}