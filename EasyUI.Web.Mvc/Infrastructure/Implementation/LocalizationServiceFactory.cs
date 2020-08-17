// (c) Copyright 2002-2009 EasyUI 




namespace EasyUI.Web.Mvc.Infrastructure.Implementation
{
    using System.Globalization;
    
    internal class LocalizationServiceFactory : ILocalizationServiceFactory
    {
        public ILocalizationService Create(string resourceName, CultureInfo culture)
        {
            return new LocalizationService(resourceName, culture);
        }
    }
}
