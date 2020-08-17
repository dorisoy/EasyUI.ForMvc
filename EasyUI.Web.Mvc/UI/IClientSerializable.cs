



namespace EasyUI.Web.Mvc.UI
{
    public interface IClientSerializable
    {
        void SerializeTo(string key, IClientSideObjectWriter writer);
    }
}
