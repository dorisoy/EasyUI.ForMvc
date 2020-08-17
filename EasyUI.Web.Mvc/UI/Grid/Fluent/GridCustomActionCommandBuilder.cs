// (c) Copyright 2002-2011 EasyUI 




namespace EasyUI.Web.Mvc.UI.Fluent
{
    using System;
    using System.Web.Routing;
    using EasyUI.Web.Mvc.UI;
    public class GridCustomActionCommandBuilder<T> : GridActionCommandBuilderBase<GridCustomActionCommand<T>, GridCustomActionCommandBuilder<T>>
        where T : class
    {
        public GridCustomActionCommandBuilder(GridCustomActionCommand<T> command) : base(command)
        {

        }

        public GridCustomActionCommandBuilder<T> Text(string text)
        {
            Command.Text = text;

            return this;
        }

        public GridCustomActionCommandBuilder<T> Action(string actionName, string controllerName, RouteValueDictionary routeValues)
        {
            Command.Action(actionName, controllerName, routeValues);
            
            return this;
        }

        public GridCustomActionCommandBuilder<T> Action(string actionName, string controllerName, object routeValues)
        {
            Command.Action(actionName, controllerName, routeValues);
            
            return this;
        }

        public GridCustomActionCommandBuilder<T> Action(string actionName, string controllerName)
        {
            Command.Action(actionName, controllerName, (object)null);

            return this;
        }

        public GridCustomActionCommandBuilder<T> SendDataKeys(bool value)
        {
            Command.SendDataKeys = value;

            return this;
        }

        public GridCustomActionCommandBuilder<T> SendState(bool value)
        {
            Command.SendState = value;

            return this;
        }

        public GridCustomActionCommandBuilder<T> Ajax(bool enabled)
        {
            Command.Ajax = enabled;

            return this;
        }

        public GridCustomActionCommandBuilder<T> DataRouteValues(Action<GridDataKeyFactory<T>> factory)
        {
            factory(new GridDataKeyFactory<T>(Command.DataRouteValues, true));

            return this;
        }
    }
}