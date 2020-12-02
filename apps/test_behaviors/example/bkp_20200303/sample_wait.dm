% Second Dialogue Model
diag_mod(sample_wait,
 % Second argument: List of Situations
 [
     % First situation
     [id ==> is,
      type ==> speech,
      in_arg ==> In_Arg,
      out_arg ==> Out_Arg,
      arcs ==>
	   [
	    In_Arg:[inc(g_count_fs1, Out_Arg)] => fs1,
	    loop:[inc(g_count_fs2, Out_Arg)] => fs2
	   ]
     ],

     % Final Situation 1
     [id ==> fs1, type ==> final],

     % Final Situation 2
     [id ==> fs2, type ==> final]
 ],
 % End List of Situations
 % Third argument: local variables (empty)
 [ ]
). % End DM (wait)
