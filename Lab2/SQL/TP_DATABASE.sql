
CREATE TABLE user_table (
    user_id          BIGINT PRIMARY KEY AUTO_INCREMENT,
    full_name        VARCHAR(150) NOT NULL,
    email            VARCHAR(150) NOT NULL UNIQUE,
    phone            VARCHAR(30),
    password_hash    VARCHAR(255) NOT NULL,
    role             ENUM('customer','admin') DEFAULT 'customer',
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE category_table (
    category_id      BIGINT PRIMARY KEY AUTO_INCREMENT,
    category_name    VARCHAR(150) NOT NULL,
    parent_id        BIGINT NULL,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (parent_id) REFERENCES category_table(category_id)
        ON DELETE SET NULL
);

CREATE TABLE product_table (
    product_id       BIGINT PRIMARY KEY AUTO_INCREMENT,
    product_name     VARCHAR(200) NOT NULL,
    description      TEXT,
    base_price       DECIMAL(10,2) NOT NULL,
    is_active        BOOLEAN DEFAULT TRUE,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE product_category_table (
    id              BIGINT PRIMARY KEY AUTO_INCREMENT,
    product_id      BIGINT NOT NULL,
    category_id     BIGINT NOT NULL,

    FOREIGN KEY (product_id) REFERENCES product_table(product_id)
        ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES category_table(category_id)
        ON DELETE CASCADE,

    UNIQUE(product_id, category_id)
);

CREATE TABLE attributes_table (
    attribute_id     BIGINT PRIMARY KEY AUTO_INCREMENT,
    attribute_name   VARCHAR(150) NOT NULL
);

CREATE TABLE attributes_options_table (
    option_id        BIGINT PRIMARY KEY AUTO_INCREMENT,
    attribute_id     BIGINT NOT NULL,
    option_name      VARCHAR(150) NOT NULL,

    FOREIGN KEY (attribute_id) REFERENCES attributes_table(attribute_id)
        ON DELETE CASCADE
);

CREATE TABLE product_variant_table (
    variant_id        BIGINT PRIMARY KEY AUTO_INCREMENT,
    product_id        BIGINT NOT NULL,
    sku               VARCHAR(100) UNIQUE,
    price             DECIMAL(10,2) NOT NULL,
    stock_quantity    INT DEFAULT 0,
    image_url         VARCHAR(500),
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (product_id) REFERENCES product_table(product_id)
        ON DELETE CASCADE
);

CREATE TABLE variant_attributes_table (
    id            BIGINT PRIMARY KEY AUTO_INCREMENT,
    variant_id    BIGINT NOT NULL,
    attribute_id  BIGINT NOT NULL,
    option_id     BIGINT NOT NULL,

    FOREIGN KEY (variant_id) REFERENCES product_variant_table(variant_id)
        ON DELETE CASCADE,
    FOREIGN KEY (attribute_id) REFERENCES attributes_table(attribute_id),
    FOREIGN KEY (option_id) REFERENCES attributes_options_table(option_id),

    UNIQUE(variant_id, attribute_id)
);

CREATE TABLE order_table (
    order_id         BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id          BIGINT NOT NULL,
    total_amount     DECIMAL(10,2) NOT NULL,
    status           ENUM('pending','paid','shipped','completed','cancelled') DEFAULT 'pending',
    shipping_address TEXT,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES user_table(user_id)
        ON DELETE CASCADE
);

CREATE TABLE order_items_table (
    order_item_id    BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id         BIGINT NOT NULL,
    product_id       BIGINT NOT NULL,
    variant_id       BIGINT NOT NULL,
    quantity         INT NOT NULL,
    unit_price       DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (order_id) REFERENCES order_table(order_id)
        ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product_table(product_id),
    FOREIGN KEY (variant_id) REFERENCES product_variant_table(variant_id)
);

CREATE INDEX idx_product_name ON product_table(product_name);
CREATE INDEX idx_variant_product ON product_variant_table(product_id);
CREATE INDEX idx_order_user ON order_table(user_id);
CREATE INDEX idx_variant_sku ON product_variant_table(sku);


INSERT INTO user_table (full_name, email, phone, password_hash, role) VALUES
('Ahmed Benali','ahmed.benali@gmail.com','0550123456','hash1','customer'),
('Sara Meftah','sara.meftah@yahoo.com','0661458796','hash2','customer'),
('Yacine Boudia','yacine.boudia@gmail.com','0778456123','hash3','customer'),
('Lina Cherif','lina.cherif@outlook.com','0559988776','hash4','customer'),
('Karim Touati','karim.touati@gmail.com','0661231234','hash5','customer'),
('Nadia Ferhat','nadia.ferhat@yahoo.com','0779988112','hash6','customer'),
('Omar Ziani','omar.ziani@gmail.com','0556677889','hash7','customer'),
('Rania Haddad','rania.haddad@gmail.com','0664455667','hash8','customer'),
('Walid Mansouri','walid.mansouri@gmail.com','0771122334','hash9','customer'),
('Admin User','admin@shop.com','0550000000','adminhash','admin');



INSERT INTO category_table (category_name) VALUES
('Electronics'),
('Clothing'),
('Home & Kitchen'),
('Sports'),
('Books');


INSERT INTO product_table (product_name, description, base_price, is_active) VALUES
('iPhone 14','Apple smartphone 128GB',900,1),
('Samsung Galaxy S23','Android flagship phone',850,1),
('Dell XPS 13','Ultrabook laptop 16GB RAM',1200,1),
('Nike Air Max','Running shoes',150,1),
('Adidas Hoodie','Winter cotton hoodie',60,1),
('Office Chair','Ergonomic chair',180,1),
('Coffee Maker','Automatic espresso machine',220,1),
('Football Ball','FIFA approved size 5',35,1),
('Basketball Shoes','Professional sports shoes',130,1),
('Cooking Pan Set','Non-stick cookware 6 pieces',95,1),
('Smart TV 55','4K Ultra HD television',700,1),
('Bluetooth Speaker','Portable waterproof speaker',75,1),
('Men T-Shirt','Cotton summer shirt',25,1),
('Women Jacket','Leather winter jacket',140,1),
('Gaming Mouse','RGB high precision mouse',45,1),
('Keyboard Mechanical','Blue switch keyboard',85,1),
('Backpack','Travel backpack 40L',55,1),
('Yoga Mat','Anti-slip mat',30,1),
('Data Science Book','Machine learning guide',50,1),
('Novel Book','Best seller fiction',20,1);


INSERT INTO product_category_table (product_id, category_id) VALUES
(1,1),(2,1),(3,1),(11,1),(12,1),(15,1),(16,1),
(4,2),(5,2),(13,2),(14,2),
(6,3),(7,3),(10,3),
(8,4),(9,4),(18,4),(17,4),
(19,5),(20,5);


INSERT INTO attributes_table (attribute_name) VALUES
('Color'),
('Size'),
('Storage'),
('RAM');


INSERT INTO attributes_options_table (attribute_id, option_name) VALUES
(1,'Black'),(1,'White'),(1,'Red'),(1,'Blue'),
(2,'S'),(2,'M'),(2,'L'),(2,'XL'),
(3,'128GB'),(3,'256GB'),
(4,'8GB'),(4,'16GB');


INSERT INTO product_variant_table (product_id, sku, price, stock_quantity, image_url) VALUES
(1,'IP14-128-BLK',900,15,'img1.jpg'),
(1,'IP14-256-BLK',1000,10,'img2.jpg'),
(2,'S23-128-WHT',850,20,'img3.jpg'),
(2,'S23-256-WHT',950,12,'img4.jpg'),
(3,'XPS13-8GB',1200,5,'img5.jpg'),
(3,'XPS13-16GB',1350,4,'img6.jpg'),
(4,'NIKE-RED-42',150,25,'img7.jpg'),
(4,'NIKE-BLK-43',155,18,'img8.jpg'),
(5,'HOODIE-M-BLK',60,30,'img9.jpg'),
(5,'HOODIE-L-BLU',60,22,'img10.jpg'),
(6,'CHAIR-BLK',180,10,'img11.jpg'),
(7,'COFFEE-WHT',220,8,'img12.jpg'),
(8,'BALL-STD',35,50,'img13.jpg'),
(9,'BASKET-42',130,14,'img14.jpg'),
(10,'PAN-SET',95,16,'img15.jpg'),
(11,'TV55-4K',700,6,'img16.jpg'),
(12,'SPEAKER-BLU',75,40,'img17.jpg'),
(13,'TSHIRT-S-RED',25,60,'img18.jpg'),
(13,'TSHIRT-M-RED',25,55,'img19.jpg'),
(13,'TSHIRT-L-RED',25,50,'img20.jpg'),
(14,'JACKET-M-BLK',140,12,'img21.jpg'),
(14,'JACKET-L-BLK',140,10,'img22.jpg'),
(15,'MOUSE-RGB',45,45,'img23.jpg'),
(16,'KEYBOARD-BLUE',85,20,'img24.jpg'),
(17,'BACKPACK-40L',55,30,'img25.jpg'),
(18,'YOGA-STD',30,35,'img26.jpg'),
(19,'DS-BOOK',50,25,'img27.jpg'),
(20,'NOVEL-BOOK',20,40,'img28.jpg'),
(4,'NIKE-RED-44',150,10,'img29.jpg'),
(5,'HOODIE-XL-BLK',60,15,'img30.jpg'),
(1,'IP14-128-WHT',900,8,'img31.jpg'),
(2,'S23-128-BLK',850,9,'img32.jpg'),
(3,'XPS13-8GB-ALT',1180,3,'img33.jpg'),
(12,'SPEAKER-RED',75,22,'img34.jpg'),
(15,'MOUSE-BASIC',35,33,'img35.jpg'),
(16,'KEYBOARD-RED',90,12,'img36.jpg'),
(18,'YOGA-PRO',45,18,'img37.jpg'),
(17,'BACKPACK-50L',65,14,'img38.jpg'),
(9,'BASKET-43',135,11,'img39.jpg'),
(10,'PAN-SET-PRO',120,9,'img40.jpg');



INSERT INTO order_table (user_id, total_amount, status, shipping_address) VALUES
(1,1900,'paid','Algiers'),
(2,60,'completed','Oran'),
(3,150,'paid','Constantine'),
(4,220,'shipped','Setif'),
(5,75,'completed','Annaba'),
(6,1200,'paid','Blida'),
(7,95,'completed','Tlemcen'),
(8,140,'shipped','Batna'),
(9,30,'completed','Bejaia'),
(1,85,'paid','Algiers'),
(2,25,'completed','Oran'),
(3,55,'paid','Constantine'),
(4,700,'paid','Setif'),
(5,35,'completed','Annaba'),
(6,45,'paid','Blida');


INSERT INTO order_items_table (order_id, product_id, variant_id, quantity, unit_price) VALUES
(1,1,1,1,900),
(1,1,2,1,1000),
(2,5,9,1,60),
(3,4,7,1,150),
(4,7,12,1,220),
(5,12,17,1,75),
(6,3,5,1,1200),
(7,10,15,1,95),
(8,14,21,1,140),
(9,18,26,1,30),
(10,16,24,1,85),
(11,13,18,1,25),
(12,17,25,1,55),
(13,11,16,1,700),
(14,8,13,1,35),
(15,15,23,1,45);



INSERT INTO variant_attributes_table (variant_id, attribute_id, option_id) VALUES

-- iPhone 14
(1,3,9),(1,1,1),      -- 128GB Black
(2,3,10),(2,1,1),     -- 256GB Black
(31,3,9),(31,1,2),    -- 128GB White

-- Samsung S23
(3,3,9),(3,1,2),
(4,3,10),(4,1,2),
(32,3,9),(32,1,1),

-- Dell XPS
(5,4,11),
(6,4,12),
(33,4,11),

-- Nike Air Max
(7,1,3),(7,2,7),
(8,1,1),(8,2,7),
(29,1,3),(29,2,7),

-- Adidas Hoodie
(9,1,1),(9,2,6),
(10,1,4),(10,2,7),
(30,1,1),(30,2,8),

-- Office Chair
(11,1,1),

-- Coffee Maker
(12,1,2),

-- Football Ball
(13,1,1),

-- Basketball Shoes
(14,2,7),
(39,2,7),

-- Pan Set
(15,1,1),
(40,1,1),

-- Smart TV
(16,1,1),

-- Speaker
(17,1,4),
(34,1,3),

-- T-Shirt
(18,1,3),(18,2,5),
(19,1,3),(19,2,6),
(20,1,3),(20,2,7),

-- Jacket
(21,1,1),(21,2,6),
(22,1,1),(22,2,7),

-- Mouse
(23,1,3),
(35,1,1),

-- Keyboard
(24,1,1),
(36,1,3),

-- Backpack
(25,1,1),
(38,1,1),

-- Yoga
(26,1,4),
(37,1,4),

-- Books
(27,1,1),
(28,1,1);

