-- ==========================================================
--  СХЕМА БАЗЫ ДАННЫХ «ЗАВОДЧИК СОБАК»
-- ==========================================================

-- На случай повторного запуска
DROP TABLE IF EXISTS veterinary_record CASCADE;
DROP TABLE IF EXISTS litter CASCADE;
DROP TABLE IF EXISTS mating CASCADE;
DROP TABLE IF EXISTS dog CASCADE;
DROP TABLE IF EXISTS breed CASCADE;
DROP TABLE IF EXISTS owner CASCADE;
DROP TABLE IF EXISTS "user" CASCADE;

-- ==========================================================
--  Таблица: Owner (Владелец)
-- ==========================================================
CREATE TABLE owner (
    owner_id     SERIAL PRIMARY KEY,
    last_name    VARCHAR(50) NOT NULL,
    first_name   VARCHAR(50) NOT NULL,
    patronymic   VARCHAR(50),
    address      VARCHAR(150) NOT NULL,
    phone        VARCHAR(20) NOT NULL UNIQUE,
    email        VARCHAR(100) UNIQUE,
    birth_date   DATE NOT NULL
        CHECK (birth_date <= CURRENT_DATE - INTERVAL '18 years')
);

COMMENT ON TABLE owner IS 'Владельцы собак';
COMMENT ON COLUMN owner.birth_date IS 'Дата рождения (≥18 лет)';

-- ==========================================================
--  Таблица: Breed (Порода)
-- ==========================================================
CREATE TABLE breed (
    breed_id     SERIAL PRIMARY KEY,
    name         VARCHAR(100) NOT NULL UNIQUE,
    description  TEXT
);

COMMENT ON TABLE breed IS 'Породы собак';

-- ==========================================================
--  Таблица: Dog (Собака)
-- ==========================================================
CREATE TABLE dog (
    dog_id        SERIAL PRIMARY KEY,
    name          VARCHAR(50) NOT NULL,
    gender        CHAR(1) NOT NULL
        CHECK (gender IN ('M','F')),
    birth_date    DATE NOT NULL,
    color         VARCHAR(50),
    has_pedigree  BOOLEAN NOT NULL DEFAULT FALSE
);

COMMENT ON TABLE dog IS 'Информация о собаках';
COMMENT ON COLUMN dog.has_pedigree IS 'Наличие родословной (TRUE/FALSE)';

-- ==========================================================
--  Таблица: Mating (Вязка)
-- ==========================================================
CREATE TABLE mating (
    mating_id  SERIAL PRIMARY KEY,
    father_id  INT NOT NULL REFERENCES dog(dog_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    mother_id  INT NOT NULL REFERENCES dog(dog_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    date       DATE NOT NULL,
    location   VARCHAR(150) NOT NULL
);

COMMENT ON TABLE mating IS 'Факты вязок собак';
COMMENT ON COLUMN mating.location IS 'Место проведения вязки';

-- ==========================================================
--  Таблица: Litter (Помёт)
-- ==========================================================
CREATE TABLE litter (
    litter_id          SERIAL PRIMARY KEY,
    mating_id          INT NOT NULL REFERENCES mating(mating_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    birth_date         DATE NOT NULL,
    number_of_puppies  INT NOT NULL DEFAULT 0
        CHECK (number_of_puppies >= 0)
);

COMMENT ON TABLE litter IS 'Информация о помётах';
COMMENT ON COLUMN litter.number_of_puppies IS 'Количество щенков';


-- ==========================================================
--  Таблица: VeterinaryRecord (Ветеринарная запись)
-- ==========================================================
CREATE TABLE veterinary_record (
    record_id    SERIAL PRIMARY KEY,
    dog_id       INT NOT NULL REFERENCES dog(dog_id) ON UPDATE CASCADE ON DELETE CASCADE,
    date         DATE NOT NULL,
    description  TEXT NOT NULL
);

COMMENT ON TABLE veterinary_record IS 'Медицинские процедуры и осмотры собак';

-- ==========================================================
--  Таблица: User (Пользователь)
-- ==========================================================
CREATE TABLE "user" (
    user_id   SERIAL PRIMARY KEY,
    login     VARCHAR(50) NOT NULL UNIQUE,
    password  VARCHAR(100) NOT NULL
);

COMMENT ON TABLE "user" IS 'Пользователи системы (заводчики, администраторы и др.)';

