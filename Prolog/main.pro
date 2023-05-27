implement main
    open core, stdio

domains
    genre = scifi; drama; thriller; animation; action.

class facts
    cinema : (integer Nr, string Name, string Addr, integer Tel, integer Seat).
    movie : (integer Nr1, string Title, integer Year, string Direc, genre Genre).
    show : (integer Show, integer Mov, string Date, string Clock, integer Rev).

clauses
    cinema(1, 'Cineplex      ', 'Main St', 5551234, 200).
    cinema(2, 'Imeperial     ', 'Pedonale', 5554321, 150).
    cinema(3, 'Plaza         ', 'Ponce De Leon Ave', 5555431, 175).
    cinema(4, 'Agimi         ', 'Kinostudio', 5552351, 250).
    cinema(5, 'Tirana        ', 'Tek Bashkia', 5552451, 300).

    movie(1, 'Black Widow', 2021, 'Cate Shortland', scifi).
    movie(2, 'King Richard', 2021, 'Reinaldo Marcus Green', drama).
    movie(3, 'Scream', 2022, 'Tyler Gillett', thriller).
    movie(4, 'Moana', 2016, 'Ron Clements', animation).
    movie(5, 'Avengers endgame', 2019, 'Anthony Russo', thriller).

    show(1, 1, '2023-04-21', '18:00', 1700).
    show(2, 2, '2023-04-25', '20:00', 1100).
    show(3, 5, '2023-04-15', '19:00', 2200).
    show(4, 3, '2023-04-05', '21:00', 1000).
    show(5, 4, '2023-04-12', '18:00', 500).

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
        write(Title, "доход составляет $:\t", Rev),
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

clauses
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
