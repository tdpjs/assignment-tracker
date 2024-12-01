## User Experience / User Interface

This file is for design choices, intuition of using the web app, and how use is interacting with the app. This is detailed documented. Please check this file (check commits after Nov 29th 22:00) even it's after the deadline just for reference. We have prioritized the essential documentations and put this as second priority.

--- 

1. #### Horizontal Scrolling
   We have made only the table of the assignments to be horizontally scrollable. The reason is that if user is using this app on their phone, unless shrinking the webpage, the whole table cannot be seen. Adding horizontal scroll only to the assignments table makes sense because only the table is moving while other information on the webpage remain at their place.

2. #### Vertical Scrolling
   We have made the whole webpage vertically scrollable. User can only scroll up and down when the display window is not big enough. Opposite to the horizontal scroll, the whole webpage should be vertically scrollable because we don't want to hide part of the assignments table "under" the input section. We want the whole table to be displayed.

3. #### Show Overdue vs. Hide Overdue
   One group member (Anselm) suggested that the logic of the `Show Overdue` button should be flipped to `Hide Overdue`. A vote was conducted with a result of 3:1 to remain unchanged, which is keeping `Show Overdue`.

   Anselm pointed out that from one of the user feedback, a suggestion of "the table should start off unselected" was suggested. Anselm agreed with that suggestion as it is more intuitive to start with an unselected list. Other group members prioritized simplicity over intuition, which the table should ONLY show assignments that matters, referring to assignments that are due in the future in our case.

   This topic has a follow-up question below.

4. #### Adding Overdue task
   A potential problem that happened during our testing phase is that there was a confusion if one can add an overdue task or not. What happened exactly was that an overdue assignment was added with the `Show Overdue` button unselected. This led to the overdue task NOT being shown on the table. This is SUPPOSED to happen, but there was no notification indicating that this overdue assignment is successfully added because of the setting of not showing `Show Overdue` assignments.

   A simple solution to this confusion is not allowing users to add overdue assignments. We have tried to implement this, but it is not working. Rather than a bug, we consider it as a design choice, as this is just one of the many solution to resolve this problem.

5. #### 
