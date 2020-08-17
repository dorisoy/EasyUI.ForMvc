namespace EasyUI.Web.Mvc.Infrastructure
{
    public interface ICacheFactory
    {
        ICache Create(string prefix);
    }
}
