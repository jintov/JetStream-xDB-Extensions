using Sitecore.Analytics.Aggregation.Data.Model;

namespace JetStream.xDBExtensions.Aggregation.Dimensions
{
    //Represents the dimension value
    public class ReferralSourcesValue : DictionaryValue
    {
        private readonly string referralSource;

        public string ReferralSource
        {
            get
            {
                return this.referralSource;
            }
        }

        public ReferralSourcesValue(string referralSource)
        {
            this.referralSource = referralSource;
        }
    }
}
