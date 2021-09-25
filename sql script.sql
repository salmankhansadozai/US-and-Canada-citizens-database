set autocommit = 0;

CREATE TABLE nationality (
    nationality_id INT,
    nationality VARCHAR(3),
    PRIMARY KEY (nationality_id)
);

CREATE TABLE citizens (
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    company_name VARCHAR(255),
    address VARCHAR(255),
    city VARCHAR(255),
    county VARCHAR(255),
    province VARCHAR(2),
    state VARCHAR(2),
    postal VARCHAR(7),
    zip VARCHAR(5),
    phone1 VARCHAR(20),
    phone2 VARCHAR(20),
    email VARCHAR(255),
    web VARCHAR(255),
    nationality_id INT,
    FOREIGN KEY (nationality_id)
        REFERENCES nationality (nationality_id)
);

-- import data from ca-500 csv using import wizard 
commit;

select * from citizens;

insert into nationality 
values (1, 'ca');
commit;

insert into nationality 
values (2, 'us');
commit;

select * from nationality;

UPDATE citizens 
SET 
    nationality_id = 1
WHERE
    state IS NULL;
commit;

select * from citizens;

-- import data from us-500 csv using import wizard 

UPDATE citizens 
SET 
    nationality_id = 2
WHERE
    state IS not NULL;
commit;
    
select * from citizens where nationality_id = 2;

-- trigger for keeping a record of new inserted records

create table counter (
	nationality varchar(10),
    rows_inserted int default 0
);

insert into counter (nationality)
values ('ca'),('us');

select * from counter;

delimiter $$
create trigger record_of_rows
after insert on citizens
for each row
begin
if new.nationality_id = 1
then 
	update counter 
	set rows_inserted = rows_inserted + 1
	where nationality = 'ca';
else 
	update counter 
	set rows_inserted = rows_inserted + 1
	where nationality = 'us';
end if;
end$$
delimiter ;
commit;

-- test the trigger

insert into citizens (first_name, last_name, address, city, province, postal, phone1, email, nationality_id)
values ('salman', 'khan', '21 Broadbridge dr.', 'toronto', 'ON', 'M1C 3K5', '647 786 4204', 'salmankhansadozai@gmail.com', 1),
		('salman', 'khan', '21 Broadbridge dr.', 'toronto', 'ON', 'M1C 3K5', '647 786 4204', 'salmankhansadozai@gmail.com', 1);

select * from counter;

select * from citizens where first_name = 'salman';

-- reset to table before the inserts
rollback;

-- procedure for when passed a country, returns every citizen record for that country. This procedure should also reset the counter for the country requested to 0

delimiter $$
create procedure get_records_by_country (
	in country varchar(2)
)
begin 
select * 
from citizens c
join nationality n on n.nationality_id = c.nationality_id
where n.nationality = country;
end$$
delimiter ;

call get_records_by_country('ca');

call get_records_by_country('us');
