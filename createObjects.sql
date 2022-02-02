--ADMIN--
create table 
admin(admin_id varchar2(10) constraint pk_admin_id primary key,
admin_name varchar2(50),
password varchar2(50)            
);

--USERS--
create table users(user_id varchar2(20) constraint pk_user_id primary key ,
user_name varchar2(50),
email varchar(50) unique,
password varchar2(50) not null,
phone_number varchar2(20),
address varchar2(50),
date_of_registration date default sysdate                         
);
CREATE SEQUENCE user_id_seq;

CREATE OR REPLACE TRIGGER user_tgr
    BEFORE INSERT
    ON users
    REFERENCING NEW AS NEW OLD AS OLD
    FOR EACH ROW
BEGIN
    IF :NEW.user_id IS NULL THEN
        SELECT 'C'||TO_CHAR(user_id_seq.NEXTVAL,'0000000') INTO :NEW.user_id FROM DUAL;
    END IF;
END;

--CATEGORY--
CREATE TABLE CATEGORIES (
CATEGORY_ID VARCHAR(7)PRIMARY KEY,
CATEGORY_NAME VARCHAR(23)
);
create sequence auto_increment_cat_id;
create trigger trg_auto_cat_id 
       before insert on CATEGORIES
       for each row
begin
   select 'U'||trim(to_char(auto_increment_cat_id.nextval, '00099'))
         into :new.CATEGORY_ID
         from dual;
end;

--PRODUCTS--
CREATE TABLE PRODUCT(
PRODUCT_ID VARCHAR(7)PRIMARY KEY,
PRODUCT_NAME VARCHAR(23),
CATEGORY_ID VARCHAR(5) REFERENCES CATEGORIES(CATEGORY_ID),
PRODUCT_PRICE NUMBER,
PRODUCT_IMAGE VARCHAR2(23),
PRODUCT_AVAILABLE_QTY NUMBER
);
create sequence auto_increment_prod_id;
create trigger trg_auto_prod_id 
       before insert on PRODUCT
       for each row
begin
   select 'U'||trim(to_char(auto_increment_prod_id.nextval, '00099'))
         into :new.PRODUCT_ID
         from dual;
end;

--CART--
CREATE TABLE CART(
CART_ID VARCHAR(7)PRIMARY KEY,
USER_ID VARCHAR(7)REFERENCES USERS(USER_ID)
);
create sequence auto_increment_cart_id;

create trigger trg_auto_cart_id 
       before insert on CART
       for each row
begin
   select 'U'||trim(to_char(auto_increment_cart_id.nextval, '00099'))
         into :new.CART_ID
         from dual;
end;

--CART_ITEMS--
CREATE TABLE CART_ITEMS (
CART_ID VARCHAR(7)REFERENCES CART(CART_ID),
USER_ID VARCHAR(7)REFERENCES USERS(USER_ID),
PRODUCT_ID VARCHAR(7) REFERENCES PRODUCT(PRODUCT_ID),
PRODUCT_QTY VARCHAR(5)
);

--COUPON--
CREATE TABLE COUPON (
COUPON_ID VARCHAR(7) PRIMARY KEY,
COUPON_NAME VARCHAR(23),
DISCOUNT_VAL NUMBER,
EXP_DATE DATE
);

create sequence auto_increment_coupon_id;

create trigger trg_auto_coupon_id 
       before insert on COUPON
       for each row
begin
   select 'U'||trim(to_char(auto_increment_coupon_id.nextval, '00099'))
         into :new.COUPON_ID
         from dual;
end;

--ORDER--
CREATE TABLE ORDERS(
ORDER_ID VARCHAR(7)PRIMARY KEY,
CART_ID VARCHAR(7)REFERENCES CART(CART_ID),
USER_ID VARCHAR(7)REFERENCES USERS(USER_ID),
ORDER_DATE DATE DEFAULT SYSDATE NOT NULL,
DELIVERY_DATE DATE DEFAULT SYSDATE + 7,
COUPON_ID VARCHAR(7),
BILL_AMOUNT NUMBER,
PAYMENT_METHOD VARCHAR(23) CONSTRAINT PM_CHECK CHECK(LOWER(PAYMENT_METHOD)IN('cod', 'debit/credit card', 'online wallet'))
);
create sequence auto_increment_order_id;

create trigger trg_auto_order_id 
       before insert on ORDERS
       for each row
begin
   select 'U'||trim(to_char(auto_increment_order_id.nextval, '00099'))
         into :new.ORDER_ID
         from dual;
end;