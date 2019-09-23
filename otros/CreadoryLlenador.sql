DROP DATABASE IF EXISTS Escuela;

CREATE DATABASE Escuela;

USE Escuela;

CREATE TABLE Materia(
  idMateria INT NOT NULL AUTO_INCREMENT,
  titulo VARCHAR(50) NOT NULL,
  descripcion VARCHAR(256),
  cantHoras TINYINT NOT NULL,
  PRIMARY KEY (idMateria)
);

CREATE TABLE Dia_Horario(
  idHorario INT NOT NULL AUTO_INCREMENT,
  dia TINYINT NOT NULL, 
  entradaSalida INT NOT NULL,
  PRIMARY KEY (idHorario)
);

CREATE TABLE Autoridades(
  dniAutoridad INT NOT NULL,
  telefono INT,
  direccion VARCHAR(100),
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  fechaIngreso DATE NULL,
  fechaNacimiento DATE,
  fichaMedica BOOLEAN NOT NULL DEFAULT 0,
  usuario VARCHAR(50) NOT NULL,
  contraseña VARCHAR(50) NOT NULL,
  PRIMARY KEY (dniAutoridad)
);

CREATE TABLE Roles (
  idRol INT AUTO_INCREMENT,
  rol VARCHAR(100),
  PRIMARY KEY (idRol)
);

CREATE TABLE Autoridades_Roles (
  dniAutoridad INT NOT NULL,
  idRol INT NOT NULL,
  PRIMARY KEY(dniAutoridad,idRol),
  FOREIGN KEY(dniAutoridad) REFERENCES Autoridades(dniAutoridad),
  FOREIGN KEY(idRol) REFERENCES Roles(idRol)
);

CREATE TABLE Division(
  idDivision INT NOT NULL AUTO_INCREMENT,
  dniPreceptor INT,
  especialidad VARCHAR(20) NOT NULL,
  año TINYINT NOT NULL,
  turno BOOLEAN NOT NULL,
  numDivision TINYINT NOT NULL,
  cicloLectivo SMALLINT NOT NULL,
  PRIMARY KEY (idDivision),
  FOREIGN KEY(dniPreceptor) REFERENCES Autoridades(dniAutoridad),
  UNIQUE(especialidad,año,turno,numDivision,cicloLectivo)
);

CREATE TABLE Cursada(
  idCursada INT NOT NULL AUTO_INCREMENT,
  idHorario INT NOT NULL,
  idDivision INT NOT NULL,
  idMateria INT NOT NULL,
  dniProfesor INT NOT NULL,
  tomarLista BOOLEAN NOT NULL,
  PRIMARY KEY (idCursada),
  FOREIGN KEY(idMateria) REFERENCES Materia(idMateria),
  FOREIGN KEY(idHorario) REFERENCES Dia_Horario(idHorario),
  FOREIGN KEY(idDivision) REFERENCES Division(idDivision),
  FOREIGN KEY(dniProfesor) REFERENCES Autoridades(dniAutoridad)
);

CREATE TABLE Alumno(
  dniAlumno INT NOT NULL,
  telefono INT,
  direccion VARCHAR(100),
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  repetidor BOOLEAN NOT NULL DEFAULT 0,
  fechaNacimiento DATE,
  fechaIngreso DATE NOT NULL,
  activo BOOLEAN NOT NULL DEFAULT 1,
  fechaBaja DATE NULL,
  PRIMARY KEY (dniAlumno)
);

CREATE TABLE Contacto_Alumno(
  idContacto INT NOT NULL AUTO_INCREMENT,
  dniAlumno INT NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  relacion VARCHAR(10) NOT NULL,
  celular INT NOT NULL,
  mail VARCHAR(100),
  dniContacto INT,
  PRIMARY KEY(idContacto),
  FOREIGN KEY(dniAlumno) REFERENCES Alumno(dniAlumno)
);

CREATE TABLE Acta_Cursada(
  idActa INT NOT NULL AUTO_INCREMENT,
  dniAlumno INT NOT NULL,
  idCursada INT NOT NULL,
  periodo VARCHAR(20),
  nota TINYINT,
  fechaCierre DATE,
  PRIMARY KEY (idActa),
  FOREIGN KEY(dniAlumno) REFERENCES Alumno(dniAlumno),
  FOREIGN KEY(idCursada) REFERENCES Cursada(idCursada)
);

