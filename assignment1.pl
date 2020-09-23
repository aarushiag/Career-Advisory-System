/*-----------------------------------------------CAREER ADVISORY SYSTEM ------------------------------------------------------------*/

:- discontiguous career/1.
:- discontiguous career/2.

/*=================================================== MAIN PROGRAM ================================================================*/

advise_career(Branch, CGPA) :- retractall(interest(_,_)), retractall(grade(_,_)), retractall(branch(_)), retractall(cgpa(_)), retractall(recommended(_)), 
assert(branch(Branch)), assert(cgpa(CGPA)), initial_review_test, suggest_career.

initial_review_test :- write('\nPlease give the following review test :-'), nl, ask_interest('Ability to communicate'), ask_interest('Presentation skills'),
ask_interest('Knowledge of core subjects'),ask_interest('Critical Thinking and Problem Solving'), ask_interest('Desire to Learn'), 
ask_interest('Teamwork'), ask_interest('Attention to details'), ask_interest('Creativity'), ask_interest('Efficient in Time Management').

suggest_career :- nl,write('\nWelcome to the career advisory system ! \n
Choose a preference from below :- \n 1. Want to study further \n 2. Want to do something on your own?\n 3. Want to serve nation?\n 4. Have a side passion?\n 5. Prefer corporate culture?\n 6. Show final suggestions?'),
nl,(read(Y), nl, ((Y =:= 1 -> (category(higher_studies))); (Y =:= 2 -> career(start_up)) ; (Y =:= 3 -> career(government_job))
; (Y =:= 4 -> career(arts)) ; (Y =:= 5 -> category(corporate)) ; (Y =:= 6 -> final_suggestion) ; write('Please choose the correct option \n'),suggest_career)).

final_suggestion :- nl, convert_to_list(List), remove_duplicates(List, Final_List),
write('The list of suggested career choices along with their priority suited for you are :- \n'), write(Final_List).

convert_to_list([Career|Tail]):- retract(recommended(Career)), convert_to_list(Tail).
convert_to_list([]).

remove_duplicates([], []).
remove_duplicates([Head | Tail], Result) :- member(Head, Tail), remove_duplicates(Tail,Result), !.
remove_duplicates([Head | Tail], [Head | Result]) :- remove_duplicates(Tail, Result), !.

ask_interest(Topic):- write('\nEnter your level of expertise for :- '), write(Topic), nl, nl,
write('0 - Absent\n1 - Low Expertise\n2 - Medium Expertise\n3 - High Expertise\n'), nl, read(Level), assert(interest(Topic, Level)).

ask_grade(Course):- write('\nEnter your grade (on a scale of 10) in the course :- '), write(Course), nl, 
					write('NOTE :- Enter 0 if the course is not done'), nl,
					read(Grade), assert(grade(Course, Grade)).
					
check_interest_threshold(Interest, Threshold) :- interest(Interest, Level), Level >= Threshold. 
check_grade_threshold([], _Threshold) :- fail.  
check_grade_threshold([H|T], Threshold) :- ((grade(H, Grade), Grade >= Threshold) ; check_grade_threshold(T, Threshold)),!.

insert(X, L, [X|L]).
 
/*------------------------------------------------ CORPORATE ------------------------------------------------------------*/



suggestCSE :- write('Choose a preference from below :- \n
1. Worked with analyzing large amount of data and extracting hidden patterns.
2. Primarily involved with programming and coding.
3. Interested in technologies related to system security.\n'), nl, (read(D), nl, ((D = 1 -> (career(big_data_eng);career(dataScientist)));
(D = 2 -> (career(sde);career(full))); (D = 3 -> career(blockchain)))).

suggestCSAM :- write('Choose a preference from below :- \n
1. Worked with analyzing large amount of data and extracting hidden patterns.
2. Primarily involved with programming and coding.
3. Interested in technologies related to system security.\n'), nl, (read(D), nl, ((D = 1 -> (career(big_data_eng);career(dataScientist);career(data_analyst)));
(D = 2 -> (career(sde);career(full))); (D = 3 -> career(blockchain)))).

