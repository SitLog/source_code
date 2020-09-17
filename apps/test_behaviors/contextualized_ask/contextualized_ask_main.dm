%   Ask Main Tester Dialogue Model
%
% 	Description: This is a tester program for ask_contextualizated behavior, the objetive is create a environment to have the oportunity to test three levels of ask.
%	
%	Arguments   Mode: 	1- This mode is for test ask_contextualized DM in regular mode
%			            2- This mode is for test ask_contextualized DM in callforatention mode
%                       3- This mode is for test ask_contextualized DM in contextualized mode
%			
%
%  	
%			


diag_mod(contextualized_ask_main, %(Mode, Status), 
	    
%First argument: list of situations
[

[
		 id ==> is,
		 type ==> neutral,
		 arcs ==> [
	              empty : empty => ask_test, %(Mode)
		 	      ]
	],
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TESTER REGULAR MODE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[
		 id ==> ask_test,%(reg),
		 type ==> neutral,
		 arcs ==> [
	              empty : [say('Please right in front of me')] => ask1
		 	      ]
	],

	[
		id ==> ask1,
		type ==> recursive,
		embedded_dm ==> contextualized_ask('Please, say a name',human,true,2,regular,Res,Status),    %%%%%%%Aquí puede que sea regular%%%%%%%%%%%
		arcs ==> [
				success : [say ('Thanks for your help')] => success,
				error : empty => error %%ask_test(1)

	]
	],


	%Final Situation
	
		[
		id ==> success,
		type ==> final,
        %in_arg ==> [Hypothesys],
	%	diag_mod ==> contextualized_ask_main(_, ok)
	],

	[
		id ==> error,
		type ==> final
	]		                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%¿Lleva una coma ahí?%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5	

], % End situation list

% List of Local Variables
[
]

). % End listen

