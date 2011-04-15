-- create schema for data
CREATE TABLE members(
  MemberID integer,
  sex varchar,
  AgeAtFirstClaim varchar
);
CREATE INDEX members_memberID ON members (MemberID);

CREATE TABLE conditions (
  PrimaryConditionGroup varchar,
  Description varchar
);
CREATE INDEX condition_group ON conditions (PrimaryConditionGroup);

CREATE TABLE claims_y1 (
  MemberID integer,
  ProviderID integer,
  vendor integer,
  pcp integer,
  Year varchar,
  specialty varchar,
  placesvc varchar,
  paydelay integer,
  LengthOfStay varchar,
  dsfs varchar,
  PrimaryConditionGroup varchar,
  CharlsonIndex varchar
);
CREATE INDEX claims_y1_memberID ON claims_y1 (memberid);

create table days_in_hospital_y2(
  memberid integer,
  DaysInHospital_Y2 integer
);
CREATE INDEX days_in_hospital_y2_memberID ON members (memberid);

-- after schem is created, load the files
\copy members from 'Members_Y1.csv' with CSV HEADER
\copy conditions from 'Lookup PrimaryConditionGroup.csv' with CSV HEADER
\copy days_in_hospital_y2 from 'DayInHospital_Y2.csv' with CSV HEADER
\copy claims_y1 from 'Claims_Y1.csv' with CSV HEADER


-- NOT PART OF HHP DATA SET:
-- add lookup table of length of stays days for convenience
CREATE TABLE length_of_stay(
  name varchar,
  days int
);
insert into length_of_stay values ('1 day', 1);
insert into length_of_stay values ('2 days', 2);
insert into length_of_stay values ('3 days', 3);
insert into length_of_stay values ('4 days', 4);
insert into length_of_stay values ('5 days', 5);
insert into length_of_stay values ('6 days', 6);
insert into length_of_stay values ('1- 2 weeks', 1*7);
insert into length_of_stay values ('2- 4 weeks', 2*7);
insert into length_of_stay values ('8-12 weeks', 8*7);
insert into length_of_stay values ('12-26 weeks', 12*7);
insert into length_of_stay values ('26+ weeks', 26*7);
insert into length_of_stay values (null, 0);

