create or replace view v1 as
select clients.*,
area.text,
nvl(orders.sum, 0) as summ,
replace(lower(clients.lastname),'а','ь') as lname,

case
when nvl(orders.sum, 0) < 1000 then 'меньше 1000'
else 'больше 1000' end as rr

from clients

left join area on clients.area = area.id
left join orders on orders.client_id=clients.id;

create or replace procedure p1 is
begin
insert into errors (id, errormessage)
values ((select max(id) from errors)+1, sysdate);
end;

BEGIN
DBMS_SCHEDULER.CREATE_JOB(
JOB_NAME => 'job123',
JOB_TYPE => 'stored_procedure',
JOB_ACTION => 'p1',
START_DATE => Sysdate+INTERVAL '10' second,
REPEAT_INTERVAL => 'FREQ=Minutely; INTERVAL=2',
ENABLED => TRUE);
END;

exec dbms_scheduler.drop_job('job123',true)
