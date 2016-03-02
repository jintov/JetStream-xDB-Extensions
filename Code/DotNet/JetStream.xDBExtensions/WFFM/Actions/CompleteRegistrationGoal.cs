using System;
using Sitecore.Analytics;
using Sitecore.Analytics.Data.Items;
using Sitecore.Data;
using Sitecore.Data.Items;
using Sitecore.Analytics.Model;
using Sitecore.WFFM.Abstractions.Actions;
using Sitecore.WFFM.Actions.Base;

namespace JetStream.xDBExtensions.WFFM.Actions
{
    public class CompleteRegistrationGoal : WffmSaveAction
    {
        private const string RegisterGoalID = "{8FFB183B-DA1A-4C74-8F3A-9729E9FCFF6A}";

        public override void Execute(ID formId, AdaptedResultList adaptedFields, ActionCallContext actionCallContext = null, params object[] data)
        {
            try
            {
                //On registration, trigger a "Register" goal completion and associate it with current interaction
                Item goal = Sitecore.Context.Database.GetItem(RegisterGoalID);
                if (goal == null)
                    return;

                PageEventItem regnGoalEvent = new PageEventItem(goal);
                PageEventData regnGoalEventData = Tracker.Current.Interaction.CurrentPage.Register(regnGoalEvent);
                regnGoalEventData.Data = goal["Description"];
                Tracker.Current.Interaction.AcceptModifications();
            }
            catch (Exception ex)
            {
            }
        }
    }
}
