// (c) Copyright EasyUI Corp. 
// This source is subject to the Microsoft Public License. 
// See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL. 


namespace EasyUI.Web.Mvc.Tests
{
    using Xunit;

    public class SiteMapManagerTests
    {
        public SiteMapManagerTests()
        {
            SiteMapManager.Clear();
        }

        [Fact]
        public void SiteMaps_should_not_be_null()
        {
            Assert.NotNull(SiteMapManager.SiteMaps);
        }
    }
}