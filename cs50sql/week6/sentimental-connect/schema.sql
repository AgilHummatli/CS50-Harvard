CREATE TABLE `users` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `username` VARCHAR(50) NOT NULL UNIQUE,
    `password` VARCHAR(128) NOT NULL,
    PRIMARY KEY(`id`)
);

CREATE TABLE `schools` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL UNIQUE,
    `type` ENUM('Primary', 'Secondary', 'Higher Education') NOT NULL,
    `location` VARCHAR(100) NOT NULL,
    `founded_year` SMALLINT UNSIGNED NOT NULL,
    PRIMARY KEY(`id`)
);

CREATE TABLE `companies` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL UNIQUE,
    `industry` ENUM('Technology', 'Education', 'Business') NOT NULL,
    `location` VARCHAR(100) NOT NULL,
    PRIMARY KEY(`id`)
);

CREATE TABLE `user_connections` (
    `user_id` INT UNSIGNED NOT NULL,
    `connected_user_id` INT UNSIGNED NOT NULL,
    PRIMARY KEY(`user_id`, `connected_user_id`),
    FOREIGN KEY(`user_id`) REFERENCES `users`(`id`),
    FOREIGN KEY(`connected_user_id`) REFERENCES `users`(`id`),
    CHECK(`user_id` < `connected_user_id`)
);

CREATE TABLE `user_schools` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `user_id` INT UNSIGNED NOT NULL,
    `school_id` INT UNSIGNED NOT NULL,
    `start_date` DATE,
    `end_date` DATE,
    `degree` VARCHAR(20),
    PRIMARY KEY(`id`),
    FOREIGN KEY(`user_id`) REFERENCES `users`(`id`),
    FOREIGN KEY(`school_id`) REFERENCES `schools`(`id`)
);

CREATE TABLE `user_companies` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `user_id` INT UNSIGNED NOT NULL,
    `company_id` INT UNSIGNED NOT NULL,
    `title` VARCHAR(100),
    `start_date` DATE,
    `end_date` DATE,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`user_id`) REFERENCES `users`(`id`),
    FOREIGN KEY(`company_id`) REFERENCES `companies`(`id`)
);

-- Sample data

INSERT INTO `users` (`first_name`, `last_name`, `username`, `password`)
VALUES ('Claudine', 'Gay', 'claudine', 'password');

INSERT INTO `users` (`first_name`, `last_name`, `username`, `password`)
VALUES ('Reid', 'Hoffman', 'reid', 'password');

INSERT INTO `schools` (`name`, `type`, `location`, `founded_year`)
VALUES ('Harvard University', 'Higher Education', 'Cambridge, Massachusetts', 1636);

INSERT INTO `companies` (`name`, `industry`, `location`)
VALUES ('LinkedIn', 'Technology', 'Sunnyvale, California');

INSERT INTO `user_schools` (`user_id`, `school_id`, `start_date`, `end_date`, `degree`)
VALUES (
    (SELECT `id` FROM `users` WHERE `username` = 'claudine'),
    (SELECT `id` FROM `schools` WHERE `name` = 'Harvard University'),
    '1993-01-01',
    '1998-12-31',
    'PhD'
);

INSERT INTO `user_companies` (`user_id`, `company_id`, `title`, `start_date`, `end_date`)
VALUES (
    (SELECT `id` FROM `users` WHERE `username` = 'reid'),
    (SELECT `id` FROM `companies` WHERE `name` = 'LinkedIn'),
    'CEO and Chairman',
    '2003-01-01',
    '2007-02-01'
);
