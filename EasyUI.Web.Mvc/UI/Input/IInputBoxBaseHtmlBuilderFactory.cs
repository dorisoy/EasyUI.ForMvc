




namespace EasyUI.Web.Mvc.UI
{
    /// <summary>
    /// InputBox 生成工厂
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public interface IInputBoxBaseHtmlBuilderFactory<T> where T : struct
    {
        /// <summary>
        /// 创建生成器
        /// </summary>
        /// <param name="input">InputBoxBase</param>
        /// <returns>IInputBoxBaseHtmlBuilder</returns>
        IInputBoxBaseHtmlBuilder Create(InputBoxBase<T> input);
    }
}