/**
 * TourniBase outreach automation for a Google Sheet tab named "Outreach".
 *
 * Keep DRY_RUN true until at least three generated messages have been reviewed.
 * Do not commit a personal email address into SEND_TEST_TO.
 */
var DRY_RUN = true;
var SEND_TEST_TO = "";
var BATCH_SIZE = 10;
var FOLLOW_UP_DELAY_DAYS = 3;
var SHEET_NAME = "Outreach";

var FIRST_EMAIL_SUBJECT = "Question about gate admissions";
var FIRST_EMAIL_BODY = [
  "Hey {{First Name}},",
  "",
  "I’m researching how youth basketball tournament directors handle spectator admissions.",
  "",
  "I saw {{Event Name}} and had a quick question — how do you currently manage gate payments, weekend/day passes, and reconciliation after the tournament?",
  "",
  "I recently talked to a director getting 1,000+ spectators per weekend who takes a mix of cash, Apple Pay, Venmo, etc. and manually adds everything up afterward.",
  "",
  "Is that pretty normal, or do you use a cleaner system?",
  "",
  "If you’re not the right person for this or don’t want me to follow up, no worries — just let me know.",
  "",
  "Thanks,",
  "Luke"
].join("\n");

var FOLLOW_UP_SUBJECT = "Following up on gate admissions";
var FOLLOW_UP_BODY = [
  "Hey {{First Name}},",
  "",
  "Just wanted to follow up on this.",
  "",
  "I’m trying to understand how tournament directors are currently handling spectator admissions — especially payment collection, weekend/day passes, re-entry, and reconciliation after the event.",
  "",
  "Even a short answer would help: are you mostly using cash/card/Venmo/wristbands, or do you have a cleaner system already?",
  "",
  "No worries if this is not relevant.",
  "",
  "Thanks,",
  "Luke"
].join("\n");

var REQUIRED_HEADERS = [
  "First Name",
  "Last Name",
  "Email",
  "Organization",
  "Event Name",
  "Source Link",
  "State",
  "Region",
  "Status",
  "Sent Date",
  "Follow Up Date",
  "Reply Notes",
  "Do Not Contact",
  "Last Error",
  "Draft Created"
];

function onOpen() {
  SpreadsheetApp.getUi()
    .createMenu("TourniBase Outreach")
    .addItem("Send first-email batch", "sendFirstEmailBatch")
    .addItem("Send follow-up batch", "sendFollowUpBatch")
    .addSeparator()
    .addItem("Create first-email drafts", "createFirstEmailDrafts")
    .addItem("Create follow-up drafts", "createFollowUpDrafts")
    .addToUi();
}

function getSheet_() {
  var spreadsheet = SpreadsheetApp.getActiveSpreadsheet();
  var sheet = spreadsheet.getSheetByName(SHEET_NAME);

  if (!sheet) {
    throw new Error('Sheet tab "' + SHEET_NAME + '" was not found.');
  }

  return sheet;
}

function getHeaderMap_(sheet) {
  var lastColumn = sheet.getLastColumn();

  if (lastColumn < 1) {
    throw new Error("The outreach sheet has no header row.");
  }

  var headers = sheet.getRange(1, 1, 1, lastColumn).getDisplayValues()[0];
  var headerMap = {};

  headers.forEach(function (header, index) {
    var cleanHeader = String(header).trim();
    if (cleanHeader) {
      headerMap[cleanHeader] = index;
    }
  });

  var missingHeaders = REQUIRED_HEADERS.filter(function (header) {
    return headerMap[header] === undefined;
  });

  if (missingHeaders.length) {
    throw new Error("Missing required columns: " + missingHeaders.join(", "));
  }

  return headerMap;
}

function getRows_(sheet, headerMap) {
  var lastRow = sheet.getLastRow();
  var lastColumn = sheet.getLastColumn();

  if (lastRow < 2) {
    return [];
  }

  var values = sheet.getRange(2, 1, lastRow - 1, lastColumn).getValues();

  return values.map(function (rowValues, index) {
    return {
      rowNumber: index + 2,
      values: rowValues,
      get: function (header) {
        return rowValues[headerMap[header]];
      }
    };
  });
}

