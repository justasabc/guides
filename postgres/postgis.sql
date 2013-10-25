-- sudo passwd postgres # 111
-- su postgres # MUST CHANGE USER TO "postgres"

-- Database: testdb
-- DROP DATABASE testdb;
CREATE DATABASE testdb;

-- Add postgis and postgis_topology extension to make testdb from normal db to PostGIS db
-- Extension: postgis
-- DROP EXTENSION postgis;
CREATE EXTENSION postgis SCHEMA public VERSION "2.0.1";

-- Extension: postgis_topology
-- DROP EXTENSION postgis_topology;
CREATE EXTENSION postgis_topology SCHEMA topology VERSION "2.0.1";

-- Schema: topology
-- DROP SCHEMA topology;
CREATE SCHEMA topology AUTHORIZATION postgres;

-- SAMPLE
-- 'POINT(10 10)'
-- 'MULTIPOINT(10 10,20 20)'
-- 'LINESTRING(10 10,20 20,30 30)'
-- 'MULTILINESTRING((10 10,20 20),(20 20,30 30))'
-- 'POLYGON((10 10,10 20,20 20,20 10,10 10))'

-- POINT
CREATE TABLE point 
(
	oid SERIAL,
	name VARCHAR,
	CONSTRAINT point_pkey PRIMARY KEY (oid)
);

-- create table(tablename geometrytype)
CREATE TABLE point2 ( oid SERIAL PRIMARY KEY, name VARCHAR); SELECT AddGeometryColumn('public','point2','geom',0,'POINT',2);
-- drop table(tablename)
DROP TABLE point2;

-- add geometry column
SELECT AddGeometryColumn('point','geom',0,'POINT',2);

-- test
SELECT AddGeometryColumn('public','point','geom',0,'POINT',2);
SELECT AddGeometryColumn('public','point','geom',0,'MULTIPOINT',2);
SELECT AddGeometryColumn('point','geom',0,'LINESTRING',2);
SELECT AddGeometryColumn('point','geom',0,'MULTILINESTRING',2);
SELECT AddGeometryColumn('point','geom',0,'POLYGON',2);
SELECT AddGeometryColumn('point','geom',0,'MULTIPOLYGON',2);

-- insert
INSERT INTO point(name,geom) VALUES('red',ST_GeometryFromText('POINT (100 200)',0));
INSERT INTO point(name,geom) VALUES('green',ST_GeometryFromText('POINT (1000 2000)',0));
INSERT INTO point(name,geom) VALUES('blue',ST_GeometryFromText('POINT (10 20)',0));

-- update
UPDATE point SET name = 'kezunlin' WHERE oid = 1;
UPDATE point SET geom = ST_GeometryFromText('POINT (10 20)',0)  WHERE oid = 1;
UPDATE point SET name = 'kezunlin' , geom = ST_GeometryFromText('POINT (10 20)',0)  WHERE oid = 1;

-- test(name:varchar no:integer length:FLOAT8)
CREATE TABLE test
(
	no INTEGER PRIMARY KEY,
	name VARCHAR,
	length FLOAT8
);
-- string integer float value can be 'xxx'
-- ST_GeometryFromText('POINT (10 20)',0) can NOT in 'yyy'
UPDATE test SET name = 'kezunlin' WHERE oid =1;
UPDATE test SET no = '20' WHERE oid =1;
UPDATE test SET length = '3.14' WHERE oid =1;


-- delete 
DELETE FROM point WHERE oid = 1;
DELETE FROM point;

-- select
-- geom WKB
SELECT oid,name, geom FROM point; 
-- st_astext  WKT
SELECT oid,name, ST_AsText(geom) FROM point; 
-- geomtext WKT
SELECT oid,name, ST_AsText(geom) as geomText FROM point; 

-- select all
SELECT oid, name, ST_AsText(geom) as geomText FROM point; 
-- select by oid
SELECT oid, name, ST_AsText(geom) as geomText FROM point WHERE oid = 6; 
-- select by name
SELECT oid, name, ST_AsText(geom) as geomText FROM point WHERE name LIKE '%zun%';

-- functions
SELECT count(*) FROM point;


-- LINESTRING
CREATE TABLE linestring 
(
	oid SERIAL,
	name VARCHAR,
	CONSTRAINT linestring_pkey PRIMARY KEY (oid)
);

-- add geometry column
SELECT AddGeometryColumn('linestring','geom',0,'LINESTRING',2);

