// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI.Html.Tests
{
    using Xunit;

    public class GridPagerRefreshBuilderTests
    {
        [Fact]
        public void Should_create_div()
        {
            var builder = new GridPagerRefreshBuilder();

            var div = builder.Create(string.Empty, string.Empty);

            Assert.Equal("div", div.TagName);
            Assert.Equal("t-status", div.Attribute("class"));
        }

        [Fact]
        public void Should_create_link_inside_div()
        {
            const string url = "test";
            const string refreshText = "refreshText";

            var builder = new GridPagerRefreshBuilder();

            var div = builder.Create(url, refreshText);

            var link = div.Children[0];

            Assert.Equal("a", link.TagName);
            Assert.Equal("t-icon t-refresh", link.Attribute("class"));
            Assert.Equal(url, link.Attribute("href"));
            Assert.Equal(refreshText, link.InnerHtml);
        }
    }
}