% Relieve Task Dialogue Model
%
% 	Description	The robot relieves an object to a person or put it on a place
%	
%	Arguments	Hand: label of arm which will relieve and object, and could be 'left' or 'right'
%
%                       Tilt: a list of tilt positions that are used to find the plane where the object is going to be put 
%				
%			Status:	
%				ok .- if the object was correctly relieved
%				not_relieved .- the object could not be relieved

diag_mod(release_plane(Hand, Tilt, Status),
[
   [
   id ==> is,
   type ==> neutral,
   arcs ==> [
             empty : [tilth(0.0), set(last_scan,0.0)] => tilt_mv(Tilt)
            ]
   ],
   
   [
   id ==> tilt_mv([]),
   type ==> neutral,
   arcs ==> [ 
             empty:[say('No plane found. Releasing object from current position')] 
                   => releasing 
            ]
   ],
   
   [
   id ==> tilt_mv([H|T]),
   type ==> neutral,
   arcs ==> [
             empty : [tiltv(H), set(last_tilt,H)] => detect_plane(T)
            ]
   ],
   
   [
   id ==> detect_plane(T),
   type ==> recursive,
   embedded_dm ==> plane_detection(Plane, kinect, _),
   arcs ==> [
             success : empty => compute_height(Plane),
             error   : empty => tilt_mv(T)
            ]
   ],
   
   [
   id ==> compute_height([plane(_,Y,_,_)|_]),
   type ==> neutral,
   arcs ==> [
            empty : [get(last_height, H),
                     TmpH is H-Y,
                     New_Height is TmpH+0.70,
                     robotheight(New_Height), 
                     set(last_height, New_Height)
                    ] => releasing
            ]
   ],
   
   [
   id ==> releasing,
   type ==> neutral,
   arcs ==> [		
             empty:[switcharm( apply(get_number_of_arm(A), [Hand]) ), 
                    offer,
                    close_grip,
                    apply(reset_hand(H), [Hand])
                   ] => success
            ]
   ],

   [
   id ==> success,
   type ==> final,
   diag_mod ==> release_plane(_, _, ok)
   ],

   [
   id ==> error,
   type ==> final,
   diag_mod ==> release_plane(_, _, not_relieved)
   ]	     

], 

% List of Local Variables
[
my_height ==> 0
]

). 
