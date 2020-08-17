




namespace EasyUI.Web.Mvc
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Web.Routing;

    using Infrastructure;

    /// <summary>
    /// 定义一个用于存储单个URL的站点地图类
    /// </summary>
    public class SiteMapNode : LinkedObjectBase<SiteMapNode>, INavigatable
    {
        private string title;
        private string routeName;
        private string controllerName;
        private string actionName;
        private string url;
        private string description;
        private string icostyle;

        /// <summary>
        /// Initializes a new instance of the <see cref="SiteMapNode"/> class.
        /// </summary>
        public SiteMapNode()
        {
            Visible = true;
            RouteValues = new RouteValueDictionary();
            IncludeInSearchEngineIndex = true;
            Attributes = new RouteValueDictionary();
            ChildNodes = new LinkedObjectCollection<SiteMapNode>(this);
        }

        /// <summary>
        /// Ico 样式
        /// </summary>
        public string IcoStyle
        {
            get
            {
                return icostyle;
            }
            set
            {
                icostyle = value;
            }
        }

        /// <summary>
        /// 描述
        /// </summary>
        public string Description
        {
            get
            {
                return description;
            }
            set
            {
                description = value;
            }
        }

        /// <summary>
        /// 标题
        /// </summary>
        /// <value>The title.</value>
        public string Title
        {
            get
            {
                return title;
            }

            set
            {
                Guard.IsNotNullOrEmpty(value, "value");

                title = value;
            }
        }

        /// <summary>
        /// 是否可见 <see cref="SiteMapNode"/> is visible.
        /// </summary>
        /// <value><c>true</c> if visible; otherwise, <c>false</c>.</value>
        public bool Visible
        {
            get;
            set;
        }

        /// <summary>
        /// 最后修改时间
        /// </summary>
        /// <value>The last modified at.</value>
        public DateTime? LastModifiedAt
        {
            get;
            set;
        }

        /// <summary>
        /// 路由名
        /// </summary>
        /// <value>The name of the route.</value>
        public string RouteName
        {
            get
            {
                return routeName;
            }

            set
            {
                Guard.IsNotNullOrEmpty(value, "value");

                routeName = value;
                controllerName = actionName = url = null;
            }
        }

        /// <summary>
        /// 控制器名
        /// </summary>
        /// <value>The name of the controller.</value>
        public string ControllerName
        {
            get
            {
                return controllerName;
            }

            set
            {
                Guard.IsNotNullOrEmpty(value, "value");

                controllerName = value;

                routeName = url = null;
            }
        }

        /// <summary>
        /// Action 方法名
        /// </summary>
        /// <value>The name of the action.</value>
        public string ActionName
        {
            get
            {
                return actionName;
            }

            set
            {
                Guard.IsNotNullOrEmpty(value, "value");

                actionName = value;

                routeName = url = null;
            }
        }

        /// <summary>
        /// 路由字典
        /// </summary>
        /// <value>The route values.</value>
        public RouteValueDictionary RouteValues
        {
            get;
            private set;
        }

        /// <summary>
        /// 获取设置URL.
        /// </summary>
        /// <value>The URL.</value>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1056:UriPropertiesShouldNotBeStrings", Justification = "Url might not be a valid uri.")]
        public string Url
        {
            get
            {
                return url;
            }

            set
            {
                Guard.IsNotNullOrEmpty(value, "value");

                url = value;

                routeName = controllerName = actionName = null;
                RouteValues.Clear();
            }
        }

        /// <summary>
        /// 获取或设置更改频率
        /// </summary>
        /// <value>The change frequency.</value>
        public SiteMapChangeFrequency ChangeFrequency
        {
            get;
            set;
        }

        /// <summary>
        /// 更新优先级
        /// </summary>
        /// <value>The update priority.</value>
        public SiteMapUpdatePriority UpdatePriority
        {
            get;
            set;
        }

        /// <summary>
        /// 获取或设置一个值，该值指示是否包含在搜索引擎索引中
        /// </summary>
        /// <value>
        /// <c>true</c> if [include in search engine index]; otherwise, <c>false</c>.
        /// </value>
        public bool IncludeInSearchEngineIndex
        {
            get;
            set;
        }

        /// <summary>
        /// 获取设置属性
        /// </summary>
        /// <value>The attributes.</value>
        public IDictionary<string, object> Attributes
        {
            get;
            private set;
        }

        /// <summary>
        /// 获取子节点
        /// </summary>
        /// <value>The child nodes.</value>
        public IList<SiteMapNode> ChildNodes
        {
            get;
            private set;
        }

        /// <summary>
        /// 自定义运算符隐式转换从 <see cref="EasyUI.Web.Mvc.SiteMapNode"/> 到 <see cref="EasyUI.Web.Mvc.SiteMapNodeBuilder"/>.
        /// </summary>
        /// <param name="node">The node.</param>
        /// <returns>The result of the conversion.</returns>
        public static implicit operator SiteMapNodeBuilder(SiteMapNode node)
        {
            Guard.IsNotNull(node, "node");

            return node.ToBuilder();
        }

        [EditorBrowsable(EditorBrowsableState.Never)]
        public SiteMapNodeBuilder ToBuilder()
        {
            return new SiteMapNodeBuilder(this);
        }

        public override string ToString()
        {
            return string.Format("{0},{1},{2}", ControllerName, ActionName, Title);
        }
    }
}