var express = require('express');
var pool = require('./bd.js').pool;
var bodyparser = require('body-parser');
var app = express();
var consultas = require('./consultas.js').consultas;

app.use(bodyparser.urlencoded({extended: false}));
app.use(express.static(__dirname + '/vistas'));
app.use(bodyparser.json());
app.get(['/home', '/'], (req,res)=>
{
    res.sendFile(__dirname + '/vistas/home.html');
});

app.get('/Alumno/:id',(req,res)=>
{
    var resultado;
    resultado = pool.query("SELECT * FROM Alumno WHERE Alumno.idAlumno = ?;", req.params.id , (err, result) => {
            if (err) throw err;
            if (result[0] == null)
            {
                console.log("No");
                res.send("No hay valores en la base de datos para ese id");
            }
    })
    res.send(resultado);
});

app.get('/ListaAlumnos', (req,res)=>
{
    var consulta = "SELECT idAlumno AS ID, nombre AS Nombre, apellido AS Apellido FROM Alumno";
    pool.query(consulta, (err, rows) =>
    {
        if(err)
        {
            throw err;
        }
        res.json(rows);
    });
});


app.get('/TomarLista', (req,res)=>
{
    res.sendFile(__dirname + '/vistas/tomarLista.html');
});

app.post('/Agregar', (req,res)=>
{
    var sql = "INSERT INTO Proyecto1_2.Asistencia (idAlumno, idSemana, valor, fecha) VALUES (" + req.body.idAlumno + "," + req.body.idSemana + ",'" + req.body.valor + "','"+ req.body.fecha +"');";
    pool.query(sql, (err,res)=>{
        if(err) throw err;
        console.log("I'm in");
    });
    res.sendFile(__dirname + "/vistas/exito.html");
});
app.get('/Mostrar', (req,res)=>
{
    res.sendFile(__dirname+'/vistas/mostrar.html');
}); 
app.get('/No', (req,res)=>
{
    res.sendFile(__dirname + "/vistas/no.html");
});

app.listen(3000);
console.log('El server está vivo.');