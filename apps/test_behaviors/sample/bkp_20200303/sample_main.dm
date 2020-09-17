% Main Dialogue Model
diag_mod(sample_main,
 %Second argument: List of Situations
 [
     % Initial situation
     [id ==> is,
      type ==> speech,
      % Situation’s arguments
      in_arg ==> In_Arg,
      out_arg ==> get(day,X), %apply(f(X),[In_Arg]),
      % Local program
      prog ==> [inc(count_init,Count_Init)],
      % Situation’s content
      arcs ==>
	   [ % Examples of Grounded forms
	       finish:screen('Good Bye') => fs,
	       % Example of predicate input and output
	       [day(X)]:[date(get(day,Y)), next_date(set(day,X)),assign(Out_Arg_Tmp,got_it)] => is,
               % Example of functional specification of
	       % expectation, action and next situation
	       [apply(f(X),[In_Arg])]: [assign(Out_Arg_Tmp,'pipe'), apply(g(X),[_])] => apply(h(X,Y),[In_Arg,Out_Arg])
	   ]
     ],
     
     % Second Situation
     [id ==> rs,
      type ==> recursive,
      prog ==> [inc(count_rec, Count_Rec)],
      embedded_dm ==> sample_wait,
      in_arg ==> In_Arg,
      arcs ==>
	   [
	    fs1:[screen(In_Arg),screen('Back to initial sit')] => is,
	    fs2:[screen(In_Arg),screen('Cont. recursive sit')] => rs
	   ]
     ],

     % Final Situation
     [id ==> fs, type ==> final]
 % End list of siuations
 ],
 
 % Third Argument: List of Local Variables
[day ==> monday, count_init ==> 0, count_rec ==> 0]
). %End DM (main)

