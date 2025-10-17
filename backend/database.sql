CREATE
DATABASE IF NOT EXISTS shopapp;
USE
shopapp;

-- 1. ROLES
CREATE TABLE roles
(
    id   INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL
) ENGINE=InnoDB;

-- 2. USERS
CREATE TABLE users
(
    id                  INT PRIMARY KEY AUTO_INCREMENT,
    fullname            VARCHAR(100) DEFAULT '',
    phone_number        VARCHAR(10)  NOT NULL,
    address             VARCHAR(200) DEFAULT '',
    password            VARCHAR(100) NOT NULL,
    created_at          DATETIME     DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active           TINYINT(1) DEFAULT 1,
    date_of_birth       DATE,
    facebook_account_id INT          DEFAULT 0,
    google_account_id   INT          DEFAULT 0,
    role_id             INT,
    FOREIGN KEY (role_id) REFERENCES roles (id)
) ENGINE=InnoDB;

-- 3. TOKENS
CREATE TABLE tokens
(
    id              INT PRIMARY KEY AUTO_INCREMENT,
    token           VARCHAR(255) UNIQUE NOT NULL,
    token_type      VARCHAR(50)         NOT NULL,
    expiration_date DATETIME,
    revoked         TINYINT(1) NOT NULL DEFAULT 0,
    expired         TINYINT(1) NOT NULL DEFAULT 0,
    user_id         INT,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 4. SOCIAL ACCOUNTS
CREATE TABLE social_accounts
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    provider    VARCHAR(20)  NOT NULL COMMENT 'Tên nhà social network',
    provider_id VARCHAR(50)  NOT NULL,
    email       VARCHAR(150) NOT NULL COMMENT 'Email tài khoản',
    name        VARCHAR(100) NOT NULL COMMENT 'Tên người dùng',
    user_id     INT,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 5. CATEGORIES
CREATE TABLE categories
(
    id   INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL DEFAULT '' COMMENT 'Tên danh mục, vd: đồ điện tử'
) ENGINE=InnoDB;

-- 6. PRODUCTS
CREATE TABLE products
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(350) NOT NULL COMMENT 'Tên sản phẩm',
    price       FLOAT        NOT NULL CHECK (price >= 0),
    thumbnail   VARCHAR(300) DEFAULT '',
    description LONGTEXT, -- TEXT/LONGTEXT không dùng DEFAULT
    created_at  DATETIME     DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories (id)
) ENGINE=InnoDB;

-- 7. PRODUCT IMAGES
CREATE TABLE product_images
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT          NOT NULL,
    image_url  VARCHAR(300) NOT NULL,
    CONSTRAINT fk_product_images_product_id
        FOREIGN KEY (product_id)
            REFERENCES products (id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 8. ORDERS
CREATE TABLE orders
(
    id               INT PRIMARY KEY AUTO_INCREMENT,
    user_id          INT,
    FOREIGN KEY (user_id) REFERENCES users (id),
    fullname         VARCHAR(100) DEFAULT '',
    email            VARCHAR(100) DEFAULT '',
    phone_number     VARCHAR(20)  NOT NULL,
    address          VARCHAR(200) NOT NULL,
    note             VARCHAR(100) DEFAULT '',
    order_date       DATETIME     DEFAULT CURRENT_TIMESTAMP,
    status           ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending'
        COMMENT 'Trạng thái đơn hàng',
    total_money      FLOAT CHECK (total_money >= 0),
    shipping_method  VARCHAR(100),
    shipping_address VARCHAR(200),
    shipping_date    DATE,
    tracking_number  VARCHAR(100),
    payment_method   VARCHAR(100),
    active           TINYINT(1) DEFAULT 1
) ENGINE=InnoDB;

-- 9. ORDER DETAILS
CREATE TABLE order_details
(
    id                 INT PRIMARY KEY AUTO_INCREMENT,
    order_id           INT   NOT NULL,
    product_id         INT   NOT NULL,
    price              FLOAT NOT NULL CHECK (price >= 0),
    number_of_products INT   NOT NULL CHECK (number_of_products > 0),
    total_money        FLOAT NOT NULL CHECK (total_money >= 0),
    color              VARCHAR(20) DEFAULT '',
    FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products (id)
) ENGINE=InnoDB;
