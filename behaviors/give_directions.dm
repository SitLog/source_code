diag_mod(give_directions(GoalPlace,InitPlace,Status),
        [

                [
                        id ==> is,
                        type ==> neutral,
                        out_arg ==> [ok],
                        arcs ==> [
                                        empty : [apply(initialize_KB_whereis,[])] => give_dir( apply(whereis_get_room(_G),[GoalPlace]), apply(whereis_get_fine_directions(_G),[GoalPlace]), apply(whereis_get_directions_from(_Object,_From),[GoalPlace,InitPlace]) )
                                ]
                ],

		[
                        id ==> give_dir(Room,Fine,Dir),
                        type ==> neutral,
                        %out_arg ==> [ok],
                        arcs ==> [
                                        empty : [ say(['In the',Room,Fine]), say(Dir)  ] => success
                                ]
                ],

                  % Final Situations
                [
                        id ==> success,
                        type ==> final,
                        in_arg ==> [StatusFollow],
                        diag_mod ==> give_directions(_,_,StatusFollow)
                ],

                [
                        id ==> error,
                        type ==> final,
                        in_arg ==> [StatusFollow],
                        diag_mod ==> give_directions(_,_,StatusFollow)
                ]



        ],



        []
).

