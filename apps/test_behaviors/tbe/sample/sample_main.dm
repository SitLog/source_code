% Main Dialogue Model
diag_mod(sample_main,
 %Second argument: List of Situations
 [
     % Initial situation
     [id ==> is,
      type ==> speech,
      % Situation’s arguments
      in_arg ==> In_Arg,
      out_arg ==> Out_Arg,
      % Local program
      prog ==> [inc(count_init,Count_Init)],
      % Situation’s content
      arcs ==>
	   [ % Examples of Grounded forms
	       finish:txt('Good Bye') => fs,
	       % Example of predicate input and output
	       [day(X)]:[date(get(day,Y)), next_date(set(day,X))] => is,
               % Example of functional specification of
	       % expectation, action and next situation
	       [Out_Arg,apply(f(X),[In_Arg])]: [screen(Out_Arg),screen(In_Arg),apply(g(X),[_])] => apply(h(X,Y),[In_Arg,Out_Arg])
	   ]
     ],
     
     % Second Situation
     [id ==> rs,
      type ==> recursive,
      prog ==> [inc(count_rec, Count_Rec)],
      embedded_dm ==> sample_wait,
      arcs ==>
	   [
	    fs1:txt('Back to initial sit') => is,
	    fs2:txt('Cont. recursive sit') => rs
	   ]
     ],

     % Final Situation
     [id ==> fs, type ==> final]
 % End list of siuations
 ],
 
 % Third Argument: List of Local Variables
[day ==> monday, count_init ==> 0, count_rec ==> 0]
). %End DM (main)