CREATE TABLE Acta_Previa(
  idActa INT NOT NULL AUTO_INCREMENT,
  idMateria INT NOT NULL,
  tipo VARCHAR(100),
  fechaCierre DATE,
  PRIMARY KEY (idActa),
  FOREIGN KEY(idMateria) REFERENCES Materia(idMateria)
);

CREATE TABLE Profesores_Acta_Previa(
  idActa INT NOT NULL,
  dniProfesor INT NOT NULL,
  PRIMARY KEY(idActa,dniProfesor),
  FOREIGN KEY(idActa) REFERENCES Acta_Previa(idActa),
  FOREIGN KEY(dniProfesor) REFERENCES Autoridades(dniAutoridad)
);

CREATE TABLE Inscripcion_Previa(
  dniAlumno INT NOT NULL,
  idActa INT NOT NULL,
  PRIMARY KEY(dniAlumno,idActa),
  FOREIGN KEY(dniAlumno) REFERENCES Alumno(dniAlumno),
  FOREIGN KEY(idActa) REFERENCES Acta_Previa(idActa)
);

CREATE TABLE Alumno_Adeuda (
  dniAlumno INT NOT NULL,
  idMateria INT NOT NULL,
  PRIMARY KEY(dniAlumno,idMateria),
  FOREIGN KEY(dniAlumno) REFERENCES Alumno(dniAlumno),
  FOREIGN KEY(idMateria) REFERENCES Materia(idMateria)
);

CREATE TABLE Historial_Alumno (
  idDivision INT NOT NULL,
  dniAlumno INT NOT NULL,
  PRIMARY KEY(idDivision,dniAlumno),
  FOREIGN KEY(idDivision) REFERENCES Division(idDivision),
  FOREIGN KEY(dniAlumno) REFERENCES Alumno(dniAlumno)
);

CREATE TABLE Plan_Estudio (
  resolucion VARCHAR(256) NOT NULL,
  descripcion VARCHAR(256),
  vigenciaDesde DATE,
  vigenciaHasta DATE,
  PRIMARY KEY(resolucion)
);

CREATE TABLE Plan_Materia (
  resolucion VARCHAR(256) NOT NULL,
  idMateria INT NOT NULL,
  PRIMARY KEY(resolucion,idMateria),
  FOREIGN KEY(resolucion) REFERENCES Plan_Estudio(resolucion),
  FOREIGN KEY(idMateria) REFERENCES Materia(idMateria)
);

CREATE TABLE Semana
(
    idDivision INT NOT NULL,
    idSemana INT NOT NULL AUTO_INCREMENT,
    diaSemana INT NOT NULL,
    tipo VARCHAR(15), /*En qué consiste ese turno. Teoría, Contraturno*/

    PRIMARY KEY(idSemana),
    FOREIGN KEY(idDivision) REFERENCES Division(idDivision)
);
CREATE TABLE Asistencia
(
    idSemana INT NOT NULL,
    idAsistencia INT NOT NULL AUTO_INCREMENT,
    dniAlumno INT NOT NULL,
    valor VARCHAR(3) NOT NULL, /*El valor de la asistencia. Presente, Tarde, Austende con Permanencia, Justificado, Otro*/
  	fecha DATE NOT NULL,

    PRIMARY KEY(idAsistencia),
    FOREIGN KEY(dniAlumno) REFERENCES Alumno(dniAlumno),
    FOREIGN KEY(idSemana) REFERENCES Semana(idSemana)
);
INSERT INTO Alumno (dniAlumno, telefono, direccion, nombre, apellido, repetidor, fechaNacimiento, fechaIngreso) VALUES
(43181089, 1131265287, "Casa de Franco", "Franco", "Mercado", 0, '2001-02-14', '2014-02-28'),
(42175858, 1148444448, "Arroyos 3", "Fernando", "Cotti", 0, '2000-11-19', '2014-02-28'),
(42468444, 1149882153, "casa de Maikhol", "Maikhol", "Sozaki", 1, '2001-02-14', '2014-02-28'),
(44311848, 1143311111, "Calle 46546", "Ocnarf", "Odacrem", 0, '2001-02-14', '2014-02-28'),
(43854561, 1179797979, "Puente 12412", "Barreto", "Barret", 0, '2001-02-14', '2014-02-28'),
(40684625, 1143897513, "Casa del puente 23424", "Lola", "Merás", 0, '2001-02-14', '2014-02-28'),
(34874652, 1179222312, "uwu 12451", "Juancho", "Tito", 0, '2001-02-14', '2014-02-28'),
(40184984, 1126484949, "Subeestudinatil 79797", "Blas", "Grudina", 1, '1994-02-14', '2014-02-28'),
(42486468, 1133363386, "Av de Mayo 977987", "Kirito", "Uchihaxd", 0, '2001-02-14', '2014-02-28');

