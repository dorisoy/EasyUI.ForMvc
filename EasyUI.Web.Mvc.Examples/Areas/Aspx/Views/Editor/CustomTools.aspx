﻿<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<EmployeeDto>" %>

<asp:content contentplaceholderid="MainContent" runat="server">

    <% Html.EasyUI().Editor()
            .Name("Editor")
            .Value(() =>
            {   %>
                &lt;p&gt;&nbsp;
                    &lt;img src=&quot;<%: Url.Content("~/Content/Editor/editor.png")%>&quot;
                            alt=&quot;Editor for ASP.NET MVC logo&quot;
                            style=&quot;display:block;margin-left:auto;margin-right:auto;&quot; /&gt;

                    EasyUI Editor for ASP.NET MVC allows your users to edit HTML in a familiar,
                    user-friendly way.&lt;br /&gt;
                    In this version, the Editor provides the core HTML editing engine, which includes
                    basic text formatting, hyperlinks, lists, and image handling.
                    The extension &lt;strong&gt;outputs identical HTML&lt;/strong&gt;
                    across all major browsers, follows accessibility standards
                    and provides an extended programming API for content manipulation.
                &lt;/p&gt;
                <% 
            })
            .Tools(tools => tools
                .Clear()
                .Custom(settings => settings.HtmlAttributes(new { @class = "t-html" }))
                .Separator()
                .Custom(settings => settings.Template(() =>
                    {
                        Html.EasyUI().DropDownList()
                            .Name("Languages")
                            .Items(items =>
                            {
                                items.Add().Text("English").Value("en");
                                items.Add().Text("Spanish").Value("es");
                                items.Add().Text("German").Value("de");
                                items.Add().Text("French").Value("fr");
                                items.Add().Text("Italian").Value("it");
                            })
                            .ClientEvents(events => events.OnChange("onLanguageChange"))
                            .Render();
                    }))
            )
            .Render();
    %>

    <script type="text/javascript">

        function onLanguageChange() {
            var editor = $('#Editor').data('tEditor');
            var html = editor.value();
            var $dropdown = $(this);
            var dropDown = $dropdown.data('tDropDownList');
            var language = dropDown.value();

            $dropdown.find('.t-arrow-down').addClass('t-loading');

            $.ajax({
                url: 'http://ajax.googleapis.com/ajax/services/language/translate',
                dataType: 'jsonp',
                data: { 
                    q : html.substr(0, 800),
                    v: '1.0',
                    langpair: '|' + language
                },
                error: function() {
                    $dropdown.find('.t-arrow-down').removeClass('t-loading');
                    alert(error);
                },
                success: function(response) {
                    $dropdown.find('.t-arrow-down').removeClass('t-loading');
                    if (response.responseStatus != 200) {
                        alert('Translation error: ' + response.responseDetails);
                        return false;
                    }
                
                    editor.value(response.responseData.translatedText);
                }
          }); 
        }

        var htmlSourcePopup;

        function showHtml(e) {
            e.stopPropagation();
            e.preventDefault();
        
            var editor = $('#Editor').data('tEditor');
            var html = editor.value();

            if (!htmlSourcePopup) {
                htmlSourcePopup =
                    $('<div class="html-view">' +
                          '<div class="textarea t-state-default"><textarea></textarea></div>' +
                          '<div class="t-button-wrapper">' + 
                              '<button id="htmlCancel" class="t-button">Cancel</button>' +
                              '<button id="htmlUpdate" class="t-button">Update</button>' +
                          '</div>' +
                      '</div>')
                    .css('display', 'none')
                  .tWindow({
                        title: 'View Generated HTML',
                        modal: true, 
                        resizable: false, 
                        draggable: true,
                        width: 700,
                        onLoad: function() {
                            var $popup = $(this);
                            $popup.find('.textarea')
                                    .css('width', function() {
                                        return 700 - (this.offsetWidth - $(this).width());
                                    })
                                    .focus()
                                  .end()
                                  .find('#htmlCancel')
                                    .click(function() {
                                        htmlSourcePopup.close();
                                    })
                                  .end()
                                  .find('#htmlUpdate')
                                    .click(function() {
                                        var value = $popup.find('textarea').val();
                                        editor.value(value);
                                        htmlSourcePopup.close();
                                    });
                        },
                        onClose: function() {
                            editor.focus();
                        },
                        effects: $.easyui.fx.toggle.defaults()
                })
                .data('tWindow');
            }

            $(htmlSourcePopup.element).find('textarea').text(html);

            htmlSourcePopup.center().open();
        }

    </script>

    <%-- attach handler for html viewer --%>
    <% Html.EasyUI().ScriptRegistrar().OnDocumentReady(() => { %>
            $('.t-html').click(showHtml);
    <% }); %>

</asp:content>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .t-editor .t-html
        {
            background-image: url('<%: Url.Content("~/Content/Editor/CustomTools/insert-html-icon.png") %>');
        }
        
        .html-view .t-button-wrapper
        {
            padding: .5em 0;
        }
        
        #htmlCancel
        {
            float: right;
        }
        
        .textarea
        {
            border-width: 1px;
            border-style: solid;
        }
        
        .textarea textarea
        {
             margin: 0;
             padding: 0;
             border: 0;
             font: normal 12px Consolas,Courier New,monospace;
             width: 100%;
             height: 300px;
        }
    </style>
</asp:Content>