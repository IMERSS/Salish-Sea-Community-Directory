/* eslint-env node */

"use strict";

const papaparse = require("papaparse"),
    linkedom = require("linkedom"),
    fs = require("fs");

const {resolvePath, stringTemplate} = require("./utils.js");

// From https://stackoverflow.com/a/31375659
const parseCSV = function (file) {
    return new Promise(function (complete, error) {
        papaparse.parse(file, {complete, error,
            header: true,
            skipEmptyLines: true}
        );
    });
};

const dataText = fs.readFileSync(resolvePath("%maxwell/test.csv"), "utf8");

const dataPromise = parseCSV(dataText);

const template = fs.readFileSync(resolvePath("%maxwell/src/html/sectionTemplate.html"), "utf8");

const rowsToSections = function (rows) {
    return rows.map(function (row) {
        console.log("Templating with row ", row);
        const replaced = stringTemplate(template, row);
        console.log("Replaced to ", replaced);
        const document = linkedom.parseHTML(replaced).document;
        const element = document.firstElementChild;
        element.setAttribute("data-community-location", row.location_code);
        return element;
    });
};

const addCommunitySections = async function (indoc) {
    const locationSections = [...indoc.querySelectorAll(".section.level2")];
    console.log("Got " + locationSections.length + " location sections");
    locationSections.forEach(section => section.classList.add("mxcw-locationSection"));

    const data = await dataPromise;
    const rows = data.data;
    const nodes = rowsToSections(rows);
    console.log("Mapped to " + nodes.length + " nodes");
    const header = indoc.getElementById("header");
    const reference = header.nextSibling;
    // console.log("Got header ", header);
    nodes.forEach(function (node) {
        header.parentNode.insertBefore(node, reference);
    });
};

module.exports = {addCommunitySections};
