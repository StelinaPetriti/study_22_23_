implement main
    open core, file, stdio

domains
    genre = scifi; drama; thriller; animation; action.

class facts - company
    cinema : (integer Nr, string Name, string Addr, integer Tel, integer Seat).
    movie : (integer Nr1, string Title, integer Year, string Direc, genre Genre).
    show : (integer Show, integer Mov, string Date, string Clock, integer Rev).

class predicates
    showing_movie : (string Name [out], string Title [out]) nondeterm.
clauses
    showing_movie(Name, Title) :-
        cinema(Nr, Name, _, _, _),
        show(Nr, Mov, _, _, _),
        movie(Mov, Title, _, _, _).

class predicates
    cinema_address_by_genre : (string Address [out], genre Genres [out]) nondeterm.
clauses
    cinema_address_by_genre(Address, Genres) :-
        show(CinemaID, MovieID, _, _, _),
        movie(MovieID, _, _, _, Genres),
        cinema(CinemaID, _, Address, _, _).

class predicates
    movies_by_director : (string Title [out], string Direc [out]) nondeterm.
clauses
    movies_by_director(Title, Direc) :-
        movie(_, Title, _, Direc, _).

class predicates
    length : (A*) -> integer N.
    sum : (real* List) -> real Sum.
    laverage : (real* List) -> real Average determ.
    max : (real* List, real Max [out]) nondeterm.
    min : (real* List, real Min [out]) nondeterm.

clauses
    length([]) = 0.
    length([_ | T]) = length(T) + 1.
    sum([]) = 0.
    sum([B | T]) = sum(T) + B.

    laverage(L) = sum(L) / length(L) :-
        length(L) > 0.
    max([Max], Max).

    max([A1, A2 | T], Max) :-
        A1 >= A2,
        max([A1 | T], Max).

    max([A1, A2 | T], Max) :-
        A1 <= A2,
        max([A2 | T], Max).
    min([Min], Min).

    min([A1, A2 | T], Min) :-
        A1 <= A2,
        min([A1 | T], Min).

    min([A1, A2 | T], Min) :-
        A1 >= A2,
        min([A2 | T], Min).

class predicates
    list : (main::company*) nondeterm.
    v_cinema : (string Cinemas) -> main::company* VMovie nondeterm.
    sumrevenue : () -> real Sum.
    maxrevenue : () -> real Max determ.
    minrevenue : () -> real Min determ.

clauses
    v_cinema(Cinemas) = VCinema :-
        show(Idcin, Nr1, _, _, _),
        movie(Nr1, _, _, _, _),
        VCinema = [ cinema(Idcin, Name, Addr, Tel, Seat) || cinema(Idcin, Name, Addr, Tel, Seat) ].
    list([X | Y]) :-
        write(X),
        nl,
        list(Y).

    sumrevenue() = Sum :-
        Sum = sum([ Reve || show(_, _, _, _, Reve) ]).

    maxrevenue() = Res :-
        max([ Reve || show(_, _, _, _, Reve) ], Max),
        Res = Max,
        !.
    minrevenue() = Res :-
        min([ Reve || show(_, _, _, _, Reve) ], Min),
        Res = Min,
        !.

    run() :-
        file::consult("../file4.txt", company),
        fail.
    run() :-
        write("\nКинотеатр, показывающий определенный фильм\n"),
        showing_movie(Name, Title),
        write(Name),
        write(" is showing "),
        write(Title, "\n"),
        fail.
    run() :-
        write("\nAдрес кинотеатра, в котором демонстрируется фильм определенного жанра\n"),
        cinema_address_by_genre(Address, Genres),
        write(Address),
        write(" = "),
        write(Genres, "\n"),
        fail.
    run() :-
        write("\nФильмы, снятые определенным режиссером\n"),
        movies_by_director(Title, Direc),
        write(Title),
        write(" - "),
        write(Direc, "\n"),
        fail.
    run() :-
        write("\n"),
        List = v_cinema("Cinemas"),
        list(List),
        nl,
        fail.
    run() :-
        write("\nSum of revenue:", sumrevenue()),
        nl,
        write("Maximum revenue:", maxrevenue()),
        nl,
        write("Minimum revenue:", minrevenue()),
        nl,
        fail.
    run() :-
        succeed.

end implement main

goal
    console::run(main::run).
