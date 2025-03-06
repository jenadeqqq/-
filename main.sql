-- Жанры
CREATE TABLE IF NOT EXISTS Genres (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- Исполнители
CREATE TABLE IF NOT EXISTS Artists (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Альбомы
CREATE TABLE IF NOT EXISTS Albums (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    year INTEGER NOT NULL CHECK (year > 1900)
);

-- Треки
CREATE TABLE IF NOT EXISTS Tracks (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    duration INTEGER NOT NULL CHECK (duration > 0),
    album_id INTEGER NOT NULL REFERENCES Albums(id)
);

-- Сборники
CREATE TABLE IF NOT EXISTS Collections (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    year INTEGER NOT NULL CHECK (year > 1900)
);

-- Жанр исполнителя
CREATE TABLE IF NOT EXISTS GenreArtist (
    genre_id INTEGER REFERENCES Genres(id),
    artist_id INTEGER REFERENCES Artists(id),
    PRIMARY KEY (genre_id, artist_id)
);

-- Альбом исполнитеоля
CREATE TABLE IF NOT EXISTS ArtistAlbum (
    artist_id INTEGER REFERENCES Artists(id),
    album_id INTEGER REFERENCES Albums(id),
    PRIMARY KEY (artist_id, album_id)
);

-- Сборник треков
CREATE TABLE IF NOT EXISTS TrackCollection (
    track_id INTEGER REFERENCES Tracks(id),
    collection_id INTEGER REFERENCES Collections(id),
    PRIMARY KEY (track_id, collection_id)
);













-- Добавление жанров
INSERT INTO Genres (name) VALUES 
('Рок'),
('Поп'),
('Хип-хоп'),
('Электроника');

-- Добавление исполнителей
INSERT INTO Artists (name) VALUES 
('Queen'),
('Eminem'),
('Madonna'),
('Imagine Dragons'),
('Rihanna');

-- Добавление альбомов
INSERT INTO Albums (title, year) VALUES 
('A Night at the Opera', 2019),
('The Marshall Mathers LP', 2020),
('Ray of Light', 2018),
('Night Visions', 2019);

-- Добавление треков
INSERT INTO Tracks (title, duration, album_id) VALUES 
('Bohemian Rhapsody', 354, 1),  -- 5:54
('Love of My Life', 219, 1),     -- 3:39
('The Real Slim Shady', 284, 2), -- 4:44
('My Name Is', 268, 2),          -- 4:28
('Ray of Light', 321, 3),        -- 5:21
('Frozen', 372, 3),              -- 6:12
('Radioactive', 189, 4),         -- 3:09
('My Fault', 230, 4);            -- 3:50

-- Добавление сборников
INSERT INTO Collections (name, year) VALUES 
('Best of Rock', 2018),
('Hip-Hop Classics', 2019),
('Pop Essentials', 2020),
('Mix Hits 2020', 2020),
('Summer Vibes', 2018);

-- Заполнение связей между жанрами и исполнителями
INSERT INTO GenreArtist (genre_id, artist_id) VALUES 
(1, 1), -- Queen - Рок
(3, 2), -- Eminem - Хип-хоп
(2, 3), -- Madonna - Поп
(1, 4), -- Imagine Dragons - Рок
(2, 5), -- Rihanna - Поп
(4, 4); -- Imagine Dragons - Электроника

-- Заполнение связей между исполнителями и альбомами
INSERT INTO ArtistAlbum (artist_id, album_id) VALUES 
(1, 1), -- Queen - A Night at the Opera
(2, 2), -- Eminem - The Marshall Mathers LP
(3, 3), -- Madonna - Ray of Light
(4, 4), -- Imagine Dragons - Night Visions
(1, 4); -- Queen (совместно) - Night Visions

-- Заполнение связей между треками и сборниками
INSERT INTO TrackCollection (track_id, collection_id) VALUES 
(1, 1), -- Bohemian Rhapsody - Best of Rock
(2, 1), -- Love of My Life - Best of Rock
(3, 2), -- The Real Slim Shady - Hip-Hop Classics
(4, 2), -- My Name Is - Hip-Hop Classics
(5, 3), -- Ray of Light - Pop Essentials
(6, 3), -- Frozen - Pop Essentials
(7, 4), -- Radioactive - Mix Hits 2020
(8, 4), -- My Fault - Mix Hits 2020
(1, 5), -- Bohemian Rhapsody - Summer Vibes
(5, 5); -- Ray of Light - Summer Vibes




SELECT title, duration 
FROM Tracks 
WHERE duration = (SELECT MAX(duration) FROM Tracks);


SELECT title 
FROM Tracks 
WHERE duration >= 210;


SELECT name 
FROM Collections 
WHERE year BETWEEN 2018 AND 2020;


SELECT name 
FROM Artists 
WHERE name NOT LIKE '% %';


SELECT title 
FROM Tracks 
WHERE title ILIKE '%мой%' OR title ILIKE '%my%';

-- 3

-- 1
SELECT g.name AS genre, COUNT(ga.artist_id) AS artist_count
FROM Genres g
LEFT JOIN GenreArtist ga ON g.id = ga.genre_id
GROUP BY g.name
ORDER BY artist_count DESC;

-- 2
SELECT COUNT(*) AS tracks_count
FROM Tracks t
JOIN Albums a ON t.album_id = a.id
WHERE a.year BETWEEN 2019 AND 2020;

-- 3. Средняя продолжительность треков по каждому альбому.
SELECT a.title AS album, AVG(t.duration) AS avg_duration
FROM Albums a
JOIN Tracks t ON a.id = t.album_id
GROUP BY a.title
ORDER BY avg_duration DESC;

-- 4
SELECT DISTINCT ar.name
FROM Artists ar
WHERE ar.id NOT IN (
    SELECT DISTINCT aa.artist_id
    FROM ArtistAlbum aa
    JOIN Albums al ON aa.album_id = al.id
    WHERE al.year = 2020
);

-- 5
SELECT DISTINCT c.name
FROM Collections c
JOIN TrackCollection tc ON c.id = tc.collection_id
JOIN Tracks t ON tc.track_id = t.id
JOIN Albums al ON t.album_id = al.id
JOIN ArtistAlbum aa ON al.id = aa.album_id
JOIN Artists ar ON aa.artist_id = ar.id
WHERE ar.name = 'Queen';
