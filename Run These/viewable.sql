SELECT unique i.photo_id as photo_id, i.owner_name as owner_name, i.permitted as permitted, i.subject as subject, i.place as place, i.timing as timing, i.description as description
FROM images i, groups g, group_lists l
WHERE (l.friend_id = 'rozsa1' AND l.group_id = g.group_id and g.group_id = i.permitted) or i.owner_name = 'rozsa' or i.permitted = 1;