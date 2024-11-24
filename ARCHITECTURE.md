
# Project's Architecture

## ***Model:***

1. **TASK MODEL**:
    - This component is a model that stores the data of all the tasks that user entered.
    - The model resides on the both client and server.
    - All controllers and views except **ADD/EDIT VIEW** can communicate with this model. It communicates the following:
        - **ADD CONTROLLER** can ask the **TASK MODEL** to store a task with complete and correct information (course, task type, task name, due date (in DD/MM/YYYY format), due time (in 24:00 format )) submission link, and additional resources can be empty. And communicate with **MANI VIEW** to display all the tasks in the table.
        - **EDIT CONTROLLER** can ask the **TASK MODEL** for the data and update the data, then ask **TASK MODEL** to store the modified data. And communicate with **MAIN VIEW** to display all the tasks in the table with modification.
        - **FILTER CONTROLLER** can ask the **TASK MODEL** to filter the task by by course, type of the task, and due date range(this_week, next_week, from, to). And communicate with **MAIN VIEW**  to display filtered tasks in the table.
        - **SORT CONTROLLER**  can ask the **TASK MODE**L to sort the data by ID of due_date in non-increasing order or non-decreasing order. And communicate with **MAIN VIEW** to display sorted tasks in the table.

## ***Controller:***

1. **ADD CONTROLLER:**
    - This component is a controller that add the data to **TASK MODEL**.
    - This controller resides on the server
    - **TASK MODEL** and **ADD/EDIT VIEW** communicates with the controller. It communicates the following:
        - The **ADD/EDIT VIEW** displays the window with all the field to be added.
        - **ADD CONTROLLER** can ask the **TASK MODEL** to store a task with complete and correct information (course, task type, task name, due date (in DD/MM/YYYY format), due time (in 24:00 format )) submission link, and additional resources can be empty.
2. **EDIT CONTROLLER:**
    - This component is a controller that modified the data in **TASK MODEL**.
    - This controller resides on the server
    - **TASK MODEL** and **ADD/EDIT VIEW** communicates with the controller. It communicates the following:
        - The **ADD/EDIT VIEW** displays the window with all the field to be update with the original information in the input bar.
        - **EDIT CONTROLLER** can ask the **TASK MODEL** for the data and update the data, then ask **TASK MODEL** to store the modified data.
3. **FILTER CONTROLLER:**
    - This component is a controller that filter the data in the **TASK MODEL** by course, type of the task, and due date range(this_week, next_week, from, to, overdue).
    - This controller resides on the server
    - **TASK MODEL** and **MAIN VIEW** communicate with the controller. It communicates the following:
        - The FILTER CONTROLLER can ask TASK MODEL for tasks with specified condition.
        - The MAIN VIEW displays the window with filtered data in a table
4. **SORT CONTROLLER:**
    - This component is a controller that sort the data in the model by ID or due date
    - This controller resides on the server
    - **TASK MODEL** and **MAIN VIEW** communicate with the controller. It communicates the following:
        - The **SORT CONTROLLER** can ask **TASK MODEL** for all tasks, and sort them in specified order
        - The **MAIN VIEW** displays the data in sorted order in the table
5. **DELETE CONTROLLER:**
    - This component is a controller that delete the data from the model
    - This controller resides on the server
    - **TASK MODEL** communicate with this controller as following:
        - The **DELETE CONTROLLER** can ask **TASK MODEL** for tasks that match all the information and delete from **TAKS MODEL**


## ***View:***

1. **MAIN VIEW:**
    - View of table with all the tasks and buttons.
    - This view resides on the client
    - **TASK MODEL**, **FILTER CONTROLLER**, and **SORT CONTROLLER** communicate with this view
        - **MAIN VIEW** displays a window with table of data from **TASK MODEL**
        - **MAIN VIEW** displays a window with table of filtered data
        - **MAIN VIEW** displays a window with table of sorted data
2. **ADD/EDIT VIEW:**
    - View of window with all the sections (course, task type, task name, due date, due time, submission link, and additional resources) to add or edit. And buttons for cancel, and update.
    - This view resides on the client
    - **ADD CONTROLLER** and **EDIT CONTROLLER** communicate with this view as following:
        - **ADD/EDIT VIEW** displays a window with the field to add
        - **ADD/EDIT VIEW** displays a window with the field to edit where original data is displayed in each box