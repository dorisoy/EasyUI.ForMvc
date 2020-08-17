// (c) Copyright 2002-2011 EasyUI 




namespace EasyUI.Web.Mvc.UI
{
    public interface IImageResizer
    {
        ImageSize Resize(ImageSize originalSize, ImageSize targetSize);
    }
}