% Фактов о кинотеатрах
cinema(1, 'Cineplex', '123 Main St', '555-1234', 200).
cinema(2, 'Imeperial', 'Pedonale', '555-4321', 150).
cinema(3, 'Plaza Theatre', 'Ponce De Leon Ave', '555-5431', 175).

% Фактов о фильмах
movie(1, 'Black Widow', 2021, 'Cate Shortland', sci_fi).
movie(2, 'King Richard', 2021, 'Reinaldo Marcus Green', drama).
movie(3, 'Scream', 2022, 'Tyler Gillett', thriller).
movie(4, 'Moana', 2016, ' Ron Clements', animation).
movie(5, 'Avengers endgame', 2019, 'Anthony Russo', action).

% Факты о шоу.Первый - это id кинотеатра, второй - id фильма
show(1, 1, '2023-04-21', '18:00', 1700).
show(1, 2, '2023-04-25', '20:00', 1100).
show(2, 1, '2023-04-15', '19:00', 2200).
show(2, 3, '2023-04-05', '21:00', 1000).
show(3, 4, '2023-04-12', '18:30', 500).
show(3, 5, '2023-04-09', '20:30', 1800).

% Правило 1: Кинотеатр, в котором показывают определенный фильм
cinema_showing_movie(CinemaID, MovieID) :-
    show(CinemaID, MovieID, _, _, _).

%Правило 2: Адрес кинотеатра, в котором демонстрируется фильм определенного жанра
cinema_address_by_genre(CinemaID, Genre) :-
    show(CinemaID, MovieID, _, _, _),
    movie(MovieID, _, _, _, Genre),
    cinema(CinemaID, _, Address, _, _).

% Правило 3: Доход кинотеатра за определенный фильм
cinema_revenue_for_movie(CinemaID, MovieID, Revenue) :-
    show(CinemaID, MovieID, _, _, Revenue).
    
% Примеры доменов (жанр фильма)
genre(sci_fi).
genre(drama).
genre(thriller).
genre(animation).
genre(action).

%Правило 4: Фильмы, снятые определенным режиссером
movies_by_director(Director, MovieID) :-
    movie(MovieID, _, _, Director, _).


% Правило 5: Адреса всех кинотеатров
cinema_address(CinemaID, Address) :-
    cinema(CinemaID, _, Address, _, _).

% Правило 6: Адреса кинотеатров, в которых демонстрируются фильмы определенного режиссера, определенного жанра
cinema_address_by_director_and_genre(CinemaID, Director, Genre) :-
    show(CinemaID, MovieID, _, _, _),
    movie(MovieID, _, _, Director, Genre),
    cinema(CinemaID, _, Address, _, _).