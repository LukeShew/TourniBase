# Google Apps Script Setup

## Install `Code.gs`

1. Open the Google Sheet that contains the outreach columns.
2. Rename the sheet tab to `Outreach`.
3. Click **Extensions > Apps Script**.
4. Open the default `Code.gs`.
5. Replace its contents with the local `Code.gs` file from this folder.
6. Save the project.
7. Refresh the Google Sheet.

If the **TourniBase Outreach** menu does not appear, select `onOpen` in the Apps Script editor and click **Run** once.

## Permissions

Google will ask for permission when you first run a function that needs it. The script requires access to:

- Read and update the current spreadsheet.
- Send email through Gmail when real sending or test-recipient mode is used.
- Create and remove Apps Script triggers.

Review the permissions and make sure the script is attached to the correct Sheet before approving.

## Safe testing

The checked-in batch setting is:

```javascript
var BATCH_SIZE = 10;
```

Use this order:

1. Import the CSV and add a few fake `example.com` rows.
2. Run **Create first-email drafts** to save ready-to-review drafts in the Gmail account running the script.
3. Review the drafts in Gmail. Nothing is sent and the Sheet tracking fields remain unchanged.
4. Send approved drafts manually from Gmail.
5. Update Status and the appropriate sent-date column in the Sheet.

If **First Name** is `NA`, `N/A`, or blank, generated emails use the greeting `Hey there,`.

Draft functions create Gmail drafts using the real recipient, subject, and body. They do not send messages or update Status and dates. After creating a draft, the script records it in the **Draft Created** column.

Examples:

- `First email: 2026-06-20`
- `First email: 2026-06-20; Follow-up: 2026-06-24`

Repeated clicks skip recipients that already have a marker for that outreach step. The marker remains after a draft is sent or deleted.

The script creates drafts only. It cannot send emails directly.
