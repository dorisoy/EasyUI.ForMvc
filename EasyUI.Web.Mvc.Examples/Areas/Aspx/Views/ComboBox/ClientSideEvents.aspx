<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Product>>" %>
<asp:Content contentPlaceHolderID="MainContent" runat="server">

    <div class="panel">
        <%: Html.EasyUI().ComboBox()
                          .Name("ComboBox")
                          .ClientEvents(events => events
                                  .OnLoad("onComboBoxLoad")
                                  .OnDataBinding("onComboBoxDataBinding")
                                  .OnDataBound("onComboBoxDataBound")
                                  .OnChange("onComboBoxChange")
                                  .OnOpen("onComboBoxOpen")
                                  .OnClose("onComboBoxClose")
                          )
                          .HtmlAttributes(new { style = "width: 200px; float: left; margin-bottom: 30px;" })
                          .DropDownHtmlAttributes( new { style = "height: 200px"})
                          .BindTo(new SelectList(Model, "ProductID", "ProductName"))
        %>

        <%: Html.EasyUI().DropDownList()
                          .Name("DropDownList")
                          .ClientEvents(events => events
                                  .OnLoad("onDropDownListLoad")
                                  .OnDataBinding("onDropDownListDataBinding")
                                  .OnDataBound("onDropDownListDataBound")
                                  .OnChange("onDropDownListChange")
                                  .OnOpen("onDropDownListOpen")
                                  .OnClose("onDropDownListClose")
                          )
                          .HtmlAttributes(new { style = "width: 200px; float: left; margin-bottom: 30px;" })
                          .DropDownHtmlAttributes( new { style = "height: 200px"})
                          .BindTo(new SelectList(Model, "ProductID", "ProductName"))
        %>

       <%: Html.EasyUI().AutoComplete()
                          .Name("AutoComplete")
                          .HtmlAttributes(new { style = "width: 196px; float: left; margin-bottom: 30px;" })
                          .ClientEvents(events => events
                                .OnLoad("onAutoCompleteLoad")
                                .OnDataBinding("onAutoCompleteDataBinding")
                                .OnDataBound("onAutoCompleteDataBound")
                                .OnChange("onAutoCompleteChange")
                                .OnOpen("onAutoCompleteOpen")
                                .OnClose("onAutoCompleteClose")
                          )
                          .Encode(false)
                          .Multiple()
                          .BindTo(Model.Select(p=>p.ProductName))
        %>
    </div>

    <div class="panel">
        <% Html.RenderPartial("EventLog"); %>
    </div>
    
    <script type="text/javascript">

        //ComboBox event handlers

        function onComboBoxChange(e) {
            $console.log('ComboBox OnChange :: value = ' + e.value + '.');
        }

        function onComboBoxDataBinding(e) {
            $console.log('ComboBox is binding.');
        }

        function onComboBoxDataBound(e) {
            $console.log('ComboBox is bound.');
        }

        function onComboBoxLoad(e) {
            $console.log('ComboBox loaded');
        }

        function onComboBoxOpen(e) {
            $console.log('ComboBox OnOpen :: pop-up DropDown is opened.');
        }

        function onComboBoxClose(e) {
            $console.log('ComboBox OnClose :: pop-up DropDown is closed.');
        }

        //DropDownList event handlers

        function onDropDownListChange(e) {
            $console.log('DropDownList OnChange :: value = ' + e.value + '.');
        }

        function onDropDownListDataBinding(e) {
            $console.log('DropDownList is binding.');
        }

        function onDropDownListDataBound(e) {
            $console.log('DropDownList is bound.');
        }

        function onDropDownListLoad(e) {
            $console.log('DropDownList loaded');
        }

        function onDropDownListOpen(e) {
            $console.log('DropDownList OnOpen :: pop-up DropDown is opened.');
        }

        function onDropDownListClose(e) {
            $console.log('DropDownList OnClose :: pop-up DropDown is closed.');
        }

        //AutoComplete event handlers

        function onAutoCompleteLoad(e) {
            $console.log('AutoComplete loaded');
        }

        function onAutoCompleteDataBinding(e) {
            $console.log('AutoComplete is binding.');
        }

        function onAutoCompleteDataBound(e) {
            $console.log('AutoComplete is bound.');
        }

        function onAutoCompleteChange(e) {
            $console.log('AutoComplete OnChange :: value = ' + e.value + '.');
        }

        function onAutoCompleteOpen(e) {
            $console.log('AutoComplete OnOpen :: pop-up DropDown is opened.');
        }

        function onAutoCompleteClose(e) {
            $console.log('AutoComplete OnClose :: pop-up DropDown is closed.');
        }
        
    </script>

</asp:Content>

<asp:Content ID="Content1" contentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        
        .panel 
        {
             float:left;
             width:34%;
        }
        
        .event-log-wrap
        {
            float: left;
            display: inline;
            width: 468px;
            margin-left: 10em;
        }
    
    </style>
</asp:Content>