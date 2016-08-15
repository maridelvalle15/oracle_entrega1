/*****************************************
************** INSERCIONES ***************
*****************************************/

/*		Creamos jefes		*/
INSERT INTO Jefe VALUES
	('V-6544230','Carlos','Rodriguez',telefonos(04123212287),NULL);
INSERT INTO Jefe VALUES
	('V-18765234','Maria','Gomez',telefonos(04243467891),NULL);
INSERT INTO Jefe VALUES
	('E-13455892','Pedro','Perez',telefonos(04123228750,04122694926),NULL);

/*		Creamos desarrolladores	senior	*/	
INSERT INTO Desarrollador
	VALUES (Desarrollador_senior_T('V-20674321','Mathieu','De Valery',telefonos(04143276648),250000,10));
INSERT INTO Desarrollador
	VALUES (Desarrollador_senior_T('V-20489547','Nelson','Saturno',telefonos(04122422986,02122422986),300000,13));
INSERT INTO Desarrollador
	VALUES (Desarrollador_senior_T('E-6286852','Raul','Del Valle',telefonos(04166082586),200000,9));

/*		Creamos desarrolladores	junior con referencia al senior que lo ayuda	*/
INSERT INTO Desarrollador
	VALUES (Desarrollador_junior_T('V-20432998',
									'Emmanuel',
									'De Aguiar',
									telefonos(04265438870),
									200000,
									'movil',(SELECT TREAT(REF(d) AS REF Desarrollador_senior_T) FROM Desarrollador d 
										WHERE d.cedula='V-20674321')));

INSERT INTO Desarrollador
	VALUES (Desarrollador_junior_T('V-22765390',
									'Meggie',
									'Sanchez',
									telefonos(04143227650),
									220000,
									'móvil',(SELECT TREAT(REF(d) AS REF Desarrollador_senior_T) FROM Desarrollador d 
										WHERE d.cedula='V-20674321')));

INSERT INTO Desarrollador
	VALUES (Desarrollador_junior_T('V-23638870',
									'Marisela',
									'Del Valle',
									telefonos(04241034595,02129755264),
									210000,
									'web',(SELECT TREAT(REF(d) AS REF Desarrollador_senior_T) FROM Desarrollador d 
										WHERE d.cedula='V-20489547')));

/*		Creamos departamentos, con referencia a:
 		- jefe que los dirige  
 		- tabla de referencias de desarrolladores
 */
INSERT INTO Departamento
	SELECT 'Departamento 1', 
			REF(j),
			Desarrollador_ref(REF(d),REF(de))
	FROM Jefe j, Desarrollador d, Desarrollador de WHERE j.cedula = 'V-6544230' and d.cedula='V-20489547' and  de.cedula='V-23638870';

INSERT INTO Departamento
	SELECT 'Departamento 2', 
			REF(j),
			Desarrollador_ref(REF(d))
	FROM Jefe j,Desarrollador d WHERE j.cedula = 'V-18765234' and d.cedula='E-6286852';

INSERT INTO Departamento
	SELECT 'Departamento 3', 
			REF(j),
			Desarrollador_ref(REF(d),REF(de),REF(des))
	FROM Jefe j, Desarrollador d, Desarrollador de, Desarrollador des WHERE j.cedula = 'E-13455892' and d.cedula='V-20674321' and de.cedula='V-20432998' and des.cedula='V-22765390';

/*		Actualizamos los jefes para indicar de que departamento son jefes		*/
UPDATE Jefe SET dep = (SELECT REF(d) FROM Departamento d WHERE d.nombre='Departamento 1') WHERE cedula='V-6544230';
UPDATE Jefe SET dep = (SELECT REF(d) FROM Departamento d WHERE d.nombre='Departamento 2') WHERE cedula='V-18765234';
UPDATE Jefe SET dep = (SELECT REF(d) FROM Departamento d WHERE d.nombre='Departamento 3') WHERE cedula='E-13455892';

/*		Creamos proyectos		*/
INSERT INTO Proyecto VALUES 
		('Mejora aplicacion mercadolibre',
		'Act dependencias aplicacion',
		'3 meses',
		'web',
		600000);
INSERT INTO Proyecto VALUES 
		('App móvil Bancaribe',
		'Desarrollo aplicacion móvil Bancaribe',
		'7 meses',
		'móvil',
		1000000);
INSERT INTO Proyecto VALUES 
		('Beneficio Clave',
		'Aplicación web empresa Telered',
		'1 mes',
		'móvil',
		300000);