-- insert
INSERT INTO linestring(name,geom) VALUES('road1',ST_GeometryFromText('LINESTRING(10 10,20 20,30 30)',0));
INSERT INTO linestring(name,geom) VALUES('road2',ST_GeometryFromText('LINESTRING(10 10,20 20,30 30)',0));
INSERT INTO linestring(name,geom) VALUES('road3',ST_GeometryFromText('LINESTRING(10 10,20 20,30 30)',0));

-- update
UPDATE linestring SET geom = ST_GeometryFromText('LINESTRING(10 10,20 20,30 30,40 40)',0)  WHERE oid = '1';

-- delete 
DELETE FROM linestring WHERE oid = '1';

-- geomtext WKT
SELECT oid,name, ST_AsText(geom) as geomText FROM linestring; 


-- Data Type : VARCHAR INTEGER  FLOAT8  DATE  TIME TIMESTAMP
VARCHAR VARCHAR(30) varchar varchar(30) character varying(30)
INT2
INT INT4   INTEGER
INT8
FLOAT4  REAL
FLOAT8  DOUBLE PRECISION
DATE
TIME
TIMESTAMP

-- add column
ALTER TABLE point ADD COLUMN address VARCHAR;
ALTER TABLE point ADD COLUMN KKK VARCHAR;
ALTER TABLE point ADD COLUMN length FLOAT8;
ALTER TABLE point ADD COLUMN address2 VARCHAR(30);
ALTER TABLE point ADD COLUMN address2 varchar(30);
ALTER TABLE point ADD COLUMN address2 character varying(30);

-- drop column
ALTER TABLE point DROP COLUMN address RESTRICT;

-- alter column type
ALTER TABLE point ALTER COLUMN address TYPE varchar(80);

-- rename column name
ALTER TABLE point RENAME COLUMN address TO city;

-- rename table name
ALTER TABLE point RENAME TO pointnew;

-- is table exist
select exists(select * from information_schema.tables where table_name='point');
-- t 
select exists(select * from information_schema.tables where table_name='point2');
-- f

-- get column names
select column_name from information_schema.columns where table_name='point';
-- get column types
select data_type from information_schema.columns where table_name='point';

-- is column exist
select exists (select column_name from information_schema.columns where table_name='point' and column_name='geom');

-- get table names
select f_table_name from public.geometry_columns;

-- get geom type
select type from public.geometry_columns where f_table_name='point';

-- get column type
select data_type from information_schema.columns where table_name = 'point' and column_name = 'no';

-- ext(layername,minx,miny,maxx,maxy)
CREATE TABLE ext(layername VARCHAR, minx FLOAT8, miny FLOAT8, maxx FLOAT8, maxy FLOAT8);
INSERT INTO ext(layername, minx, miny, maxx, maxy) VALUES('links', 1.1, 1.1, 2.2, 2.2);
SELECT minx, miny, maxx, maxy FROM ext WHERE layername = 'links';


-- NEW from postgis 2.0
SELECT 4::INTEGER;
SELECT 'SRID=4;POINT(0 0)'::geometry;
SELECT 'CIRCULARSTRING(0 0, 1 1, 1 0)'::geometry;
SELECT ST_AsText(ST_MakeEnvelope(10, 10, 11, 11, 4326));

-- Create a table with geometry POINT
CREATE TABLE testgeom
( 	
	id INTEGER PRIMARY KEY,
	geom geometry(POINT)
);

-- Create a table with geograph POINT
CREATE  TABLE  testgeog
(	
	gid  serial  PRIMARY  KEY, 
	the_geog  geography(POINT,4326)  
);

-- Create a table with 2D geometry linestring
CREATE  TABLE  roads  
( 
	id  SERIAL  PRIMARY  KEY,
	name  VARCHAR(64),
  	geom  geometry(LINESTRING,4326) 
);

-- Add a 3D linestring column
ALTER  TABLE  roads  ADD  COLUMN  geom2  geometry(LINESTRINGZ,4326);

-- Also we can add a geometry column by AddGeometryColumn function.
SELECT AddGeometryColumn('public', 'roads', 'geom', 4236, 'LINESTRING', 2);
SELECT AddGeometryColumn('public', 'roads', 'geom2', 4236, 'LINESTRINGZ', 3);


-- Create a table with geography column
CREATE  TABLE  global_points  
(
	id  SERIAL  PRIMARY  KEY,
	name  VARCHAR(64),
	location  GEOGRAPHY(POINT,4326)
);

