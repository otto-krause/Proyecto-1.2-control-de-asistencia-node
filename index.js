var express = require('express');
var pool = require('./bd.js').pool;
var app = express();
var consulta;

app.get('/home', (req,res)=>
{
    app.use(express.static(__dirname + '/viste'));
    res.sendFile(__dirname + '/viste/home.html');
});

app.get('/Alumno/:id',(req,res)=>
{
    pool.query("SELECT * FROM Alumno WHERE Alumno.idAlumno = ?", [req.params.id], (err, rows) => {
            if (rows[0] != null)
            {
                console.log(rows);
                res.send(rows);
            }
            else
            {
                console.log("No");
                res.send("No hay valores en la batadase para ese id");
            }    
        })      
});

/*;*/
app.listen(3000);
console.log('El server está vivo.');