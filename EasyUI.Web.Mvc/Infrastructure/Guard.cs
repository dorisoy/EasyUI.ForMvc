
namespace EasyUI.Web.Mvc.Infrastructure
{
    using System;
    using System.Collections.Generic;

    using Extensions;

    /// <summary>
    /// ������������֤.
    /// </summary>
    public static class Guard
    {
        /// <summary>
        /// ȷ��ָ���Ĳ�����Ϊ��
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
        /// ȷ��ָ�����ַ���������Ϊ��
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
        /// ȷ��ָ�����鲻�ǿյĻ�յ�
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
        /// ȷ��ָ���ļ��ϲ��ǿյĻ�յ�
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
        /// ȷ��ָ����ֵ��������
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
        /// ȷ��ָ����ֵ���Ǹ�����
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
        /// ȷ��ָ����ֵ���Ǹ���������
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
        /// ȷ��ָ����·����һ������·������ʼ·��Ϊ ~/.
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