suggestECE.

career(chip_designer).
career(vlsi).
career(mobile_communications).

career(data_analyst) :- write('Do you have experience with languages like R or Python Statistical Programming?'), nl, read(S), nl, S=y,
write('Have you done courses like Finance, Micro/Macro courses, Probability and Statistics, ML etc?'), nl, read(B), nl, B=y, 
write('Do you have skills like critical thinking and presentation skills?'), nl, read(A), nl, A=y, 
explanation(data_analyst),nl, assertz(recommended('Data Analyst')),fail.

career(big_data_eng) :- write('Do you have experience with technologies like SQL based databases, ETL Tools, Hadoop etc?'), nl, read(S), nl, S=y,
write('Have you done courses like DBMS, Big Data Mining, Data Warehousing,?'), nl, read(B), nl, B=y, explanation(big_data_eng),nl, 
assertz(recommended('Big Data Engineer')),fail.

career(dataScientist) :- write('Do you have skils like critical thinking, Risk Analysis and Problem Solving Ability?'), nl, read(S), nl, S=y,
write('Have you done courses like Probability and Statistics, ML, NLP, AI, CV, IA, Data Science, Deep Learning?'), nl, read(B), nl, B=y, 
explanation(dataScientist),nl, assertz(recommended('Data Scientist')),fail.

career(full) :- write('Do you have experience with languages and frameworks like HTML, CSS, NodeJS, Angular Js, Bootstrap, Django etc.?'), nl, read(S), nl, S=y,
write('Do you have technical know how of client side components, server side languages, web application frameworks and database management systems?'), nl, read(A), nl, A=y, 
write('Are you familiar with principles of basic prototype design and UI-UX design?'), nl, read(B), nl, B=y, explanation(full),nl, 
assertz(recommended('Full Stack Developer')),fail.

career(sde) :- write('Do you have experience with languages like C, C++, Java, Python Ruby, Perl etc?'), nl, read(S), nl, S=y,
write('Do you have skills like technical creativity and analytical thinking for solving day to day problems?'), nl, read(A), nl, A=y, 
write('Are aware of different processes involved in development of softwares?'), nl, read(B), nl, B=y, explanation(sde),nl, assertz(recommended('Software Developer')),fail.

career(blockchain) :- write('Do you have experience with languages like Simplicity, C++, Solidity, Rholang, Javascript etc?'), nl, read(S), nl, S=y,
write('Are you aware of technologies like Bitcoin?'), nl, read(A), nl, A=y, 
write('Have you done courses like Probability and Statistics, Discrete Mathematics, Cryptography, Bitcoin etc?'), nl, read(B), nl, B=y, explanation(blockchain)
,nl, assertz(recommended('Blockchain Developer')),fail.

category(corporate) :- (branch(B),(B = cse -> (suggestCSE) ; B = ece -> (suggestECE) ; B = csam -> (suggestCSAM); 
(write('Please mention a valid branch\n'),category(corporate))),suggest_career);suggest_career.


/*---------------------------------------------HIGHER STUDIES------------------------------------------------------------*/
category(higher_studies) :- (write('Can you study for long hours?'), nl, read(L), nl, L=y, 
write('Do you want to do specialization in core subjects?'), nl, read(Y), nl, 
(Y=y -> ask_location_pref ; Y=n -> career(mba,higher_studies) ; write('Please choose the correct option \n'),category(higher_studies)));suggest_career.

ask_location_pref :- (write('Choose a preference from below :- \n 1. Want to study abroad? \n 2. Want to stay in India? \n 3. Fine with both ?'),nl,
(read(P), nl, ((P = 1 -> career(masters,higher_studies)) ; (P = 2 -> career(mtech,higher_studies)) ; (P = 3 -> (career(masters,higher_studies),
career(mtech,higher_studies))); write('Please choose the correct option \n'), ask_location_pref))).

