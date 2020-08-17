// (c) Copyright EasyUI Corp. 
// This source is subject to the Microsoft Public License. 
// See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL. 


namespace EasyUI.Web.Mvc.Extensions.Tests
{
    using Xunit;

    public class HttpContextBaseExtensionsTests
    {
        [Fact]
        public void RequestContext_should_return_new_context()
        {
            TestHelper.RegisterDummyRoutes();

            Assert.NotNull(TestHelper.CreateMockedHttpContext().Object.RequestContext());
        }
    }
}