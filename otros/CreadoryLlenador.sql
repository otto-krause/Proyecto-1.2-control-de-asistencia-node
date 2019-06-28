DROP DATABASE IF EXISTS Proyecto1_2;

CREATE DATABASE Proyecto1_2;

USE Proyecto1_2;

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
  entrada INT NOT NULL,
  salida INT NOT NULL,
  PRIMARY KEY (idHorario)
);

CREATE TABLE Autoridades(
  idAutoridad INT NOT NULL AUTO_INCREMENT,
  dni INT NOT NULL,
  telefono INT,
  direccion VARCHAR(100),
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  fechaIngreso DATE NOT NULL,
  fechaNacimiento DATE,
  fichaMedica VARCHAR(500),
  PRIMARY KEY (idAutoridad)
);

CREATE TABLE Roles (
  idRol INT AUTO_INCREMENT,
  rol VARCHAR(100),
  PRIMARY KEY (idRol)
);

CREATE TABLE Autoridades_Roles (
  idAutoridad INT NOT NULL AUTO_INCREMENT,
  idRol INT NOT NULL,
  FOREIGN KEY(idAutoridad) REFERENCES Autoridades(idAutoridad),
  FOREIGN KEY(idRol) REFERENCES Roles(idRol)
);

CREATE TABLE Division(
  idDivision INT NOT NULL AUTO_INCREMENT,
  idPreceptor INT NOT NULL,
  especialidad VARCHAR(20) NOT NULL,
  año TINYINT NOT NULL,
  turno BIT NOT NULL,
  numDivision TINYINT NOT NULL,
  cicloLectivo SMALLINT NOT NULL,
  PRIMARY KEY (idDivision),
  FOREIGN KEY(idPreceptor) REFERENCES Autoridades(idAutoridad)
);

CREATE TABLE Cursada(
  idCursada INT NOT NULL AUTO_INCREMENT,
  idHorario INT NOT NULL,
  idDivision INT NOT NULL,
  idMateria INT NOT NULL,
  idProfesor INT NOT NULL,
  tomarLista BIT NOT NULL,
  PRIMARY KEY (idCursada),
  FOREIGN KEY(idMateria) REFERENCES Materia(idMateria),
  FOREIGN KEY(idHorario) REFERENCES Dia_Horario(idHorario),
  FOREIGN KEY(idDivision) REFERENCES Division(idDivision),
  FOREIGN KEY(idProfesor) REFERENCES Autoridades(idAutoridad)
);

CREATE TABLE Alumno(
  idAlumno INT NOT NULL AUTO_INCREMENT,
  dni INT NOT NULL,
  telefono INT,
  direccion VARCHAR(100),
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  repetidor BIT NOT NULL,
  fechaNacimiento DATE,
  fechaIngreso DATE NOT NULL,
  PRIMARY KEY (idAlumno)
);

CREATE TABLE Contacto_Alumno(
  idContacto INT NOT NULL AUTO_INCREMENT,
  idAlumno INT NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  relacion VARCHAR(10) NOT NULL,
  celular INT NOT NULL,
  mail VARCHAR(100),
  dniContacto INT,
  PRIMARY KEY(idContacto),
  FOREIGN KEY(idAlumno) REFERENCES Alumno(idAlumno)
);

CREATE TABLE Acta_Cursada(
  idActa INT NOT NULL AUTO_INCREMENT,
  idAlumno INT NOT NULL,
  idCursada INT NOT NULL,
  periodo VARCHAR(20),
  nota TINYINT,
  fechaCierre DATE,
  PRIMARY KEY (idActa),
  FOREIGN KEY(idAlumno) REFERENCES Alumno(idAlumno),
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
  idActa INT NOT NULL AUTO_INCREMENT,
  idProfesor INT NOT NULL,
  FOREIGN KEY(idActa) REFERENCES Acta_Previa(idActa),
  FOREIGN KEY(idProfesor) REFERENCES Autoridades(idAutoridad)
);

CREATE TABLE Inscripcion_Previa(
  idAlumno INT NOT NULL,
  idActa INT NOT NULL,
  FOREIGN KEY(idAlumno) REFERENCES Alumno(idAlumno),
  FOREIGN KEY(idActa) REFERENCES Acta_Cursada(idActa)
);

CREATE TABLE Alumno_Adeuda (
  idAlumno INT NOT NULL,
  idMateria INT NOT NULL,
  FOREIGN KEY(idAlumno) REFERENCES Alumno(idAlumno),
  FOREIGN KEY(idMateria) REFERENCES Materia(idMateria)
);

