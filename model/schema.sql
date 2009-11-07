DROP TABLE IF EXISTS post;

CREATE TABLE post (
    id INT NOT NULL,
    title VARCHAR(64) NOT NULL,
    body VARCHAR(65536) NOT NULL,
    date_ DATE NOT NULL,
    time_ TIME,
    PRIMARY KEY (id)
);
