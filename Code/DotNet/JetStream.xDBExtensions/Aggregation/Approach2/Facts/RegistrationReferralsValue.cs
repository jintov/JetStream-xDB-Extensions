using Sitecore.Analytics.Aggregation.Data.Model;

namespace JetStream.xDBExtensions.Aggregation.Facts
{
    //Represents the fact value
    public sealed class RegistrationReferralsValue : DictionaryValue
    {
        public long Count { get; set; }


        internal static RegistrationReferralsValue Reduce(RegistrationReferralsValue left, RegistrationReferralsValue right)
        {
            return new RegistrationReferralsValue()
            {
                Count = left.Count + right.Count
            };
        }
    }
}
