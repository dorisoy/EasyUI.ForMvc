<%@ Page Title="Ajax Loading Of Content Tests" Language="C#" MasterPageFile="~/Views/Shared/Site.Master"
    Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <h2>
        Ajax Loading Of Content Tests</h2>
    <% Html.EasyUI().PanelBar()
            .Name("myPanelBar")
            .Items(parent =>
            {
                parent.Add().Text("Item 0")
                            .Content(() =>
                            {%>
                                <p>
                                    Lipsum!!!</p>
                            <%})
                            .Expanded(true);
                
                parent.Add().Text("Item 1")
                            .Content(() =>
                            {%>
                                <p>
                                    Lipsum!!!</p>
                            <%})
                            .Expanded(true);

                parent.Add().Text("Item 2")
                            .Content(() =>
                            {%>
                                <p>
                                    Lipsum!!!</p>
                            <%})
                            .Expanded(false);
                parent.Add().Text("Item 3")
                            .Content(() =>
                                        {%>
                                <p>
                                    Lipsum!!!</p>
                                <%})
                            .Expanded(false);

                parent.Add().Text("Item 4")
                            .LoadContentFrom(Url.Action("AjaxView1", "PanelBar"));

                parent.Add().Text("Item 5")
                            .LoadContentFrom(Url.Action("AjaxView2", "PanelBar"));
                parent.Add().Text("Item 6")
                            .Content(() =>
                            {%>
                                <p>
                                    Lipsum!!!</p>
                            <%});
            }) 
            .Effects(effects=>effects.Toggle())
            .Render(); %>

    <script type="text/javascript">

        function getRootItem(index) {
            return $('#myPanelBar').find('.t-header').eq(index)
        }

    </script>

</asp:Content>


<asp:Content ContentPlaceHolderID="TestContent" runat="server">

<script type="text/javascript">



        test('clicking expanded content items should collapse them', function() {
        
            var item = getRootItem(0);

            item.trigger('click');
            
            equal(item.parent().find('.t-content').css("display"), 'none');
        });

        test('clicking expanded content items should toggle arrow', function() {
            var item = getRootItem(1);

            item.trigger('click');

            ok(item.parent().find('.t-icon').hasClass('t-arrow-down'));
        });

        test('clicking collapsed content items should expand them', function() {
            var item = getRootItem(2);

            item.trigger('click');

            equal(item.parent().find('.t-content').css("display"), "block");
        });

        test('clicking collapsed content items should toggle arrow', function() {
            var item = getRootItem(3);

            item.trigger('click');

            ok(item.parent().find('.t-icon').hasClass('t-arrow-up'));
        });

        test('clicking should make item active', function() {

            var item = getRootItem(6);
            
            item.trigger('click');

            ok(item.parent().hasClass('t-state-active'));
        });

</script>

</asp:Content>