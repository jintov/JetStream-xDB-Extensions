using System;
using System.Linq;
using Sitecore.Analytics;
using Sitecore.Data;
using Sitecore.WFFM.Abstractions.Actions;
using Sitecore.WFFM.Actions.Base;
using JetStream.xDBExtensions.Contact.Facets;
using JetStream.xDBExtensions.Contact.Elements;

namespace JetStream.xDBExtensions.WFFM.Actions
{
    public class SaveReferralToxDB : WffmSaveAction
    {
        private const string HearAboutUsFieldID = "{40FD69A2-91FE-44B6-ADEC-6386AE4AAA85}";

        public override void Execute(ID formId, AdaptedResultList adaptedFields, ActionCallContext actionCallContext = null, params object[] data)
        {
            //Get referral sources from the WFFM form
            string selectedReferralSources = adaptedFields.FirstOrDefault(f => f.FieldID == HearAboutUsFieldID).Parameters;
            if (string.IsNullOrEmpty(selectedReferralSources))
                return;

            //Populate contact facet with registration and referral sources collection
            var contact = Tracker.Current.Contact;
            var referrals = contact.GetFacet<IContactRegistration>("Registration Info");
            referrals.RegisteredDate = DateTime.Now;

            foreach (string referralSource in selectedReferralSources.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries))
            {
                IReferral referral = referrals.ReferralSources.Create();
                referral.Source = referralSource;
            }
        }
    }
}
