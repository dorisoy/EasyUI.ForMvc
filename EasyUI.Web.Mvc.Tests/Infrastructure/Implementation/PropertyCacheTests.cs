// (c) Copyright EasyUI Corp. 
// This source is subject to the Microsoft Public License. 
// See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL. 


namespace EasyUI.Web.Mvc.Infrastructure.Implementation.Tests
{
    using Xunit;

    public class PropertyCacheTests
    {
        [Fact]
        public void Should_be_able_get_properties()
        {
            Assert.NotEmpty(new PropertyCache(new NoCache()).GetProperties(typeof(SiteMapBase)));
        }
    }
}