<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>

<asp:content contentplaceholderid="MainContent" runat="server">
    <div class="panel">
        <h3>ComboBox</h3>

         <%: Html.EasyUI().ComboBox()
                           .Name("ComboBox")
                           .ClientEvents(events => events
                           .OnDataBinding("onComboBoxDataBinding"))
        %>
    </div>

    <div class="panel">
        <h3>DropDownList</h3>

        <%: Html.EasyUI().DropDownList()
                          .Name("DropDownList")
                          .ClientEvents(events => events
                          .OnDataBinding("onDropDownListDataBinding"))
        %>
    </div>

    <div class="panel">
        <h3>AutoComplete</h3>

        <%: Html.EasyUI().AutoComplete()
                          .Name("AutoComplete")
                          .ClientEvents(events => events
                          .OnDataBinding("onAutoCompleteDataBinding"))
        %>
    </div>

    <script type="text/javascript">

        function onComboBoxDataBinding(e) {
            var comboBox = $('#ComboBox').data('tComboBox');

            comboBox.dataBind([
                { Text: "Product 1", Value: "1" },
                { Text: "Product 2", Value: "2", Selected: true },
                { Text: "Product 3", Value: "3" },
                { Text: "Product 4", Value: "4" },
                { Text: "Product 5", Value: "5" },
                { Text: "Product 6", Value: "6" },
                { Text: "Product 7", Value: "7" },
                { Text: "Product 8", Value: "8" },
                { Text: "Product 9", Value: "9" },
                { Text: "Product 10", Value: "10" },
                { Text: "Product 11", Value: "11" },
                { Text: "Product 12", Value: "12" },
                { Text: "Product 13", Value: "13" },
                { Text: "Product 14", Value: "14" },
                { Text: "Product 15", Value: "15" },
                { Text: "Product 16", Value: "16" },
                { Text: "Product 17", Value: "17" },
                { Text: "Product 18", Value: "18" },
                { Text: "Product 19", Value: "19" },
                { Text: "Product 20", Value: "20" }
            ], true /*preserve state*/);
        }

        function onDropDownListDataBinding(e) {
            var dropDownList = $('#DropDownList').data('tDropDownList');

            dropDownList.dataBind([
                { Text: "Product 1", Value: "1" },
                { Text: "Product 2", Value: "2", Selected: true },
                { Text: "Product 3", Value: "3" },
                { Text: "Product 4", Value: "4" },
                { Text: "Product 5", Value: "5" },
                { Text: "Product 6", Value: "6" },
                { Text: "Product 7", Value: "7" },
                { Text: "Product 8", Value: "8" },
                { Text: "Product 9", Value: "9" },
                { Text: "Product 10", Value: "10" },
                { Text: "Product 11", Value: "11" },
                { Text: "Product 12", Value: "12" },
                { Text: "Product 13", Value: "13" },
                { Text: "Product 14", Value: "14" },
                { Text: "Product 15", Value: "15" },
                { Text: "Product 16", Value: "16" },
                { Text: "Product 17", Value: "17" },
                { Text: "Product 18", Value: "18" },
                { Text: "Product 19", Value: "19" },
                { Text: "Product 20", Value: "20" }
            ]);
        }

        function onAutoCompleteDataBinding(e) {
            var autocomplete = $('#AutoComplete').data('tAutoComplete');

            autocomplete.dataBind(["Product 1", "Product 2", "Product 3", "Product 4", "Product 5", "Product 6", "Product 7",
                                    "Product 8", "Product 9", "Product 10", "Product 11", "Product 12", "Product 13", "Product 14",
                                    "Product 15", "Product 16", "Product 17", "Product 18", "Product 19", "Product 20" ], true /*preserve state*/);
        }

    </script>
</asp:content>

<asp:Content runat="server" ContentPlaceHolderID="HeadContent">

    <style type="text/css">
        .panel 
        {
             float:left;
             width:30%;
             padding-bottom: 3em;
        }
        
        .panel h3
        {
            font-weight: normal;
        }
        
        .panel .t-autocomplete
        {
            margin-top: 2px;
        }
    </style>
</asp:Content>