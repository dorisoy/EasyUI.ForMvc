<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage" %>
<asp:content contentPlaceHolderID="MainContent" runat="server">
   
    <%: Html.EasyUI().TreeView()
            .Name("TreeView")
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
                               .ImageHtmlAttributes(new { alt = "Inbox Icon" });

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
                    .ImageHtmlAttributes(new { alt = "Contacts Icon" })
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
    %>
		
</asp:content>