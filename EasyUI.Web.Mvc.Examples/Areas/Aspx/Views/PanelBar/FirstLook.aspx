<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>
<asp:Content contentPlaceHolderID="MainContent" runat="server">
   
    <% Html.EasyUI().PanelBar()
            .Name("PanelBar")
            .HtmlAttributes(new { style = "width: 300px; float: left; margin-bottom: 30px;" })
            .ExpandMode((PanelBarExpandMode)Enum.Parse(typeof(PanelBarExpandMode), (string)ViewData["expandMode"]))
            .SelectedIndex(0)
            .Items(item =>
            {
                item.Add()
                    .Text("Mail")
                    .ImageUrl("~/Content/PanelBar/FirstLook/mail.gif")
                    .ImageHtmlAttributes(new { alt = "Mail Icon" })
                    .Items(subItem =>
                    {
                        subItem.Add()
                               .Text("Personal Folders")
                               .ImageUrl("~/Content/PanelBar/FirstLook/mailPersonalFolders.gif")
                               .ImageHtmlAttributes(new { alt = "Personal Folders Icon" });

                        subItem.Add()
                               .Text("Deleted Items")
                               .ImageUrl("~/Content/PanelBar/FirstLook/mailDeletedItems.gif")
                               .ImageHtmlAttributes(new { alt = "Deleted Items Icon" });

                        subItem.Add()
                               .Text("Inbox")
                               .ImageUrl("~/Content/PanelBar/FirstLook/mailInbox.gif")
                               .ImageHtmlAttributes(new { alt = "Inbox Icon" }).Enabled(false);

                        subItem.Add()
                               .Text("My Mail")
                               .ImageUrl("~/Content/PanelBar/FirstLook/mailFolder.gif")
                               .ImageHtmlAttributes(new { alt = "My Mail Icon" });

                        subItem.Add()
                               .Text("Sent Items")
                               .ImageUrl("~/Content/PanelBar/FirstLook/mailSent.gif")
                               .ImageHtmlAttributes(new { alt = "Sent Items Icon" });

                        subItem.Add()
                               .Text("Outbox")
                               .ImageUrl("~/Content/PanelBar/FirstLook/mailOutbox.gif")
                               .ImageHtmlAttributes(new { alt = "Outbox Icon" });

                        subItem.Add()
                               .Text("Search Folders")
                               .ImageUrl("~/Content/PanelBar/FirstLook/mailSearch.gif")
                               .ImageHtmlAttributes(new { alt = "Search Folders Icon" });
                    });

                item.Add()
                    .Text("Contacts")
                    .ImageUrl("~/Content/PanelBar/FirstLook/contacts.gif")
                    .ImageHtmlAttributes(new { alt = "Contacts Icon" }).Enabled(false)
                    .Items((subItem) =>
                    {
                        subItem.Add()
                               .Text("My Contacts")
                               .ImageUrl("~/Content/PanelBar/FirstLook/contactsItems.gif")
                               .ImageHtmlAttributes(new { alt = "Contact Icon" });

                        subItem.Add()
                               .Text("Address Cards")
                               .ImageUrl("~/Content/PanelBar/FirstLook/contactsItems.gif")
                               .ImageHtmlAttributes(new { alt = "Contact Icon" });

                        subItem.Add()
                               .Text("Phone List")
                               .ImageUrl("~/Content/PanelBar/FirstLook/contactsItems.gif")
                               .ImageHtmlAttributes(new { alt = "Contact Icon" });

                        subItem.Add()
                               .Text("Shared Contacts")
                               .ImageUrl("~/Content/PanelBar/FirstLook/contactsItems.gif")
                               .ImageHtmlAttributes(new { alt = "Contact Icon" });
                    });

                item.Add()
                    .Text("Tasks")
                    .ImageUrl("~/Content/PanelBar/FirstLook/tasks.gif")
                    .ImageHtmlAttributes(new { alt = "Tasks Icon" })
                    .Items((subItem) =>
                    {
                        subItem.Add()
                               .Text("My Tasks")
                               .ImageUrl("~/Content/PanelBar/FirstLook/tasksItems.gif")
                               .ImageHtmlAttributes(new { alt = "Task Icon" });

                        subItem.Add()
                               .Text("Shared Tasks")
                               .ImageUrl("~/Content/PanelBar/FirstLook/tasksItems.gif")
                               .ImageHtmlAttributes(new { alt = "Task Icon" });

                        subItem.Add()
                               .Text("Active Tasks")
                               .ImageUrl("~/Content/PanelBar/FirstLook/tasksItems.gif")
                               .ImageHtmlAttributes(new { alt = "Task Icon" });

                        subItem.Add()
                               .Text("Completed Tasks")
                               .ImageUrl("~/Content/PanelBar/FirstLook/tasksItems.gif")
                               .ImageHtmlAttributes(new { alt = "Task Icon" });
                    });

                item.Add()
                    .Text("Notes")
                    .ImageUrl("~/Content/PanelBar/FirstLook/notes.gif")
                    .ImageHtmlAttributes(new { alt = "Notes Icon" })
                    .Items((subItem) =>
                    {
                        subItem.Add()
                               .Text("My Notes")
                               .ImageUrl("~/Content/PanelBar/FirstLook/notesItems.gif")
                               .ImageHtmlAttributes(new { alt = "Note Icon" });

                        subItem.Add()
                               .Text("Notes List")
                               .ImageUrl("~/Content/PanelBar/FirstLook/notesItems.gif")
                               .ImageHtmlAttributes(new { alt = "Note Icon" });

                        subItem.Add()
                               .Text("Shared Notes")
                               .ImageUrl("~/Content/PanelBar/FirstLook/notesItems.gif")
                               .ImageHtmlAttributes(new { alt = "Note Icon" });

                        subItem.Add()
                               .Text("Archive")
                               .ImageUrl("~/Content/PanelBar/FirstLook/notesItems.gif")
                               .ImageHtmlAttributes(new { alt = "Note Icon" });
                    });

                item.Add()
                    .Text("Folders List")
                    .ImageUrl("~/Content/PanelBar/FirstLook/foldersList.gif")
                    .ImageHtmlAttributes(new { alt = "Folders List Icon" })
                    .Items((subItem) =>
                    {
                        subItem.Add()
                               .Text("My Client.Net")
                               .ImageUrl("~/Content/PanelBar/FirstLook/mailFolder.gif")
                               .ImageHtmlAttributes(new { alt = "Folder List Icon" });

                        subItem.Add()
                               .Text("My Profile")
                               .ImageUrl("~/Content/PanelBar/FirstLook/mailFolder.gif")
                               .ImageHtmlAttributes(new { alt = "Folder List Icon" });

                        subItem.Add()
                               .Text("My Support Tickets")
                               .ImageUrl("~/Content/PanelBar/FirstLook/mailFolder.gif")
                               .ImageHtmlAttributes(new { alt = "Folder List Icon" });

                        subItem.Add()
                               .Text("My Licenses")
                               .ImageUrl("~/Content/PanelBar/FirstLook/mailFolder.gif")
                               .ImageHtmlAttributes(new { alt = "Folder List Icon" });
                    });
            })
            .Render(); 
    %>

<% using (Html.Configurator("Allow...")
              .PostTo("FirstLook", "PanelBar")
              .Begin())
   { %>
	<ul>
		<li>
			<%: Html.RadioButton("expandMode", PanelBarExpandMode.Single.ToString(), true, new { id = "single" })%>
			<label for="single"><strong>only one panel</strong> to be expanded at a time</label>
		</li>
		<li>
			<%: Html.RadioButton("expandMode", PanelBarExpandMode.Multiple.ToString(), new { id = "multiple" })%>
			<label for="multiple"><strong>multiple panels</strong> to be expanded at a time</label>
		</li>
	</ul>
    <button type="submit" class="t-button">Apply</button>
<% } %>
		
</asp:Content>

<asp:Content contentPlaceHolderID="HeadContent" runat="server">
	<style type="text/css">
		/* adjust styles for the images (depending on their dimensions) */
		.example .t-panelbar .t-image
		{
			margin-top: 3px;
		}
		
		.example .t-panelbar .t-group .t-image
		{
			margin-left: 7px;
		}
		
	    .example .configurator
	    {
	        width: 300px;
	        float: left;
	        margin: 0 0 0 10em;
	        display: inline;
	    }
	</style>
</asp:Content>