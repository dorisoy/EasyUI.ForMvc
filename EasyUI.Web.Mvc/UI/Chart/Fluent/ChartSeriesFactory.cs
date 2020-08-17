﻿




namespace EasyUI.Web.Mvc.UI.Fluent
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;
    using System.Linq.Expressions;
    using EasyUI.Web.Mvc.Extensions;
    using EasyUI.Web.Mvc.Infrastructure;
    using EasyUI.Web.Mvc.UI;

    /// <summary>
    /// Creates series for the <see cref="Chart{TModel}" />.
    /// </summary>
    /// <typeparam name="TModel">The type of the data item to which the chart is bound to</typeparam>
    public class ChartSeriesFactory<TModel> : IHideObjectMembers
        where TModel : class
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ChartSeriesFactory{TModel}"/> class.
        /// </summary>
        /// <param name="container">The container.</param>
        public ChartSeriesFactory(Chart<TModel> container)
        {
            Guard.IsNotNull(container, "container");

            Container = container;
        }

        /// <summary>
        /// The parent Chart
        /// </summary>
        public Chart<TModel> Container
        {
            get;
            private set;
        }

        /// <summary>
        /// Defines bound bar series.
        /// </summary>
        /// <param name="expression">
        /// The expression used to extract the series value from the chart model
        /// </param>
        public virtual ChartBarSeriesBuilder<TModel> Bar<TValue>(Expression<Func<TModel, TValue>> expression)
        {
            Guard.IsNotNull(expression, "expression");

            ChartBarSeries<TModel, TValue> barSeries = new ChartBarSeries<TModel, TValue>(Container, expression);

            Container.Series.Add(barSeries);

            return new ChartBarSeriesBuilder<TModel>(barSeries);
        }

        /// <summary>
        /// Defines bound bar series.
        /// </summary>
        /// <param name="memberName">
        /// The name of the value member.
        /// </param>
        public virtual ChartBarSeriesBuilder<TModel> Bar(string memberName)
        {
            return Bar(null, memberName);
        }

        /// <summary>
        /// Defines bound bar series.
        /// </summary>
        /// <param name="memberType">
        /// The type of the value member.
        /// </param>
        /// <param name="memberName">
        /// The name of the value member.
        /// </param>
        public virtual ChartBarSeriesBuilder<TModel> Bar(Type memberType, string memberName)
        {
            var valueExpr = BuildMemberExpression(memberType, memberName);
            var seriesType = typeof(ChartBarSeries<,>).MakeGenericType(typeof(TModel), valueExpr.Body.Type);
            var series = (IChartBarSeries)BuildSeries(seriesType, valueExpr);

            series.Member = memberName;

            if (!series.Name.HasValue())
            {
                series.Name = memberName.AsTitle();
            }

            Container.Series.Add((ChartSeriesBase<TModel>)series);

            return new ChartBarSeriesBuilder<TModel>(series);
        }

        /// <summary>
        /// Defines bar series bound to inline data.
        /// </summary>
        /// <param name="data">
        /// The data to bind to.
        /// </param>
        public virtual ChartBarSeriesBuilder<TModel> Bar(IEnumerable data)
        {
            Guard.IsNotNull(data, "data");

            ChartBarSeries<TModel, object> barSeries = new ChartBarSeries<TModel, object>(Container, data);

            Container.Series.Add(barSeries);

            return new ChartBarSeriesBuilder<TModel>(barSeries);
        }

        /// <summary>
        /// Defines bound column series.
        /// </summary>
        /// <param name="expression">
        /// The expression used to extract the series value from the chart model
        /// </param>
        public virtual ChartBarSeriesBuilder<TModel> Column<TValue>(Expression<Func<TModel, TValue>> expression)
        {
            var builder = Bar(expression);
            builder.Series.Orientation = ChartBarSeriesOrientation.Vertical;

            return builder;
        }

        /// <summary>
        /// Defines bound bar series.
        /// </summary>
        /// <param name="memberName">
        /// The name of the value member.
        /// </param>
        public virtual ChartBarSeriesBuilder<TModel> Column(string memberName)
        {
            return Column(null, memberName);
        }

        /// <summary>
        /// Defines bound bar series.
        /// </summary>
        /// <param name="memberType">
        /// The type of the value member.
        /// </param>
        /// <param name="memberName">
        /// The name of the value member.
        /// </param>
        public virtual ChartBarSeriesBuilder<TModel> Column(Type memberType, string memberName)
        {
            var builder = Bar(memberType, memberName);
            builder.Series.Orientation = ChartBarSeriesOrientation.Vertical;

            return builder;
        }

        /// <summary>
        /// Defines bar series bound to inline data.
        /// </summary>
        /// <param name="data">
        /// The data to bind to
        /// </param>
        public virtual ChartBarSeriesBuilder<TModel> Column(IEnumerable data)
        {
            var builder = Bar(data);
            builder.Series.Orientation = ChartBarSeriesOrientation.Vertical;

            return builder;
        }

        /// <summary>
        /// Defines bound line series.
        /// </summary>
        /// <param name="expression">
        /// The expression used to extract the series value from the chart model
        /// </param>
        public virtual ChartLineSeriesBuilder<TModel> Line<TValue>(Expression<Func<TModel, TValue>> expression)
        {
            Guard.IsNotNull(expression, "expression");

            ChartLineSeries<TModel, TValue> LineSeries = new ChartLineSeries<TModel, TValue>(Container, expression);

            Container.Series.Add(LineSeries);

            return new ChartLineSeriesBuilder<TModel>(LineSeries);
        }

        /// <summary>
        /// Defines bound line series.
        /// </summary>
        /// <param name="memberName">
        /// The name of the value member.
        /// </param>
        public virtual ChartLineSeriesBuilder<TModel> Line(string memberName)
        {
            return Line(null, memberName);
        }

        /// <summary>
        /// Defines bound line series.
        /// </summary>
        /// <param name="memberType">
        /// The type of the value member.
        /// </param>
        /// <param name="memberName">
        /// The name of the value member.
        /// </param>
        public virtual ChartLineSeriesBuilder<TModel> Line(Type memberType, string memberName)
        {
            var valueExpr = BuildMemberExpression(memberType, memberName);
            var seriesType = typeof(ChartLineSeries<,>).MakeGenericType(typeof(TModel), valueExpr.Body.Type);
            var series = (IChartLineSeries)BuildSeries(seriesType, valueExpr);

            series.Member = memberName;

            if (!series.Name.HasValue())
            {
                series.Name = memberName.AsTitle();
            }

            Container.Series.Add((ChartSeriesBase<TModel>)series);

            return new ChartLineSeriesBuilder<TModel>(series);
        }

        /// <summary>
        /// Defines line series bound to inline data.
        /// </summary>
        /// <param name="data">
        /// The data to bind to
        /// </param>
        public virtual ChartLineSeriesBuilder<TModel> Line(IEnumerable data)
        {
            Guard.IsNotNull(data, "data");

            ChartLineSeries<TModel, object> lineSeries = new ChartLineSeries<TModel, object>(Container, data);

            Container.Series.Add(lineSeries);

            return new ChartLineSeriesBuilder<TModel>(lineSeries);
        }

        /// <summary>
        /// Defines bound scatter series.
        /// </summary>
        /// <param name="xValueExpression">
        /// The expression used to extract the X value from the chart model
        /// </param>
        /// <param name="yValueExpression">
        /// The expression used to extract the Y value from the chart model
        /// </param>
        public virtual ChartScatterSeriesBuilder<TModel> Scatter<TValue>(Expression<Func<TModel, TValue>> xValueExpression, Expression<Func<TModel, TValue>> yValueExpression)
        {
            Guard.IsNotNull(xValueExpression, "xValueExpression");
            Guard.IsNotNull(yValueExpression, "yValueExpression");

            ChartScatterSeries<TModel, TValue> scatterSeries = new ChartScatterSeries<TModel, TValue>(Container, xValueExpression, yValueExpression);

            Container.Series.Add(scatterSeries);

            return new ChartScatterSeriesBuilder<TModel>(scatterSeries);
        }

        /// <summary>
        /// Defines bound scatter series.
        /// </summary>
        /// <param name="xMemberName">
        /// The name of the X value member.
        /// </param>
        /// <param name="yMemberName">
        /// The name of the Y value member.
        /// </param>
        public virtual ChartScatterSeriesBuilder<TModel> Scatter(string xMemberName, string yMemberName)
        {
            return Scatter(null, xMemberName, yMemberName);
        }

        /// <summary>
        /// Defines bound scatter series.
        /// </summary>
        /// <param name="memberType">
        /// The type of the value members.
        /// </param>
        /// <param name="xMemberName">
        /// The name of the X value member.
        /// </param>
        /// <param name="memberNameY>
        /// The name of the Y value member.
        /// </param>
        public virtual ChartScatterSeriesBuilder<TModel> Scatter(Type memberType, string xMemberName, string yMemberName)
        {
            var expressionX = BuildMemberExpression(memberType, xMemberName);
            var expressionY = BuildMemberExpression(memberType, yMemberName);

            var seriesType = typeof(ChartScatterSeries<,>).MakeGenericType(typeof(TModel), expressionX.Body.Type);
            var series = (IChartScatterSeries) BuildSeries(seriesType, expressionX, expressionY);

            series.XMember = xMemberName;
            series.YMember = yMemberName;

            if (!series.Name.HasValue())
            {
                series.Name = xMemberName.AsTitle() + ", " + yMemberName.AsTitle();
            }

            Container.Series.Add((ChartSeriesBase<TModel>)series);

            return new ChartScatterSeriesBuilder<TModel>(series);
        }

        /// <summary>
        /// Defines scatter series bound to inline data.
        /// </summary>
        /// <param name="data">
        /// The data to bind to
        /// </param>
        public virtual ChartScatterSeriesBuilder<TModel> Scatter(IEnumerable data)
        {
            Guard.IsNotNull(data, "data");

            ChartScatterSeries<TModel, object> scatterSeries = new ChartScatterSeries<TModel, object>(Container, data);

            Container.Series.Add(scatterSeries);

            return new ChartScatterSeriesBuilder<TModel>(scatterSeries);
        }

        /// <summary>
        /// Defines bound scatter line series.
        /// </summary>
        /// <param name="xValueExpression">
        /// The expression used to extract the X value from the chart model
        /// </param>
        /// <param name="yValueExpression">
        /// The expression used to extract the Y value from the chart model
        /// </param>
        public virtual ChartScatterLineSeriesBuilder<TModel> ScatterLine<TValue>(Expression<Func<TModel, TValue>> xValueExpression, Expression<Func<TModel, TValue>> yValueExpression)
        {
            Guard.IsNotNull(xValueExpression, "xValueExpression");
            Guard.IsNotNull(yValueExpression, "yValueExpression");

            ChartScatterLineSeries<TModel, TValue> scatterLineSeries = new ChartScatterLineSeries<TModel, TValue>(Container, xValueExpression, yValueExpression);

            Container.Series.Add(scatterLineSeries);

            return new ChartScatterLineSeriesBuilder<TModel>(scatterLineSeries);
        }

        /// <summary>
        /// Defines bound scatter line series.
        /// </summary>
        /// <param name="xMemberName">
        /// The name of the X value member.
        /// </param>
        /// <param name="yMemberName">
        /// The name of the Y value member.
        /// </param>
        public virtual ChartScatterLineSeriesBuilder<TModel> ScatterLine(string xMemberName, string yMemberName)
        {
            return ScatterLine(null, xMemberName, yMemberName);
        }

        /// <summary>
        /// Defines bound scatter line series.
        /// </summary>
        /// <param name="memberType">
        /// The type of the value members.
        /// </param>
        /// <param name="xMemberName">
        /// The name of the X value member.
        /// </param>
        /// <param name="memberNameY>
        /// The name of the Y value member.
        /// </param>
        public virtual ChartScatterLineSeriesBuilder<TModel> ScatterLine(Type memberType, string xMemberName, string yMemberName)
        {
            var expressionX = BuildMemberExpression(memberType, xMemberName);
            var expressionY = BuildMemberExpression(memberType, yMemberName);

            var seriesType = typeof(ChartScatterLineSeries<,>).MakeGenericType(typeof(TModel), expressionX.Body.Type);
            var series = (IChartScatterLineSeries)BuildSeries(seriesType, expressionX, expressionY);

            series.XMember = xMemberName;
            series.YMember = yMemberName;

            if (!series.Name.HasValue())
            {
                series.Name = xMemberName.AsTitle() + ", " + yMemberName.AsTitle();
            }

            Container.Series.Add((ChartSeriesBase<TModel>)series);

            return new ChartScatterLineSeriesBuilder<TModel>(series);
        }

        /// <summary>
        /// Defines scatter line series bound to inline data.
        /// </summary>
        /// <param name="data">
        /// The data to bind to
        /// </param>
        public virtual ChartScatterLineSeriesBuilder<TModel> ScatterLine(IEnumerable data)
        {
            Guard.IsNotNull(data, "data");

            ChartScatterLineSeries<TModel, object> scatterLineSeries = new ChartScatterLineSeries<TModel, object>(Container, data);

            Container.Series.Add(scatterLineSeries);

            return new ChartScatterLineSeriesBuilder<TModel>(scatterLineSeries);
        }

        /// <summary>
        /// Defines bound pie series.
        /// </summary>
        /// <param name="expressionValue">
        /// The expression used to extract the series value from the chart model
        /// </param>
        public virtual ChartPieSeriesBuilder<TModel> Pie<TValue>(Expression<Func<TModel, TValue>> expressionValue, Expression<Func<TModel, string>> expressionCategory)
        {
            Guard.IsNotNull(expressionValue, "expressionValue");
            Guard.IsNotNull(expressionCategory, "expressionCategory");

            ChartPieSeries<TModel, TValue> pieSeries = new ChartPieSeries<TModel, TValue>(Container, expressionValue, expressionCategory, null, null);

            Container.Series.Add(pieSeries);

            return new ChartPieSeriesBuilder<TModel>(pieSeries);
        }

        /// <summary>
        /// Defines bound pie series.
        /// </summary>
        /// <param name="expressionValue">
        /// The expression used to extract the series value from the chart model
        /// </param>
        public virtual ChartPieSeriesBuilder<TModel> Pie<TValue>(Expression<Func<TModel, TValue>> expressionValue, Expression<Func<TModel, string>> expressionCategory, Expression<Func<TModel, string>> expressionColor, Expression<Func<TModel, bool>> expressionExplode)
        {
            Guard.IsNotNull(expressionValue, "expressionValue");
            Guard.IsNotNull(expressionCategory, "expressionCategory");
            Guard.IsNotNull(expressionExplode, "expressionExplode");

            ChartPieSeries<TModel, TValue> pieSeries = new ChartPieSeries<TModel, TValue>(Container, expressionValue, expressionCategory, expressionColor, expressionExplode);

            Container.Series.Add(pieSeries);

            return new ChartPieSeriesBuilder<TModel>(pieSeries);
        }

        /// <summary>
        /// Defines bound pie series.
        /// </summary>
        /// <param name="memberName">
        /// The name of the value member.
        /// </param>
        public virtual ChartPieSeriesBuilder<TModel> Pie(string valueMemberName, string categoryMemberName)
        {
            return Pie(null, valueMemberName, categoryMemberName, "", "");
        }

        /// <summary>
        /// Defines bound pie series.
        /// </summary>
        /// <param name="valueMemberName">
        /// The name of the value member.
        /// </param>
        /// <param name="categoryMemberName">
        /// The name of the category member.
        /// </param>
        /// <param name="explodeMemberName">
        /// The name of the explode member.
        /// </param>
        public virtual ChartPieSeriesBuilder<TModel> Pie(string valueMemberName, string categoryMemberName, string colorMemberName, string explodeMemberName)
        {
            return Pie(null, valueMemberName, categoryMemberName, colorMemberName, explodeMemberName);
        }

        /// <summary>
        /// Defines bound pie series.
        /// </summary>
        /// <param name="memberType">
        /// The type of the value member.
        /// </param>
        /// <param name="valueMemberName">
        /// The name of the value member.
        /// </param>
        /// <param name="categoryMemberName">
        /// The name of the category member.
        /// </param>
        /// <param name="explodeMemberName">
        /// The name of the explode member.
        /// </param>
        public virtual ChartPieSeriesBuilder<TModel> Pie(Type memberType, string valueMemberName, string categoryMemberName, string colorMemberName, string explodeMemberName)
        {
            var valueExpr = BuildMemberExpression(memberType, valueMemberName);
            var categoryExpr = BuildMemberExpression(typeof(string), categoryMemberName);
            var colorExpr = colorMemberName.HasValue() ? BuildMemberExpression(typeof(string), colorMemberName) : null;
            var explodeExpr = explodeMemberName.HasValue() ? BuildMemberExpression(typeof(bool), explodeMemberName) : null;

            var seriesType = typeof(ChartPieSeries<,>).MakeGenericType(typeof(TModel), valueExpr.Body.Type);
            var series = (IChartPieSeries)BuildSeries(seriesType, valueExpr, categoryExpr, colorExpr, explodeExpr);

            if (!series.Name.HasValue())
            {
                series.Name = valueMemberName.AsTitle();
            }

            Container.Series.Add((ChartSeriesBase<TModel>)series);

            return new ChartPieSeriesBuilder<TModel>(series);
        }

        /// <summary>
        /// Defines pie series bound to inline data.
        /// </summary>
        /// <param name="data">
        /// The data to bind to
        /// </param>
        public virtual ChartPieSeriesBuilder<TModel> Pie(IEnumerable data)
        {
            Guard.IsNotNull(data, "data");

            ChartPieSeries<TModel, object> pieSeries = new ChartPieSeries<TModel, object>(Container, data);

            Container.Series.Add(pieSeries);

            return new ChartPieSeriesBuilder<TModel>(pieSeries);
        }

        private LambdaExpression BuildMemberExpression(Type memberType, string memberName)
        {
            const bool liftMemberAccess = false;
            var expression = ExpressionBuilder.Lambda<TModel>(memberType, memberName, liftMemberAccess);

#if MVC3
            if (typeof(TModel).IsDynamicObject() && memberType != null && expression.Body.Type.GetNonNullableType() != memberType.GetNonNullableType())
            {
                expression = Expression.Lambda(Expression.Convert(expression.Body, memberType), expression.Parameters);
            }
#endif

            return expression;
        }

        private object BuildSeries(Type seriesType, params LambdaExpression[] expressions)
        {
            var ctorTypeArgs = new List<Type>();
            ctorTypeArgs.Add(Container.GetType());
            ctorTypeArgs.AddRange(from e in expressions select e != null ? e.GetType() : typeof(object));

            var constructor = seriesType.GetConstructor(ctorTypeArgs.ToArray()) ?? seriesType.GetConstructors()[0];

            var ctorArgs = new List<object>();
            ctorArgs.Add(Container);
            ctorArgs.AddRange(expressions);

            return constructor.Invoke(ctorArgs.ToArray());
        }
    }
}