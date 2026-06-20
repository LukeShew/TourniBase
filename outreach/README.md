# TourniBase Outreach

This folder contains a small Google Sheets and Gmail outreach system for contacting youth basketball tournament directors. It sends controlled batches, tracks outreach status, prevents duplicate sends, and starts in safe dry-run mode.

## 1. Create the Google Sheet

1. Open [Google Sheets](https://sheets.google.com) and create a blank spreadsheet.
2. Rename the first tab to `Outreach`.
3. Import `sheet-template.csv`:
   - Click **File > Import > Upload**.
   - Select `sheet-template.csv`.
   - Choose **Replace current sheet**.
4. Delete the three fake example rows before adding real leads.
5. Keep the header names unchanged. The script uses them to find each column.

Do not add the same director more than once. The script checks normalized email addresses and organization names to prevent contacting multiple people from the same organization.

Use only these Status values:

- Not sent
- Sent
- Followed up
- Replied
- Booked call
- Not interested
- Bad email
- Do not contact

## 2. Add the Apps Script

1. In the Sheet, click **Extensions > Apps Script**.
2. Open the default `Code.gs` file.
3. Replace its contents with everything from `apps-script/Code.gs`.
4. Click **Save**.
5. Return to the Sheet and refresh the page.

If the menu does not appear, run `onOpen` once from the Apps Script editor and approve the requested permissions.

## 3. Configure safe test mode

At the top of `Code.gs`, leave:

```javascript
var DRY_RUN = true;
var SEND_TEST_TO = "";
```

With `DRY_RUN` set to `true`:

- If `SEND_TEST_TO` is blank, no email is sent. The generated subject and body are written to the Apps Script execution log.
- If `SEND_TEST_TO` contains your email, test messages are sent only to that address with `[TEST]` added to the subject.
- A dry-run send updates **Last Error** to `DRY RUN - not sent` but does not change Status or sent dates.

Do not put a personal email address in the repository. Add it only inside the copy of `Code.gs` in your private Google Sheet.

## 4. Preview messages

Keep `DRY_RUN = true`, then use:

- **TourniBase Outreach > Preview next first-email batch**
- **TourniBase Outreach > Preview next follow-up batch**

Open **Extensions > Apps Script > Executions**, select the latest execution, and read its logs.

Preview at least three generated first emails. Confirm the names and event names look normal before enabling real sending. Preview functions never send email or update rows.

To save the eligible messages in the Gmail account that owns/runs the Sheet script, use:

- **TourniBase Outreach > Create first-email drafts**
- **TourniBase Outreach > Create follow-up drafts**

Draft creation does not send messages or change Status and sent dates. The script records each created draft in the **Draft Created** column, for example `First email: 2026-06-20`. Repeated clicks skip rows that already have a marker for that outreach step. A later follow-up marker is appended to the same cell.

## 5. Send the first 10 emails

1. Confirm the preview output.
2. Change `DRY_RUN` to `false` in your private Apps Script copy.
3. Save the script.
4. In the Sheet, click **TourniBase Outreach > Send first-email batch**.
5. Approve permissions if Google asks.

The script sends up to 10 eligible first emails. Successful rows change to **Sent**, and **Sent Date** is set to the current date.

## 6. Send follow-ups

Use **TourniBase Outreach > Send follow-up batch**.

A follow-up is eligible only when:

- Status is **Sent**.
- **Sent Date** is at least three days old.
- No follow-up has already been recorded for that email.

Successful rows change to **Followed up**, and **Follow Up Date** is set to the current date.

## 7. Avoid spammy behavior

- Start with 10 total messages per day.
- Send only to relevant tournament contacts with a legitimate reason to hear from you.
- Personalize the first name and event name.
- Do not repeatedly contact people who do not reply.
- Honor every opt-out immediately.
- Remove bad addresses instead of retrying them.
- Review replies and bounce notices before each new batch.
- Do not buy large generic email lists or suddenly increase volume.

Recommended starting cadence: 10 emails per day, then adjust based on reply quality, bounce rate, and opt-outs.

The daily trigger uses one shared limit of 10 messages. It processes eligible follow-ups first, then uses any remaining capacity for first emails.

## 8. Mark someone as Do Not Contact

1. Select any cells in the rows you want to block.
2. Click **TourniBase Outreach > Mark selected rows as Do Not Contact**.

The script sets **Do Not Contact** to `TRUE` and Status to **Do not contact**.

You can also manually enter `TRUE`, `yes`, `y`, or `1` in the **Do Not Contact** column.

## 9. Track replies manually

Gmail replies are not read automatically.

When a director replies:

1. Change Status to **Replied**, **Booked call**, **Not interested**, **Bad email**, or **Do not contact**.
2. Add useful context to **Reply Notes**.
3. Set **Do Not Contact** to `TRUE` when the person opts out or should not receive another message.

Terminal statuses are always skipped.

## Daily trigger

Use **TourniBase Outreach > Setup daily trigger** to create one daily run. The trigger remains safe while `DRY_RUN` is `true`.

Use **TourniBase Outreach > Remove daily trigger** to remove it.

Google chooses the exact minute within the configured morning hour. See `apps-script/README.md` for permission and testing details.
