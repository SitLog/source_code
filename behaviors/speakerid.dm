% DOAs Dialogue Model
%
% 	Description	Identify speaker by voice
%
%	Arguments	Speaker:
%				[] .- if unknown
%				<anything else> .- speaker name
%	
%			    Confidence:	
%				low .- low confidence
%				mid .- unsure but probable
%				high .- high confidence
%
%			    Status:	
%				ok .- heard something
%				error .- did not hear anything

diag_mod(speakerid(Speaker, Confidence, Status),
[
    [  
        id ==> is,
        type ==> speakerid,
        arcs ==> [
            speaker([Name,Conf]) : empty => next(Name,Conf)
        ]
    ],
    [
        id ==> next(nothing,_),	
        type ==> neutral,
        arcs ==> [
            empty : empty => error
        ]
    ],
    [
        id ==> next(Name,Conf),	
        type ==> neutral,
        out_arg ==> [Name,Conf],
        arcs ==> [
            empty : empty => success
        ]
    ],
    % Final Situations
    [
        id ==> success,
        type ==> final,
        in_arg ==> [Name,Conf],
        diag_mod ==> speakerid(Name,Conf,ok)
    ],
    [
        id ==> error,
        type ==> final,
        diag_mod ==> speakerid([],[],error)
    ]
],
% Second argument: list of local variables
[]
).


