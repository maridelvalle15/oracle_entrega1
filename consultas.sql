/*****************************************
************** INSERCIONES ***************
*****************************************/

/*		Creamos jefes		*/
INSERT INTO Jefe VALUES
	('6544230','Carlos','Rodriguez',telefonos(04123212287),NULL);
INSERT INTO Jefe VALUES
	('18765234','Maria','Gomez',telefonos(04243467891),NULL);

/*		Creamos desarrolladores		*/	
INSERT INTO Desarrollador
	VALUES (Desarrollador_senior_T('20674321','Mathieu','De Valery',telefonos(04143276648),100000,10));

INSERT INTO Desarrollador
	VALUES (Desarrollador_junior_T('20432998',
									'Emmanuel',
									'De Aguiar',
									telefonos(04265438870),
									200000,
									20,(SELECT TREAT(REF(d) AS REF Desarrollador_senior_T) FROM Desarrollador d 
										WHERE d.cedula='20674321')));

INSERT INTO Desarrollador
	VALUES (Desarrollador_junior_T('22765390',
									'Meggie',
									'Sanchez',
									telefonos(04143227650),
									200000,
									20,(SELECT TREAT(REF(d) AS REF Desarrollador_senior_T) FROM Desarrollador d 
										WHERE d.cedula='20674321')));

/*		Creamos departamentos, con referencia a:
 		- jefe que los dirige  
 		- tabla de referencias de desarrolladores
 */
INSERT INTO Departamento
	SELECT 'Departamento 1', 
			REF(j),
			Desarrollador_ref(VALUE(d))
	FROM Jefe j,Desarrollador d WHERE j.cedula = '6544230' and d.cedula='20674321';

INSERT INTO Departamento
	SELECT 'Departamento 2', 
			REF(j),
			Desarrollador_ref(Desarrollador_T('12345','Desarrollador','',telefonos(04241087644)))
	FROM Jefe j WHERE j.cedula = '18765234';

/*		Actualizamos los jefes para indicar de que departamento son jefes		*/
UPDATE Jefe SET dep = (SELECT REF(d) FROM Departamento d WHERE d.nombre='Departamento 1') WHERE cedula='6544230';
UPDATE Jefe SET dep = (SELECT REF(d) FROM Departamento d WHERE d.nombre='Departamento 2') WHERE cedula='6544230';

/*		Creamos proyectos		*/
INSERT INTO Proyecto VALUES 
		('Mejora aplicacion mercadolibre',
		'Act dependencias aplicacion',
		'3 meses',
		'web',
		600000);

/*		Creamos clientes		*/
INSERT INTO Cliente
	SELECT '7364527',
			'Jorge Perez',
			telefonos(04241087644),
			Proyectos_ref(REF(p))
	FROM Proyecto p WHERE p.nombre='Mejora aplicacion mercadolibre';

/* Creamos la relacion entre proyectos y sus desarrolladores */
INSERT INTO ProyectDesarr VALUES (
	(SELECT REF (p) FROM Proyecto p WHERE p.nombre='Mejora aplicacion mercadolibre'),
	(SELECT REF (d) FROM Desarrollador d WHERE d.cedula='20674321'));

/* 

/*****************************************
*************** CONSULTAS ****************
*****************************************/

/* Consultamos al jefe del Departamento 1 */
SELECT DEREF(d.jefe_dep) FROM Departamento d WHERE d.nombre='Departamento 1';
/* Consulta de los desarrolladores senior para todos los desarrolladores junior */
SELECT deref(treat(ref(d) AS ref desarrollador_junior_t).senior) senior FROM desarrollador d;
/* COnsulta a tabla anidada */
SELECT d.nombre, f.cedula, f.nombre FROM Departamento d, TABLE (d.desarrolladores) f;

/