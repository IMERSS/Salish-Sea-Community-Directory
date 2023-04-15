/* eslint-env node */

"use strict";

const papaparse = require("papaparse"),
    linkedom = require("linkedom"),
    fluid = require("infusion"),
    fs = require("fs");

// From https://stackoverflow.com/a/31375659
/**
 * Read a CSV file, returning a promise
 * @param {String} file - The filename to be read
 * @return {Promise<Object>} A promise for the papaparse contents of the CSV file with rows in member `data`
 */
const parseCSV = function (file) {
    return new Promise(function (complete, error) {
        papaparse.parse(file, {complete, error,
            header: true,
            skipEmptyLines: true}
        );
    });
};

const dataText = fs.readFileSync(fluid.module.resolvePath("%maxwell/tabular_data/Salish_Sea_Communities.csv"), "utf8");

const dataPromise = parseCSV(dataText);

const template = fs.readFileSync(fluid.module.resolvePath("%maxwell/src/html/sectionTemplate.html"), "utf8");

const rowsToSections = function (rows) {
    return rows.map(function (row) {
        console.log("Templating with row ", row);
        const replaced = fluid.stringTemplate(template, row);
        console.log("Replaced to ", replaced);
        const document = linkedom.parseHTML(replaced).document;
        const element = document.firstElementChild;
        element.setAttribute("data-community-location", row.location_code);
        return element;
    });
};

const filterDone = function (rows) {
    return rows.filter(row => row.done);
};

const addCommunitySections = async function (indoc) {
    const locationSections = [...indoc.querySelectorAll(".section.level2")];
    console.log("Got " + locationSections.length + " location sections");
    locationSections.forEach(section => section.classList.add("mxcw-locationSection"));

    const data = await dataPromise;
    const rows = data.data;
    const filtered = filterDone(rows);
    console.log("Filtered to " + filtered.length + " rows");
    const nodes = rowsToSections(filtered);
    console.log("Mapped to " + nodes.length + " nodes");
    const header = indoc.getElementById("header");
    const reference = header.nextSibling;
    // console.log("Got header ", header);
    nodes.forEach(function (node) {
        header.parentNode.insertBefore(node, reference);
    });
};

module.exports = {addCommunitySections};
