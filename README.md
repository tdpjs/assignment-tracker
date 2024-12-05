## How to use the app

The web version of the app is hosted at https://assignment-tracker-tdpjs.web.app/

# Sign in
- Email and password:
    - Enter your email and password if you previously signed up and click sign in.
    - If this is the first time using the app, you need to navigate to the sign-up screen and enter your credentials. After you click "Sign up" a confirmation email will be sent to your email address with a link that verifies your email, redirect you to the app and signs you in.
    - If you attempt to sign up with an email address that is already in use, nothing will be sent and the password you entered will not work.
    - If you previously signed in using an email and forget your password, click "Forgot your password?", enter your email and a password reset email will be sent to your email address where you can enter your new password and be signed in.
- OAuth providers:
    - You may choose to sign in with one of three OAuth providers, login using your accounts, and you will be redirected to the app after successfully signing in.

# Main view layout
Upon successfully signing in, you will be redirected to a page where you can see a table of your assignments. Initially this table is empty. You can add assignments by clicking the button in the middle fo the screen labeled "Add Assignment"
Above the table are options to sort assignments be some criteria, a field to enter filters of assignments, a button next to it that apply the filters and a checkbox to show/hide assignments whose due dates are overdue.

# Adding assignments

When clicking "Add Assignment", a pop-up dialog will appear where you can input various details of the assignment.
The following details are required for every task: Name, Due Date and Due Time.
The rules for each field are as follows:
- Course: can be any string, spaces are okay
- Name: can be any string, spaces are okay
- Type: can be any string, spaces are okay
- Due Date: must be in YYYY-MM-DD format. Clicking on the field will open up a GUI where you can select the date. Alternatively you can type it in the correct format manually.
- Due Time: must be in HH:MM (TZ) where 00 <= HH <= 23, 00 <= MM <= 59, TZ is the timezone abbreviation of the time you entered. (e.g 11:00 PST). By default, timezone is set to PST
    - Supported abbreviations are (ACDT, ACST, ACT, ACWST, ADT, AEDT, AEST, AFT, AKDT, AKST, ALMT, AMST, AMT, ANAST, ANAT, AQTT, ART, AST, AWDT, AWST, AZOST, AZOT, AZST, AZT, AoE, BNT, BOT, BRST, BRT, BST, BTT, CAST, CAT, CCT, CDT, CEST, CET, CHADT, CHAST, CHOST, CHOT, CHUT, CIST, CKT, CLST, CLT, COT, CST, CVT, CXT, ChST, DAVT, DDUT, EASST, EAST, EAT, ECT, EDT, EEST, EET, EGST, EGT, EST, ET, FET, FJST, FJT, FKST, FKT, FNT, GALT, GAMT, GET, GFT, GILT, GMT, GST, GYT, HKT, HST, IOT, IRDT, IRKST, IRKT, IRST, IST, JST, KGT, KOST, KRAST, KRAT, KST, KUYT, LHDT, LHST, LINT, MAGST, MAGT, MART, MAWT, MDT, MHT, MMT, MSD, MSK, MST, MUT, MVT, MYT, NCT, NDT, NFDT, NFT, NOVST, NOVT, NPT, NRT, NST, NUT, NZDT, NZST, OMSST, OMST, ORAT, PDT, PET, PETST, PETT, PGT, PHOT, PHT, PKT, PMDT, PMST, PONST, PST, PWT, PYST, PYT, QYZT, RET, ROTT, SAST, SBT, SCT, SGT, SRET, SRT, SST, SYOT, TAHT, TFT, TJT, TKT, TLT, TMT, TOST, TOT, TRT, TVT, ULAST, ULAT, UTC, UYST, UYT, UZT, VET, VLAST, VLAT, VOST, VUT, WAKT, WARST, WAST, WAT, WEST, WET, WFT, WIT, WST, WT, YAKT, YAKST, YEKT)
- Submission: can be any string, spaces are okay. The expected input is a single web link or normal text, the links will not work if more than once are entered.
- Resources: any comma separated strings allowed.

Click "Add Assignment" in the dialog to add the new assignment.

# Editing assignments

Each assignment has a button on the last column to edit the assignment. A similar pop-up dialog to the add assignment dialog will appear where you can edit each fields.
The rules for each field are similar as above.

# Deleting assignments

Each assignment has a button on the last column to delete the assignment.
When clicked a pop-up dialog will appear requesting your confirmation to delete the assignment, select "Delete Assignment" to delete the assignment.

# Sorting displayed assignments

By default, assignments displayed are sorted in Due Date Ascending order.
Select in the sort drop-down a criteria to sort by: Due Date Ascending, Due Date Descending, Order Added Ascending and Order Added Descending.

# Filtering displayed assignments

By default, all assignments are displayed. You may enter filters to only display assignments of matching criteria.
The following filters are available:

- course:<arg>, <arg> can be any string, matches all assignments whose "Course" column partially matches <arg>
- name:<arg>, <arg> can be any string, matches all assignments whose "Name" column partially matches <arg>
- type:<arg>, <arg> can be any string, matches all assignments whose "Type" column partially matches <arg>
- from:<arg>, <arg> must be in the format YYYY-MM-DD, YYYY > 0, MM > 0, DD > 0. Overflow dates and months carry over to the next value. (e.g. 2024-11-31 is equivalent to 2024-12-01)
- to:<arg>, <arg> must be in the format YYYY-MM-DD, YYYY > 0, MM > 0, DD > 0. Overflow dates and months carry over to the next value. (e.g. 2024-11-31 is equivalent to 2024-12-01)
- timezone:<arg>, <arg> must be one of the timezone abbreviations shown above.

A few rules on filters:
- When "from:<arg>" and "to:<arg>" is used, timezone is defaulted to PST, if you wish to set a different timezone for the filter, use the "timezone:<arg>" filter.
- Only the first occurrence of each filter will be used
- Filters should be separated by spaces
- Invalid filters will be ignored.

# Show Overdue Tasks

There is a checkbox to show assignments whose due dates have passed

# Sign out

There is a button at the bottom right of the screen that signs out and takes you back to the sign in screen 