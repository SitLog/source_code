initial_position ==> origen.
time ==> 0.
last_scan ==> 0.
last_tilt ==> -30.0.
last_height ==> 1.40.
right_arm ==> free.
left_arm ==> free.
find_currpos ==> _.
%%
%% Error counters
gpsr_error ==> 0.
deliver_nav_error ==> 0.
find_empty_scn_error ==> 0.
find_nav_error ==> 0.
find_not_fnd_error ==> 0.
find_not_fnd_prsn_error ==> 0.
find_lost_user_error ==> 0.
mv_error ==> 0.
question_error ==> 0.
say_error ==> 0.
tk_empty_scn_error ==> 0.
tk_nav_error ==> 0.
tk_not_fnd_error ==> 0.
tk_not_grasped_error ==> 0.
follow_error ==> 0.
%% Ends Error counters
%%
%% Variables to keep track of turning degrees while
%% searching the table in the storing groceries task
angle_storing_groceries ==> 0.
neg_angle_storing_groceries ==> 0.
flag_angle_storing_groceries ==> false.
angle_operation ==> addition.
%%
%% This flag becomes a positive figure when Golem turns
%% left when approaching an object. Otherwise, it becomes negative
turn_flag_approach ==> 0.0.
%%
%% Recognition mode
%% Variable to set what is used: whether MOPED, the tabletop object detector or both
object_recognition_mode ==> moped.
%%
%% Set to true if the recognition is done when approaching an specific object
approaching ==> false.    
%%
%%
%% New demo papaer global variables
g_count_fs1 ==> 0.
g_count_fs2 ==> 0.
