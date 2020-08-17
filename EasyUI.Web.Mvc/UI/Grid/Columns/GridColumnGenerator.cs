




namespace EasyUI.Web.Mvc.UI
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Linq;
    using System.Linq.Expressions;
    using System.Reflection;
    using Extensions;    

    public class GridColumnGenerator<T> where T : class
    {
        private readonly Grid<T> grid;

        public GridColumnGenerator(Grid<T> grid)
        {
            this.grid = grid;
        }

        public IEnumerable<GridColumnBase<T>> GetColumns()
        {
            if (typeof(T) == typeof(DataRowView) && grid.DataSource is GridDataTableWrapper)
            {
                return GetColumnsForDataTable(grid.DataSource as GridDataTableWrapper);
            }

            return typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance)
                                .Where(property => property.CanRead && property.GetGetMethod().GetParameters().Length == 0)
                                .Where(property => property.PropertyType.IsEnum || (property.PropertyType != typeof(object) && property.PropertyType.IsPredefinedType())
                                    || (property.PropertyType.IsNullableType() && property.PropertyType.GetNonNullableType().IsPredefinedType()))
                                .Select(property => CreateBoundColumn(property));
        }

        private IEnumerable<GridColumnBase<T>> GetColumnsForDataTable(GridDataTableWrapper dataTableWrapper)
        {            
            var dataTable = dataTableWrapper.Table;
            if (dataTable == null)
            {
                return Enumerable.Empty<GridColumnBase<T>>();
            }
            return dataTable.Columns.OfType<DataColumn>()
                                    .Select(c => CreateBoundColumn(c.ColumnName, c.DataType));
        }

        public GridColumnBase<T> CreateBoundColumn(string memberName, Type memberType)
        {
            bool liftMemberAccess = false;

            if (grid.DataSource != null)
            {
                liftMemberAccess = grid.DataSource.AsQueryable().Provider.IsLinqToObjectsProvider();
            }

            LambdaExpression lambdaExpression = ExpressionBuilder.Lambda<T>(memberType, memberName, liftMemberAccess);

            Type columnType = typeof(GridBoundColumn<,>).MakeGenericType(new[] { typeof(T), lambdaExpression.Body.Type });

            ConstructorInfo constructor = columnType.GetConstructor(new[] { grid.GetType(), lambdaExpression.GetType() });

            IGridBoundColumn column = (IGridBoundColumn)constructor.Invoke(new object[] { grid, lambdaExpression });

            column.Member = memberName;
            column.Title = memberName.AsTitle();

            if (memberType != null)
            {
                column.MemberType = memberType;
            }
            return (GridColumnBase<T>)column;
        }

        public GridColumnBase<T> CreateBoundColumn(PropertyInfo property)
        {
            Type columnType = typeof(GridBoundColumn<,>).MakeGenericType(new[] { typeof(T), property.PropertyType });
            Type funcType = typeof(Func<,>).MakeGenericType(new[] { typeof(T), property.PropertyType });
            Type expressionType = typeof(Expression<>).MakeGenericType(new[] { funcType });

            ParameterExpression parameterExpression = Expression.Parameter(typeof(T), "x");

            Expression propertyExpression = Expression.Property(parameterExpression, property);
            
            Expression expression = Expression.Lambda(funcType, propertyExpression, parameterExpression);

            return (GridColumnBase<T>)columnType.GetConstructor(new[] { grid.GetType(), expressionType }).Invoke(new object[] { grid, expression });
        }
        
        public GridColumnBase<T> CreateColumn(GridColumnSettings settings)
        {
            var commandSettings = settings as GridCommandColumnSettings;
            if (commandSettings != null)
            {
                var column = new GridActionColumn<T>(grid);
                
                column.Settings = settings;
                
                foreach (var command in commandSettings.Commands)
                {
                    if (!(command is GridSelectActionCommand))
                    {
                        grid.Editing.Enabled = true;
                    }
                    column.Commands.Add(command);
                }

                return column;

            }
            return CreateBoundColumn(settings);
        }
        
        private GridColumnBase<T> CreateBoundColumn(GridColumnSettings settings)
        {
            var memberType = settings.MemberType;

            var lambdaExpression = ExpressionBuilder.Lambda<T>(memberType, settings.Member, false);

            var columnType = typeof(GridBoundColumn<,>).MakeGenericType(new[] { typeof(T), lambdaExpression.Body.Type });

            var constructor = columnType.GetConstructor(new[] { grid.GetType(), lambdaExpression.GetType() });

            var column = (GridColumnBase<T>)constructor.Invoke(new object[] { grid, lambdaExpression });

            if (memberType != null)
            {
                (column as IGridBoundColumn).MemberType = memberType;
            }

            column.Settings = settings;
            if (settings is GridColumnSettings<T>)
            {
                column.Template = ((GridColumnSettings<T>)settings).Template;
            }
            return column;
        }
    }
}