DROP TABLE users;
DROP TABLE subscriptions;
DROP TABLE audio_recordings;
DROP TABLE images;
DROP TABLE scalar_data;
DROP TABLE persons;
DROP TABLE sensors;
/*
 *  To store the personal information
 */
CREATE TABLE persons (
       person_id int,
       first_name varchar(24),
       last_name  varchar(24),
       address    varchar(128),
       email      varchar(128),
       phone      char(10),
       PRIMARY KEY(person_id),
       UNIQUE (email)
) tablespace c391ware;

/*
 * To store user info
 * role: 'a'->administrator
 * role: 'd'->data curator
 * role: 's'->scientist
 */
CREATE TABLE users (
    user_name           varchar(32),
    password            varchar(32),
    role                char(1),
    person_id           int,
    date_registered     date,
    CHECK (role in ('a', 'd', 's')),
    PRIMARY KEY(user_name),
    FOREIGN KEY(person_id) REFERENCES persons
) tablespace c391ware;

/*
 * To store sensor info
 * sensor_type: 'a'->audio recorder
 * sensor_type: 'i'->image recorder
 * sensor_type: 's'->scalar value recorder
 */

CREATE TABLE sensors(
    sensor_id    int,
    location     varchar(64),
    sensor_type  char(1),
    description  varchar(128),
    CHECK(sensor_type in ('a', 'i', 's')),
    PRIMARY KEY(sensor_id)
) tablespace c391ware;

/*
 * subscription relations
 */

CREATE TABLE subscriptions(
    sensor_id    int,
    person_id    int,
    PRIMARY KEY(sensor_id, person_id),
    FOREIGN KEY(person_id) REFERENCES persons,
    FOREIGN KEY(sensor_id) REFERENCES sensors
) tablespace c391ware;

/*
 * audio
 */

CREATE TABLE audio_recordings(
    recording_id int,
    sensor_id int,
    date_created date,
    length int,
    description varchar(128),
    recorded_data blob,
    PRIMARY KEY(recording_id),
    FOREIGN KEY(sensor_id) REFERENCES sensors
) tablespace c391ware;

/*
 * image
 */

CREATE TABLE images(
    image_id int,
    sensor_id int,
    date_created date,
    description varchar(128),
    thumbnail blob,
    recoreded_data blob,
    PRIMARY KEY(image_id),
    FOREIGN KEY(sensor_id) REFERENCES sensors
) tablespace c391ware;

/*
 * scalar
 */

CREATE TABLE scalar_data(
    id int,
    sensor_id int,
    date_created date,
    value float,
    PRIMARY KEY(id),
    FOREIGN KEY(sensor_id) REFERENCES sensors
) tablespace c391ware;

commit;
