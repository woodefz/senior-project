DROP DATABASE IF EXISTS skinsite;
CREATE DATABASE IF NOT EXISTS skinsite;
USE skinsite;

CREATE TABLE IF NOT EXISTS Brand (
	brand_id CHAR(8) PRIMARY KEY,
    brandName VARCHAR(1000) NOT NULL,
    brandDescription VARCHAR(3000)
);

CREATE TABLE IF NOT EXISTS SkinType (
	skt_id CHAR(8) PRIMARY KEY,
    sktName VARCHAR(1000) NOT NULL,
    sktDescription VARCHAR(3000)
);

CREATE TABLE IF NOT EXISTS Ingredient (
	ingd_id CHAR(8) PRIMARY KEY,
    ingdName VARCHAR(1000) NOT NULL,
    ingdDetail VARCHAR(3000),
    ingdRating INT NOT NULL
);

ALTER TABLE Ingredient ADD CONSTRAINT 
chk_ingdRating CHECK (ingdRating >= 1 AND ingdRating <= 10);
    
CREATE TABLE IF NOT EXISTS Category (
	cat_id CHAR(8) PRIMARY KEY,
    catName VARCHAR(1000) NOT NULL
);

CREATE TABLE IF NOT EXISTS Size (
	size_id CHAR(8) PRIMARY KEY,
    volumn INT NOT NULL,
    unit ENUM("g", "ml") NOT NULL
);

CREATE TABLE IF NOT EXISTS Benefit (
	benefit_id CHAR(8) PRIMARY KEY,
    benefitName VARCHAR(1000) NOT NULL,
    benefitDesc VARCHAR(3000)
);

CREATE TABLE IF NOT EXISTS Concern (
	concern_id CHAR(8) PRIMARY KEY,
    concernName VARCHAR(1000) NOT NULL,
    concernyDetail VARCHAR(3000)
);

CREATE TABLE IF NOT EXISTS Step (
	step_id CHAR(8) PRIMARY KEY,
    stepName VARCHAR(1000) NOT NULL
);

CREATE TABLE IF NOT EXISTS account_skin (
	acc_id CHAR(8) PRIMARY KEY,
	accName VARCHAR(1000) NOT NULL,
    email VARCHAR(320) NOT NULL,
	pwd VARCHAR(20) NOT NULL,
    accRoles ENUM("Member", "Admin") DEFAULT "Member" NOT NULL,
    gender ENUM("Male", "Female", "Not prefer to say") NOT NULL,
    dob DATE NOT NULL,
    sktid CHAR(8),
    CONSTRAINT FK_sktID FOREIGN KEY (sktid)
    REFERENCES SkinType(skt_id)
);

CREATE TABLE IF NOT EXISTS product (
	pd_id CHAR(8) PRIMARY KEY,
	pdName VARCHAR(1000) NOT NULL,
    pdDescription VARCHAR(3000),
    pdusage VARCHAR(1000) NOT NULL,
	photo VARCHAR(1000) NOT NULL,
    FDA CHAR(15) NOT NULL,
    PAO VARCHAR(1000) NOT NULL,
    catid char(8) NOT NULL,
    CONSTRAINT FK_catID FOREIGN KEY (catid)
    REFERENCES Category(cat_id)
);

CREATE TABLE IF NOT EXISTS review (
	pdid CHAR(8) NOT NULL,
    accid CHAR(8) NOT NULL,
	scoreRating INT NOT NULL,
    textReview VARCHAR(1000),
	rvdate DATETIME NOT NULL,
    gender ENUM("Male", "Female", "Not prefer to say") NOT NULL,
    CONSTRAINT PK_review PRIMARY KEY (pdid, accid),
    CONSTRAINT FK_rvpdid FOREIGN KEY (pdid)
    REFERENCES Product(pd_id),
    CONSTRAINT FK_rvaccid FOREIGN KEY (accid)
    REFERENCES account_skin(acc_id)
);

ALTER TABLE review ADD CONSTRAINT 
chk_scoreRating CHECK (scoreRating >= 0 AND scoreRating <= 5);

CREATE TABLE IF NOT EXISTS routineset (
	pdid CHAR(8) NOT NULL,
    accid CHAR(8) NOT NULL,
    stepid CHAR(8) NOT NULL,
	rountine_id CHAR(8) NOT NULL,
    routineName VARCHAR(1000) NOT NULL,
    CONSTRAINT PK_rountine PRIMARY KEY (pdid, accid, stepid),
    CONSTRAINT FK_rtpdid FOREIGN KEY (pdid)
    REFERENCES Product(pd_id),
    CONSTRAINT FK_rtaccid FOREIGN KEY (accid)
    REFERENCES account_skin(acc_id),
    CONSTRAINT FK_rtstepid FOREIGN KEY (stepid)
    REFERENCES Step(step_id)
);

