--    Openbravo POS is a point of sales application designed for touch screens.
--    Copyright (C) 2007-2010 Openbravo, S.L.
--    http://sourceforge.net/projects/openbravopos
--
--    This file is part of Openbravo POS.
--
--    Openbravo POS is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--    Openbravo POS is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with Openbravo POS.  If not, see <http://www.gnu.org/licenses/>.

-- Database initial script for POSTGRESQL
-- v2

CREATE TABLE  APPLICATIONS (
    ID VARCHAR NOT NULL,
    NAME VARCHAR NOT NULL,
    VERSION VARCHAR NOT NULL,
    PRIMARY KEY (ID)
);
INSERT INTO APPLICATIONS(ID, NAME, VERSION) VALUES($APP_ID{}, $APP_NAME{}, $DB_VERSION{});

CREATE TABLE  ROLES (
    ID VARCHAR NOT NULL,
    NAME VARCHAR NOT NULL,
    PERMISSIONS BYTEA,
    PRIMARY KEY (ID)
);
CREATE UNIQUE INDEX ROLES_NAME_INX ON ROLES(NAME);

CREATE TABLE  PEOPLE (
    ID VARCHAR NOT NULL,
    NAME VARCHAR NOT NULL,
    APPPASSWORD VARCHAR,
    CARD VARCHAR,
    ROLE VARCHAR NOT NULL,
    VISIBLE BOOLEAN NOT NULL,
    IMAGE BYTEA,
    PRIMARY KEY (ID),
    CONSTRAINT PEOPLE_FK_1 FOREIGN KEY (ROLE) REFERENCES ROLES(ID)
);
CREATE UNIQUE INDEX PEOPLE_NAME_INX ON PEOPLE(NAME);
CREATE INDEX PEOPLE_CARD_INX ON PEOPLE(CARD);

CREATE TABLE  RESOURCES (
    ID VARCHAR NOT NULL,
    NAME VARCHAR NOT NULL,
    RESTYPE INTEGER NOT NULL,
    CONTENT BYTEA,
    PRIMARY KEY (ID)
);
CREATE UNIQUE INDEX RESOURCES_NAME_INX ON RESOURCES(NAME);

CREATE TABLE  TAXCUSTCATEGORIES (
    ID VARCHAR NOT NULL,
    NAME VARCHAR NOT NULL,
    PRIMARY KEY (ID)
);
CREATE UNIQUE INDEX TAXCUSTCAT_NAME_INX ON TAXCUSTCATEGORIES(NAME);

CREATE TABLE  CUSTOMERS (
    ID VARCHAR NOT NULL,
    SEARCHKEY VARCHAR NOT NULL,
    TAXID VARCHAR,
    NAME VARCHAR NOT NULL,
    TAXCATEGORY VARCHAR,
    CARD VARCHAR,
    MAXDEBT DOUBLE PRECISION DEFAULT 0 NOT NULL,
    ADDRESS VARCHAR,
    ADDRESS2 VARCHAR,
    POSTAL VARCHAR,
    CITY VARCHAR,
    REGION VARCHAR,
    COUNTRY VARCHAR,
    FIRSTNAME VARCHAR,
    LASTNAME VARCHAR,
    EMAIL VARCHAR,
    PHONE VARCHAR,
    PHONE2 VARCHAR,
    FAX VARCHAR,
    NOTES VARCHAR,
    VISIBLE BOOLEAN NOT NULL DEFAULT TRUE,
    CURDATE TIMESTAMP,
    CURDEBT DOUBLE PRECISION,
    PREPAID DOUBLE PRECISION DEFAULT 0 NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT CUSTOMERS_TAXCAT FOREIGN KEY (TAXCATEGORY) REFERENCES TAXCUSTCATEGORIES(ID)
);
CREATE UNIQUE INDEX CUSTOMERS_SKEY_INX ON CUSTOMERS(SEARCHKEY);
CREATE INDEX CUSTOMERS_TAXID_INX ON CUSTOMERS(TAXID);
CREATE INDEX CUSTOMERS_NAME_INX ON CUSTOMERS(NAME);
CREATE INDEX CUSTOMERS_CARD_INX ON CUSTOMERS(CARD);

