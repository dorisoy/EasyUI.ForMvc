// (c) Copyright EasyUI Corp. 
// This source is subject to the Microsoft Public License. 
// See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL. 


namespace EasyUI.Web.Mvc.Infrastructure.Implementation.Tests
{
    using Xunit;

    public class FieldCacheTests
    {
        [Fact]
        public void Should_be_able_get_fields()
        {
            Assert.NotEmpty(new FieldCache(new NoCache()).GetFields(typeof(DummyObjectWithPublicField)));
        }

        public class DummyObjectWithPublicField
        {
            public string Field1;
        }
    }
}