<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<EasyUI.Web.Mvc.Examples.ComboBoxFirstLookModel>" %>

<asp:content contentPlaceHolderID="MainContent" runat="server">

    <h3>ComboBox</h3>

    <%: Html.EasyUI().ComboBox()
            .Name("ComboBox")
            .AutoFill(Model.ComboBoxAttributes.AutoFill.Value)
            .SelectedIndex(Model.ComboBoxAttributes.SelectedIndex.Value)
            .BindTo(new SelectList(Model.Products, "ProductID", "ProductName"))
            .HtmlAttributes(new { style = string.Format("width:{0}px", Model.ComboBoxAttributes.Width) })
            .Filterable(filtering =>
            {
                if (Model.ComboBoxAttributes.FilterMode != 0) 
                {
                    filtering.FilterMode(AutoCompleteFilterMode.StartsWith);
                }
            })
            .HighlightFirstMatch(Model.ComboBoxAttributes.HighlightFirst.Value)
            .OpenOnFocus(Model.ComboBoxAttributes.OpenOnFocus.Value)
    %>
    
    <% using (Html.Configurator("The ComboBox should...")
                  .PostTo("FirstLook", "ComboBox")
                  .Begin())
       { %>
        <ul>
            <li>
                <label for="ComboBoxAttributes_Width">be</label>
                <%: Html.EasyUI().IntegerTextBoxFor(m => m.ComboBoxAttributes.Width)
                        .InputHtmlAttributes(new { style = "width: 60px" })
                        .MinValue(0)
                        .MaxValue(1000)
                %>
                <label for="ComboBoxAttributes_Width">pixels <strong>wide</strong></label>
            </li>
            <li>
                <label for="ComboBoxAttributes_SelectedIndex"><strong>select item</strong> with index</label>
                <%: Html.EasyUI().NumericTextBoxFor(m => m.ComboBoxAttributes.SelectedIndex)
                        .InputHtmlAttributes(new { style = "width: 60px" })
                        .MinValue(-1)
                        .MaxValue(Model.Products.Count() - 1)
                        .DecimalDigits(0)
                %>
            </li>
            <li>
                <label for="ComboBoxAttributes_HighlightFirst"><strong>highlight</strong> first item</label>
                <%: Html.CheckBox("ComboBoxAttributes.HighlightFirst", Model.ComboBoxAttributes.HighlightFirst.GetValueOrDefault(false)) %>
            </li>
            <li>
                <label for="ComboBoxAttributes_AutoFill"><strong>auto-filling</strong> text</label>
                <%: Html.CheckBox("ComboBoxAttributes.AutoFill", Model.ComboBoxAttributes.AutoFill.GetValueOrDefault(false)) %>
            </li>
            <li>
                <label for="ComboBoxAttributes_OpenOnFocus"><strong>open on focus</strong> text</label>
                <%: Html.CheckBox("ComboBoxAttributes.OpenOnFocus", Model.ComboBoxAttributes.OpenOnFocus.GetValueOrDefault(false))%>
            </li>
        </ul>
        <button type="submit" class="t-button">Apply</button>
    <% } %>
    
    <h3>DropDownList</h3>

    <%: Html.EasyUI().DropDownList()
            .Name("DropDownList")
            .SelectedIndex(Model.DropDownListAttributes.SelectedIndex.Value)
            .BindTo(new SelectList(Model.Products, "ProductID", "ProductName"))
            .HtmlAttributes(new { style = string.Format("width:{0}px", Model.DropDownListAttributes.Width) })
    %>
    
    <% using (Html.Configurator("The DropDownList should...")
                  .PostTo("FirstLook", "ComboBox")
                  .Begin())
       { %>
        <ul>
            <li>
                <label for="DropDownListAttributes_Width">have a <strong>width</strong> of</label>
                <%: Html.EasyUI().IntegerTextBoxFor(m => m.DropDownListAttributes.Width)
                        .InputHtmlAttributes(new { style = "width: 60px" })
                        .MinValue(0)
                        .MaxValue(1000)
                %>
                pixels
            </li>
            <li>
                <label for="DropDownListAttributes_SelectedIndex"><strong>select item</strong> with index</label>
                <%: Html.EasyUI().IntegerTextBoxFor(m => m.DropDownListAttributes.SelectedIndex)
                        .InputHtmlAttributes(new { style = "width: 60px" })
                        .MinValue(0)
                        .MaxValue(Model.Products.Count() - 1)
                %>
            </li>
        </ul>
        <button type="submit" class="t-button">Apply</button>
    <% } %>

    <h3>AutoComplete</h3>

    <%: Html.EasyUI().AutoComplete()
            .Name("AutoComplete")
            .Encode(false)
            .BindTo(Model.Products.Select(p=>p.ProductName))
            .AutoFill(Model.AutoCompleteAttributes.AutoFill.Value)
            .HtmlAttributes(new { style = string.Format("width:{0}px", Model.AutoCompleteAttributes.Width) })
            .HighlightFirstMatch(Model.AutoCompleteAttributes.HighlightFirst.Value)
            .Filterable(filtering =>
            {
                if (Model.AutoCompleteAttributes.FilterMode != 0) 
                {
                    filtering.FilterMode(AutoCompleteFilterMode.StartsWith);
                }
            })
            .Multiple(multi =>
            {
                multi.Separator(Model.AutoCompleteAttributes.MultipleSeparator)
                    .Enabled(Model.AutoCompleteAttributes.AllowMultipleValues.Value);
                     
            })
    %>

    <% using (Html.Configurator("The AutoComplete should...")
                .PostTo("FirstLook", "ComboBox")
                .Begin())
       { %>
        <ul>
            <li>
                <label for="AutoCompleteAttributes_Width">have a <strong>width</strong> of</label>
                <%: Html.EasyUI().IntegerTextBoxFor(m => m.AutoCompleteAttributes.Width)
                        .InputHtmlAttributes(new { style = "width: 60px" })
                        .MinValue(0)
                        .MaxValue(1000)
                %>
                pixels
            </li>
            <li>
                <%: HttpUtility.HtmlDecode(Html.LabelFor(m => m.AutoCompleteAttributes.AllowMultipleValues).ToHtmlString()) %>
                <%: Html.CheckBox("AutoCompleteAttributes.AllowMultipleValues", Model.AutoCompleteAttributes.AllowMultipleValues.GetValueOrDefault(false)) %>
                <%: Html.LabelFor(m => m.AutoCompleteAttributes.MultipleSeparator) %>
                <%: Html.TextBoxFor(m => m.AutoCompleteAttributes.MultipleSeparator, new { style = "width: 40px"}) %>
            </li>
            <li>
                <%: HttpUtility.HtmlDecode(Html.LabelFor(m => m.AutoCompleteAttributes.HighlightFirst).ToHtmlString()) %>
                <%: Html.CheckBox("AutoCompleteAttributes.HighlightFirst", Model.AutoCompleteAttributes.HighlightFirst.GetValueOrDefault(false)) %>
            </li>
            <li>
                <%: HttpUtility.HtmlDecode(Html.LabelFor(m => m.AutoCompleteAttributes.AutoFill).ToHtmlString()) %>
                <%: Html.CheckBox("AutoCompleteAttributes.AutoFill", Model.AutoCompleteAttributes.AutoFill.GetValueOrDefault(false)) %>
            </li>
        </ul>
        <button type="submit" class="t-button">Apply</button>
    <% } %>

</asp:content>

<asp:content ID="Content1" contentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .example .t-combobox
        {
            margin-bottom: 280px;
            float: left;
        }
        
        .example .t-dropdown
        {
            clear:both;
            margin-bottom: 230px;
            float: left;
        }
        
        #AutoComplete
        {
            clear:both;
            margin-bottom: 230px;
            float: left;
        }
       
        .example .configurator
        {
            width: 400px;
            float: left;
            margin: 0 0 0 15em;
            display: inline;
        }
        
        .configurator p
        {
            margin: 0;
            padding: .4em 0;
        }
        
        .configurator li
        {
            padding-bottom: 3px;
        }
        
        .configurator .t-dropdown
        {
            vertical-align: middle;
        }
    </style>
</asp:content>