CREATE TABLE  CATEGORIES (
    ID VARCHAR NOT NULL,
    NAME VARCHAR NOT NULL,
    PARENTID VARCHAR,
    IMAGE BYTEA,
    DISPORDER INTEGER,
    PRIMARY KEY(ID),
    CONSTRAINT CATEGORIES_FK_1 FOREIGN KEY (PARENTID) REFERENCES CATEGORIES(ID)
);
CREATE UNIQUE INDEX CATEGORIES_NAME_INX ON CATEGORIES(NAME);

CREATE TABLE  TAXCATEGORIES (
    ID VARCHAR NOT NULL,
    NAME VARCHAR NOT NULL,
    PRIMARY KEY (ID)
);
CREATE UNIQUE INDEX TAXCAT_NAME_INX ON TAXCATEGORIES(NAME);

CREATE TABLE  TAXES (
    ID VARCHAR NOT NULL,
    NAME VARCHAR NOT NULL,
    VALIDFROM TIMESTAMP DEFAULT '2001-01-01 00:00:00' NOT NULL,
    CATEGORY VARCHAR NOT NULL,
    CUSTCATEGORY VARCHAR,
    PARENTID VARCHAR,
    RATE DOUBLE PRECISION NOT NULL,
    RATECASCADE BOOLEAN NOT NULL DEFAULT FALSE,
    RATEORDER INTEGER,
    PRIMARY KEY(ID),
    CONSTRAINT TAXES_CAT_FK FOREIGN KEY (CATEGORY) REFERENCES TAXCATEGORIES(ID),
    CONSTRAINT TAXES_CUSTCAT_FK FOREIGN KEY (CUSTCATEGORY) REFERENCES TAXCUSTCATEGORIES(ID),
    CONSTRAINT TAXES_TAXES_FK FOREIGN KEY (PARENTID) REFERENCES TAXES(ID)
);
CREATE UNIQUE INDEX TAXES_NAME_INX ON TAXES(NAME);

CREATE TABLE  ATTRIBUTE (
    ID VARCHAR NOT NULL,
    NAME VARCHAR NOT NULL,
    PRIMARY KEY (ID)
);

CREATE TABLE  ATTRIBUTEVALUE (
    ID VARCHAR NOT NULL,
    ATTRIBUTE_ID VARCHAR NOT NULL,
    VALUE VARCHAR,
    PRIMARY KEY (ID),
    CONSTRAINT ATTVAL_ATT FOREIGN KEY (ATTRIBUTE_ID) REFERENCES ATTRIBUTE(ID) ON DELETE CASCADE
);

CREATE TABLE  ATTRIBUTESET (
    ID VARCHAR NOT NULL,
    NAME VARCHAR NOT NULL,
    PRIMARY KEY (ID)
);

CREATE TABLE  ATTRIBUTEUSE (
    ID VARCHAR NOT NULL,
    ATTRIBUTESET_ID VARCHAR NOT NULL,
    ATTRIBUTE_ID VARCHAR NOT NULL,
    LINENO INTEGER,
    PRIMARY KEY (ID),
    CONSTRAINT ATTUSE_SET FOREIGN KEY (ATTRIBUTESET_ID) REFERENCES ATTRIBUTESET(ID) ON DELETE CASCADE,
    CONSTRAINT ATTUSE_ATT FOREIGN KEY (ATTRIBUTE_ID) REFERENCES ATTRIBUTE(ID)
);
CREATE UNIQUE INDEX ATTUSE_LINE ON ATTRIBUTEUSE(ATTRIBUTESET_ID, LINENO);

CREATE TABLE  ATTRIBUTESETINSTANCE (
    ID VARCHAR NOT NULL,
    ATTRIBUTESET_ID VARCHAR NOT NULL,
    DESCRIPTION VARCHAR,
    PRIMARY KEY (ID),
    CONSTRAINT ATTSETINST_SET FOREIGN KEY (ATTRIBUTESET_ID) REFERENCES ATTRIBUTESET(ID) ON DELETE CASCADE
);

