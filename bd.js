const mysql = require('mysql');

var pool = mysql.createPool({
    connectionLimit: 30,
    host : 'localhost',
    user : 'root',
    password : '',
    database : 'BD_Proyecto1_1'
})

pool.getConnection((err,conexion)=>
{
    if (err)
    {
        console.log("ERRORRORORIHNjhobn  ");
    }
    else
    {
        console.log("SE CONECtÓ A LA DB");
    }
});
exports.pool = pool;