/*---------------------- MTECH ---------------------------------*/
career(mtech,higher_studies) :-  write('Do you like research?'), nl, read(R), nl, R=y, 
check_interest_threshold('Knowledge of core subjects',3),
check_interest_threshold('Teamwork',2),
check_interest_threshold('Critical Thinking and Problem Solving',2),
check_interest_threshold('Desire to Learn',2),
write('Have you worked on a research problem (in BTP/Course Projects)?'), nl,read(G), nl, G=y,
cgpa(Grade), Grade >= 7, explanation(mtech),nl, assertz(recommended('mtech')), fail.

/*---------------------- MASTERS ---------------------------------*/
career(masters,higher_studies) :-  write('Do you have an economic background?'), nl, read(E), nl, E=y,
write('Do you like research?'), nl, read(R), nl, R=y, 
check_interest_threshold('Teamwork',2),
check_interest_threshold('Critical Thinking and Problem Solving',2),
check_interest_threshold('Desire to Learn',2),
write('Have you worked on a research problem (in BTP/Course Projects)?'), nl,read(G), nl, G=y,
cgpa(Grade), Grade >= 7, explanation(masters),nl, assertz(recommended('masters')), fail.

/*---------------------- MBA ---------------------------------*/
career(mba,higher_studies) :- write('Are you good in extra curicular activities?'), nl,read(R), nl, R=y, 
check_interest_threshold('Ability to communicate',3), check_interest_threshold('Presentation skills',2), check_interest_threshold('Critical Thinking and Problem Solving',2),
write('Have you managed events at esya or odessey?'), nl,read(M), nl, M=y, 
write('Do you prefer being a leader in group projects?'), nl,read(P), nl, P=y, 
ask_grade(eiitm), ask_grade(escm),ask_grade(hiee), ask_grade(ek), ask_grade(eComm), check_grade_threshold([eiitm, escm, hiee, ek, eComm],9),
explanation(mba),nl, assertz(recommended('mba')), fail. 

/*------------------------------------------------- START UP----------------------------------------------------------------*/
career(start_up) :- (write('Do you have a new development idea?'), nl,read(D), nl, D=y, 
write('Do you have money to invest?'), nl,read(M), nl, M=y, 
write('Are you willing to take monetary risk in life?'), nl,read(R), nl, R=y, 
check_interest_threshold('Ability to communicate',3), check_interest_threshold('Presentation skills',2), check_interest_threshold('Teamwork',3),check_interest_threshold('Efficient in Time Management',2),
ask_grade(eiitm), ask_grade(escm),ask_grade(hiee), ask_grade(ek), ask_grade(eComm), check_grade_threshold([eiitm, escm, hiee, ek, eComm],9),
explanation(start-up),nl, assertz(recommended('Entrepreneurship(start-up)')),
suggest_career); suggest_career.

/*----------------------------------------------- GOVERNMENT JOB -----------------------------------------------------------*/
career(government_job) :- (write('Choose a preference from below :- \n 1. Power matters more than money?\n 2. Want a good work life balance'), nl, read(Y), nl, 
(Y=1 -> career(navyOrCivil), suggest_career ; Y=2 -> career(psu) ; write('Please choose the correct option \n'),career(government_job)));suggest_career.

career(navyOrCivil):- X = 0, Y = 0, write('Do you have high physically and mentally standards?'), nl,(read(F), nl, (F=y -> X1 is X+1 ; X1 is X)),
write('Do you have high score in UPSC Exam?'), nl,(read(U), nl, (U=y -> Y1 is Y+1 ; Y1 is Y)), 
write('Do you have high score in NDA/AFCAT Exam?'), nl,(read(N), nl, (N=y -> X2 is X1+1 ; X2 is X1)), 
write('Are you willing to relocate in remote areas flexibly?'), nl,(read(R), nl, (R=y -> Y2 is Y1+1 ; Y2 is Y1)), 
write('Have you done more than 12 HSS credits?'), nl,(read(H), nl, (H=y -> Y3 is Y2+1 ; Y3 is Y2)), 
write('Are you ready to live without family?'), nl,(read(W), nl, (W=y -> X3 is X2+1 ; X3 is X2)), 
((X3 > Y3, explanation(navy), nl, assertz(recommended('IAF'))) 
; (X3 < Y3, explanation(civil),nl, 
assertz(recommended('Civil Services'))); (X3 = Y3 , X3 =\= 0, explanation(navyAndCivil),nl, assertz(recommended('IAF')),
assertz(recommended('Civil Services')))).

