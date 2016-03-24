drop table popularity;

CREATE TABLE popularity(
       photo_id int,
       views int,
       PRIMARY KEY(photo_id),
       FOREIGN KEY(photo_id) REFERENCES images
);