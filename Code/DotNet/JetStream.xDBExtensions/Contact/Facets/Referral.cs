using Sitecore.Analytics.Model.Framework;

namespace JetStream.xDBExtensions.Contact.Elements
{
    public class Referral : Element, IReferral
    {
        private const string SOURCE = "Source";

        public Referral()
        {
            this.EnsureAttribute<string>(SOURCE);
        }

        public string Source
        {
            get
            {
                return this.GetAttribute<string>(SOURCE);
            }
            set
            {
                this.SetAttribute<string>(SOURCE, value);
            }
        }
    }
}
