using Sitecore.Analytics.Aggregation.Data.Model;
using Sitecore.Analytics.Core;

namespace JetStream.xDBExtensions.Aggregation.Dimensions
{
    //Represents the dimension (key + value)
    //Tables, stored procs and TVP types with this naming convention should exist in Reporting database and mapped in Sitecore config
    public class ReferralSources : Dimension<ReferralSourcesKey, ReferralSourcesValue>
    {
        public Hash32 Add(string referralSource)
        {
            referralSource = referralSource ?? string.Empty;
            Hash32 referralSourceId = Hash32.Compute(referralSource);
            this.Add(new ReferralSourcesKey(referralSourceId), new ReferralSourcesValue(referralSource));

            return referralSourceId;
        }
    }
}
