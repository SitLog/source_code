% Gender Task Dialogue Model
%
% 	Description	The robot recognizes the gender of a person 
%	
%	Arguments	G: The gender of the person Golem is seeing
%				
%			St:	
%				    ok .- if the gender was recognized
%			       	    failure .- otherwise

diag_mod(gender(G, St),
[

   [
   id ==> is,
   type ==> neutral,
   arcs ==> [
            empty : [say(['I will recognize your gender ','Stay still'])] => take_photo_of_crowd
            ]
   ],
   
   [  
   id ==> take_photo_of_crowd,
   type ==> recursive,
   embedded_dm ==> memorize_body(nearest,10,james,Body_Positions,_),
   arcs ==> [
            success : [say('I saw you')] => analyzing_crowd,
            error : [say('I did not see you '),say('I will continue with the task')] => error				
            ]
   ],
    
   [
   id ==> analyzing_crowd,
   type ==> analyzing_crowd(1),
   arcs ==> [
            detected(X) : [say('Bear with me I am still working')] => crowd_description	  	
            ]
   ],
    
   [
   id ==> crowd_description,
   type ==> detect_crowd(1),
   arcs ==> [
            detected(crowd(A,B,_)): [apply( when(If,True,False),[A>0, say('Got it'), say('I could not detect your gender')] )] 
                                  => apply( when(If,True,False),[A>0, man_woman(B), error] )
            ]
   ],

   [
   id ==> man_woman(Val),	
   type ==> neutral, 
   arcs ==> [
            empty : empty => apply( when(If,True,False),[Val>0, man, woman] )
	    ]
   ],

   [
   id ==> man,	
   type ==> neutral, 
   out_arg ==> [male],
   arcs ==> [
            empty : empty => success
            ]
   ],
   
   [
   id ==> woman,	
   type ==> neutral, 
   out_arg ==> [female],
   arcs ==> [
            empty : empty => success
            ]
   ],

   [
   id ==> success,
   type ==> final,
   in_arg ==> [Gender],
   diag_mod ==> gender(Gender, ok) 
   ],
	
   [
   id ==> error,
   type ==> final,
   diag_mod ==> gender(unknown, failure)
   ]

],

  % Second argument: list of local variables
  [
  ]

).
