﻿// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.UI.Html.Tests
{
    using Moq;
    using System.Web.Routing;
    using Xunit;

    public class GridButtonBaseTests
    {
        class GridButtonTestDouble : GridButtonBuilderBase
        {
            protected override string ButtonTagName
            {
                get
                {
                    return "button";
                }
            }
        }

        private readonly GridButtonBuilderBase button;

        public GridButtonBaseTests()
        {
            button = new GridButtonTestDouble();
        }

        [Fact]
        public void Should_apply_decorators()
        {
            var decorator = new Mock<IGridButtonBuilderDecorator>();
            decorator.Setup(d => d.Apply(It.IsAny<IHtmlNode>()));

            button.Decorators.Add(decorator.Object);

            button.Create(null);

            decorator.VerifyAll();
        }        
        
        [Fact]
        public void Should_apply_html_attributes_to_button_tag()
        {
            button.HtmlAttributes = new RouteValueDictionary(new { foo = "bar" });

            var result = button.Create(null);

            result.Attribute("foo").ShouldEqual("bar"); 
        }

        [Fact]
        public void Should_apply_css_class()
        {
            button.CssClass = "foo";
            
            var result = button.Create(null);

            result.Attribute("class").Split(' ').ShouldContain("foo"); 
        }
    }
}