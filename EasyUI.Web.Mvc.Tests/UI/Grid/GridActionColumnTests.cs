// (c) Copyright 2002-2009 EasyUI 



namespace EasyUI.Web.Mvc.UI.Tests
{
    using EasyUI.Web.Mvc.UI.Html;
    using Xunit;

    public class GridActionColumnTests
    {
        private readonly GridActionColumn<Customer> column;
        
        public GridActionColumnTests()
	    {
            column = new GridActionColumn<Customer>(GridTestHelper.CreateGrid<Customer>());
	    }

        [Fact]
        public void Should_create_action_command_builder()
        {
            column.CreateDisplayBuilder(null).ShouldBeType<GridActionCellBuilder>();
        }
    }
}
