## Found Bugs

---

#### 1. Not knowing what to buy
Looking at the list of ingredients there are a lot of ingredients that I don’t know what to cook with at first glance. Since the app already have a list of recipes it would be very nice to allow the users to access that list of recipes (and their lists of ingredients) from within the app without needing the ingredients that go into the dishes first. This would greatly help users who are unsure of what to buy and what can be made. I think, other than the very general ingredients such as salt, pepper, flour, milk, eggs etc., people don’t just buy stuff without knowing what to make with them.
   
#### 2. `Recipe` showing only the list of ingredients without the actual recipe
I think a feature that should be implemented is displaying the actual recipe of each dish along with their lists of requirements. I don’t know how to scramble my eggs… 😢
   
#### 3. Missing sort features in various locations
**My Pantry** section in the main screen is not sorted in order of ascending expiry dates as specified in the specification. The full list of items the user have in their pantry which can be accessed by clicking `See All` does have sorting functionalities based on various property. However, it was quite hard to figure out that this functionality exist due to the fact that the drop down triangles indicating the table is sorted by a certain property is initially hidden and only shows up when a user clicks on the cells. Item suggestions drop down when adding a new items in the main screen should be sorted in alphabetical order for ease of looking up what items are allowed in the app (I went and bought hash browns because the specification made me crave it but there were no hash browns in the list of items, I tried to add it anyways but couldn’t choose a location to add it. 😢)The `Remove Item` functionality inside the full pantry is implemented as a drop-drown only without a search loop up function and this drop-down suffers the same issue with the drop-down in the main screen: it is not sorted in alphabetical order which makes it very hard to find the thing you want to remove. Alternatively the `Remove item` feature could have a search feature where user can type the name of the item they wish to remove (similar to how they would add an item in the main screen)
   
#### 4. App’s handling of adding new entries of items with the same names
The specification says that `If an item is already in inventory, the app will display “you already have this item.”` However this is not how the app behaves. It actually overwrites the entry of that item in the database, effectively acting as an **Edit** feature. This could be a design choice, in which case it should be specified. In my opinion, neither restricting the user from adding an item that already exists in the pantry nor overwriting the previous entry is a good design choice. Take this scenario as an example: I bought 200g of chicken two days ago. Today chicken is on sale so I buy another 300g, in this case I would like to add more chicken to my current pantry, each of which have different amounts and should have different expiry times, which should make sense. A good behaviour of the app in this case would be to: 
    1. When the user adds an item that is already in the pantry, compare the old entry’s expiry date with the new one.
    2. If they are the same, whether by setting the due date themselves or by leaving that field blank and letting the program decide based on the location placed, then the new amount in the current entry should be added to the already existing entry. 
    3. If they are NOT the same between the old entry and the new entry, then the new entry should be added as a separate entry altogether.
       
#### 5. “About to expire” notification
The feature to notify the user of ingredients that are about to expire in the main screen isn’t implemented.
   
#### 6. Lack of information of `Location` field
The app allows user to specify where they put each items. However, currently there isn’t actually any way to view this information. I’d imagine there was no time to implement this feature. It would be a very nice feature to have though in my opinion.
    
#### 7. Displayed recipes that can be made
Currently under the `What can I cook?` section there is only, at any given time, 4 recipes displayed, and there is no way to view more recipes/other recipes. I’d assume this is not the intended behaviour. As stated in an earlier point, a way to access every single recipe this app has would in turn resolve this issue as well (well somewhat, as then the user still have to figure out if they have all the ingredients to cook a certain thing). Alternatively, without needing to expose the entire list of recipes to the user, the app could show only every recipes that are possible using the ingredients the user currently have added. This could simply be another menu that opens when clicking a `See All` button under the `What can I cook?`section
    
#### 8. Search function in full list
As the number of ingredient increases, it is hard to keep track what ingredients I have. So I probobly better have a search bar to search for the ingredients
    
#### 9. Font issue on group member computer
It is not a big issue, even though the window size is set, “Your Ingredient” in the item table is not showing completely i.e “Your Ingredie…”, and there is free space beside it. I feel like if the window size is fixed, then it should show “Your Ingredient” completely