CREATE TABLE  ATTRIBUTEINSTANCE (
    ID VARCHAR NOT NULL,
    ATTRIBUTESETINSTANCE_ID VARCHAR NOT NULL,
    ATTRIBUTE_ID VARCHAR NOT NULL,
    VALUE VARCHAR,
    PRIMARY KEY (ID),
    CONSTRAINT ATTINST_SET FOREIGN KEY (ATTRIBUTESETINSTANCE_ID) REFERENCES ATTRIBUTESETINSTANCE(ID) ON DELETE CASCADE,
    CONSTRAINT ATTINST_ATT FOREIGN KEY (ATTRIBUTE_ID) REFERENCES ATTRIBUTE(ID)
);

CREATE TABLE  PRODUCTS (
    ID VARCHAR NOT NULL,
    REFERENCE VARCHAR NOT NULL,
    CODE VARCHAR,
    CODETYPE VARCHAR,
    NAME VARCHAR NOT NULL,
    PRICEBUY DOUBLE PRECISION,
    PRICESELL DOUBLE PRECISION NOT NULL,
    CATEGORY VARCHAR NOT NULL,
    TAXCAT VARCHAR NOT NULL,
    ATTRIBUTESET_ID VARCHAR,
    STOCKCOST DOUBLE PRECISION,
    STOCKVOLUME DOUBLE PRECISION,
    IMAGE BYTEA,
    ISCOM BOOLEAN NOT NULL DEFAULT FALSE,
    ISSCALE BOOLEAN NOT NULL DEFAULT FALSE,
    ATTRIBUTES BYTEA,
    DISCOUNTENABLED BOOLEAN NOT NULL DEFAULT FALSE,
    DISCOUNTRATE DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    PRIMARY KEY (ID),
    CONSTRAINT PRODUCTS_FK_1 FOREIGN KEY (CATEGORY) REFERENCES CATEGORIES(ID),
    CONSTRAINT PRODUCTS_TAXCAT_FK FOREIGN KEY (TAXCAT) REFERENCES TAXCATEGORIES(ID),
    CONSTRAINT PRODUCTS_ATTRSET_FK FOREIGN KEY (ATTRIBUTESET_ID) REFERENCES ATTRIBUTESET(ID)
);
CREATE UNIQUE INDEX PRODUCTS_INX_0 ON PRODUCTS(REFERENCE);
CREATE UNIQUE INDEX PRODUCTS_NAME_INX ON PRODUCTS(NAME);

CREATE TABLE  PRODUCTS_CAT (
    PRODUCT VARCHAR NOT NULL,
    CATORDER INTEGER,
    PRIMARY KEY (PRODUCT),
    CONSTRAINT PRODUCTS_CAT_FK_1 FOREIGN KEY (PRODUCT) REFERENCES PRODUCTS(ID)
);
CREATE INDEX PRODUCTS_CAT_INX_1 ON PRODUCTS_CAT(CATORDER);

CREATE TABLE  PRODUCTS_COM (
    ID VARCHAR NOT NULL,
    PRODUCT VARCHAR NOT NULL,
    PRODUCT2 VARCHAR NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT PRODUCTS_COM_FK_1 FOREIGN KEY (PRODUCT) REFERENCES PRODUCTS(ID),
    CONSTRAINT PRODUCTS_COM_FK_2 FOREIGN KEY (PRODUCT2) REFERENCES PRODUCTS(ID)
);
CREATE UNIQUE INDEX PCOM_INX_PROD ON PRODUCTS_COM(PRODUCT, PRODUCT2);

CREATE TABLE SUBGROUPS (
    ID VARCHAR NOT NULL,
    COMPOSITION VARCHAR NOT NULL,
    NAME VARCHAR NOT NULL,
    IMAGE BYTEA,
    DISPORDER INTEGER,
    PRIMARY KEY(ID),
    CONSTRAINT SUBGROUPS_FK_1 FOREIGN KEY (COMPOSITION) REFERENCES PRODUCTS(ID) ON DELETE CASCADE
);