CREATE TABLE Historial_Alumno (
  idDivision INT NOT NULL,
  idAlumno INT NOT NULL,
  FOREIGN KEY(idDivision) REFERENCES Division(idDivision),
  FOREIGN KEY(idAlumno) REFERENCES Alumno(idAlumno)
);

CREATE TABLE Plan_Estudio (
  resolucion INT NOT NULL,
  descripcion VARCHAR(256),
  vigenciaDesde DATE,
  vigenciaHasta DATE,
  PRIMARY KEY(resolucion)
);

CREATE TABLE Plan_Materia (
  resolucion INT NOT NULL,
  idMateria INT NOT NULL,
  FOREIGN KEY(resolucion) REFERENCES Plan_Estudio(resolucion),
  FOREIGN KEY(idMateria) REFERENCES Materia(idMateria)
);

CREATE TABLE Semana
(
    idDivision INT NOT NULL,
    idSemana INT NOT NULL AUTO_INCREMENT,
    diaSemana INT NOT NULL,
    tipo VARCHAR(5), /*En qué consiste ese turno. Teoría, Contraturno*/

    PRIMARY KEY(idHorario),
    FOREIGN KEY(idDivision) REFERENCES Division(idDivision)
);
CREATE TABLE Asistencia
(
    idAsistencia INT NOT NULL AUTO_INCREMENT,
    idAlumno INT NOT NULL,
    valor VARCHAR(3) NOT NULL, /*El valor de la asistencia. Presente, Tarde, Austende con Permanencia, Justificado, Otro*/
	fecha DATE NOT NULL,

    PRIMARY KEY(idAsistencia),
    FOREIGN KEY(idAlumno) REFERENCES Alumno(idAlumno),
    FOREIGN KEY(idSemana) REFERENCES Semana(idSemana)
);

INSERT INTO Alumno (dni, telefono, direccion, nombre, apellido, repetidor, fechaNacimiento, fechaIngreso) VALUES
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
('1','21919065','1120170312','2908 Kali Lodge','Tina','Jenkins','2002-08-21','1974-06-18','Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras venenatis faucibus turpis, nec gravida diam scelerisque a. Pellentesque ornare eros vitae purus tempus porta.'),
('2','30650300','1157976040','58926 William Heights Apt. 015','Stan','Hane','2009-08-07','1971-12-22','Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras venenatis faucibus turpis, nec gravida diam scelerisque a. Pellentesque ornare eros vitae purus tempus porta.'),
('3','27212129','1141112588','060 Buckridge Grove Apt. 904','Otho','Hilll','1986-10-03','1996-08-31','Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras venenatis faucibus turpis, nec gravida diam scelerisque a. Pellentesque ornare eros vitae purus tempus porta.'),
('4','27158976','1155012825','18620 Urban Crossing','Karley','Farrell','2013-05-04','1972-10-17','Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras venenatis faucibus turpis, nec gravida diam scelerisque a. Pellentesque ornare eros vitae purus tempus porta.'),
('5','29744957','1134704092','326 Gonzalo Way','Leola','Heaney','1978-07-25','1997-02-17','Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras venenatis faucibus turpis, nec gravida diam scelerisque a. Pellentesque ornare eros vitae purus tempus porta.'),
('6','35072595','1158669824','818 Moises Ranch Suite 581','Aliyah','Stanton','1981-09-13','1976-10-21','Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras venenatis faucibus turpis, nec gravida diam scelerisque a. Pellentesque ornare eros vitae purus tempus porta.'),
('7','33524756','1142726379','54841 Creola Walk','Berneice','Abshire','2001-10-18','1980-12-10','Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras venenatis faucibus turpis, nec gravida diam scelerisque a. Pellentesque ornare eros vitae purus tempus porta.'),
('8','36426663','1133903751','5158 Borer Villages Apt. 883','Rhea','Christiansen','2015-03-06','1982-11-16','Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras venenatis faucibus turpis, nec gravida diam scelerisque a. Pellentesque ornare eros vitae purus tempus porta.'),
('9','37184023','1150723651','695 Mohr Cape','Bernadette','Kuhlman','2018-06-11','1986-05-21','Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras venenatis faucibus turpis, nec gravida diam scelerisque a. Pellentesque ornare eros vitae purus tempus porta.'),
('10','35006292','1137957715','5879 Faustino Highway','Wiley','Lang','1987-09-14','1994-09-14','Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras venenatis faucibus turpis, nec gravida diam scelerisque a. Pellentesque ornare eros vitae purus tempus porta.'); 
