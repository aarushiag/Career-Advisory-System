/*-----------------------------------------------CAREER ADVISORY SYSTEM------------------------------------------------------------*/

/*---------------------------------------------HIGHER STUDIES------------------------------------------------------------*/
category(higher_studies) :- (write('Do you have an economic background?'), nl, read(E), nl, E=y,
write('Can you study for long hours?'), nl, read(L), nl, L=y, 
write('Do you want to do specialization?'), nl, read(Y), nl, 
(Y=y -> ask_location_pref ; Y=n -> career(mba,higher_studies) ; write('Please choose the correct option \n'),category(higher_studies)));suggest_career.

ask_location_pref :- (write('Choose a preference from below :- \n 1. Want to study abroad? \n 2. Want to stay in India? \n 3. Fine with both ?'),nl,
(read(P), nl, ((P = 1 -> career(masters,higher_studies)) ; (P = 2 -> career(mtech,higher_studies)) ; (P = 3 -> (career(masters,higher_studies),
career(mtech,higher_studies))); write('Please choose the correct option \n'), ask_location_pref))).

/*---------------------- MTECH ---------------------------------*/
career(mtech,higher_studies) :-  write('Do you like research?'), nl, read(R), nl, R=y, write('Good Score in GATE?'), nl,read(G), nl, G=y,
write('Type your CGPA on scale of 10'), nl,read(C), nl, C >= 8, write('---------------------------------------- \n
The suggested career for you is mtech \n----------------------------------------'),nl, assertz(recommended('mtech')), fail.


/*---------------------- MASTERS ---------------------------------*/
career(masters,higher_studies) :-  write('Do you like research?'), nl,read(R), nl, R=y, write('Good Score in GRE?'), read(G), nl, G=y,
write('Good Score in TOEFL?'), read(T), nl, T=y, write('Type your CGPA on scale of 10'), read(C), nl, C >= 8, 
write('---------------------------------------- \n
The suggested career for you is masters \n----------------------------------------'),nl, assertz(recommended('masters')), fail.


/*---------------------- MBA ---------------------------------*/
career(mba,higher_studies) :- write('Are you good in extra curicular activities?'), nl,read(R), nl, R=y, 
write('Have you managed events at esya or odessey?'), nl,read(M), nl, M=y, write('Do you prefer being a leader in group projects?'), 
nl,read(P), nl, P=y, write('Did you get a good score in CAT/GMAT?'), 
nl,read(S), nl, S=y,write('---------------------------------------- \n 
The suggested career for you is mba \n----------------------------------------'),nl, assertz(recommended('mba')), fail. 

/*---------------------- START UP-----------------------------*/
career(start_up) :- (write('Do you have a new development idea?'), nl,read(D), nl, D=y, write('Do you have money to invest?'), nl,read(M), nl, M=y, 
write('Are you willing to take monetary risk in life?'), nl,read(R), nl, R=y, write('---------------------------------------- \n 
The suggested career for you is Entrepreneurship(start-up)\n----------------------------------------'),nl, assertz(recommended('Entrepreneurship(start-up)')),
suggest_career); suggest_career.
/*---------------------- GOVERNMENT JOB --------------------*/
career(government_job) :- (write('Choose a preference from below :- \n 1. Power matters more than money?\n 2. Want a good work life balance'), nl, read(Y), nl, 
(Y=1 -> career(navyOrCivil), suggest_career ; Y=2 -> career(psu) ; write('Please choose the correct option \n'),career(government_job)));suggest_career.

career(navyOrCivil):- X = 0, Y = 0, write('Do you have high physically and mentally standards?'), nl,(read(F), nl, (F=y -> X1 is X+1 ; X1 is X)),
write('Do you have high score in UPSC Exam?'), nl,(read(U), nl, (U=y -> Y1 is Y+1 ; Y1 is Y)), 
write('Do you have high score in NDA/AFCAT Exam?'), nl,(read(N), nl, (N=y -> X2 is X1+1 ; X2 is X1)), 
write('Are you willing to relocate in remote areas flexibly?'), nl,(read(R), nl, (R=y -> Y2 is Y1+1 ; Y2 is Y1)), 
write('Have you done more than 12 HSS credits?'), nl,(read(H), nl, (H=y -> Y3 is Y2+1 ; Y3 is Y2)), 
write('Are you ready to live without family?'), nl,(read(W), nl, (W=y -> X3 is X2+1 ; X3 is X2)), 
((X3 > Y3, write('---------------------------------------- \n 
The suggested career for you is Indian Armed Forces\n----------------------------------------'), nl, assertz(recommended('IAF'))) ; (X3 < Y3, write('---------------------------------------- \n 
The suggested career for you is Civil Services\n----------------------------------------'),nl, assertz(recommended('Civil Services'))); (X3 = Y3 , X3 =\= 0, write('---------------------------------------- \n 
The suggested careers for you are Indian Armed Forces and Civil Services\n----------------------------------------'),nl, assertz(recommended('IAF')),
assertz(recommended('Civil Services')))).

career(psu) :- (write('Are you concerned about job security?'), nl,read(J), nl, J=y, write('Do you need a steady source of income?'), nl,read(I), nl, I=y, 
write('Do you have a good score in GATE?'), nl,read(G), nl, G=y, write('---------------------------------------- \n 
The suggested career for you is Pubilc Services Undertaking\n----------------------------------------'),nl, assertz(recommended('Pubilc Services Undertaking')),
suggest_career); suggest_career.

/*=================================================== MAIN PROGRAM ================================================================*/
suggest_career :- nl,write('Welcome to the career advisory system ! \n
Choose a preference from below :- \n 1. Want to study further \n 2. Want to do something on your own?\n 3. Want to serve nation?\n 4. Show final suggestions?'),
nl,(read(Y), nl, ((Y =:= 1 -> (category(higher_studies))); (Y =:= 2 -> career(start_up)) ; (Y =:= 3 -> career(government_job))
; (Y =:= 4 -> final_suggestion) ; write('Please choose the correct option \n'),suggest_career)).

final_suggestion :- nl, convert_to_list(List), remove_duplicates(List, Final_List), length(Final_List, Length), prioritize(Final_List, Final_PList, Length), 
write('The list of suggested career choices along with their priority suited for you are :- \n'), write(Final_PList).

convert_to_list([Career|Tail]):- retract(recommended(Career)), convert_to_list(Tail).
convert_to_list([]).

remove_duplicates([], []).
remove_duplicates([Head | Tail], Result) :- member(Head, Tail), remove_duplicates(Tail,Result), !.
remove_duplicates([Head | Tail], [Head | Result]) :- remove_duplicates(Tail, Result), !.

prioritize([], [], Total_length).
prioritize([H|T], [H1|Result], Total_length) :- prioritize(T, Result, Total_length), length(T, TailLength), X is Total_length - TailLength, H1 = (H , X).
