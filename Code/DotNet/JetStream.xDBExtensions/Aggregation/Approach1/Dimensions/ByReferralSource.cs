using System;
using System.Collections.Generic;
using Sitecore.Analytics.Aggregation.Data.Model;
using Sitecore.ExperienceAnalytics.Aggregation.Data.Model;
using Sitecore.ExperienceAnalytics.Aggregation.Dimensions;
using Sitecore.ExperienceAnalytics.Aggregation.Data.Schema;
using JetStream.xDBExtensions.Contact.Elements;
using JetStream.xDBExtensions.Contact.Facets;

namespace JetStream.xDBExtensions.Aggregation.Dimensions
{
    public class ByReferralSource : DimensionBase
    {
        private const string RegisterGoalID = "{8FFB183B-DA1A-4C74-8F3A-9729E9FCFF6A}";

        public ByReferralSource(Guid dimensionId) : base(dimensionId)
        {
        }

        public override IEnumerable<DimensionData> GetData(IVisitAggregationContext context)
        {
            //First check if the current interaction has "Register" goal completed event
            if (context.Visit.Pages
                    .Exists(p => p.PageEvents.Exists(pe => pe.IsGoal && pe.PageEventDefinitionId == Guid.Parse(RegisterGoalID))))
            {
                if (context.Contact != null)
                {
                    //Get registration info for the current interaction's contact
                    var regnInfo = context.Contact.GetFacet<IContactRegistration>("Registration Info");
                    if (regnInfo != null && regnInfo.ReferralSources.Count > 0)
                    {
                        //Calculate the fact value for the registration; assign a value of 1 for each registration
                        SegmentMetricsValue value = this.CalculateCommonMetrics(context, 1);

                        //For each referral source, create the dimension and fact data and return for Sitecore to store in Fact_SegmentMetrics table
                        foreach (IReferral referral in regnInfo.ReferralSources)
                        {
                            yield return new DimensionData
                            {
                                DimensionKey = referral.Source,
                                MetricsValue = value
                            };
                        }
                    }
                }
            }
        }
    }
}
