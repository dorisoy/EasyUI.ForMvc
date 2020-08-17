
namespace EasyUI.Web.Mvc.Infrastructure
{
    using System;
    using System.Collections.Generic;

    using Extensions;

    /// <summary>
    /// 辅助类用于验证.
    /// </summary>
    public static class Guard
    {
        /// <summary>
        /// 确保指定的参数不为空
        /// </summary>
        /// <param name="parameter">The parameter.</param>
        /// <param name="parameterName">Name of the parameter.</param>
        public static void IsNotNull(object parameter, string parameterName)
        {
            if (parameter == null)
            {
                throw new ArgumentNullException(parameterName, Resources.TextResource.CannotBeNull.FormatWith(parameterName));
            }
        }

        /// <summary>
        /// 确保指定的字符串参数不为空
        /// </summary>
        /// <param name="parameter">The parameter.</param>
        /// <param name="parameterName">Name of the parameter.</param>
        public static void IsNotNullOrEmpty(string parameter, string parameterName)
        {
            if (string.IsNullOrEmpty((parameter ?? string.Empty)))
            {
                throw new ArgumentException(Resources.TextResource.CannotBeNullOrEmpty.FormatWith(parameterName));
            }
        }

        /// <summary>
        /// 确保指定数组不是空的或空的
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="parameter">The parameter.</param>
        /// <param name="parameterName">Name of the parameter.</param>
        public static void IsNotNullOrEmpty<T>(T[] parameter, string parameterName)
        {
            IsNotNull(parameter, parameterName);

            if (parameter.Length == 0)
            {
                throw new ArgumentException(Resources.TextResource.ArrayCannotBeEmpty.FormatWith(parameterName));
            }
        }

        /// <summary>
        /// 确保指定的集合不是空的或空的
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="parameter">The parameter.</param>
        /// <param name="parameterName">Name of the parameter.</param>
        public static void IsNotNullOrEmpty<T>(ICollection<T> parameter, string parameterName)
        {
            IsNotNull(parameter, parameterName);

            if (parameter.Count == 0)
            {
                throw new ArgumentException(Resources.TextResource.CollectionCannotBeEmpty.FormatWith(parameterName), parameterName);
            }
        }

        /// <summary>
        /// 确保指定的值是正整数
        /// </summary>
        /// <param name="parameter">The parameter.</param>
        /// <param name="parameterName">Name of the parameter.</param>
        public static void IsNotZeroOrNegative(int parameter, string parameterName)
        {
            if (parameter <= 0)
            {
                throw new ArgumentOutOfRangeException(parameterName, Resources.TextResource.CannotBeNegativeOrZero.FormatWith(parameterName));
            }
        }

        /// <summary>
        /// 确保指定的值不是负整数
        /// </summary>
        /// <param name="parameter">The parameter.</param>
        /// <param name="parameterName">Name of the parameter.</param>
        public static void IsNotNegative(int parameter, string parameterName)
        {
            if (parameter < 0)
            {
                throw new ArgumentOutOfRangeException(parameterName, Resources.TextResource.CannotBeNegative.FormatWith(parameterName));
            }
        }

        /// <summary>
        /// 确保指定的值不是负整浮点数
        /// </summary>
        /// <param name="parameter">The parameter.</param>
        /// <param name="parameterName">Name of the parameter.</param>
        public static void IsNotNegative(float parameter, string parameterName)
        {
            if (parameter < 0)
            {
                throw new ArgumentOutOfRangeException(parameterName, Resources.TextResource.CannotBeNegative.FormatWith(parameterName));
            }
        }

        /// <summary>
        /// 确保指定的路径是一个虚拟路径，起始路径为 ~/.
        /// </summary>
        /// <param name="parameter">The parameter.</param>
        /// <param name="parameterName">Name of the parameter.</param>
        public static void IsNotVirtualPath(string parameter, string parameterName)
        {
            IsNotNullOrEmpty(parameter, parameterName);

            if (!parameter.StartsWith("~/", StringComparison.Ordinal))
            {
                throw new ArgumentException(Resources.TextResource.SourceMustBeAVirtualPathWhichShouldStartsWithTileAndSlash, parameterName);
            }
        }
    }
}