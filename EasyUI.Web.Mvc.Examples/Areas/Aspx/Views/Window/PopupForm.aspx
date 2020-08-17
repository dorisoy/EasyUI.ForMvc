﻿<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Examples.Master" %>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">

	<%  Html.EasyUI().Window()
            .Name("Window")
            .Title("Submit feedback")
            .Content(() => {%>
                <% using (Html.BeginForm("popupform", "window", FormMethod.Post, new { id = "feedback-form" }))
                   { %>
                        <p class="note">This is just an example, sent data will <strong>not</strong> be saved.</p>

                        <label for="name">Name:</label>
                        <%: Html.TextBox("name") %>

                        <label for="email">E-mail:</label>
                        <%: Html.TextBox("email") %>

                        <label for="comment-value">Comments:</label>
                        <%: Html.EasyUI().Editor()
                                .Name("comment")
                                .Tools(tools => tools
                                    .Clear()
                                    .Bold().Italic().Separator()
                                    .InsertOrderedList().InsertUnorderedList().Separator()
                                    .Indent().Outdent().Separator()
                                    .CreateLink()
                                )%>

                        <div class="form-actions">
                            <button type="submit" class="t-button">Submit feedback!</button>
                        </div>

                <% } %>
            <%})
            .Width(400)
            .Draggable(true)
            .Modal(true)
            .Visible(false)
            .Render();
	%>

    <button id="feedback-open-button" class="t-button">Submit feedback...</button>

    <% if (ViewData["name"] != null || ViewData["email"] != null || ViewData["comment"] != null) { %>
        <div class="t-group">
            <h3>Feedback:</h3>
    
            <p>
                Name: <%: ViewData["name"] %><br />
                E-mail: <%: ViewData["email"] %><br />
                Comment: <%: ViewData["comment"] %>
            </p>
        </div>
    <% } %>

    <% Html.EasyUI().ScriptRegistrar()
           .OnDocumentReady(() =>
           {%>
               // open the initially hidden window when the button is clicked
               $('#feedback-open-button')
                    .click(function(e) {
                        e.preventDefault();
                        $('#Window').data('tWindow').center().open();
                    });
           <%}); %>

</asp:Content>

<asp:Content ContentPlaceHolderID="HeadContent" runat="server">

    <style type="text/css">
        
        #feedback-open-button
        {
            height: 32px;
            margin: 2em 0 4em;
        }
        
        #feedback-form
        {
            padding: 0 1em 1em;
        }
        
        #feedback-form label
        {
            display: block;
            line-height: 25px;
            margin-top: 1em;
        }
        
        #feedback-form input
        {
            width: 370px;
        }
        
        .form-actions
        {
            padding-top: 1em;
            overflow: hidden;
        }
        
        .form-actions button
        {
            float: right;
        }
        
        .example .t-group
        {
            border-width: 1px;
            border-style: solid;
            padding: 0 1em 1em;
        }
        
    </style>

</asp:Content>
