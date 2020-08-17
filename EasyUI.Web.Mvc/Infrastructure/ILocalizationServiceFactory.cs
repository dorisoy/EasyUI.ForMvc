// (c) Copyright 2002-2009 EasyUI 




using System.Globalization;

namespace EasyUI.Web.Mvc.Infrastructure
{
    public interface ILocalizationServiceFactory
    {
        ILocalizationService Create(string resourceName, CultureInfo culture);
    }
}
