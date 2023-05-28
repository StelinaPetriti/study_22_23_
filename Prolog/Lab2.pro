implement main
    open core, file, stdio

domains
    genre = scifi; drama; thriller; animation; action.

class facts - file1
    cinema : (integer Nr, string Name, string Addr, integer Tel, integer Seat).
    movie : (integer Nr1, string Title, integer Year, string Direc, genre Genre).
    show : (integer Show, integer Mov, string Date, string Clock, integer Rev).

%Кинотеатр, показывающий определенный фильм.
class predicates
    showing_movie : (string Name [out], string Title [out]) nondeterm.
clauses
    showing_movie(Name, Title) :-
        cinema(Nr, Name, _, _, _),
        show(Nr, Mov, _, _, _),
        movie(Mov, Title, _, _, _).

%Правило 2: Адрес кинотеатра, в котором демонстрируется фильм определенного жанра
class predicates
    cinema_address_by_genre : (string Address [out], genre Genres [out]) nondeterm.
clauses
    cinema_address_by_genre(Address, Genres) :-
        show(CinemaID, MovieID, _, _, _),
        movie(MovieID, _, _, _, Genres),
        cinema(CinemaID, _, Address, _, _).

%Правило 3: оФильмы, снятые определенным режиссером
class predicates
    movies_by_director : (string Title [out], string Direc [out]) nondeterm.
clauses
    movies_by_director(Title, Direc) :-
        movie(_, Title, _, Direc, _).

class predicates
    printCinemas : ().
    increaseCinema : (integer H).

class predicates
    printRevenues : ().
    increaseRevenue : (integer D).

clauses
    printCinemas() :-
        cinema(_, Name, _, _, Seat),
        write(Name, Seat),
        nl,
        fail.
    printCinemas() :-
        write("Название кинотеатров и их места\n\n").

clauses
    printRevenues() :-
        show(_, Mov, _, _, Rev),
        movie(Mov, Title, _, _, _),
        write(Title, " доход составляет $\t", Rev),
        nl,
        fail.
    printRevenues() :-
        write("Фильмы и их выручка от каждого показа\n\n").

class facts
    stats : (integer Count, integer Sum) single.

clauses
    stats(0, 0).

class facts
    stats1 : (integer Count1, integer Sum1) single.

clauses
    stats1(0, 0).

class predicates
    writeCinemaStats : ().

class predicates
    writeRevenueStats : ().
clauses
    writeCinemaStats() :-
        assert(stats(0, 0)),
        cinema(_, _Name, _, _, Seat),
        stats(Count, Sum),
        assert(stats(Count + 1, Sum + Seat)),
        fail.
    writeCinemaStats() :-
        stats(Count, Sum),
        writef("Количество кинотеатров: %\nСумма мест: %\n", Count, Sum).

clauses
    writeRevenueStats() :-
        assert(stats1(0, 0)),
        show(_, _, _, _, Rev),
        stats1(Count1, Sum1),
        %min(Min, Seat, NewMin),
        %max(Max, Seat, NewMax),
        assert(stats1(Count1 + 1, Sum1 + Rev)),
        fail.
    writeRevenueStats() :-
        stats1(Count1, Sum1),
        writef("Сумма выручки: %\nСреднее значение выручки: %\n", Sum1, Sum1 / Count1).

clauses
    increaseCinema(H) :-
        retract(cinema(Nr, Name, Adr, Tel, Seat)),
        asserta(cinema(Nr, Name, Adr, Tel, Seat + H)),
        fail.
    increaseCinema(_).

clauses
    increaseRevenue(D) :-
        retract(show(Show, Mov, Date, Clock, Rev)),
        asserta(show(Show, Mov, Date, Clock, Rev + D)),
        fail.
    increaseRevenue(_).

class predicates
    reconsult : (string FileName).
clauses
    reconsult(FileName) :-
        retractFactDB(file1),
        consult(FileName, file1).

clauses
    run() :-
        console::init(),
        reconsult("..\\file1.txt"),
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
        printCinemas(),
        printRevenues(),
        writeCinemaStats(),
        writeRevenueStats(),
        X = stdio::readLine(),
        increaseCinema(toTerm(X)),
        Y = stdio::readline(),
        increaseRevenue(toTerm(Y)),
        printCinemas(),
        writeCinemaStats(),
        printRevenues(),
        writeRevenueStats().

end implement main

goal
    console::runUtf8(main::run).
