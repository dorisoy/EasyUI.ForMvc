




namespace EasyUI.Web.Mvc.Infrastructure
{
    public interface IObjectCopier
    {
        void Copy(object source, object destination, params string[] excludedMembers);
    }
}