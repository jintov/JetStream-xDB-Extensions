using System;
using Sitecore.Analytics.Model.Framework;
using JetStream.xDBExtensions.Contact.Elements;

namespace JetStream.xDBExtensions.Contact.Facets
{
    [Serializable]
    public class ContactRegistration : Facet, IContactRegistration
    {
        private const string REGISTERED_DATE = "Registered Date";
        private const string REFERRAL_SOURCES = "Referral Sources";

        public ContactRegistration()
        {
            this.EnsureAttribute<DateTime>(REGISTERED_DATE);
            this.EnsureCollection<IReferral>(REFERRAL_SOURCES);
        }

        public DateTime RegisteredDate
        {
            get
            {
                return this.GetAttribute<DateTime>(REGISTERED_DATE);
            }
            set
            {
                this.SetAttribute<DateTime>(REGISTERED_DATE, value);
            }
        }

        public IElementCollection<IReferral> ReferralSources
        {
            get
            {
                return this.GetCollection<IReferral>(REFERRAL_SOURCES);
            }
        }
    }
}