career(psu) :- (write('Are you concerned about job security?'), nl,read(J), nl, J=y, write('Do you need a steady source of income?'), nl,read(I), nl, I=y, 
write('Do you have a good score in GATE?'), nl,read(G), nl, G=y, explanation(psu),nl, assertz(recommended('Pubilc Services Undertaking')),
suggest_career); suggest_career.

/*---------------------------------------------------- ARTS ---------------------------------------------------------------*/

career(arts) :- (write('Are you willing to take risk?'), nl,read(R), nl, R=y , 
write('Do you have proficiency in Photography/Dance/Music/Writing?'), nl,read(H), nl, H=y ,
(write('Have you taken part in events related to your hobbies during college?'), nl,read(E), nl, E=y ;
write('Do you participate in competitions like reality shows or on Youtube?'), nl,read(Y), nl, Y=y),
explanation(arts),nl, assertz(recommended('Artist')),
suggest_career);suggest_career.

/*------------------------------------------------ EXPLANATION -----------------------------------------------------------*/

explanation(masters) :- write('------------------------------------------------------------------------
The suggested career for you is masters.\n
Explanation - You are an efficient Team player, critical thinker and have a keen desire to learn. You have also find some novel solutions to problems. Start preparing for TOEFL and GRE exam.
------------------------------------------------------------------------').

explanation(mtech) :- write('------------------------------------------------------------------------
The suggested career for you is mtech \n
Explanation - You are proficient in Core subjects. You are an efficient Team player, critical thinker and have a keen desire to learn. You have also find some novel solutions to problems. Start preparing for GATE exam.
------------------------------------------------------------------------').

explanation(mba) :- write('------------------------------------------------------------------------
The suggested career for you is mba.\n
Explanation - You have good presentation and communication skills and are good at managing public groups events. You are a critical thinker. Start preparing for CAT exam.
------------------------------------------------------------------------').

explanation(start-up) :- write('------------------------------------------------------------------------
The suggested career for you is Entrepreneurship(start-up).
Explanation - You are a good team player, can think critically and have good management skills.Hence, you can start a new venture. 
------------------------------------------------------------------------').

explanation(navy) :- write('---------------------------------------- \n 
The suggested career for you is Indian Armed Forces\n----------------------------------------').

explanation(civil) :- write('---------------------------------------- \n 
The suggested career for you is Civil Services\n----------------------------------------').

explanation(navyAndCivil) :- write('---------------------------------------- \n 
The suggested careers for you are Indian Armed Forces and Civil Services\n----------------------------------------').

explanation(psu) :- write('---------------------------------------- \n 
The suggested career for you is Pubilc Services Undertaking\n----------------------------------------').

explanation(arts) :- write('---------------------------------------- \n 
The suggested career for you is Artist\n----------------------------------------').

explanation(data_analyst) :- write('----------------------------------------------------- 
The suggested career for you is Data Analyst\n-----------------------------------------------------\n').

explanation(big_data_eng) :- write('----------------------------------------------------- \n
The suggested career for you is Big Data Engineer\n-----------------------------------------------------\n').

explanation(dataScientist) :- write('----------------------------------------------------- \n
The suggested career for you is Data Scientist\n-----------------------------------------------------\n').

explanation(full) :- write('----------------------------------------------------- \n
The suggested career for you is Full Stack Developer\n-----------------------------------------------------\n').

explanation(sde) :- write('----------------------------------------------------- \n
The suggested career for you is Software Developer\n-----------------------------------------------------\n').

explanation(blockchain) :- write('----------------------------------------------------- \n
The suggested career for you is Blockchain Developer\n-----------------------------------------------------\n').

/*-----------------------------------------------( made by - Aarushi Agarwal (2016216)) ------------------------------------------------------------*/
