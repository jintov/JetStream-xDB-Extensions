using System;
using Sitecore.Analytics.Model.Framework;
using JetStream.xDBExtensions.Contact.Elements;

namespace JetStream.xDBExtensions.Contact.Facets
{
    public interface IContactRegistration: IFacet
    {
        DateTime RegisteredDate { get; set; }

        IElementCollection<IReferral> ReferralSources { get; }
    }
}
