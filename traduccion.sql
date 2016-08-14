DROP TABLE DEPARTAMENTO CASCADE CONSTRAINTS;
DROP TABLE JEFE CASCADE CONSTRAINTS;
DROP TABLE PROYECTO CASCADE CONSTRAINTS;
DROP TABLE PROYECTDESARR CASCADE CONSTRAINTS;
DROP TABLE DESARROLLADOR CASCADE CONSTRAINTS;
DROP TABLE Cliente CASCADE CONSTRAINTS;
DROP TYPE PROYECTDESARR_T force;
DROP TYPE PROYECTO_T force;
DROP TYPE Departamento_T force;
DROP TYPE Desarrollador_movil_T force;
DROP TYPE Desarrollador_web_T force;
DROP TYPE Desarrollador_T force;
DROP TYPE JEFE_T force;
DROP TYPE Cliente_T force;

/* Creacion de los objetos*/
CREATE OR REPLACE TYPE Jefe_T AS OBJECT
	(cedula CHAR(10),
	nombre VARCHAR2(20),
	apellido VARCHAR2(20),
	telefonos NUMBER);
/
CREATE OR REPLACE TYPE Departamento_T AS OBJECT
	(nombre VARCHAR2(40),
	jefe_dep REF Jefe_T);
/
CREATE OR REPLACE TYPE Desarrollador_T AS OBJECT
	(cedula CHAR(10),
	nombre VARCHAR2(20),
	apellido VARCHAR2(20),
	telefonos NUMBER,
	departamento ref Departamento_T)NOT FINAL;
/
CREATE OR REPLACE TYPE Desarrollador_movil_T UNDER Desarrollador_T
	(sueldo NUMBER,
	proyectos_totales NUMBER,
	member function obtener_sueldo return NUMBER);
/
CREATE OR REPLACE TYPE Desarrollador_web_T UNDER Desarrollador_T
	(sueldo NUMBER,
	anios_experiencia NUMBER,
	member function obtener_sueldo return NUMBER);
/
CREATE OR REPLACE TYPE Jefe_T FORCE AS OBJECT
	(cedula CHAR(10),
	nombre VARCHAR2(20),
	apellido VARCHAR2(20),
	telefonos NUMBER,
	dep REF Departamento_T);
/
CREATE OR REPLACE TYPE Cliente_T AS OBJECT
	(Id VARCHAR(10),
	nombre VARCHAR(40),
	telefonos NUMBER);
/
CREATE OR REPLACE TYPE Proyecto_T AS OBJECT
	(nombre VARCHAR2(30),
	descripcion VARCHAR2(50),
	duracion VARCHAR2(20),
	tipo VARCHAR2(5),
	cliente REF Cliente_T,
	member function obtener_costo return NUMBER);
/
/* Objeto para tabla intermedia para relacionar proyectos con desarrolladores*/
CREATE OR REPLACE TYPE ProyectDesarr_T AS OBJECT
	(proyecto REF Proyecto_T,
	desarrollador REF Desarrollador_T);
/

/*Creacion de tablas*/
CREATE TABLE Departamento OF Departamento_T
	(PRIMARY KEY (nombre));

CREATE TABLE Desarrollador OF Desarrollador_T
	(PRIMARY KEY (cedula),
	foreign key (departamento) references Departamento);

CREATE TABLE Cliente of Cliente_T
	(PRIMARY KEY (Id));

CREATE TABLE Proyecto of Proyecto_T
	(PRIMARY KEY (nombre),
	foreign key (cliente) references Cliente);

/* Tabla intermedia para relacionar proyectos con desarrolladores*/
CREATE TABLE ProyectDesarr of ProyectDesarr_T 
	(foreign key (proyecto) references Proyecto,
	foreign key (desarrollador) references Desarrollador);

CREATE TABLE Jefe of Jefe_T 
	(PRIMARY KEY (cedula),
	foreign key (dep) references Departamento);

ALTER TABLE Departamento
	ADD FOREIGN KEY (jefe_dep) references Jefe;
