-- NOTE: Use Fill Series option of the spread sheet processor to generate teiiid.
-- Start with a large number

DROP table IF EXISTS temp_data;

CREATE TABLE IF NOT EXISTS temp_data
(
    teiid                   integer,
    dob                     text,
    age                     integer,
    health_facility_name    text,
    patient_name            text,
    sex                     character,
    phone_no                text,
    address                 text,
    state_residence         text,
    lga_residence           text,
    hospital_number         text,
    patient_consent         text,
    qr_code                 text,
    supporter_name          text,
    supporter_phone         text,
    supp_relationship       text,
    has_diabetes            text,
    diabetes_treat_past     text,
    has_hypertension        text,
    hypertension_treat_past text,
    visit_1_date            text,
    visit_1_systolic        integer,
    visit_1_diastolic       integer,
    visit_1_medicines       text,
    visit_2_date            text,
    visit_2_systolic        integer,
    visit_2_diastolic       integer,
    visit_2_medicines       text,
    visit_3_date            text,
    visit_3_systolic        integer,
    visit_3_diastolic       integer,
    visit_3_medicines       text,
    visit_4_date            text,
    visit_4_systolic        integer,
    visit_4_diastolic       integer,
    visit_4_medicines       text,
    visit_5_date            text,
    visit_5_systolic        integer,
    visit_5_diastolic       integer,
    visit_5_medicines       text,
    visit_6_date            text,
    visit_6_systolic        integer,
    visit_6_diastolic       integer,
    visit_6_medicines       text,
    visit_7_date            text,
    visit_7_systolic        integer,
    visit_7_diastolic       integer,
    visit_7_medicines       text,
    visit_8_date            text,
    visit_8_systolic        integer,
    visit_8_diastolic       integer,
    visit_8_medicines       text,
    visit_9_date            text,
    visit_9_systolic        integer,
    visit_9_diastolic       integer,
    visit_9_medicines       text,
    visit_10_date           text,
    visit_10_systolic       integer,
    visit_10_diastolic      integer,
    visit_10_medicines      text
);

-- Copy the data file into the DB instance
-- Copying CSV data in raw format to the table
COPY temp_data
    FROM '/data/Legacy_Data_Sample.csv'
    DELIMITER ','
    CSV HEADER;

-- Finding the OU Numeric ID
select *
from organisationunit
where uid = 'uid';

--- Loading data trackedentityinstance Table
INSERT INTO trackedentityinstance (trackedentityinstanceid, uid, created,
                                   lastupdated, deleted, organisationunitid,
                                   trackedentitytypeid, lastupdatedby, createdatclient, lastupdatedatclient, inactive)
    (SELECT m.teiid::int,
            generate_uid(),
            now(),
            now(),
            false,
            43498,
            73828,
            75,
            now(),
            now(),
            false
     FROM temp_data m)
ON CONFLICT DO NOTHING;

-- Creating Enrollments
INSERT INTO programinstance (programinstanceid, uid, created, lastupdated, deleted, enrollmentdate,
                             trackedentityinstanceid,
                             programid, organisationunitid, storedby, status, createdatclient, lastupdatedatclient,
                             incidentdate)
SELECT nextval('hibernate_sequence'),
       generate_uid(),
       now(),
       now(),
       false,
       now(),
       t.teiid::int,
       73867,
       43498,
       'akumbabarns',
       'ACTIVE',
       now(),
       now(),
       now()
FROM temp_data t;


-- adding ownership
INSERT INTO trackedentityprogramowner
SELECT nextval('hibernate_sequence'), m.teiid::int, 73867, now(), now(), 43498, 'akumbabarns'
FROM temp_data m;

-- Finding the TEI Att ID
select *
from trackedentityattribute;

-- adding age
INSERT INTO trackedentityattributevalue (trackedentityinstanceid, trackedentityattributeid, created, lastupdated, value,
                                         storedby)
SELECT t.teiid::int, 73810, now(), now(), t.age, 'akumbabarns'
FROM temp_data t;

-- patient_name
INSERT INTO trackedentityattributevalue (trackedentityinstanceid, trackedentityattributeid, created, lastupdated, value,
                                         storedby)
SELECT t.teiid::int, 73818, now(), now(), t.patient_name, 'akumbabarns'
FROM temp_data t;

-- Adding Events

INSERT INTO public.programstageinstance (programstageinstanceid, uid, code, created, lastupdated, createdatclient,
                                         lastupdatedatclient, lastsynchronized, programinstanceid, programstageid,
                                         attributeoptioncomboid, deleted, storedby, duedate, executiondate,
                                         organisationunitid, status, completedby, completeddate, geometry,
                                         eventdatavalues, assigneduserid, createdbyuserinfo, lastupdatedbyuserinfo)
SELECT nextval('hibernate_sequence'),
       generate_uid(),
       null,
       now(),
       now(),
       null,
       null,
       now(),
       pi.programinstanceid,
       73847,
       24,
       false,
       'akumbabarns',
       now(),
       now(),
       43498,
       'ACTIVE',
       null,
       null,
       null,
       concat('{
     "CZPgB1WuEp0": {
       "value": "', t.visit_1_diastolic, '",
       "created": "', now(), '",
       "lastUpdated": "', now(), '",
       "createdByUserInfo": {
          "id": 61385,
          "uid": "LL20yR5Lozr",
          "surname": "Akumba",
          "username": "akumbabarns",
          "firstName": "Barnabas"
        },
       "providedElsewhere": false,
       "lastUpdatedByUserInfo": {
          "id": 61385,
          "uid": "LL20yR5Lozr",
          "surname": "Akumba",
          "username": "akumbabarns",
          "firstName": "Barnabas"
        }
     },"J2YWUFBEyvZ": {
       "value": "', t.visit_1_diastolic, '",
       "created": "', now(), '",
       "lastUpdated": "', now(), '",
       "createdByUserInfo": {
          "id": 61385,
          "uid": "LL20yR5Lozr",
          "surname": "Akumba",
          "username": "akumbabarns",
          "firstName": "Barnabas"
        },
       "providedElsewhere": false,
       "lastUpdatedByUserInfo": {
          "id": 61385,
          "uid": "LL20yR5Lozr",
          "surname": "Akumba",
          "username": "akumbabarns",
          "firstName": "Barnabas"
        }
     }}')::jsonb,
       null,
       '{
          "id": 61385,
          "uid": "LL20yR5Lozr",
          "surname": "Akumba",
          "username": "akumbabarns",
          "firstName": "Barnabas"
        }',
       '{
          "id": 61385,
          "uid": "LL20yR5Lozr",
          "surname": "Akumba",
          "username": "akumbabarns",
          "firstName": "Barnabas"
        }'
FROM temp_data t
         JOIN programinstance pi on t.teiid = pi.trackedentityinstanceid
where t.visit_1_date <> '';



