/*****************************************
************** INSERCIONES ***************
*****************************************/

/*		Creamos jefes		*/
INSERT INTO Jefe VALUES
	('6544230','Carlos','Rodriguez','04123212287',NULL);
INSERT INTO Jefe VALUES
	('18765234','Maria','Gomez','04243467891',NULL);

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
	SELECT 'Departamento 1', REF(j)
	FROM Jefe j WHERE j.cedula = '6544230';

INSERT INTO Departamento
	SELECT 'Departamento 2', REF(j)
	FROM Jefe j WHERE j.cedula = '6544230';


INSERT INTO Desarrollador
	VALUES (Desarrollador_senior_T('20674321','Mathieu','De Valery','04143276648',100000,20));


/*		Creamos desarrolladores, con referencia a:
		- departamento en el cual trabajan
*/
INSERT INTO Desarrollador
	SELECT Desarrollador_movil_T('20674321','Mathieu','De Valery','04143276648',REF(d),100000,20)
	FROM Departamento d WHERE d.nombre='Departamento 1';


UPDATE Jefe SET dep = (SELECT REF(d) FROM Departamento d WHERE d.nombre='Departamento 1') WHERE cedula='6544230';
UPDATE Jefe SET dep = (SELECT REF(d) FROM Departamento d WHERE d.nombre='Departamento 2') WHERE cedula='6544230';

/* UPDATE STATEMENT
UPDATE Departamento SET jefe_dep = (SELECT REF(j) FROM Jefe j WHERE j.cedula='6544230') WHERE nombre='Departamento 1';
*/

/*****************************************
*************** CONSULTAS ****************
*****************************************/

/* Consultamos al jefe del Departamento 1 */
SELECT DEREF(d.jefe_dep) FROM Departamento d WHERE d.nombre='Departamento 1';
/* Consultamos el departamento en el cual trabaja un desarrollador */
SELECT DEREF(d.departamento) FROM Desarrollador d WHERE d.cedula='20674321';
/