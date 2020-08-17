<%@ Page Title="Ajax Loading Of Content Tests" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
        
    <%  Html.EasyUI().TabStrip()
            .Name("myTab")
            .Items(parent =>
            {
                parent.Add()
                    .Text("Nunc tincidunt")
                    .Content(() => {%>
                        <p>
                            Proin elit arcu, rutrum commodo, vehicula tempus, 
                            commodo a, risus. Curabitur nec arcu. Donec 
                            sollicitudin mi sit amet mauris. Nam elementum 
                            quam ullamcorper ante. Etiam aliquet massa et 
                            lorem. Mauris dapibus lacus auctor risus. Aenean 
                            tempor ullamcorper leo. Vivamus sed magna quis 
                            ligula eleifend adipiscing. Duis orci. Aliquam 
                            sodales tortor vitae ipsum. Aliquam nulla. Duis 
                            aliquam molestie erat. Ut et mauris vel pede 
                            varius sollicitudin. Sed ut dolor nec orci 
                            tincidunt interdum. Phasellus ipsum. Nunc 
                            tristique tempus lectus.
                        </p>
                    <%});
							  
                parent.Add()
                    .Text("Nunc tincidunt 2")
                    .Content(() =>
                            {%>
                                <p>
                                    Lipsum!!!
                            </p>
                            <%}
                    );

                parent.Add()
                    .Text("Proin dolor")
                    .LoadContentFrom(Url.Action("AjaxView1", "TabStrip"));

                parent.Add()
                    .Text("Aenean lacinia")
                    .LoadContentFrom(Url.Action("AjaxView2", "TabStrip"));

                parent.Add()
                    .Text("Disabled tab")
                    .Enabled(false)
                    .LoadContentFrom(Url.Action("AjaxView2", "TabStrip"));

                parent.Add()
                    .Text("contentLoad test")
                    .LoadContentFrom(Url.Action("AjaxView2", "TabStrip"));
            })
            .Render(); %>

</asp:Content>

<asp:Content ContentPlaceHolderID="TestContent" runat="server">

    <script type="text/javascript">

        function getTab(index) {
            return $('#myTab').find('.t-item').eq(index)
        }

        function getTabStrip() {
            return $("#myTab").data("tTabStrip");
        }

        test('clicking should make clicked item active', function() {
            var item = getTab(1);

            item.find('> .t-link').trigger('click');
            
            ok(item.hasClass('t-state-active'));
        });
        
        test('clicking should make all items except clicked unactive', function() {
            var item = getTab(0);

            item.find('> .t-link').trigger('click');

            equal(item.parent().find('.t-state-active').length, 1);
        });
        
        test('clicking disabled tab should not navigate', function() {
            var tabStrip = $(getTabStrip().element),
                item = getTab(4);

            var isDefaultPrevented = false,
                testHandler = function (e) {
                    isDefaultPrevented = e.isDefaultPrevented();
                    e.preventDefault();
                };

            tabStrip.delegate('.t-link', 'click', testHandler)
            item.find('> .t-link').trigger('click')
            tabStrip.undelegate('.t-link', 'click', testHandler);

            ok(isDefaultPrevented);
        });
        
        test('ajax content url should be attached to item', function() {
            var tabStrip = $(getTabStrip().element),
                item = getTab(5);

            equals(item.find('> .t-link').data('ContentUrl'), '<%= Url.Action("AjaxView2", "TabStrip") %>');
        });

    </script>

</asp:Content>