CREATE TABLE SUBGROUPS_PROD (
    SUBGROUP VARCHAR NOT NULL,
    PRODUCT VARCHAR NOT NULL,
    PRIMARY KEY (SUBGROUP, PRODUCT),
    CONSTRAINT SUBGROUPS_PROD_FK_1 FOREIGN KEY (SUBGROUP) REFERENCES SUBGROUPS(ID) ON DELETE CASCADE,
    CONSTRAINT SUBGROUPS_PROD_FK_2 FOREIGN KEY (PRODUCT) REFERENCES PRODUCTS(ID) ON DELETE CASCADE
);

CREATE TABLE TARIFFAREAS (
    ID VARCHAR NOT NULL,
    NAME VARCHAR NOT NULL,
    TARIFFORDER INTEGER DEFAULT 0,
    PRIMARY KEY(ID)
);
CREATE UNIQUE INDEX TARIFFAREAS_NAME_INX ON TARIFFAREAS(NAME);

CREATE TABLE TARIFFAREAS_PROD (
    TARIFFID VARCHAR NOT NULL,
    PRODUCTID VARCHAR NOT NULL,
    PRICESELL DOUBLE PRECISION NOT NULL,
    PRIMARY KEY (TARIFFID, PRODUCTID),
    CONSTRAINT TARIFFAREAS_PROD_FK_1 FOREIGN KEY (TARIFFID) REFERENCES TARIFFAREAS(ID) ON DELETE CASCADE,
    CONSTRAINT TARIFFAREAS_PROD_FK_2 FOREIGN KEY (PRODUCTID) REFERENCES PRODUCTS(ID) ON DELETE CASCADE
);

CREATE TABLE  LOCATIONS (
    ID VARCHAR NOT NULL,
    NAME VARCHAR NOT NULL,
    ADDRESS VARCHAR,
    PRIMARY KEY (ID)
);
CREATE UNIQUE INDEX LOCATIONS_NAME_INX ON LOCATIONS(NAME);

CREATE TABLE  STOCKDIARY (
    ID VARCHAR NOT NULL,
    DATENEW TIMESTAMP NOT NULL,
    REASON INTEGER NOT NULL,
    LOCATION VARCHAR NOT NULL,
    PRODUCT VARCHAR NOT NULL,
    ATTRIBUTESETINSTANCE_ID VARCHAR,
    UNITS DOUBLE PRECISION NOT NULL,
    PRICE DOUBLE PRECISION NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT STOCKDIARY_FK_1 FOREIGN KEY (PRODUCT) REFERENCES PRODUCTS(ID),
    CONSTRAINT STOCKDIARY_ATTSETINST FOREIGN KEY (ATTRIBUTESETINSTANCE_ID) REFERENCES ATTRIBUTESETINSTANCE(ID),
    CONSTRAINT STOCKDIARY_FK_2 FOREIGN KEY (LOCATION) REFERENCES LOCATIONS(ID)
);
CREATE INDEX STOCKDIARY_INX_1 ON STOCKDIARY(DATENEW);

CREATE TABLE  STOCKLEVEL (
    ID VARCHAR NOT NULL,
    LOCATION VARCHAR NOT NULL,
    PRODUCT VARCHAR NOT NULL,
    STOCKSECURITY DOUBLE PRECISION,
    STOCKMAXIMUM DOUBLE PRECISION,
    PRIMARY KEY (ID),
    CONSTRAINT STOCKLEVEL_PRODUCT FOREIGN KEY (PRODUCT) REFERENCES PRODUCTS(ID),
    CONSTRAINT STOCKLEVEL_LOCATION FOREIGN KEY (LOCATION) REFERENCES LOCATIONS(ID)
);

