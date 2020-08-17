




using System.Collections.Generic;
using System.Globalization;

namespace EasyUI.Web.Mvc.UI
{
    /// <summary>
    /// Helper class to convert jQuery Animation Duration.
    /// </summary>
    public static class AnimationDurationConverter
    {
        private static readonly IDictionary<int, string> durationMap = BuildMap();

        /// <summary>
        /// Converts specified duration in jQuery equivalent value.
        /// </summary>
        /// <param name="duration">The duration.</param>
        /// <returns></returns>
        public static string ToString(int duration)
        {
            return durationMap.ContainsKey(duration) ? durationMap[duration] : duration.ToString(CultureInfo.InvariantCulture);
        }

        private static IDictionary<int, string> BuildMap()
        {
            var map = new Dictionary<int, string>
                          {
                              {
                                  (int) AnimationDuration.Fast, "'fast'"
                                  },
                              {
                                  (int) AnimationDuration.Normal, "'normal'"
                                  },
                              {
                                  (int) AnimationDuration.Slow, "'slow'"
                                  }
                          };

            return map;
        }
    }
}