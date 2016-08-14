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

/*****************************************
*************** OBJETOS ******************
*****************************************/

/*		Relacion 1:1 Jefe-Departamento		*/
CREATE OR REPLACE TYPE Jefe_T AS OBJECT
	(cedula CHAR(10),
	nombre VARCHAR2(20),
	apellido VARCHAR2(20),
	telefonos NUMBER);
/

/*		Relacion 1:1 Jefe-Departamento		*/
CREATE OR REPLACE TYPE Departamento_T AS OBJECT
	(nombre VARCHAR2(40),
	jefe_dep REF Jefe_T);
/

/*		Relacion 1:N Desarrollador-Departamento 
		Desarrollador superclase
*/
CREATE OR REPLACE TYPE Desarrollador_T AS OBJECT
	(cedula CHAR(10),
	nombre VARCHAR2(20),
	apellido VARCHAR2(20),
	telefonos NUMBER)NOT FINAL;
/

/*		Desarrollador senior subclase de Desarrollador
		Relacion 1:N Desarrollador senior-Desarrolador junior		
*/
CREATE OR REPLACE TYPE Desarrollador_senior_T UNDER Desarrollador_T
	(sueldo NUMBER,
	anios_empresa NUMBER,
	member function obtener_sueldo return NUMBER);
/

/*		Desarrollador junior subclase de Desarrollador		
		Relacion 1:N Desarrollador senior-Desarrolador junior
*/
CREATE OR REPLACE TYPE Desarrollador_junior_T UNDER Desarrollador_T
	(sueldo NUMBER,
	tipo_desarrollo VARCHAR(20),
	member function obtener_sueldo return NUMBER);
/

/*		Creamos tabla de referencias para Desarrollador		*/
CREATE OR REPLACE TYPE Desarrollador_ref AS TABLE OF REF Desarrollador_T;
/

/*		Agregamos la referencia a la tabla de desarrolladores		*/
CREATE OR REPLACE TYPE Departamento_T FORCE AS OBJECT
	(nombre VARCHAR2(40),
	jefe_dep REF Jefe_T,
	desarrolladores Desarrollador_ref);
/

/*		Agregamos la referencia a departamento		*/
CREATE OR REPLACE TYPE Jefe_T FORCE AS OBJECT
	(cedula CHAR(10),
	nombre VARCHAR2(20),
	apellido VARCHAR2(20),
	telefonos NUMBER,
	dep REF Departamento_T);
/

/*		Relacion 1:N Cliente-Proyecto		*/
CREATE OR REPLACE TYPE Cliente_T AS OBJECT
	(Id VARCHAR(10),
	nombre VARCHAR(40),
	telefonos NUMBER);
/

/*		Relacion 1:N Cliente-Proyecto		*/
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

/*****************************************
**************** TABLAS ******************
*****************************************/

/*		Creacion de la tabla anidada de desarrolladores		*/
CREATE TABLE Departamento OF Departamento_T
	(PRIMARY KEY (nombre))
	Nested table desarrolladores STORE AS desarrolladores_store;

CREATE TABLE Desarrollador OF Desarrollador_T
	(PRIMARY KEY (cedula));

CREATE TABLE Cliente of Cliente_T
	(PRIMARY KEY (Id));

CREATE TABLE Proyecto of Proyecto_T
	(PRIMARY KEY (nombre),
	foreign key (cliente) references Cliente);

/* Tabla intermedia para relacionar proyectos con desarrolladores*/
CREATE TABLE ProyectDesarr of ProyectDesarr_T 
	(foreign key (proyecto) references Proyecto,
	foreign key (desarrollador) references Desarrollador);

/*
	Para mantener la integridad referencial, 
	se crearia un trigger (relacion 1:1)
*/
CREATE TABLE Jefe of Jefe_T 
	(PRIMARY KEY (cedula),
	foreign key (dep) references Departamento);

/*		Modificacion de la tabla Departamento para agregar la referencia a Jefe		
		Para mantener la integridad referencial,
		se crearia un trigger (relacion 1:1)
*/
ALTER TABLE Departamento
	ADD FOREIGN KEY (jefe_dep) references Jefe;