INSERT INTO Roles (rol) VALUES
("Profesor"),
("Preceptor");

INSERT INTO Autoridades VALUES 
('21919065','1120170312','2908 Kali Lodge','Tina','Jenkins','2002-08-21','1974-06-18',1,'jenkin.tina', 'uwuowoewe'),
('30650300','1157976040','58926 William Heights Apt. 015','Stan','Hane','2009-08-07','1971-12-22',1,'ElStan', 'QueleesGil'),
('27212129','1141112588','060 Buckridge Grove Apt. 904','Otho','Hilll','1986-10-03','1996-08-31',1,'Lorem', 'ipsum'),
('27158976','1155012825','18620 Urban Crossing','Karley','Farrell','2013-05-04','1972-10-17',0,'karleyF','1234'),
('29744957','1134704092','326 Gonzalo Way','Leola','Heaney','1978-07-25','1997-02-17',1,'Leolahan','1245'),
('35072595','1158669824','818 Moises Ranch Suite 581','Aliyah','Stanton','1981-09-13','1976-10-21',1,'aaaaaa','bbbbbb'),
('33524756','1142726379','54841 Creola Walk','Berneice','Abshire','2001-10-18','1980-12-10',0,'contraseña','usuario'),
('36426663','1133903751','5158 Borer Villages Apt. 883','Rhea','Christiansen','2015-03-06','1982-11-16',0,'Tuvieja','EnTanga'),
('37184023','1150723651','695 Mohr Cape','Bernadette','Kuhlman','2018-06-11','1986-05-21',1,'OtroUsuario','Ysucontraseña'),
('35006292','1137957715','5879 Faustino Highway','Wiley','Lang','1987-09-14','1994-09-14',1,'User','11037'); 

INSERT INTO Division(dniPreceptor,especialidad,año,turno,numDivision,cicloLectivo) VALUES
(27212129,'Computación', 6, 1, 1, 2019),
(27212129,'Computación', 5, 0, 2, 2019),
(27212129,'Química', 6, 1, 1, 2019),
(27212129,'Computación', 6, 0, 2, 2019),
(27212129,'Electrónica', 6, 1, 3, 2019),
(27212129,'Electrónica', 4, 0, 1, 2019),
(27212129,'Energías Renovables', 6, 1, 1, 2019),
(27212129,'Mecánica', 6, 1, 2, 2019),
(27212129,'Construcciones', 6, 0, 1, 2019);

INSERT INTO Semana(diaSemana, tipo, idDivision) VALUES
(1,'Teoría',1),
(2,'Teoría',1),
(2,'Contraturno',1),
(3,'Teoría',1),
(4,'Teoría',1),
(4,'Contraturno',1),
(5,'Teoría',1),
(5,'Contraturno',1),
(1,'Teoría',2),
(1,'Contraturno',2),
(2,'Teoría',2),
(3,'Teoría',2),
(4,'Teoría',2),
(5,'Contraturno',2);

INSERT INTO Dia_Horario (dia, entradaSalida) VALUES
(1,13251620),
(2,14101750),
(3,08001130);


INSERT INTO Materia (titulo, descripcion, cantHoras) VALUES
('Matemática 1', 'Es Matemática, pero 1', 3),
('Matemática 2', 'Es Matemática, pero 2', 3),
('Desarrollo de Sistemas', 'Es Hid.', 6),
('Lengua y Literatura', 'Es Lengua, pero literatura', 2),
('Tecnología de la Representación', 'Es hacer dibujitos', 3);

INSERT INTO Cursada(idHorario, idDivision, idMateria, dniProfesor, tomarLista) VALUES
(1,1,1,21919065,0),
(2,1,2,21919065,0),
(3,1,3,27212129,1),
(2,1,1,27212129,1),
(1,2,1,27212129,1);

INSERT INTO Historial_Alumno(idDivision,dniAlumno) VALUES
(1,43181089),
(1,42175858),
(1,42468444),
(4,44311848),
(1,43854561),
(3,40684625),
(2,34874652),
(6,40184984),
(7,42486468);

