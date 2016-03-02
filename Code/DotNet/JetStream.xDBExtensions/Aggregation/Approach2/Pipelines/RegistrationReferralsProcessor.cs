using System;
using Sitecore.Analytics.Aggregation.Pipeline;
using Sitecore.Analytics.Core;
using Sitecore.Diagnostics;
using JetStream.xDBExtensions.Aggregation.Dimensions;
using JetStream.xDBExtensions.Aggregation.Facts;
using JetStream.xDBExtensions.Contact.Elements;
using JetStream.xDBExtensions.Contact.Facets;

namespace JetStream.xDBExtensions.Aggregation.Pipelines
{
    //Pipeline processor to calculate the fact metrics
    public sealed class RegistrationReferralsProcessor : AggregationProcessor
    {
        private const string RegisterGoalID = "{8FFB183B-DA1A-4C74-8F3A-9729E9FCFF6A}";

        protected override void OnProcess(AggregationPipelineArgs args)
        {
            Assert.ArgumentNotNull(args, "args");

            //First check if the current interaction has "Register" goal completed event
            if (!args.Context.Visit.Pages
                    .Exists(p => p.PageEvents.Exists(pe => pe.IsGoal && pe.PageEventDefinitionId == Guid.Parse(RegisterGoalID))))
                return;

            //Check if the current interaction has an associated contact
            if (args.Context.Contact == null)
                return;

            //Get registration info for the current interaction's contact
            var regnInfo = args.Context.Contact.GetFacet<IContactRegistration>("Registration Info");
            if (regnInfo == null || regnInfo.ReferralSources.Count == 0)
                return;

            //For each referral source, create the fact data / metrics
            foreach (IReferral referral in regnInfo.ReferralSources)
            {
                //Fact key
                RegistrationReferralsKey key = new RegistrationReferralsKey()
                {
                    Date = args.DateTimeStrategy.Translate(regnInfo.RegisteredDate),
                    SiteNameId = AggregationProcessor.UpdateSiteNamesDimension(args),
                    ReferralSourceId = RegistrationReferralsProcessor.UpdateReferralSourceDimension(args, referral.Source)
                };

                //Fact value
                RegistrationReferralsValue value = new RegistrationReferralsValue()
                {
                    Count = 1
                };

                //Emit the fact for Sitecore to store in corresponding table
                var fact = args.GetFact<RegistrationReferrals>();
                fact.Emit(key, value);
            }
        }

        //To update dimension in corresponding table
        private static Hash32 UpdateReferralSourceDimension(AggregationPipelineArgs args, string referralSource)
        {
            return args.GetDimension<ReferralSources>().Add(referralSource);
        }
    }
}
