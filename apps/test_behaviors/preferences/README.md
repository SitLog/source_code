# Conceptual inference demo
The code that implements the conceptual inference demo, relying on the knowledge and preferences stored in the robot's knowledge-base, is within the files:

- [preferences_main.dm](https://github.com/SitLog/source_code/blob/master/apps/test_behaviors/preferences/preferences_main.dm): from here all the other dialogue models involved in the demo are called, also the pipeline of the execution is defined and some basic conversation with the user takes place.
- [ask_user_preferences.dm](https://github.com/SitLog/source_code/blob/master/apps/test_behaviors/preferences/ask_user_preferences.dm): at the beginning of the task, this code defines a conversation from which the robot acquires the preferences of the user. Such preferences are stored in the KB.
- [welcome_user.dm](https://github.com/SitLog/source_code/blob/master/apps/test_behaviors/preferences/welcome_user.dm): with this code the robot meets the user and welcome him or her after a day of work. A short conversation is held and the KB is updated with the information expressed by the user.
- [get_preferences.dm](https://github.com/SitLog/source_code/blob/master/apps/test_behaviors/preferences/get_preferences.dm): an important use of preferences occurs here since the user orders some items, which are compared with the preferred ones retrived from the KB. If conflict arises, the user is asked to choose the item to be fetched. 
- [get_pref_items.dm](https://github.com/SitLog/source_code/blob/master/apps/test_behaviors/preferences/get_pref_items.dm): in this code the final items ordered by the user are looked for in the preferred shelves, knowledge that is also stored in the KB. Then the robot takes such items.
- [deliver_pref_items.dm](https://github.com/SitLog/source_code/blob/master/apps/test_behaviors/preferences/deliver_pref_items.dm): once the items are taken, this code tells the robot where to go to deliver them. It finds out the room where the user is found based on his or her preferences.
- [update_kb_pref.dm](https://github.com/SitLog/source_code/blob/master/apps/test_behaviors/preferences/update_kb_pref.dm): after delivering the items, by this code the robot informs the user if such items where misplaced in the shelves and asks whether or not to update the KB accordingly. If the user accepts, the update to the KB is performed.
- [check_item_locations.dm](https://github.com/SitLog/source_code/blob/master/apps/test_behaviors/preferences/check_item_locations.dm): the code here lets the user know if the objects in the shelves are placed incorrectly, then gives a possible explanation of this misplacement using abduction and the information in the KB. The robot also offers to put the misplaced objects in their right shelves.
- [fetch_and_take.dm](https://github.com/SitLog/source_code/blob/master/apps/test_behaviors/preferences/fetch_and_take.dm): finally, with this code the misplaced objects are taken by the robot, who puts them in their right shelves.
- [user_functions.pl](https://github.com/SitLog/source_code/blob/master/apps/test_behaviors/user_functions.pl): several user functions needed in the conceptual inference demo are defined here among many others for a wide range of dialogue models. Some of the user functions used by the conceptual inference demo are: the parser for the human-robot conversation, the choice between ordered and preferred items and the abduction reasoning to determined a possible cause for the misplaced objects.
- [preferences_KB.txt](https://github.com/SitLog/source_code/blob/master/knowledge_base/preferences_KB.txt): holds the KB for the conceptual inference demo.

If the demo wants to be executed on SitLog test mode, run the command ```./scripts/test_behaviors test``` on a terminal with present directory the source of this repository (see also the instructions [here](https://github.com/SitLog/source_code#sitlog)). Then you can enter the following answers when prompted by the interpreter.

    res(preferences).
    ok.
    'hi golem i like malz'.
    'i like noodles best'.
    'no thanks golem that is ok'.
    'i had a bad day'.
    'bring me something to drink and bisquits'.
    'yes'.
    'no golem noodles is ok'.
    objects([object(malz,0.2,2,0.55,4,5,6,7,8)]).
    objects([object(bisquits,1,2,3,4,5,6,7,8)]).
    objects([object(noodles,1,2,3,4,5,6,7,8),object(coke,1,2,3,4,5,6,7,8)]).
    objects([object(noodles,0.2,2,0.55,4,5,6,7,8)]).
    'yes golem please'.
    'yes golem please'.
    objects([object(coke,0.2,2,0.55,4,5,6,7,8)]).

