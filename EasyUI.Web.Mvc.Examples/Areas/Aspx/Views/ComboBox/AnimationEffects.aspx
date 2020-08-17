<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Product>>" %>
<asp:Content contentPlaceHolderID="MainContent" runat="server">

    <div class="panel">
        <%: Html.EasyUI().ComboBox()
                          .Name("ComboBox")
                          .Effects(fx =>
                          {
                              if (ViewData["animation"].ToString() == "slide")
                              {
                                  fx.Slide();
                              }
                              else
                              {
                                  /* activate only toggle, so that the items show */
                                  fx.Toggle();
                              }

                              fx.OpenDuration((int)ViewData["openDuration"])
                                .CloseDuration((int)ViewData["closeDuration"]);
                          })
                          .BindTo(new SelectList(Model, "ProductID", "ProductName", Model.ToList()[0]))
                          .HtmlAttributes(new { style = "clear:both; width: 200px; float: left; margin-bottom: 30px;" }) %>

        <%: Html.EasyUI().DropDownList()
                          .Name("DropDownList")
                          .Effects(fx =>
                          {
                              if (ViewData["animation"].ToString() == "slide")
                              {
                                  fx.Slide();
                              }
                              else
                              {
                                  /* activate only toggle, so that the items show */
                                  fx.Toggle();
                              }

                              fx.OpenDuration((int)ViewData["openDuration"])
                                .CloseDuration((int)ViewData["closeDuration"]);
                          })
                          .BindTo(new SelectList(Model, "ProductID", "ProductName", Model.ToList()[0]))
                          .HtmlAttributes(new { style = "clear:both; width: 200px; float: left; margin-bottom: 30px;" })%>

       <%: Html.EasyUI().AutoComplete()
                         .Name("AutoComplete")
                         .Effects(fx =>
                          {
                              if (ViewData["animation"].ToString() == "slide")
                              {
                                  fx.Slide();
                              }
                              else
                              {
                                  /* activate only toggle, so that the items show */
                                  fx.Toggle();
                              }

                              fx.OpenDuration((int)ViewData["openDuration"])
                                .CloseDuration((int)ViewData["closeDuration"]);
                          })
                          .Encode(false)
                          .BindTo(Model.Select(p => p.ProductName))
                          .HtmlAttributes(new { style = "clear:both; width: 200px; float: left; margin-bottom: 30px;" }) %>
    </div>
    <div class="panel">
        <% using (Html.Configurator("Animate with...")
                      .PostTo("AnimationEffects", "ComboBox")
                      .Begin())
           { %>
            <ul>
                 <li>
                    <%: Html.RadioButton("animation", "toggle", new { id = "toggle", title = "toggle" })%>
                    <label for="toggle"><strong>toggle</strong> animation</label>
                    <br />
                    <%: Html.RadioButton("animation", "slide", new { id = "slide", title = "slide" })%>
                    <label for="toggle"><strong>slide</strong> animation</label>
                </li>
                <li>
                    <ul>
                        <li>
                            <label for="openDuration">open for</label>
                            <%: Html.EasyUI().NumericTextBox()
                                              .Name("openDuration")
                                              .DecimalDigits(0)
                                              .NumberGroupSeparator("")
                                              .MinValue(0)
                                              .MaxValue(10000)
                                              .Value(Convert.ToDouble(ViewData["openDuration"]))
                            %> ms
                        </li>
                        <li>
                            <label for="closeDuration">close for</label>
                            <%: Html.EasyUI().NumericTextBox()
                                              .Name("closeDuration")
                                              .DecimalDigits(0)
                                              .NumberGroupSeparator("")
                                              .MinValue(0)
                                              .MaxValue(10000)
                                              .Value(Convert.ToDouble(ViewData["closeDuration"]))
                            %> ms
                        </li>
                    </ul>
                </li>
            </ul>
    
            <button class="t-button" type="submit">Apply</button>
        <% } %>
    </div>
    <% Html.EasyUI().ScriptRegistrar().OnDocumentReady(() => {%>
        /* client-side validation */
        $('.configurator button').click(function(e) {
            $('.configurator :text').each(function () {
                if ($(this).hasClass('t-state-error')) {
                    alert("TextBox `" + this.name + "` has an invalid param!");
                    e.preventDefault();
                }
            });
        });
    <%}); %>
    
</asp:Content>


<asp:Content contentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        
        .panel
        {
             float:left;
             width:47%;
        }
        
        .example .configurator
        {
            width: 300px;
            float: left;
            margin: 0 0 0 10em;
            display: inline;
        }
        
        .configurator li
        {
            padding: 3px 0;
        }
        
        .configurator input[type=text]
        {
            width: 50px;
        }
        
        .configurator ul ul
        {
            padding-left: 24px;
            margin: 0;
        }
        
        .configurator ul ul label
        {
            width: 48px;
            margin: 0;
        }
    
    </style>
</asp:Content>