CREATE TABLE  STOCKCURRENT (
    LOCATION VARCHAR NOT NULL,
    PRODUCT VARCHAR NOT NULL,
    ATTRIBUTESETINSTANCE_ID VARCHAR,
    UNITS DOUBLE PRECISION NOT NULL,
    CONSTRAINT STOCKCURRENT_FK_1 FOREIGN KEY (PRODUCT) REFERENCES PRODUCTS(ID),
    CONSTRAINT STOCKCURRENT_ATTSETINST FOREIGN KEY (ATTRIBUTESETINSTANCE_ID) REFERENCES ATTRIBUTESETINSTANCE(ID),
    CONSTRAINT STOCKCURRENT_FK_2 FOREIGN KEY (LOCATION) REFERENCES LOCATIONS(ID)
);
CREATE UNIQUE INDEX STOCKCURRENT_INX ON STOCKCURRENT(LOCATION, PRODUCT, ATTRIBUTESETINSTANCE_ID);

CREATE TABLE  CLOSEDCASH (
    MONEY VARCHAR NOT NULL,
    HOST VARCHAR NOT NULL,
    HOSTSEQUENCE INTEGER NOT NULL,
    DATESTART TIMESTAMP,
    DATEEND TIMESTAMP,
    PRIMARY KEY(MONEY)
);
CREATE INDEX CLOSEDCASH_INX_1 ON CLOSEDCASH(DATESTART);
CREATE UNIQUE INDEX CLOSEDCASH_INX_SEQ ON CLOSEDCASH(HOST, HOSTSEQUENCE);

CREATE TABLE  RECEIPTS (
    ID VARCHAR NOT NULL,
    MONEY VARCHAR NOT NULL,
    DATENEW TIMESTAMP NOT NULL,
    ATTRIBUTES BYTEA,
    PRIMARY KEY(ID),
    CONSTRAINT RECEIPTS_FK_MONEY FOREIGN KEY (MONEY) REFERENCES CLOSEDCASH(MONEY)
);
CREATE INDEX RECEIPTS_INX_1 ON RECEIPTS(DATENEW);

CREATE TABLE  TICKETS (
    ID VARCHAR NOT NULL,
    TICKETTYPE INTEGER DEFAULT 0 NOT NULL,
    TICKETID INTEGER NOT NULL,
    PERSON VARCHAR NOT NULL,
    CUSTOMER VARCHAR,
    STATUS INTEGER DEFAULT 0 NOT NULL,
    CUSTCOUNT INTEGER DEFAULT NULL,
    TARIFFAREA VARCHAR DEFAULT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT TICKETS_FK_ID FOREIGN KEY (ID) REFERENCES RECEIPTS(ID),
    CONSTRAINT TICKETS_FK_2 FOREIGN KEY (PERSON) REFERENCES PEOPLE(ID),
    CONSTRAINT TICKETS_CUSTOMERS_FK FOREIGN KEY (CUSTOMER) REFERENCES CUSTOMERS(ID),
    CONSTRAINT TICKETS_TARIFFAREA FOREIGN KEY (TARIFFAREA) REFERENCES TARIFFAREAS(ID)
);
CREATE INDEX TICKETS_TICKETID ON TICKETS(TICKETTYPE, TICKETID);

CREATE SEQUENCE TICKETSNUM START WITH 1;
CREATE SEQUENCE TICKETSNUM_REFUND START WITH 1;
CREATE SEQUENCE TICKETSNUM_PAYMENT START WITH 1;

CREATE TABLE  TICKETLINES (
    TICKET VARCHAR NOT NULL,
    LINE INTEGER NOT NULL,
    PRODUCT VARCHAR,
    ATTRIBUTESETINSTANCE_ID VARCHAR,
    UNITS DOUBLE PRECISION NOT NULL,
    PRICE DOUBLE PRECISION NOT NULL,
    TAXID VARCHAR NOT NULL,
    ATTRIBUTES BYTEA,
    PRIMARY KEY (TICKET, LINE),
    CONSTRAINT TICKETLINES_FK_TICKET FOREIGN KEY (TICKET) REFERENCES TICKETS(ID),
    CONSTRAINT TICKETLINES_FK_2 FOREIGN KEY (PRODUCT) REFERENCES PRODUCTS(ID),
    CONSTRAINT TICKETLINES_ATTSETINST FOREIGN KEY (ATTRIBUTESETINSTANCE_ID) REFERENCES ATTRIBUTESETINSTANCE(ID),
    CONSTRAINT TICKETLINES_FK_3 FOREIGN KEY (TAXID) REFERENCES TAXES(ID)
);

