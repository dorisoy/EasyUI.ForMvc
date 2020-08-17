




namespace EasyUI.Web.Mvc.UI.Fluent
{
    using System;
    using EasyUI.Web.Mvc.Infrastructure;

    public class GridToolBarCommandFactory<T> : IHideObjectMembers where T : class
    {
        private readonly GridToolBarSettings<T> settings;

        public GridToolBarCommandFactory(GridToolBarSettings<T> settings)
        {
            this.settings = settings;
        }

        public GridToolBarCommandFactory<T> Position(GridToolBarPosition value)
        {
            settings.Position = value;

            return this;
        }

#if MVC2 || MVC3
        
        public GridToolBarCommandBuilder<T> Insert()
        {
            var command = new GridToolBarInsertCommand<T>();

            settings.Commands.Add(command);

            settings.Grid.Editing.Enabled = true;

            return new GridToolBarCommandBuilder<T>(command);
        }
        
        public GridToolBarCommandBuilder<T> SubmitChanges()
        {
            var command = new GridToolBarSubmitChangesCommand<T>();

            settings.Commands.Add(command);

            settings.Grid.Editing.Enabled = true;

            return new GridToolBarCommandBuilder<T>(command);
        }

#endif
        public GridToolBarCustomCommandBuilder<T> Custom()
        {
            var command = new GridToolBarCustomCommand<T>();

            settings.Commands.Add(command);

            return new GridToolBarCustomCommandBuilder<T>(command);
        }

        public void Template(Func<object, object> template)
        {
            Guard.IsNotNull(template, "template");

            settings.Template.InlineTemplate = template;
        }

        public void Template(Action template)
        {
            Guard.IsNotNull(template, "template");

            settings.Template.Content = template;
        }

        public void Template(string template)
        {
            Guard.IsNotNullOrEmpty(template, "template");

            settings.Template.Html = template;
        }
    }
}