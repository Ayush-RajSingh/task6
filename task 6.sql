CREATE TABLE Reactions (
    id INT PRIMARY KEY,
    content_id VARCHAR(36),
    user_id VARCHAR(36),
    type VARCHAR(50),
    datetime INT,
    intensity INT,
    duration INT,
    engagement_score FLOAT,
    sentiment_score FLOAT
);

select * from Reactions

COPY Reactions(id, content_id, user_id, type, datetime, intensity, duration, engagement_score, sentiment_score)
FROM 'C:\Program Files/PostgreSQL/16/data/backup/Reactions.csv'
DELIMITER ',' 
CSV;

CREATE TABLE ReactionTypes (
    id INT PRIMARY KEY,
    type VARCHAR(50),
    sentiment VARCHAR(50),
    score INT,
    frequency INT,
    weight FLOAT
);

COPY ReactionTypes(id, type, sentiment, score, frequency, weight)
FROM 'C:\Program Files/PostgreSQL/16/data/backup/ReactionTypes.csv'
DELIMITER ',' 
CSV;

CREATE TABLE Content (
    id INT PRIMARY KEY,
    content_id VARCHAR(36),
    type VARCHAR(50),
    category VARCHAR(50),
    views INT,
    likes INT,
    shares INT
);

COPY Content(id, content_id, type, category, views, likes, shares)
FROM 'C:\Program Files/PostgreSQL/16/data/backup/Content_prepared.csv'
DELIMITER ',' 
CSV;

SELECT c.content_id, c.type, c.category, r.type AS reaction_type, r.datetime
FROM Content c
INNER JOIN Reactions r ON c.content_id = r.content_id
WHERE c.category = 'Studying'
LIMIT 10;

SELECT c.category, COUNT(r.id) AS reaction_count
FROM Content c
LEFT JOIN Reactions r ON c.content_id = r.content_id
GROUP BY c.category
HAVING COUNT(r.id) > 100
ORDER BY reaction_count DESC;

SELECT rt.type, 'Positive' AS sentiment, COUNT(r.id) AS reaction_count
FROM ReactionTypes rt
JOIN Reactions r ON rt.type = r.type
WHERE rt.sentiment = 'positive'
GROUP BY rt.type

UNION

SELECT rt.type, 'Negative' AS sentiment, COUNT(r.id) AS reaction_count
FROM ReactionTypes rt
JOIN Reactions r ON rt.type = r.type
WHERE rt.sentiment = 'negative'
GROUP BY rt.type

ORDER BY reaction_count DESC;