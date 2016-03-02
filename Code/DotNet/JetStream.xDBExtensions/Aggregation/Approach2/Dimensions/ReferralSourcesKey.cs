using Sitecore.Analytics.Aggregation.Data.Model;
using Sitecore.Analytics.Core;

namespace JetStream.xDBExtensions.Aggregation.Dimensions
{
    //Represents the dimension key
    public class ReferralSourcesKey : DictionaryKey
    {
        private readonly Hash32 referralSourceId;

        public Hash32 ReferralSourceId
        {
            get
            {
                return this.referralSourceId;
            }
        }

        public ReferralSourcesKey(Hash32 referralSourceId)
        {
            this.referralSourceId = referralSourceId;
        }
    }
}
