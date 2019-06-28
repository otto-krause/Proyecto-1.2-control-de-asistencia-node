var express = require('express');
var pool = require('./bd.js').pool;
var bodyparser = require('body-parser');
var urlencodedParser = bodyparser.urlencoded({extended: false});
var app = express();
var consultas = require('./consultas.js').consultas;

app.use(express.static(__dirname + '/viste'));
app.use(bodyparser.json());
app.get('/home', (req,res)=>
{
    console.log(consultas);
    res.sendFile(__dirname + '/viste/home.html');
});

app.get('/Alumno/:id',(req,res)=>
{
    pool.query(consultas.mostrarAlumno, req.params.id , (err, result) => {
            if (err) throw err;
            if (result[0] != null)
            {
                console.log(result);
                res.send(result);
            }
            else
            {
                console.log("No");
                res.send("No hay valores en la base de datos para ese id");
            }
    })
});
app.get('/TomarLista', (req,res)=>
{
    console.log(consultas);
    res.sendFile(__dirname + '/viste/tomarLista.html');
});

app.post('/Agregar', urlencodedParser, (req,res)=>
{
    console.log(req.body);
});


app.listen(3000);
console.log('El server está vivo.');