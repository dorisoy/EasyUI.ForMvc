<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<TextBoxFirstLookModelView>" %>
<asp:content contentPlaceHolderID="MainContent" runat="server">

<div class="section">
    <%: Html.EasyUI().NumericTextBox()
            .Name("NumericTextBox")
            .Spinners(Model.NumericShowSpinners.Value)
            .MinValue(Model.NumericMinValue.Value)
            .MaxValue(Model.NumericMaxValue.Value)
    %>
    
    <% using (Html.Configurator("The numeric textbox should...")
              .PostTo("FirstLook", "NumericTextBox")
              .Begin())
   { %>
       <ul>
		    <li>
		        <label for="NumericMinValue">limit the <strong>minimum</strong> value to</label>
                <%:  Html.EasyUI().NumericTextBox()
                                   .Name("NumericMinValue")
                                   .MinValue(-100000)
                                   .MaxValue(100000)
                                   .Value(Model.NumericMinValue.Value)
                %>
		    </li>
		    <li>
		        <label for="NumericMaxValue">limit the <strong>maximum</strong> value to</label>
                <%:  Html.EasyUI().NumericTextBox()
                                   .Name("NumericMaxValue")
                                   .MinValue(-100000)
                                   .MaxValue(100000)
                                   .Value(Model.NumericMaxValue.Value)
                %>
            </li>
		    <li>
			    <%: Html.CheckBox("NumericShowSpinners", Model.NumericShowSpinners.Value)%>
			    <label for="NumericShowSpinners">show <strong>spin buttons</strong></label>
		    </li>
		</ul>
		
        <button type="submit" class="t-button">Apply</button>
    <% } %>
</div>

<div class="section">
   <%: Html.EasyUI().CurrencyTextBox()
           .Name("CurrencyTextBox")
           .Spinners(Model.CurrencyShowSpinners.Value)
           .MinValue(Model.CurrencyMinValue.Value)
           .MaxValue(Model.CurrencyMaxValue.Value)
    %>
    
    <% using (Html.Configurator("The currency textbox should...")
              .PostTo("FirstLook", "NumericTextBox")
              .Begin())
   { %>
       <ul>
		    <li>
		        <label for="CurrencyMinValue">limit the <strong>minimum</strong> value to</label>
                <%:  Html.EasyUI().CurrencyTextBox()
                                   .Name("CurrencyMinValue")
                                   .MinValue(-100000)
                                   .MaxValue(100000)
                                   .Value(Model.CurrencyMinValue.Value)
                %>
		    </li>
		    <li>
		        <label for="CurrencyMaxValue">limit the <strong>maximum</strong> value to</label>
                <%:  Html.EasyUI().CurrencyTextBox()
                                   .Name("CurrencyMaxValue")
                                   .MinValue(-100000)
                                   .MaxValue(100000)
                                   .Value(Model.CurrencyMaxValue.Value)
                %>
            </li>
		    <li>
			    <%: Html.CheckBox("CurrencyShowSpinners", Model.CurrencyShowSpinners.Value) %>
			    <label for="CurrencyShowSpinners">show <strong>spin buttons</strong></label>
		    </li>
		</ul>
		
        <button type="submit" class="t-button">Apply</button>
    <% } %>
    
</div>

<div class="section">

   <%: Html.EasyUI().PercentTextBox()
                     .Name("PercentTextBox")
                     .Spinners(Model.PercentShowSpinners.Value)
                     .MinValue(Model.PercentMinValue.Value)
                     .MaxValue(Model.PercentMaxValue.Value)
    %>
    
    <% using (Html.Configurator("The percent textbox should...")
              .PostTo("FirstLook", "NumericTextBox")
              .Begin())
   { %>
       <ul>
		    <li>
		        <label for="PercentMinValue">limit the <strong>minimum</strong> value to</label>
                <%:  Html.EasyUI().NumericTextBox()
                                   .Name("PercentMinValue")
                                   .MinValue(-100000)
                                   .MaxValue(100000)
                                   .Value(Model.PercentMinValue.Value)
                %>
		    </li>
		    <li>
		        <label for="PercentMaxValue">limit the <strong>maximum</strong> value to</label>
                <%:  Html.EasyUI().NumericTextBox()
                                   .Name("PercentMaxValue")
                                   .MinValue(-100000)
                                   .MaxValue(100000)
                                   .Value(Model.PercentMaxValue.Value)
                %>
            </li>
		    <li>
			    <%: Html.CheckBox("PercentShowSpinners", Model.PercentShowSpinners.Value)%>
			    <label for="PercentShowSpinners">show <strong>spin buttons</strong></label>
		    </li>
		</ul>
		
        <button type="submit" class="t-button">Apply</button>
    <% } %>
</div>

<div class="section">
   
   <%: Html.EasyUI().IntegerTextBox()
                     .Name("IntegerTextBox")
                     .Spinners(Model.IntegerShowSpinners.Value)
                     .MinValue(Model.IntegerMinValue.Value)
                     .MaxValue(Model.IntegerMaxValue.Value)
    %>
    
    <% using (Html.Configurator("The integer textbox should...")
              .PostTo("FirstLook", "NumericTextBox")
              .Begin())
   { %>
       <ul>
		    <li>
		        <label for="IntegerMinValue">limit the <strong>minimum</strong> value to</label>
                <%:  Html.EasyUI().IntegerTextBox()
                                   .Name("IntegerMinValue")
                                   .MinValue(-100000)
                                   .MaxValue(100000)
                                   .Value(Model.IntegerMinValue.Value)
                %>
		    </li>
		    <li>
		        <label for="IntegerMaxValue">limit the <strong>maximum</strong> value to</label>
                <%:  Html.EasyUI().IntegerTextBox()
                                   .Name("IntegerMaxValue")
                                   .MinValue(-100000)
                                   .MaxValue(100000)
                                   .Value(Model.IntegerMaxValue.Value)
                %>
            </li>
		    <li>
			    <%: Html.CheckBox("IntegerShowSpinners", Model.IntegerShowSpinners.Value)%>
			    <label for="IntegerShowSpinners">show <strong>spin buttons</strong></label>
		    </li>
		</ul>
		
        <button type="submit" class="t-button">Apply</button>
    <% } %>
</div>

</asp:content>

<asp:content contentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        
        .section
        {
            width: 40%;
            height: 300px;
            float: left;
            margin-right: 9%;
        }
        
        .configurator .t-input
        {
            width: 75px;
        }
        
        .configurator label
        {
            width: 155px;
        }
        
        .configurator li
        {
            padding-bottom: 4px;
        }
    </style>
</asp:content>