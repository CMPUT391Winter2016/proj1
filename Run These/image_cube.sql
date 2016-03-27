CREATE VIEW image_cube as
SELECT owner_name, subject, timing, count(*) as count
FROM images
GROUP BY CUBE(owner_name, subject, timing);