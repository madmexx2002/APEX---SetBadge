# Oracle Apex - Set Badge Value from JavaScript

1. Create Application Item to hold the current value of the badge. Use meaningful names => BADGE_{NAME}.
2. Create a computation for the item. Currently only PL/SQL Expression and SQL Query allowed.
3. Install procedure SET_BADGE and function CALC_COMPUTATION in your schema. 
4. Create an application process from type AJAX Callback and call procedure SET_BADGE.
5. Upload badge.js to static files and reference it under "User Interface" / "JavaScript"
6. Call JavaScript Function setBadge({Item Name}) when ever u need it. => For example in a Dynamic Action on event "Dialog close".

