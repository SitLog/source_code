% Second Dialogue Model
diag_mod(example_wait,
 % Second argument: List of Situations
 [
     % First situation
     [id ==> is,
      type ==> speech,
      in_arg ==> In_Arg,
      arcs ==>
	   [
	    In_Arg:[inc(g_count_fs1, G1)] => fs1,
	    loop:[inc(g_count_fs2, G2)] => fs2
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