function normalizeBool_(value) {
  if (value === true || value === 1) {
    return true;
  }

  var normalized = String(value || "").trim().toLowerCase();
  return normalized === "true" ||
    normalized === "yes" ||
    normalized === "y" ||
    normalized === "1";
}

function isTerminalStatus_(status) {
  var normalized = normalizeStatus_(status);
  return normalized === "replied" ||
    normalized === "booked call" ||
    normalized === "not interested" ||
    normalized === "bad email" ||
    normalized === "do not contact";
}

function renderTemplate_(template, data) {
  return String(template).replace(/\{\{([^}]+)\}\}/g, function (match, key) {
    var value = data[String(key).trim()];
    return value === undefined || value === null ? "" : String(value).trim();
  });
}

function buildFirstEmail_(row) {
  var data = {
    "First Name": getGreetingName_(row.get("First Name")),
    "Event Name": row.get("Event Name")
  };

  return {
    subject: renderTemplate_(FIRST_EMAIL_SUBJECT, data),
    body: renderTemplate_(FIRST_EMAIL_BODY, data)
  };
}

function buildFollowUpEmail_(row) {
  var data = {
    "First Name": getGreetingName_(row.get("First Name")),
    "Event Name": row.get("Event Name")
  };

  return {
    subject: renderTemplate_(FOLLOW_UP_SUBJECT, data),
    body: renderTemplate_(FOLLOW_UP_BODY, data)
  };
}

function sendFirstEmailBatch() {
  var count = processBatch_("first", BATCH_SIZE, false);
  notify_("First-email batch processed: " + count + " message(s).");
}

function sendFollowUpBatch() {
  var count = processBatch_("followup", BATCH_SIZE, false);
  notify_("Follow-up batch processed: " + count + " message(s).");
}

function createFirstEmailDrafts() {
  var count = createDraftBatch_("first", BATCH_SIZE);
  notify_("First-email drafts created: " + count + ". Check Gmail > Drafts.");
}

function createFollowUpDrafts() {
  var count = createDraftBatch_("followup", BATCH_SIZE);
  notify_("Follow-up drafts created: " + count + ". Check Gmail > Drafts.");
}

function processBatch_(step, limit, previewOnly) {
  var sheet = getSheet_();
  var headerMap = getHeaderMap_(sheet);
  var rows = getRows_(sheet, headerMap);
  var tracking = buildEmailTracking_(rows);
  var processedEmails = {};
  var processedOrganizations = {};
  var processedCount = 0;

  for (var index = 0; index < rows.length && processedCount < limit; index += 1) {
    var row = rows[index];
    var email = normalizeEmail_(row.get("Email"));
    var organization = normalizeOrganization_(row.get("Organization"));

    if (!email ||
        processedEmails[email] ||
        (organization && processedOrganizations[organization]) ||
        tracking.suppressed[email] ||
        (organization && tracking.suppressedOrganizations[organization])) {
      continue;
    }

    if (!isEligibleForStep_(row, step, tracking)) {
      continue;
    }

    var message = step === "first" ? buildFirstEmail_(row) : buildFollowUpEmail_(row);
    logMessage_(row, email, step, message, previewOnly);

    if (!previewOnly) {
      sendOrRecord_(sheet, headerMap, row, email, step, message);
    }

    processedEmails[email] = true;
    if (organization) {
      processedOrganizations[organization] = true;
    }
    processedCount += 1;
  }

  return processedCount;
}

