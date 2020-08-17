// (c) Copyright 2002-2011 EasyUI 




namespace EasyUI.Web.Mvc.UI
{
    using System.IO;

    public interface IThumbnailCreator
    {
        byte[] Create(Stream source, ImageSize desiredSize, string contentType);
    }
}