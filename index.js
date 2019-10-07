var express = require('express');
var pool = require('./bd.js').pool;
var bodyparser = require('body-parser');
var app = express();
var autenticacion = require('./autenticacion');

var AutoridadDivision = 'CREATE VIEW Profesores_Division AS SELECT dniAutoridad, usuario, idDivision, tomarLista FROM Cursada JOIN Autoridades ON (dniProfesor = dniAutoridad);'; //Divisiones con Autoridades
var PreceptoresDivision = 'CREATE VIEW Preceptores_Division AS SELECT dniPreceptor, usuario, idDivision FROM Division JOIN Autoridades ON (Division.dniPreceptor = Autoridades.dniAutoridad)';
const corsConfig = function(req, res, next) {
    res.header('Access-Control-Allow-Origin', 'http://localhost:8080')
    res.header('Access-Control-Allow-Credentials', true)
    res.header('Access-Control-Allow-Methods', 'GET,HEAD,OPTIONS,POST,PUT')
    res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization')
    next()
}

app.use(corsConfig);
app.use(bodyparser.urlencoded({extended: false}));
app.use(express.static(__dirname + '/vistas'));
app.use(bodyparser.json());

app.get('/ObtenerCursos', async (req,res, next)=>
{
    var usuarioAutoridad = 'Lorem';
    var SacarDivisionesDeXAutoridad = 'SELECT DISTINCT * FROM (SELECT B.usuario, A.idDivision, CONCAT(año," ",especialidad," ",numDivision) AS Division FROM Division AS A JOIN Profesores_Division AS B ON (A.idDivision = B.idDivision) WHERE B.tomarLista = 1) AS C UNION SELECT * FROM (SELECT E.usuario, D.idDivision, CONCAT(año," ",especialidad," ",numDivision) AS Division FROM Division AS D JOIN Preceptores_Division AS E ON (D.idDivision = E.idDivision)) AS F WHERE usuario = ' + "'" +usuarioAutoridad + "'" + ';'; //Divisiones donde la Autoridad es la seleccionada.
    pool.query(SacarDivisionesDeXAutoridad, (err,rows)=>
    {
        if(err)
        {
            throw(err);
        }
        res.json(rows);
    })


});

app.get('/ObtenerSemSistencia/:idDivision/:diaSemana', async (req,res, next)=>
{
    var consulta = "SELECT idSemana, tipo as turno, idDivision FROM Semana WHERE (Semana.idDivision = " + req.params.idDivision + " AND Semana.diaSemana = (SELECT DAYOFWEEK('" + req.params.diaSemana + "')));";
    console.log(consulta);
    pool.query(consulta,(err,rows) =>
    {
        if(err)
        {
            throw err;
        }
        res.json(rows);
    })
});

app.get('/ListaAlumnos/:IdDivision', async (req,res,next)=>
{
    console.log("Alguien quiere la lista de alumnos de la division con el id " + req.params.IdDivision);
    var consulta = "SELECT Alumno.dniAlumno AS dniAlumno, nombre AS Nombre, apellido AS Apellido FROM Alumno JOIN Historial_Alumno ON (Alumno.dniAlumno = Historial_Alumno.dniAlumno) WHERE (idDivision = " + req.params.IdDivision+");";
    pool.query(consulta, (err, rows) =>
    {
        if(err)
        {
            throw err;
        }
        res.json(rows);
    });
});

app.post('/Agregar', async (req,res, next)=>
{
    var sql = "INSERT INTO Proyecto1_2.Asistencia (dniAlumno, idSemana, valor, fecha) VALUES (" + req.body.dniAlumno + "," + req.body.idSemana + ",'" + req.body.valor + "','"+ req.body.fecha +"');";
    pool.query(sql, (err,res)=>{
        if(err) throw err;
        console.log("I'm in");
    });
    res.sendFile(__dirname + "/vistas/exito.html");
});
    
app.listen(3000);
console.log('El server está vivo.');