function createDraftBatch_(step, limit) {
  var sheet = getSheet_();
  var headerMap = getHeaderMap_(sheet);
  var rows = getRows_(sheet, headerMap);
  var tracking = buildEmailTracking_(rows);
  var processedEmails = {};
  var processedOrganizations = {};
  var createdCount = 0;

  for (var index = 0; index < rows.length && createdCount < limit; index += 1) {
    var row = rows[index];
    var email = normalizeEmail_(row.get("Email"));
    var organization = normalizeOrganization_(row.get("Organization"));

    if (!email ||
        processedEmails[email] ||
        (organization && processedOrganizations[organization]) ||
        tracking.suppressed[email] ||
        (organization && tracking.suppressedOrganizations[organization]) ||
        hasDraftMarker_(row.get("Draft Created"), step) ||
        !isEligibleForStep_(row, step, tracking)) {
      continue;
    }

    var message = step === "first" ? buildFirstEmail_(row) : buildFollowUpEmail_(row);

    try {
      GmailApp.createDraft(email, message.subject, message.body);
      writeDraftMarker_(sheet, headerMap, row, step);
      Logger.log(
        "DRAFT CREATED | Row %s | To: %s | Subject: %s",
        row.rowNumber,
        email,
        message.subject
      );
      createdCount += 1;
    } catch (error) {
      var messageText = error && error.message ? error.message : String(error);
      sheet.getRange(row.rowNumber, headerMap["Last Error"] + 1).setValue(messageText);
      Logger.log("Row %s draft failed: %s", row.rowNumber, messageText);
    }

    processedEmails[email] = true;
    if (organization) {
      processedOrganizations[organization] = true;
    }
  }

  return createdCount;
}

function hasDraftMarker_(value, step) {
  var marker = step === "first" ? "first email:" : "follow-up:";
  return String(value || "").toLowerCase().indexOf(marker) !== -1;
}

function writeDraftMarker_(sheet, headerMap, row, step) {
  var existingValue = String(row.get("Draft Created") || "").trim();
  var label = step === "first" ? "First email" : "Follow-up";
  var marker = label + ": " + formatToday_();
  var nextValue = existingValue ? existingValue + "; " + marker : marker;

  sheet.getRange(
    row.rowNumber,
    headerMap["Draft Created"] + 1
  ).setValue(nextValue);
}

function buildEmailTracking_(rows) {
  var firstDone = {};
  var followUpDone = {};
  var suppressed = {};
  var organizationFirstDone = {};
  var suppressedOrganizations = {};

  rows.forEach(function (row) {
    var email = normalizeEmail_(row.get("Email"));
    var organization = normalizeOrganization_(row.get("Organization"));
    if (!email) {
      return;
    }

    var status = normalizeStatus_(row.get("Status"));
    var doNotContact = normalizeBool_(row.get("Do Not Contact"));

    if (doNotContact || isTerminalStatus_(status)) {
      suppressed[email] = true;
      if (organization) {
        suppressedOrganizations[organization] = true;
      }
    }

    if (row.get("Sent Date") || status === "sent" || status === "followed up") {
      firstDone[email] = true;
      if (organization) {
        organizationFirstDone[organization] = true;
      }
    }

    if (row.get("Follow Up Date") || status === "followed up") {
      followUpDone[email] = true;
    }
  });

  return {
    firstDone: firstDone,
    followUpDone: followUpDone,
    suppressed: suppressed,
    organizationFirstDone: organizationFirstDone,
    suppressedOrganizations: suppressedOrganizations
  };
}

function isEligibleForStep_(row, step, tracking) {
  var email = normalizeEmail_(row.get("Email"));
  var organization = normalizeOrganization_(row.get("Organization"));
  var status = normalizeStatus_(row.get("Status"));

  if (!email ||
      normalizeBool_(row.get("Do Not Contact")) ||
      isTerminalStatus_(status) ||
      (organization && tracking.suppressedOrganizations[organization])) {
    return false;
  }

  if (step === "first") {
    var notSentStatus = status === "" || status === "not sent";
    return notSentStatus &&
      !tracking.firstDone[email] &&
      (!organization || !tracking.organizationFirstDone[organization]);
  }

  if (step === "followup") {
    return status === "sent" &&
      !tracking.followUpDone[email] &&
      hasWaitedRequiredDays_(row.get("Sent Date"));
  }

  throw new Error("Unknown outreach step: " + step);
}

