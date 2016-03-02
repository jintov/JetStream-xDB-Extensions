using System;
using Sitecore.Analytics.Aggregation.Data.Model;
using Sitecore.Analytics.Core;

namespace JetStream.xDBExtensions.Aggregation.Facts
{
    //Represents the fact key composed of multiple dimension keys
    public sealed class RegistrationReferralsKey : DictionaryKey
    {
        public DateTime Date { get; set; }

        public Hash32 SiteNameId { get; set; }

        public Hash32 ReferralSourceId { get; set; }
    }
}
