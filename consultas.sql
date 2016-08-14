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
	VALUES (Desarrollador_senior_T('20674321','Mathieu','De Valery',telefonos(04143276648),100000,20));

/*		Creamos departamentos, con referencia a:
 		- jefe que los dirige  
 		- tabla de referencias de desarrolladores
 */
INSERT INTO Departamento
	SELECT 'Departamento 1', 
			REF(j),
			Desarrollador_ref(REF(d))
	FROM Jefe j,Desarrollador d WHERE j.cedula = '6544230' and d.cedula='20674321';

INSERT INTO Departamento
	SELECT 'Departamento 2', 
			REF(j),
			Desarrollador_ref(REF(d))
	FROM Jefe j,Desarrollador d WHERE j.cedula = '18765234' and d.cedula='20674321';

/*		Actualizamos los jefes para indicar de que departamento son jefes		*/
UPDATE Jefe SET dep = (SELECT REF(d) FROM Departamento d WHERE d.nombre='Departamento 1') WHERE cedula='6544230';
UPDATE Jefe SET dep = (SELECT REF(d) FROM Departamento d WHERE d.nombre='Departamento 2') WHERE cedula='6544230';


/*****************************************
*************** CONSULTAS ****************
*****************************************/

/* Consultamos al jefe del Departamento 1 */
SELECT DEREF(d.jefe_dep) FROM Departamento d WHERE d.nombre='Departamento 1';
/* Consultamoslos desarrolladores que trabajan en un departamento 
SELECT DEREF(d.departamento) FROM Desarrollador d WHERE d.cedula='20674321';*/
/