CREATE TABLE viewed(
       photo_id int,
       viewee varchar(24),
       PRIMARY KEY(photo_id, viewee),
       FOREIGN KEY(photo_id) REFERENCES images,
       FOREIGN KEY(viewee) REFERENCES users
);