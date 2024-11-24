### Project Requirements

1. The application shall use JavaFX to render the UI
2. The application shall be a desktop application.
3. The application shall be supported on Windows and Ubuntu.
4. The application should be able to be launched by double clicking a shortcut.
5. The application should be able to be launched by typing its name in a terminal.
6. The app can be closed by clicking the red x on the top right.
7. The app can be closed by the user clicks Alt + F4
8. The main window of the application shall display all tasks in a table in the center of the application.
9. Each row of the table shall represent a task
10. Each column of the table shall represent each property of the task: ID, Course, Type, Name, Due Date, Due Time, Submission Link, and Resources.
11. The value displayed in a task’s cell under the “ID” column in the main window shall be a positive integer.
12. The value displayed in a task’s cell under the “Course” column in the main window will be the value of the task’s “Course” property
13. The value displayed in a task’s cell under the “Type” column in the main window will be the value of the task’s “Type” property
14. The value displayed in a task’s cell under the “Name” column in the main window shall never be empty
15. The value displayed in a task’s cell under the “Name” column in the main window will be the value of the task’s “Name” property
16. The value displayed in a task’s cell under the “Due Date” column in the main window will be the value of the task’s “Due Date” property
17. The value displayed in a task’s cell under the “Due Time” column in the main window will be the value of the task’s “Due Time” property
18. The value displayed in a task’s cell under the “Submission Link” column in the main window will be a hyperlink with the text “SUBMISSION” if the value of the task’s “Submission Link” property is a valid web link. 
19. If a task’s cell under the “Submission Link” is a hyperlink with the text “SUBMISSION” then it shall link to the link stored in the value of the task’s “Submission Link” property.
20. The value displayed in a task’s cell under the “Submission Link” column in the main window will be the value of the task’s “Submission Link” property if the value is not a valid web link.
21. The value displayed in a task’s cell under the “Resources” column in the main window will be hyperlinks with the texts “resources1”, “resources2”, etc. 
22. The hyperlinks “resources1”, “resources2” will link to the links stored in the value of the task’s “Resources” property. 
23. Each task added to the database shall receive a unique positive integer ID in its internal representation.
24. Subsequent tasks ID will be 1 integer higher than the previous task’s ID.
25. Tasks with identical field values shall be treated as separate tasks entirely. That is, they will either both be displayed or both be hidden.
26. Subsequence IDs shall be computed from the integer following the highest task ID currently in the database.
27. Clicking the “Add” button at the bottom of the tasks table shall open an overlay for adding a new task. We shall refer to this as the “Add/Edit” screen.
28. The “Add/Edit” screen shall be one big rectangle and two rectangles side by side below it
29. The big rectangle shall have two columns: one of labels and the other of input boxes.
30. The small rectangle on the left shall have the text “CANCEL” written on it
31. The small rectangle on the right shall have the text “CONFIRM” written on it
32. The left column has labels of properties: Course, Name, Type, Due Date, Due Time, Submission Link, and Resources.
33. The right column has input boxes that can be typed into.
34. The input box corresponding to the label “Course” shall display the placeholder text “e.g. CPEN_221”
35. The input box corresponding to the label “Name” shall display the placeholder text “e.g. PPT 1”
36. The input box corresponding to the label “Type” shall display the placeholder text “e.g. quiz”
37. The input box corresponding to the label “Due Date” shall display the placeholder text “e.g. 23/10/2024”
38. The input box corresponding to the label “Due Time” shall display the placeholder text “e.g. 22:00”
39. The input box corresponding to the label “Submission Link” shall display the placeholder text “e.g. https://awesomesite.edu/quiz/ ”
40. The input box corresponding to the label “Resources” shall display the placeholder text “e.g. https://awesomesite.edu/resource1 https://awesomesite.edu/resource2 ”
41. When the user clicks the “CANCEL” button the “Add/Edit” window will close.
42. When the user clicks the “CANCEL” button no new task will be added to the database.
43. When the user clicks the “CANCEL” button after having entered contents into the input boxes, those contents will not be preserve until the next time the “Add/Edit” window is pulled up.
44. When the user clicks the “CONFIRM”, assuming no other input boxes contains invalid inputs, and the input box labeled “Course” is empty (the placeholder text is shown) the application shall assign an empty string to the new task’s “Course” property. 
45. When the user clicks the “CONFIRM”, assuming no other input boxes contains invalid inputs, and the input box labeled “Course” is not empty the application shall take the contents of the input box labeled “Course” as is and assign the string found to the new task’s “Course” property.
46. When the user clicks the “CONFIRM”, assuming no other input boxes contains invalid inputs, and the input box labeled “Type” is empty (the placeholder text is shown), the application shall assign an empty string to the new task’s “Type” property. 
47. When the user clicks the “CONFIRM”, assuming no other input boxes contains invalid inputs, and the input box labeled “Type” is not empty, the application shall take the contents of the input box labeled “Type” as is and assign the string found to the new task’s “Type” property.
48. When the user clicks the “CONFIRM”, assuming no other input boxes contains invalid inputs, and the input box labeled “Name” is empty (The placeholder text is shown),  the application shall detect invalid inputs and not add the task.
49. When the user clicks the “CONFIRM”, assuming no other input boxes contains invalid inputs, and the input box labeled “Name” is not empty,  the application shall take the contents of the input box labeled “Name” as is and assign the string found to the new task’s “Name” property.
50. When the user clicks the “CONFIRM”, assuming no other input boxes contains invalid inputs, and the input box labeled “Submission Link” is empty (the placeholder text is shown), the application shall assign an empty string to the new task’s “Submission Link” property.
51. When the user clicks the “CONFIRM”, assuming no other input boxes contains invalid inputs, and the input box labeled “Submission Link” is not empty, the application shall take the contents of the input box labeled “Submission Link” as is and assign the string found to the new task’s “Submission Link” property.
52. When the user clicks the “CONFIRM”, assuming no other input boxes contains invalid inputs, and the input box labeled “Due Date” is empty (The placeholder text is shown),  the application shall detect invalid inputs and not add the task.
53. When the user clicks the “CONFIRM”, assuming no other input boxes contains invalid inputs, and the input box labeled “Due Date” is not empty and is not in the correct format (DD/MM/YYYY), the application shall detect invalid inputs and not add the task.
54. When the user clicks the “CONFIRM”, assuming no other input boxes contains invalid inputs, and the input box labeled “Due Date” is not empty and is in the correct format (DD/MM/YYYY), the application shall take the contents of the input box labeled “Due Date” as is and assign the string found to the new task’s “Due Date” property.
55. When the user clicks the “CONFIRM”, assuming no other input boxes contains invalid inputs, and the input box labeled “Due Time” is empty (the placeholder text is shown), the application shall assign the default value “23:59” to the new task’s “Due Time” property
56. When the user clicks the “CONFIRM”, assuming no other input boxes contains invalid inputs, and the input box labeled “Due Time” is not empty and is not in the correct format, (MM:HH) the application shall detect invalid inputs and not add the task.
57. When the user clicks the “CONFIRM”, assuming no other input boxes contains invalid inputs, and the input box labeled “Due Time” is not empty and is in the correct format (MM:HH), the application shall take the contents of the input box labeled “Due Date” as is and assign the string found to the new task’s “Due Time” property.
58. When the user clicks the “CONFIRM”, assuming no other input boxes contains invalid inputs, and the input box labeled “Submission Link” is empty (the placeholder text is shown) the application shall assign an empty string to the new task’s “Submission Link” property. 
59. When the user clicks the “CONFIRM”, assuming no other input boxes contains invalid inputs, and the input box labeled “Submission Link” is not empty the application shall take the contents of the input box labeled “Course” as is and assign the string found to the new task’s “Submission Link” property.
60. When the user clicks the “CONFIRM”, assuming no other input boxes contains invalid inputs, and the input box labeled “Resources” is empty (the placeholder text is shown), the application shall assign an empty string to the new task’s “Resources” property. 
61. When the user clicks the “CONFIRM”, assuming no other input boxes contains invalid inputs, and the input box labeled “Resources” is not empty and is not in the correct format (links separated by commas), the application shall detect invalid inputs and not add the task. 
62. When the user clicks the “CONFIRM”, assuming no other input boxes contains invalid inputs, and the input box labeled “Resources” is not empty and is in the correct format (links separated by commas), the application shall take the contents of the input box labeled “Resources” as is and assign the string found to the new task’s “Resources” property.
63. When the user clicks the “CONFIRM” button and the input box labeled “Name” is empty, the task will not be added. 
64. When the user clicks the “CONFIRM” button and the input box labeled “Due Date” is empty, the task will not be added. 
65. When the user clicks the “CONFIRM” button and the contents in the input box labeled “Due Date” is not in the expected format, the task will not be added.
66. When the user clicks the “CONFIRM” button and the contents in the input box labeled “Due Date” is not in the expected format, the “Add/Edit” window will not go away.
67. When the user clicks the “CONFIRM” button and the contents in the input box labeled “Due Date” is not in the expected format, the contents of the “Add/Edit” window will not refresh. In other words, all content previously input by the user before the latest click on the “ADD” button will be preserved.
68. When the user clicks the “CONFIRM” button and the contents in the input box labeled “Due Date” is not in the expected format, the border of the input box labeled “Due Date” will turn from the color black to the color red.
69. When the user clicks the “CONFIRM” button and the contents in the input box labeled “Due Date” is not in the expected format, the contents of the input box labeled “Due Date” will turn from the color black to the color red.
70. When the user clicks the “CONFIRM” button and the contents in the input box labeled “Due Time” is not in the expected format, the task will not be added.
71. When the user clicks the “CONFIRM” button and the contents in the input box labeled “Due Time” is not in the expected format, the “Add/Edit” window will not go away.
72. When the user clicks the “CONFIRM” button and the contents in the input box labeled “Due Time” is not in the expected format, the contents of the “Add/Edit” window will not refresh. In other words, all content previously input by the user before the latest click on the “CONFIRM” button will be preserved.
73. When the user clicks the “CONFIRM” button and the contents in the input box labeled “Due Time” is not in the expected format, the border of the input box labeled “Due Date” will turn from the color black to the color red.
74. When the user clicks the “CONFIRM” button and the contents in the input box labeled “Due Time” is not in the expected format, the contents of the input box labeled “Due Date” will turn from the color black to the color red.
75. When the user clicks the “CONFIRM” button and the contents in the input box labeled “Resources” is not in the expected format, the task will not be added.
76. When the user clicks the “CONFIRM” button and the contents in the input box labeled “Resources” is not in the expected format, the “Add/Edit” window will not go away.
77. When the user clicks the “CONFIRM” button and the contents in the input box labeled “Resources” is not in the expected format, the contents of the “Add/Edit” window will not refresh. In other words, all content previously input by the user before the latest click on the “CONFIRM” button will be preserved.
78. When the user clicks the “CONFIRM” button and the contents in the input box labeled “Resources” is not in the expected format, the border of the input box labeled “Due Date” will turn from the color black to the color red.
79. When the user clicks the “CONFIRM” button and the contents in the input box labeled “Resources” is not in the expected format, the contents of the input box labeled “Due Date” will turn from the color black to the color red.
80. When the user clicks the “CONFIRM” button and all input boxes contain valid inputs, the task will be added to the database. 
81. When the user clicks the “CONFIRM” button and all input boxes contain valid inputs, the “Add/Input” window will close.
82. When the “Add/Edit” window closes by the user successfully clicking “CONFIRM” and adding the task, the contents of its input boxes will not persist until the next time it is opened up (i.e. by clicking on the “ADD” button again.)
83. When the user hover their mouse over a row in the tasks table, a rectangle will render on the right side of that row with the text “EDIT” written on it.
84. When the user clicks on the rectangle with the text “EDIT” written on it the “Add/Edit” screen will appear on top of the normal window.
85. The window opened up by clicking the “EDIT” button will have the same layout as the one opened up by clicking the “ADD” button at the bottom of the normal window
86. When opening up the “Add/Edit” screen by clicking on the “EDIT” button rather than the “ADD” button the input box corresponding to the label “Course” shall contain the string value representing the property “Course” of the task on the row hovered over before clicking the “EDIT” button or the placeholder string “e.g. CPEN_221” if there is no value input previously.
87. When opening up the “Add/Edit” screen by clicking on the “EDIT” button rather than the “ADD” button the input box corresponding to the label “Name” shall contain the string value representing the property “Name” of the task on the row hovered over before clicking the “EDIT” button.
88. When opening up the “Add/Edit” screen by clicking on the “EDIT” button rather than the “ADD” button the input box corresponding to the label “Type” shall contain the string value representing the property “Type” of the task on the row hovered over before clicking the “EDIT” button or the placeholder string “e.g. quiz” if there is no value input previously.
89. When opening up the “Add/Edit” screen by clicking on the “EDIT” button rather than the “ADD” button the input box corresponding to the label “Due Date” shall contain the string value representing the property “Due Date” of the task on the row hovered over before clicking the “EDIT” button.
90. When opening up the “Add/Edit” screen by clicking on the “EDIT” button rather than the “ADD” button the input box corresponding to the label “Due Time” shall contain the string value representing the property “Due Time” of the task on the row hovered over before clicking the “EDIT” button or the placeholder string “e.g. 22:00” if there is no value input previously.
91. When opening up the “Add/Edit” screen by clicking on the “EDIT” button rather than the “ADD” button the input box corresponding to the label “Submission Link” shall contain the string value representing the property “Course” of the task on the row hovered over before clicking the “EDIT” button or the placeholder string “e.g. https://awesomesite.edu/quiz/ ” if there is no value input previously.
92. When opening up the “Add/Edit” screen by clicking on the “EDIT” button rather than the “ADD” button the input box corresponding to the label “Resources” shall contain the string value representing the property “Course” of the task on the row hovered over before clicking the “EDIT” button or the placeholder string “e.g. https://awesomesite.edu/resource1 https://awesomesite.edu/resource2 ” if there is no value input previously.
93. The user shall be able to edit contents of the input boxes. similar to how they would when the add a task. 
94. Clicking the “CONFIRM” button on the “Add/Edit” window after opening the window by clicking an “EDIT” button will produce the same behaviour as pressing the “CONFIRM” button on the “Add/Edit” window after opening the window by clicking the “ADD” button.
95. When the user clicks the “CONFIRM” button after opening the window by clicking an “EDIT” button, and all input boxes contain valid inputs, the “Add/Edit” window will close. 
96. When the user clicks the “CONFIRM” button after opening the window by clicking an “EDIT” button, and all input boxes contain valid inputs, the task on the row where the “EDIT” button was clicked will be updated with the changes. 
97. When the user clicks the “CANCEL” button on the “Add/Edit” window after opening the window by clicking an “EDIT” button, the “Add/Edit” window will close.
98. When the user clicks the “CANCEL” button on the “Add/Edit” window after opening the window by clicking an “EDIT” button without making any changes, no changes will be made to the task on the row where the “EDIT” button was clicked. 
99. When the user clicks the “CANCEL” button on the “Add/Edit” window after opening the window by clicking an “EDIT” button after having made changes in the input boxes, the task on the row where the “EDIT” button was clicked shall not be updated with the changes. 
100. When the user hover their mouse over a row in the tasks table, a rectangle will render on the right side of that row with the text “DELETE” written on it.
101. When the user clicks on the rectangle with the text “DELETE” written on it the “Delete” window will appear on top of the normal window.
102. The “Delete” window is a rectangle in the middle of the screen with two smaller rectangles side by side below it. 
103. The big rectangle in the “Delete” window has the text “Are you sure you want to delete this?”. 
104. The small rectangle on the left side in the “Delete” window has the text “NO”. 
105. The small rectangle on the left side in the “Delete” window has the text “YES”. 
106. When the user clicks on “YES” the task on the row where the “DELETE” button was clicked will be removed from the database.
107. When the user clicks on “YES” the “Delete” window will close. 
108. When the user clicks on “NO” no changes will be made to the task on the row where the “DELETE” button was clicked.
109. When the user clicks on “NO” the “Delete” window will close.
110. The input bar left of the button with the text “FILTER” shall be in input mode after one mouse click on it.
111. Contents of the input bar shall be able to be edited using keyboard inputs
112. Shen the user clicks on the button with the text “FILTER”, the displayed tasks in the table will update according to the filtering flags 
113. Before the “FILTER” button is clicked for the first time after the application is open, all undue tasks (all tasks whose due dates and times occur after the current date and time when the app is ran) shall be displayed in the table. This shall be considered part of the “default” filter.
114. Before the “FILTER” button is clicked for the first time after the application is open, tasks shall be sorted in chronological order (increasing due dates and times) in the table. This shall be considered part of the “default” filter.
115. Before the “FILTER” button is clicked for the first time after the application is open, no overdue tasks (tasks whose due dates and times occurred before the current time when the app is fan) shall be displayed. This shall be considered part of the “default” filter.
116. When the input bar to the left of the button labeled “FILTER” has contents input by the user for the first but the “FILTER” button had not been clicked then no filters will be applied and still only undue tasks will be displayed
117. When the input bar to the left of the button labeled “FILTER” has contents input by the user for the first but the “FILTER” button had not been clicked then no filters will be applied and still tasks will be displayed in increasing due dates and times order.
118. When the button “FILTER” is clicked, the application shall re-render the tasks displayed based on the contents in the input bar on the left of the button (filters)
119. The contents of the input bar to the left of the button labeled “FILTER” shall be able to be edited at any time 
120. When the “FILTER” button is clicked and there are no contents in the input bar to the left of the button then the new displayed tasks will follow the “default” filter.
121. When the “FILTER” button is clicked and the contents in the input bar contains invalid flags (not one of “show_overdue”, “course:<args>”, “type:<args>”, “order:due_date”, “order:due_date_ascending”, “order:id”, “order:id_ascending”, “from:<DD/MM/YYYY>”, “to:<DD/MM/YYYY>”,  “name:<args>”,“this_week”, “next_week”), the application will ignore these values when determining the new tasks to display. 
122. When the “FILTER” button is clicked and the contents in the input bar contains valid flags BUT they are not separated by a space in between they will be treated as invalid and thus not be applied to the displayed tasks. 
123. When the “FILTER” button is clicked and “show_overdue” by itself is found in the contents of the input bar to the left of the button, the new displayed tasks will include all tasks in the database, sorted in chronological order.
124. When the “FILTER” button is clicked and “from:” by itself is found in the contents of the input bar to the left of the button, the new displayed tasks will include all UNDUE tasks from 00:00 of the date specified in the argument of the “from:” tag
125. When the “FILTER” button is clicked and more than one of the flags “from:” are found in the contents of the input bar to the left of the button, the first one to appear (the furthermost left) will be applied to the new displayed tasks. 
126. When the “FILTER” button is clicked and “to:” by itself is found in the contents of the input bar to the left of the button, the new displayed tasks will include all UNDUE tasks up to 23:59 of the date specified in the argument of the “to:” tag
127. When the “FILTER” button is clicked and more than one of the flags “to:” are found in the contents of the input bar to the left of the button, the first one to appear (the furthermost left) will be applied to the new displayed tasks. 
128. When the “FILTER” button is clicked and one of the flags “from:” and “to:” are found in the contents of the input bar to the left of the button, the new displayed tasks will include all UNDUE tasks from 00:00 of the date specified in the argument of the “from:” tag up to 23:59 of the date specified in the argument of the “to:” tag
129. When the “FILTER” button is clicked and “this_week” by itself is found in the contents of the input bar to the left of the button, the new displayed tasks will include all UNDUE tasks in the current week (00:00 of the Monday to 23:59 of the Sunday) containing the date the program is ran. 
130. When the “FILTER” button is clicked and “next_week” by itself is found in the contents of the input bar to the left of the button, the new displayed tasks will include all UNDUE tasks in the week following the week containing the date the program is ran. 
131. When the “FILTER” button is clicked and “this_week” and a “from:” tag is found in the contents of the input bar to the left of the button, the new displayed tasks will include the union of all UNDUE tasks in the current week (00:00 of the Monday to 23:59 of the Sunday) and from 00:00 of the date specified in the argument of the “from:” tag.
132. When the “FILTER” button is clicked and “this_week” and a “to:” tag is found in the contents of the input bar to the left of the button, the new displayed tasks will include the union of all UNDUE tasks in the current week (00:00 of the Monday to 23:59 of the Sunday) and up to 23:59 of the date specified in the argument of the “to:” tag
133. When the “FILTER” button is clicked and “this_week”,  a “from:” tag and a “to:” tag is found in the contents of the input bar to the left of the button, the new displayed tasks will include the union of all three tasks
134. When the “FILTER” button is clicked and “next_week”,  a “from:” tag and a “to:” tag is found in the contents of the input bar to the left of the button, the new displayed tasks will include the union of all three tasks
135. When the “FILTER” button is clicked and more than one of the flags “this_week” and “next_week” are found in the contents of the input bar to the left of the button, the first one to appear (the furthermost left) will be applied to the new displayed tasks. 
136. When the “FILTER” button is clicked and “ show_overdue ” is found with any combination of the tags “from:”, “to:”, “this_week”, “next_week”, the new displayed tasks will include all tasks in the specified range by the date filters. 
137. When the “FILTER” button is clicked and a “course:” tag  is found in the contents of the input bar to the left of the button the displayed tasks will include only tasks whose “Course” property matches EXACTLY with the argument of the “Course:” task.
138. When the “FILTER” button is clicked and a “type:” tag  is found in the contents of the input bar to the left of the button the displayed tasks will include only tasks whose “Course” property matches EXACTLY with the argument of the “Course:” task.
139. When the “FILTER” button is clicked and a “name:” tag  is found in the contents of the input bar to the left of the button the displayed tasks will include only tasks whose “Course” property PARTIALLY matches with the argument of the “Course:” task.
140. When the “FILTER” button is clicked and a “order:due_date” tag is found in the contents of the input bar to the left of the button the displayed tasks will be sorted in increasing due date and times order (Tasks with earliest due dates will appear first), this is also the “default” order.
141. When the “FILTER” button is clicked and a “order:due_date_descending” tag is found in the contents of the input bar to the left of the button the displayed tasks will be sorted in descending due date and times order (Tasks with latest due dates appear first).
142. When the “FILTER” button is clicked and a “order:id” tag is found in the contents of the input bar to the left of the button the displayed tasks will be sorted in increasing ID (Tasks with lowest ID will appear first)
143. When the “FILTER” button is clicked and a “order:id_descending” tag is found in the contents of the input bar to the left of the button the displayed tasks will be sorted in decreasing ID order (Tasks with latest due dates appear first).
144. When the “FILTER” button is clicked and a single “order:” tag is found in the contents of the input bar to the left of the button with an argument that is not one of “due_date”, “due_date_descending”, “id” or “id_descending” the application will ignore the “order:” tag. 
145. When the “FILTER” button is clicked and multiple “order:” tags are found in the contents of the input bar to the left of the button the new displayed tasks will be sorted according to the argument of the first “order:” tag found. 
146. There shall be a button at the top right of the main window labeled “EXPORT”.
147. When the user clicks on the button labeled “EXPORT” the application a “.ics” file containing calendar entries of the currently displayed tasks will be saved to the user’s machine in the default download location.