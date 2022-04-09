CREATE TABLESPACE TBS_2022 DATAFILE 'C:\oraclexe\app\oracle\oradata\XE\TBS_2022_01.dbf'
size 100M online;

CREATE USER liaten IDENTIFIED BY 0000
default tablespace TBS_2022;

SELECT * FROM DBA_USERS;

GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW,
CREATE PROCEDURE, CREATE TRIGGER, CREATE SEQUENCE TO liaten;

ALTER USER liaten quota unlimited on TBS_2022;

SELECT SYSDATE FROM DUAL; /* ДАТА И ВРЕМЯ */

/*
	DATE FORMAT = DD-MM-YYYY HH24:MI:SS
*/

SELECT TRUNC(SYSDATE) FROM DUAL; /* ВЫВОДИТ НУЛЕВОЕ ВРЕМЯ */

SELECT TO_CHAR(TRUNC(SYSDATE),'DD.MM.YYYY') FROM DUAL; /* ВЫВОДИТ ДАТУ БЕЗ ВРЕМЕНИ */

SELECT TO_CHAR(TRUNC(SYSDATE),'YYYY') AS YEAR FROM DUAL; /* ВЫВОДИТ ГОД */

CREATE TABLE TEST(
	id number,
	login varchar2 (10 BYTE),
	secondname varchar2 (20 CHAR),
	date_ins date,
	date_upd date
);

INSERT INTO TEST(id,login,secondname,date_ins,date_upd)
VALUES (2,'l','p',SYSDATE,SYSDATE);

INSERT ALL
	INTO TEST(id,login,secondname,date_ins,date_upd) VALUES (2,'l','p',SYSDATE,SYSDATE)
	INTO TEST(id,login,secondname,date_ins,date_upd) VALUES (2,'l','p',SYSDATE,SYSDATE)
	INTO TEST(id,login,secondname,date_ins,date_upd) VALUES (2,'l','p',SYSDATE,SYSDATE)
SELECT 1 FROM DUAL;

TRUNCATE TABLE TEST; /* ОЧИСТИТЬ ТАБЛИЦУ */

declare
	i number;
	begin
	FOR i IN 1..10 LOOP
		INSERT INTO TEST(id,login,secondname,date_ins,date_upd)
		VALUES (2,'l','p',SYSDATE,SYSDATE);  
	END LOOP;
end;

delete from test; /* УДАЛИТЬ ЗАПИСИ В ТАБЛИЦУ */

-- найти максимальный id и вставить в конец, коммит нужен чтобы данные не потерялись
declare
	i number;
    max_id number;
	begin
	FOR i IN 1..10 LOOP
    SELECT MAX(ID) into max_id FROM TEST;
		if(i=5) then
			INSERT INTO TEST(id,login,secondname,date_ins,date_upd)
			VALUES (1,'ЁЁЁЁЁЁЁЁЁЁ','p',SYSDATE,SYSDATE);
		else
			INSERT INTO TEST(id,login,secondname,date_ins,date_upd)
			VALUES (max_id+1,'l','p',SYSDATE,SYSDATE);  
		end if;
        commit;
	END LOOP;
end;

-- триггер на добавление строчки
CREATE OR REPLACE TRIGGER TRG
BEFORE INSERT OR UPDATE ON TEST FOR EACH ROW
DECLARE
BEGIN
	IF(INSERTING) THEN
		:new.date_ins:=SYSDATE;
	ELSE
		:new.date_upd:=SYSDATE;
	end if;
END;

-- ИНКРЕМЕНТ
CREATE SEQUENCE SEQ_INF
	MINVALUE 1
	START WITH 1
	INCREMENT BY 1
	NOCACHE;
	
SELECT SEQ.NEXTVAL FROM DUAL;

INSERT INTO TEST(id,login,secondname,date_ins,date_upd)
VALUES (SEQ_INF.NEXTVAL,'l','p',SYSDATE,SYSDATE);
