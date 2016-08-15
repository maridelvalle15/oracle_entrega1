DROP TABLE DEPARTAMENTO CASCADE CONSTRAINTS;
DROP TABLE JEFE CASCADE CONSTRAINTS;
DROP TABLE PROYECTO CASCADE CONSTRAINTS;
DROP TABLE PROYECTDESARR CASCADE CONSTRAINTS;
DROP TABLE DESARROLLADOR CASCADE CONSTRAINTS;
DROP TABLE Cliente CASCADE CONSTRAINTS;
DROP TYPE telefonos force;
DROP TYPE PROYECTDESARR_T force;
DROP TYPE PROYECTO_T force;
DROP TYPE Departamento_T force;
DROP TYPE Juniors force;
DROP TYPE Desarrollador_senior_T force;
DROP TYPE Desarrollador_junior_T force;
DROP TYPE Desarrollador_T force;
DROP TYPE JEFE_T force;
DROP TYPE Cliente_T force;

/*****************************************
*************** OBJETOS ******************
*****************************************/

/*		Creamos un arreglo de maximo 3 numeros de telefono		*/
CREATE OR REPLACE TYPE telefonos IS VARRAY(3) of NUMBER;
/

/*		Creamos tipo para relacion 1:1 Jefe-Departamento		*/
CREATE OR REPLACE TYPE Jefe_T;
/

/*		Creamos tipo relacion 1:1 Jefe-Departamento		*/
CREATE OR REPLACE TYPE Departamento_T;
/

/*		Creamos tipo relacion 1:N Cliente-Proyecto		*/
CREATE OR REPLACE TYPE Proyecto_T;
/

/*		Creamos tipo relacion 1:N Desarrollador senior - Desarrollador junior		*/
CREATE OR REPLACE TYPE Desarrollador_senior_T;
/

/*		Relacion 1:N Desarrollador-Departamento 
		Desarrollador superclase
*/
CREATE OR REPLACE TYPE Desarrollador_T AS OBJECT
	(cedula CHAR(10),
	nombre VARCHAR2(20),
	apellido VARCHAR2(20),
	tlf telefonos)NOT FINAL;
/


/*		Desarrollador junior subclase de Desarrollador		
		Relacion 1:N Desarrollador senior-Desarrollador junior
		Para la relacion, se coloca REF de un lado y member function
		del otro
*/
CREATE OR REPLACE TYPE Desarrollador_junior_T UNDER Desarrollador_T
	(sueldo NUMBER,
	tipo_desarrollo VARCHAR(20),
	senior REF Desarrollador_senior_T,
	member function obtener_sueldo return NUMBER);
/

/*		Creamos una tabla para obtener la coleccion de juniors en senior		*/
CREATE OR REPLACE TYPE Juniors AS TABLE OF REF Desarrollador_junior_T;
/

/*		Desarrollador senior subclase de Desarrollador
		Relacion 1:N Desarrollador senior-Desarrollador junior		
*/
CREATE OR REPLACE TYPE Desarrollador_senior_T UNDER Desarrollador_T
	(sueldo NUMBER,
	anios_empresa NUMBER,
	member function obtener_juniors return Juniors,
	member function obtener_sueldo return NUMBER);
/

/*		Creamos tabla de referencias para Desarrollador
		Sera utilizada en Departamento_T
*/
CREATE OR REPLACE TYPE Desarrollador_ref AS TABLE OF REF Desarrollador_T;
/

/*		Creamos objeto para relacion 1:1 Jefe-Departamento	
		Creamos una referencia en cada clase participante en
		la relacion
*/
CREATE OR REPLACE TYPE Departamento_T AS OBJECT
	(nombre VARCHAR2(40),
	jefe_dep REF Jefe_T,
	desarrolladores Desarrollador_ref);
/

/*		Creamos objeto para relacion 1:1 Jefe-Departamento		
		Creamos una referencia en cada clase participante en
		la relacion
*/
CREATE OR REPLACE TYPE Jefe_T AS OBJECT
	(cedula CHAR(10),
	nombre VARCHAR2(20),
	apellido VARCHAR2(20),
	tlf telefonos,
	dep REF Departamento_T);
/

/*		Relacion 1:N Cliente-Proyecto		*/
CREATE OR REPLACE TYPE Proyecto_T AS OBJECT
	(nombre VARCHAR2(50),
	descripcion VARCHAR2(100),
	duracion VARCHAR2(20),
	tipo VARCHAR2(10),
	costo NUMBER,
	member function obtener_costo return NUMBER);
/

/*		Objeto para tabla intermedia para relacionar proyectos con desarrolladores		*/
CREATE OR REPLACE TYPE ProyectDesarr_T AS OBJECT
	(proyecto REF Proyecto_T,
	desarrollador REF Desarrollador_T);
/

/*		Creamos tabla de referencias para Proyecto		
		Sera utilizada en Cliente_T
*/
CREATE OR REPLACE TYPE Proyectos_ref AS TABLE OF REF Proyecto_T;
/

/*		Relacion 1:N Cliente-Proyecto		
		Para la relacion, se coloca REF de un lado y member function
		del otro
*/
CREATE OR REPLACE TYPE Cliente_T AS OBJECT
	(Id VARCHAR(10),
	nombre VARCHAR(40),
	tlf telefonos,
	proyectos Proyectos_ref);
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

/*		Creacion de la tabla anidada de proyectos		*/
CREATE TABLE Cliente OF Cliente_T
	(PRIMARY KEY (Id))
	Nested table proyectos STORE AS proyectos_store;

CREATE TABLE Proyecto OF Proyecto_T
	(PRIMARY KEY (nombre));

/* Tabla intermedia para relacionar proyectos con desarrolladores*/
CREATE TABLE ProyectDesarr OF ProyectDesarr_T 
	(foreign key (proyecto) references Proyecto,
	foreign key (desarrollador) references Desarrollador);

/*
	Para mantener la integridad referencial, 
	se crearia un trigger (relacion 1:1)
*/
CREATE TABLE Jefe OF Jefe_T 
	(PRIMARY KEY (cedula),
	foreign key (dep) references Departamento);

/*		Modificacion de la tabla Departamento para agregar la referencia a Jefe		
		Para mantener la integridad referencial,
		se crearia un trigger (relacion 1:1)
*/
ALTER TABLE Departamento
	ADD FOREIGN KEY (jefe_dep) references Jefe;