CREATE TABLE IF NOT EXISTS wishlist (
	pdid CHAR(8) NOT NULL,
    accid CHAR(8) NOT NULL,
    dateAdd DATETIME NOT NULL,
    CONSTRAINT PK_wishlist PRIMARY KEY (pdid, accid),
    CONSTRAINT FK_wlpdid FOREIGN KEY (pdid)
    REFERENCES Product(pd_id),
    CONSTRAINT FK_wlaccid FOREIGN KEY (accid)
    REFERENCES account_skin(acc_id)
);

CREATE TABLE IF NOT EXISTS Price (
	sizeid CHAR(8) NOT NULL,
    pdid CHAR(8) NOT NULL,
    price DECIMAL(7,2) NOT NULL,
    CONSTRAINT PK_price PRIMARY KEY (sizeid, pdid),
    CONSTRAINT FK_psizeid FOREIGN KEY (sizeid)
    REFERENCES Size(size_id),
    CONSTRAINT FK_ppdid FOREIGN KEY (pdid)
    REFERENCES Product(pd_id)
);

CREATE TABLE IF NOT EXISTS FavBrand (
    accid CHAR(8) NOT NULL,
    brandid CHAR(8) NOT NULL,
    CONSTRAINT PK_FavBrand PRIMARY KEY (accid, brandid),
    CONSTRAINT FK_fbaccid FOREIGN KEY (accid)
    REFERENCES account_skin(acc_id),
    CONSTRAINT FK_fbbrandid FOREIGN KEY (brandid)
    REFERENCES Brand(brand_id)
);

CREATE TABLE IF NOT EXISTS UserConcern (
    accid CHAR(8) NOT NULL,
    concernid CHAR(8),
    ingdid CHAR(8),
    CONSTRAINT PK_UserConcern PRIMARY KEY (accid, concernid, ingdid),
    CONSTRAINT FK_usaccid FOREIGN KEY (accid)
    REFERENCES account_skin(acc_id),
    CONSTRAINT FK_usconcernid FOREIGN KEY (concernid)
    REFERENCES Concern(concern_id),
    CONSTRAINT FK_usingdid FOREIGN KEY (ingdid)
    REFERENCES Ingredient(ingd_id)
);

CREATE TABLE IF NOT EXISTS ProductSkinType (
    pdid CHAR(8) NOT NULL,
    sktid CHAR(8) NOT NULL,
    CONSTRAINT PK_ProductSkinType PRIMARY KEY (pdid, sktid),
    CONSTRAINT FK_pstpdid FOREIGN KEY (pdid)
    REFERENCES Product(pd_id),
    CONSTRAINT FK_pstsktid FOREIGN KEY (sktid)
    REFERENCES SkinType(skt_id)
);

CREATE TABLE IF NOT EXISTS IngdInProduct (
    pdid CHAR(8) NOT NULL,
    ingdid CHAR(8) NOT NULL,
    CONSTRAINT PK_IngdInProduct PRIMARY KEY (pdid, ingdid),
    CONSTRAINT FK_iippdid FOREIGN KEY (pdid)
    REFERENCES Product(pd_id),
    CONSTRAINT FK_iipingdid FOREIGN KEY (ingdid)
    REFERENCES Ingredient(ingd_id)
);

CREATE TABLE IF NOT EXISTS IngdConcern (
    ingdid CHAR(8) NOT NULL,
    concernid CHAR(8),
    CONSTRAINT PK_IngdConcern PRIMARY KEY (ingdid, concernid),
    CONSTRAINT FK_icingdid FOREIGN KEY (ingdid)
    REFERENCES Ingredient(ingd_id),
    CONSTRAINT FK_icconcernid FOREIGN KEY (concernid)
    REFERENCES Concern(concern_id)
);

CREATE TABLE IF NOT EXISTS BenefitInIngd (
    ingdid CHAR(8) NOT NULL,
    benefitid CHAR(8),
    CONSTRAINT PK_BenefitInIngd PRIMARY KEY (ingdid, benefitid),
    CONSTRAINT FK_biiingdid FOREIGN KEY (ingdid)
    REFERENCES Ingredient(ingd_id),
    CONSTRAINT FK_biibenefitid FOREIGN KEY (benefitid)
    REFERENCES Benefit(benefit_id)
);

CREATE TABLE IF NOT EXISTS ProductBrand (
    brandid CHAR(8) NOT NULL,
    pdid CHAR(8) NOT NULL,
    CONSTRAINT PK_ProductBrand PRIMARY KEY (brandid, pdid),
    CONSTRAINT FK_pbbrandid FOREIGN KEY (brandid)
    REFERENCES Brand(brand_id),
    CONSTRAINT FK_pbpdid FOREIGN KEY (pdid)
    REFERENCES Product(pd_id)
);