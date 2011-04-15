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