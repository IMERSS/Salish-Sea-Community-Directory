"use strict";

/* global maxwell */

maxwell.mapDirectorySections = function () {
    const locationSections = [...document.querySelectorAll(".mxcw-locationSection")];
    const idToSection = {};
    const prefix = "Location-Map-";
    locationSections.forEach(function (section, index) {
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
    const communitySectionNodes = [...document.querySelectorAll(".mxcw-communitySection")];
    const communitySections = communitySectionNodes.map(function (section) {
        const locationId = section.getAttribute("data-community-location");
        const heading = section.querySelector("h2");
        const locationIndex = idToSection[locationId].index;
        return {locationId, locationIndex, section, heading};
    });

    // This lookup function is mixed in to the overall leaflet instance to override the identity
    const sectionIndexToWidgetIndex = sectionIndex => communitySections[sectionIndex].locationIndex;

    return {idToSection, communitySections, sectionIndexToWidgetIndex};
};