INSERT INTO Proyecto VALUES 
		('Automercados Plazas',
		'Desarrollo Sistema Web Automercados Plazas',
		'8 meses',
		'web',
		2000000);

/*		Creamos clientes con su respectivo proyecto		*/
INSERT INTO Cliente
	SELECT 'V-7364527',
			'Jorge Perez',
			telefonos(04241087644),
			Proyectos_ref(REF(p),REF(pr))
	FROM Proyecto p, Proyecto pr WHERE p.nombre='Mejora aplicacion mercadolibre' and pr.nombre='Automercados Plazas';

INSERT INTO Cliente
	SELECT 'V-10986260',
			'Daniel Hernandez',
			telefonos(04123213327,02123447630),
			Proyectos_ref(REF(p))
	FROM Proyecto p WHERE p.nombre='App móvil Bancaribe';

INSERT INTO Cliente
	SELECT '12328362',
			'James Coburn',
			telefonos(305643871),
			Proyectos_ref(REF(p))
	FROM Proyecto p WHERE p.nombre='Beneficio Clave';

/* Creamos la relacion entre proyectos y sus desarrolladores */
INSERT INTO ProyectDesarr VALUES (
	(SELECT REF (p) FROM Proyecto p WHERE p.nombre='Mejora aplicacion mercadolibre'),
	(SELECT REF (d) FROM Desarrollador d WHERE d.cedula='V-20489547'));

INSERT INTO ProyectDesarr VALUES (
	(SELECT REF (p) FROM Proyecto p WHERE p.nombre='Mejora aplicacion mercadolibre'),
	(SELECT REF (d) FROM Desarrollador d WHERE d.cedula='V-23638870'));

INSERT INTO ProyectDesarr VALUES (
	(SELECT REF (p) FROM Proyecto p WHERE p.nombre='App móvil Bancaribe'),
	(SELECT REF (d) FROM Desarrollador d WHERE d.cedula='V-20674321'));

INSERT INTO ProyectDesarr VALUES (
	(SELECT REF (p) FROM Proyecto p WHERE p.nombre='App móvil Bancaribe'),
	(SELECT REF (d) FROM Desarrollador d WHERE d.cedula='V-22765390'));

INSERT INTO ProyectDesarr VALUES (
	(SELECT REF (p) FROM Proyecto p WHERE p.nombre='App móvil Bancaribe'),
	(SELECT REF (d) FROM Desarrollador d WHERE d.cedula='V-20432998'));

INSERT INTO ProyectDesarr VALUES (
	(SELECT REF (p) FROM Proyecto p WHERE p.nombre='Beneficio Clave'),
	(SELECT REF (d) FROM Desarrollador d WHERE (d.cedula='V-20489547')));

INSERT INTO ProyectDesarr VALUES (
	(SELECT REF (p) FROM Proyecto p WHERE p.nombre='Beneficio Clave'),
	(SELECT REF (d) FROM Desarrollador d WHERE d.cedula='E-6286852'));

/* 

/*****************************************
*************** CONSULTAS ****************
**************************************REF
/* Consultamos al jefe del Departamento 1 */
SELECT DEREF(d.jefe_dep) FROM Departamento d WHERE d.nombre='Departamento 1';

/* Consulta de todos los desarrolladores senior */
SELECT d.nombre, d.apellido, 
        treat(value(d) AS Desarrollador_senior_T).anios_empresa anios_empresa
		FROM desarrollador d;

/* Consulta de los desarrolladores senior que ayudan a los desarrolladores junior */
SELECT deref(treat(ref(d) AS ref desarrollador_junior_t).senior) senior FROM desarrollador d;

/* Consulta de todos los desarrolladores senior */
SELECT d.nombre, d.apellido, 
        treat(value(d) AS Desarrollador_senior_T).anios_empresa anios_empresa
		FROM desarrollador d;

/* Consulta a tabla anidada: retorna los desarrolladores que trabajan en un departamento */
SELECT deref(VALUE(f)).cedula cedula, deref(VALUE(f)).nombre nombre_Desarrollador, deref(VALUE(f)).apellido apellido_Desarrollador 
FROM Departamento d, TABLE (d.desarrolladores) f WHERE d.nombre='Departamento 1';

/* Consulta a tabla anidada: retorna los proyectos de un cliente particular */ 
SELECT deref(VALUE(f)).nombre nombre, deref(VALUE(f)).tipo tipo, deref(VALUE(f)).costo costo 
FROM Cliente t, TABLE (t.proyectos) f WHERE t.Id='V-7364527';
/