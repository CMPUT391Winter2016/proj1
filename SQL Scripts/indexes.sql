drop index sub_idx;
drop index place_idx;
drop index desc_idx;

CREATE INDEX sub_idx ON images(subject) INDEXTYPE IS CTXSYS.CONTEXT;
CREATE INDEX place_idx ON images(place) INDEXTYPE IS CTXSYS.CONTEXT;
CREATE INDEX desc_idx ON images(description) INDEXTYPE IS CTXSYS.CONTEXT;
/
