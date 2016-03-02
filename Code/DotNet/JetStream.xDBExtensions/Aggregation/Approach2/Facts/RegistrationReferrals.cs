using Sitecore.Analytics.Aggregation.Data.Model;

namespace JetStream.xDBExtensions.Aggregation.Facts
{
    //Represents the fact entity (key and values)
    //Tables, stored procs and TVP types with this naming convention should exist in Reporting database and mapped in Sitecore config
    public sealed class RegistrationReferrals : Fact<RegistrationReferralsKey, RegistrationReferralsValue>
    {
        public RegistrationReferrals() : base(RegistrationReferralsValue.Reduce)
        {
        }
    }
}
