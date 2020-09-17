diag_mod(plane_main,
[
    [
      id ==> is,	
      type ==> neutral,
      arcs ==> [
                  empty : [tilth(0.0), set(last_scan,0.0),
                           tiltv(-20.0), set(last_tilt,-20.0),
                           robotheight(1.20),
                           X is 0.3+0.71,
                           screen(X), 
                           Y is round(0.22999999999999998*100)/100,
                           screen(Y),
                           %caption(Y),
                           set(last_height,1.20)
                           ] => behavior
               ]
    ],
    
    [  
      id ==> behavior,
      type ==> recursive,
      %embedded_dm ==> plane_detection(P, moped, St),
      %embedded_dm ==> plane_detection(P, kinect, St),
      %embedded_dm ==> find_empty_scene_cat(object,food,[kitchencabinet,sink,bar,kitchentable],[0.0,-8.0,8.0],[-30.0,-5.0],category,[object(_G2503236,_G2503237,_G2503238,_G2503239,_G2503240,_G2503241,_G2503242,_G2503243,_G2503244)],_G3032785,false,false,false,[consult_kb(change_object_property,[golem,found,_G2154262],_G2154289,_G2154292),consult_kb(value_object_property,[golem,found],_G2154295,_G2154298),say(['Here is the' ,food, 'it is a' ,_G2154295],_G2154301)],_G3032704),
      embedded_dm ==> find_empty_scene(object,[X],[kitchencabinet,sink,bar,kitchentable],[0.0,-8.0,8.0],[-30.0,-5.0],object,[object(_G2503236,_G2503237,_G2503238,_G2503239,_G2503240,_G2503241,_G2503242,_G2503243,_G2503244)],_G3032785,false,false,false,[consult_kb(change_object_property,[golem,found,_G2154262],_G2154289,_G2154292),consult_kb(value_object_property,[golem,found],_G2154295,_G2154298),say(['Here is the' ,food, 'it is a' ,_G2154295],_G2154301)],_G3032704),
      arcs ==> [
       		      success : [say('Success I found a plane')%,
       		                 %get(last_tilt, LastTilt), 
       		                 %cam2nav([X,Y,Z],[LastTilt,0.1,-0.06], Polar_Coord)
       		                ] => fs, 
                      error   : [say('I could not detect any plane')] => fs
               ]
    ],
    
    [
      id ==> fs,
      type ==> final
    ]
    
],

  % Second argument: list of local variables
[
]

).	

