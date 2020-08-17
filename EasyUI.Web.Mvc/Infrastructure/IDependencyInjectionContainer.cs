namespace EasyUI.Web.Mvc.Infrastructure
{
    using System;

    /// <summary>
    /// 提供依赖注入容接口
    /// </summary>
    public interface IDependencyInjectionContainer
    {
        void Register<TService, TArg>(Func<TArg, TService> factory);

        void Register<TService, TArg1, TArg2, TArg3, TArg4>(Func<TArg1, TArg2, TArg3, TArg4, TService> factory);

        void Register<TService, TArg1, TArg2, TArg3>(Func<TArg1, TArg2, TArg3, TService> factory);

        void Register<TService, TArg1, TArg2>(Func<TArg1, TArg2, TService> factory);

        void Register<TService>(Func<TService> factory);
        
        void Register<TService>(Func<IDependencyInjectionContainer, TService> factory);

        /// <summary>
        /// 解析服务
        /// </summary>
        /// <typeparam name="TService"></typeparam>
        /// <returns></returns>
        TService Resolve<TService>();
    }
}