-- Also we can add a geometry column by AddGeometryColumn function.
SELECT AddGeographyColumn('public', 'roads', 'geom', 4236, 'LINESTRING', 2);

-- See the contents of the metadata view
SELECT  *  FROM  geography_columns;

--  Add  some  data  into  the  test  table
INSERT  INTO  global_points  (name,  location)  VALUES  ('Town',  ST_GeographyFromText('SRID=4326;POINT(-110  30)')  );
INSERT  INTO  global_points  (name,  location)  VALUES  ('Forest',  ST_GeographyFromText('SRID=4326;POINT(-109  29)')  );
INSERT  INTO  global_points  (name,  location)  VALUES  ('London',  ST_GeographyFromText('SRID=4326;POINT(0  49)')  );

--  Index  the  test  table  with  a  spherical  index
CREATE INDEX global_points_gix ON global_points USING GIST ( location );

-- DROP Index
DROP INDEX global_points_gix;

-- Calculate the distance from location to POINT(-110  29)
SELECT name, ST_Distance(location, ST_GeographyFromText('SRID=4326;POINT(-110  29)')) as distance FROM global_points;
  name  |     distance
--------+------------------
 Town   | 110844.074057415
 Forest | 97438.6175247019
 London | 8940405.75635803

--  Show  a  distance  query  and  note,  London  is  outside  the  1000km  tolerance
SELECT  name  FROM  global_points  WHERE  ST_DWithin(location,  ST_GeographyFromText('SRID=4326;POINT(-110  29)'),  1000000);
  name
--------
 Town
 Forest

--  Distance  calculation  using  GEOGRAPHY  (122.2km)
SELECT ST_Distance('LINESTRING(-122.33 47.606, 0.0 51.5)'::geography, 'POINT(-21.96 64.15)':: geography);
--  Distance  calculation  using  GEOMETRY  (13.3  "degrees") inaccurate
SELECT  ST_Distance('LINESTRING(-122.33  47.606,  0.0  51.5)'::geometry,  'POINT(-21.96  64.15)'::geometry);


-- load data
-- Create table to store data
CREATE  TABLE  roads
( 
	road_id  INTEGER PRIMARY  KEY,
  	road_geom  geometry(LINESTRING), 
	road_name  VARCHAR(64)
);

-- road.sql
BEGIN;
INSERT  INTO  roads  (road_id,  road_geom,  road_name)
VALUES  (1,ST_GeomFromText('LINESTRING(191232  243118,191108  243242)',-1),'Jeff  Rd');
INSERT  INTO  roads  (road_id,  road_geom,  road_name)
VALUES  (2,ST_GeomFromText('LINESTRING(189141  244158,189265  244817)',-1),'Geordie  Rd');
INSERT  INTO  roads  (road_id,  road_geom,  road_name)
VALUES  (3,ST_GeomFromText('LINESTRING(192783  228138,192612  229814)',-1),'Paul  St');
INSERT  INTO  roads  (road_id,  road_geom,  road_name)
VALUES  (4,ST_GeomFromText('LINESTRING(189412  252431,189631  259122)',-1),'Graeme  Ave');
INSERT  INTO  roads  (road_id,  road_geom,  road_name)
VALUES  (5,ST_GeomFromText('LINESTRING(190131  224148,190871  228134)',-1),'Phil  Tce');
INSERT  INTO  roads  (road_id,  road_geom,  road_name)
VALUES  (6,ST_GeomFromText('LINESTRING(198231  263418,198213  268322)',-1),'Dave  Cres');
COMMIT;

-- load sql
-- Open the cmd first 
-- psql  -d  testdb  -f  roads.sql

-- shp2pgsql
-- Open the cmd first
-- shp2pgsql  -c  -D  -i  -I  Links.shp  public.links  >  links.sql
-- shp2pgsql -c Links.shp public.links  > links.sql
-- psql  -d  testdb  -f  links.sql

-- && MBR intersect
SELECT  ST_AsText(road_geom)  AS  geom FROM  roads
WHERE road_geom  &&  ST_MakeEnvelope(191232,243117,191232,243119,312);


--  C:\Users\ke\AppData\Roaming\postgresql\pgpass.conf
-- localhost:5432:*:postgres:111

-- # psql -h <server address> -U <username>
-- psql -h localhost -U postgres -p 5432 
ALTER USER postgres WITH PASSWORD '111';
ALTER USER postgres WITH PASSWORD '123';

