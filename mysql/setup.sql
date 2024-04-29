CREATE TABLE customers (
    id              MEDIUMINT NOT NULL AUTO_INCREMENT,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    name            nvarchar(100) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE books (
    id              MEDIUMINT NOT NULL AUTO_INCREMENT,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    title           nvarchar(200) NOT NULL,
    isbn_10         nchar(10),
    isbn_13         nchar(13),
    PRIMARY KEY (id)
);