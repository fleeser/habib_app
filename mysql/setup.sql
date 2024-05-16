CREATE TABLE addresses (
    id                  MEDIUMINT NOT NULL AUTO_INCREMENT,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    city                varchar(100) NOT NULL,
    postal_code         nvarchar(5) NOT NULL,
    street              varchar(100) NOT NULL,
    CONSTRAINT pk_address_id PRIMARY KEY (id)
);

CREATE TABLE customers (
    id                  MEDIUMINT NOT NULL AUTO_INCREMENT,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    first_name          varchar(100) NOT NULL,
    last_name           varchar(100) NOT NULL,
    title               varchar(50),
    occupation          varchar(100),
    phone               varchar(20),
    mobile              varchar(20),
    address_id          MEDIUMINT,  
    CONSTRAINT pk_customer_id PRIMARY KEY (id),
    CONSTRAINT fk_customers_address_id FOREIGN KEY (address_id) REFERENCES addresses(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE publishers (
    id                  MEDIUMINT NOT NULL AUTO_INCREMENT,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    name                varchar(100) NOT NULL,
    city                varchar(100),
    CONSTRAINT pk_publisher_id PRIMARY KEY (id)
);

CREATE TABLE authors (
    id                  MEDIUMINT NOT NULL AUTO_INCREMENT,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    first_name          varchar(100) NOT NULL,
    last_name           varchar(100) NOT NULL,
    title               varchar(100),
    CONSTRAINT pk_author_id PRIMARY KEY (id)
);

CREATE TABLE books (
    id                  MEDIUMINT NOT NULL AUTO_INCREMENT,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    title               varchar(255) NOT NULL,
    isbn_10             nchar(10),
    isbn_13             nchar(13),
    edition             SMALLINT,
    publish_date        DATE,
    publisher_id        MEDIUMINT NOT NULL,
    author_id           MEDIUMINT NOT NULL,
    bought              SMALLINT,
    CONSTRAINT pk_book_id PRIMARY KEY (id),
    CONSTRAINT fk_books_publisher_id FOREIGN KEY (publisher_id) REFERENCES publishers(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_books_author_id FOREIGN KEY (author_id) REFERENCES authors(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT book_bought_0_or_1 CHECK (bought IN (0, 1))
);

CREATE TABLE categories (
    id                  MEDIUMINT NOT NULL AUTO_INCREMENT,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    name                varchar(100) NOT NULL,
    CONSTRAINT pk_category_id PRIMARY KEY (id)
);

CREATE TABLE borrows (
    id                  MEDIUMINT NOT NULL AUTO_INCREMENT,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    book_id             MEDIUMINT,
    customer_id         MEDIUMINT,
    end_date            DATE NOT NULL,
    status              ENUM('borrowed', 'returned', 'exceeded', 'warned'),
    CONSTRAINT pk_borrow_id PRIMARY KEY (id),
    CONSTRAINT fk_borrows_book_id FOREIGN KEY (book_id) REFERENCES books(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_borrows_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id) ON UPDATE CASCADE ON DELETE CASCADE
);