CREATE TABLE  PAYMENTS (
    ID VARCHAR NOT NULL,
    RECEIPT VARCHAR NOT NULL,
    PAYMENT VARCHAR NOT NULL,
    TOTAL DOUBLE PRECISION NOT NULL,
    TRANSID VARCHAR,
    RETURNMSG BYTEA,
    PRIMARY KEY (ID),
    CONSTRAINT PAYMENTS_FK_RECEIPT FOREIGN KEY (RECEIPT) REFERENCES RECEIPTS(ID)
);
CREATE INDEX PAYMENTS_INX_1 ON PAYMENTS(PAYMENT);

CREATE TABLE  TAXLINES (
    ID VARCHAR NOT NULL,
    RECEIPT VARCHAR NOT NULL,
    TAXID VARCHAR NOT NULL, 
    BASE DOUBLE PRECISION NOT NULL, 
    AMOUNT DOUBLE PRECISION NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT TAXLINES_TAX FOREIGN KEY (TAXID) REFERENCES TAXES(ID),
    CONSTRAINT TAXLINES_RECEIPT FOREIGN KEY (RECEIPT) REFERENCES RECEIPTS(ID)
);

CREATE TABLE  FLOORS (
    ID VARCHAR NOT NULL,
    NAME VARCHAR NOT NULL,
    IMAGE BYTEA,
    PRIMARY KEY (ID)
);
CREATE UNIQUE INDEX FLOORS_NAME_INX ON FLOORS(NAME);

CREATE TABLE  PLACES (
    ID VARCHAR NOT NULL,
    NAME VARCHAR NOT NULL,
    X INTEGER NOT NULL,
    Y INTEGER NOT NULL,
    FLOOR VARCHAR NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT PLACES_FK_1 FOREIGN KEY (FLOOR) REFERENCES FLOORS(ID)
);
CREATE UNIQUE INDEX PLACES_NAME_INX ON PLACES(NAME);

CREATE TABLE  RESERVATIONS (
    ID VARCHAR NOT NULL,
    CREATED TIMESTAMP NOT NULL,
    DATENEW TIMESTAMP DEFAULT '2001-01-01 00:00:00' NOT NULL,
    TITLE VARCHAR NOT NULL,
    CHAIRS INTEGER NOT NULL,
    ISDONE BOOLEAN NOT NULL,
    DESCRIPTION VARCHAR,
    PRIMARY KEY (ID)
);
CREATE INDEX RESERVATIONS_INX_1 ON RESERVATIONS(DATENEW);

CREATE TABLE  RESERVATION_CUSTOMERS (
    ID VARCHAR NOT NULL,
    CUSTOMER VARCHAR NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT RES_CUST_FK_1 FOREIGN KEY (ID) REFERENCES RESERVATIONS(ID),
    CONSTRAINT RES_CUST_FK_2 FOREIGN KEY (CUSTOMER) REFERENCES CUSTOMERS(ID)
);

CREATE TABLE  THIRDPARTIES (
    ID VARCHAR NOT NULL,
    CIF VARCHAR NOT NULL,
    NAME VARCHAR NOT NULL,
    ADDRESS VARCHAR,
    CONTACTCOMM VARCHAR,
    CONTACTFACT VARCHAR,
    PAYRULE VARCHAR,
    FAXNUMBER VARCHAR,
    PHONENUMBER VARCHAR,
    MOBILENUMBER VARCHAR,
    EMAIL VARCHAR,
    WEBPAGE VARCHAR,
    NOTES VARCHAR,
    PRIMARY KEY (ID)
);
CREATE UNIQUE INDEX THIRDPARTIES_CIF_INX ON THIRDPARTIES(CIF);
CREATE UNIQUE INDEX THIRDPARTIES_NAME_INX ON THIRDPARTIES(NAME);

CREATE TABLE  SHAREDTICKETS (
    ID VARCHAR NOT NULL,
    NAME VARCHAR NOT NULL,
    CONTENT BYTEA,
    PRIMARY KEY(ID)
);
