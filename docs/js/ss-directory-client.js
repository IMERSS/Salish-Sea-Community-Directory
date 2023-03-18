"use strict";

// noinspection ES6ConvertVarToLetConst // otherwise this is a duplicate on minifying
var maxwell = fluid.registerNamespace("maxwell");

maxwell.sectionIndexToCommunityIndex = function (sectionIndex, communitySections) {
    return communitySections[sectionIndex].locationIndex;
};

maxwell.resolveLocationSections = function (locationSections) {
    const idToSection = {};
    const prefix = "Location-Map-";
    [...locationSections].forEach(function (section, index) {
        const heading = section.querySelector("h2");
        const headingText = heading.innerText;
        if (!headingText.startsWith(prefix)) {
            throw "Unexpected heading name " + headingText + " which doesn't begin with " + prefix;
        }
        const id = headingText.substring(prefix.length);
        // const id = section.id.substring("location-map-".length);
        idToSection[id] = {section, index};
        console.log("Got section with id ", id);
    });
    return idToSection;
};

maxwell.resolveCommunitySections = function (idToSection, communitySectionNodes) {
    const communitySections = [...communitySectionNodes].map(function (section) {
        const locationId = section.getAttribute("data-community-location");
        const heading = section.querySelector("h2");
        const locationIndex = idToSection[locationId].index;
        return {locationId, locationIndex, section, heading};
    });
    return communitySections;
};

fluid.defaults("maxwell.scrollyWithCommunitySections", {
    selectors: {
        locationSection: ".mxcw-locationSection",
        communitySection: ".mxcw-communitySection"
    },
    members: {
        idToSection: "@expand:maxwell.resolveLocationSections({that}.dom.locationSection)",
        communitySections: "@expand:maxwell.resolveCommunitySections({that}.idToSection, {that}.dom.communitySection)"
    },
    invokers: {
        sectionIndexToWidgetIndex: "maxwell.sectionIndexToCommunityIndex({arguments}.0, {that}.communitySections)",
        resolveSectionHolders: "fluid.identity({that}.communitySections)"
    }
});
