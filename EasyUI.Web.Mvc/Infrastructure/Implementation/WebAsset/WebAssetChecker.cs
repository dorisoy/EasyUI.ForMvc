﻿namespace EasyUI.Web.Mvc.Infrastructure.Implementation
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using EasyUI.Web.Mvc.UI;

    internal class WebAssetChecker : IWebAssetChecker
    {
        private static readonly IEnumerable<Func<string, bool>> Predicates = new Func<string, bool>[]
        {
            source => source.Equals(ScriptRegistrar.jQuery, StringComparison.OrdinalIgnoreCase),
            source => source.Equals(ScriptRegistrar.jQueryValidation, StringComparison.OrdinalIgnoreCase),
            source => source.StartsWith("EasyUI.", StringComparison.OrdinalIgnoreCase)
        };

        public bool IsNative(WebAsset asset)
        {
            var fileName = Path.GetFileName(asset.Source);

            foreach (var predicate in Predicates)
            {
                if (predicate(fileName))
                {
                    return true;
                }
            }

            return false;
        }

        public bool IsAbsolute(WebAsset asset)
        {
            return asset.Source.Contains("//");
        }
    }
}