function hasWaitedRequiredDays_(sentDateValue) {
  var sentDate = parseSheetDate_(sentDateValue);
  if (!sentDate) {
    return false;
  }

  var now = new Date();
  var elapsedMs = now.getTime() - sentDate.getTime();
  var requiredMs = FOLLOW_UP_DELAY_DAYS * 24 * 60 * 60 * 1000;
  return elapsedMs >= requiredMs;
}

function sendOrRecord_(sheet, headerMap, row, email, step, message) {
  var lastErrorColumn = headerMap["Last Error"] + 1;

  try {
    if (DRY_RUN) {
      if (String(SEND_TEST_TO || "").trim()) {
        GmailApp.sendEmail(
          String(SEND_TEST_TO).trim(),
          "[TEST] " + message.subject,
          "Original recipient: " + email + "\n\n" + message.body
        );
      }

      sheet.getRange(row.rowNumber, lastErrorColumn).setValue("DRY RUN - not sent");
      return;
    }

    GmailApp.sendEmail(email, message.subject, message.body);

    var statusColumn = headerMap["Status"] + 1;
    var dateColumn = step === "first"
      ? headerMap["Sent Date"] + 1
      : headerMap["Follow Up Date"] + 1;
    var nextStatus = step === "first" ? "Sent" : "Followed up";

    sheet.getRange(row.rowNumber, statusColumn).setValue(nextStatus);
    sheet.getRange(row.rowNumber, dateColumn).setValue(formatToday_());
    sheet.getRange(row.rowNumber, lastErrorColumn).clearContent();
  } catch (error) {
    var messageText = error && error.message ? error.message : String(error);
    sheet.getRange(row.rowNumber, lastErrorColumn).setValue(messageText);
    Logger.log("Row %s failed: %s", row.rowNumber, messageText);
  }
}

function logMessage_(row, email, step, message, previewOnly) {
  Logger.log(
    "%s %s | Row %s | To: %s\nSubject: %s\n\n%s",
    previewOnly ? "PREVIEW" : (DRY_RUN ? "DRY RUN" : "SEND"),
    step === "first" ? "FIRST EMAIL" : "FOLLOW-UP",
    row.rowNumber,
    email,
    message.subject,
    message.body
  );
}

function parseSheetDate_(value) {
  if (Object.prototype.toString.call(value) === "[object Date]" && !isNaN(value.getTime())) {
    return value;
  }

  var text = String(value || "").trim();
  if (!text) {
    return null;
  }

  var dateOnlyMatch = text.match(/^(\d{4})-(\d{2})-(\d{2})$/);
  if (dateOnlyMatch) {
    return new Date(
      Number(dateOnlyMatch[1]),
      Number(dateOnlyMatch[2]) - 1,
      Number(dateOnlyMatch[3])
    );
  }

  var parsed = new Date(text);
  return isNaN(parsed.getTime()) ? null : parsed;
}

function formatToday_() {
  return Utilities.formatDate(
    new Date(),
    Session.getScriptTimeZone(),
    "yyyy-MM-dd"
  );
}

function normalizeEmail_(email) {
  return String(email || "").trim().toLowerCase();
}

function normalizeStatus_(status) {
  return String(status || "").trim().toLowerCase();
}

function normalizeOrganization_(organization) {
  return String(organization || "")
    .trim()
    .toLowerCase()
    .replace(/\s+/g, " ");
}

function getGreetingName_(firstName) {
  var cleanName = String(firstName || "").trim();
  var normalized = cleanName.toLowerCase().replace(/[^a-z]/g, "");

  if (!normalized || normalized === "na" || normalized === "none") {
    return "there";
  }

  return cleanName;
}

function notify_(message) {
  try {
    SpreadsheetApp.getUi().alert(message);
  } catch (error) {
    Logger.log(message);
  }
}
