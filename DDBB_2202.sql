USE blog_db;

-- ADD NEW COLUMN IN USERS TABLE WITH BOOLEAN USER STATUS
ALTER TABLE users
ADD COLUMN actiu BOOLEAN NOT NULL DEFAULT TRUE;

-- check it's created
DESCRIBE users;

-- =============================
-- 			TEST DATA
-- =============================

-- USERS

INSERT INTO users (nom_usuari, email, contrasenya_hash, rol)
VALUES 
('admin1','admin@mail.com','hash','Admin');
('editor1','editor@mail.com','hash','Editor'),
('lector1','lector@mail.com','hash','Lector');

SELECT * FROM users;


-- CATEGORIES

INSERT INTO categories (nom_categoria)
VALUES ('Tecnologia'), ('Cultura');

-- TAGS 

INSERT INTO tags (tag_nom)
VALUES ('IA'), ('Innovacio');

-- ARTICLES, user 5 as editor

INSERT INTO articles (titol, contingut, data_publicacio, estat, id_user, id_categoria)
VALUES ('Article publicat', 'Contingut...', NOW(), 'Publicat', 5, 1), 
('Article esborrany', 'Contingut...', NOW(), 'Esborrany', 5, 2);


-- ARTICLE-TAG

-- to see values and check article id
SELECT id_article, titol FROM articles;
SELECT id_tag, tag_nom FROM tags;

INSERT INTO article_tag (id_article, id_tag)
VALUES (2,1),(3,2);

SELECT * FROM tags;


-- COMMENTS 

INSERT INTO comments (contingut, id_user, id_article)
VALUES ('Bon article!', 3, 2);

SELECT id_comment, contingut, id_article, data_comentari FROM comments;


-- TRIGGER DERIVED ARTICLE TABLE ADAPTATION

SHOW CREATE TABLE articles; -- to check constraint name

-- delete current constraint
ALTER TABLE articles 
DROP FOREIGN KEY articles_ibfk_1;
-- allow for column to take NULL
ALTER TABLE articles
MODIFY id_user INT NULL;

-- create new FOREIGN KEY
ALTER TABLE articles
ADD CONSTRAINT fk_articles_user
FOREIGN KEY (id_user)
REFERENCES users(id_user)
ON DELETE SET NULL; -- if user is deleted, set id_user to NULL

-- TRIGGER CHECK with user 2

SELECT id_article, estat, id_user
FROM articles;

DELETE FROM users WHERE id_user = 2;

SELECT * FROM articles WHERE id_user = 2; -- returns 0 rows, valid query but no matching data

-- =============================
-- 			QUERIES
-- =============================

-- CREATE ARTICLE (editor/admin only)
INSERT INTO articles (titol, contingut, data_publicacio, estat, id_user, id_categoria)
SELECT 'Nou article', 'Contingut...', NOW(), 'Esborrany', u.id_user, 1
FROM users u
WHERE u.id_user = 5
AND u.rol IN ('Editor', 'Admin');

SELECT * FROM articles;

-- CHANGE STATUS (author Editor/Admin only)
UPDATE articles a
JOIN users u ON a.id_user = u.id_user 
SET a.estat = 'Publicat'
WHERE a.id_article = 6
AND u.id_user = 5
AND u.rol IN ('Editor', 'Admin');

-- COMMENT ARTICLE with id = 6 (registered users, only if article status = 'Publicat')
INSERT INTO comments (contingut, id_user, id_article)
SELECT 'Molt interessant!', u.id_user, a.id_article
FROM users u
JOIN articles a ON a.id_article = 6
WHERE u.id_user = 3
AND u.rol IN ('Lector', 'Editor', 'Admin')
AND a.estat = 'Publicat';

SELECT * FROM comments;

-- MODERATE (delete comment, admin only)

DELETE c
FROM comments c
JOIN users u ON u.id_user = 5 -- does not work with other users
WHERE c.id_comment = 6 -- id of comment to be deleted
AND u.rol = 'Admin';

SELECT * FROM comments;
SELECT * FROM users;


-- CATEGORY FILTER
SELECT a.titol, c.nom_categoria
FROM articles a
JOIN categories c ON a.id_categoria = c.id_categoria 
WHERE c.nom_categoria  = 'Cultura'
AND a.estat = 'Publicat';

SELECT * FROM categories;

-- TAG FILTER
SELECT a.titol, t.tag_nom
FROM articles a
JOIN article_tag at ON a.id_article = at.id_article 
JOIN tags t ON at.id_tag = t.id_tag
WHERE t.tag_nom = 'IA'
AND a.estat = 'Publicat';

-- EDITOR DASHBOARD (Editor/admin)
SELECT a.titol, a.estat, a.data_publicacio
FROM articles a
JOIN users u ON a.id_user = u.id_user 
WHERE u.id_user = 5
AND u.rol = ('Editor', 'Admin');

-- COMMENT HISTORY (reader)
SELECT c.contingut, c.data_comentari
FROM comments c
JOIN users u ON c.id_user = u.id_user 
WHERE u.id_user = 3
AND u.rol = 'Lector';


