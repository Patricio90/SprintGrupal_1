let r = new Date();
document.getElementById("Fecha").innerHTML=r;

// Funcion que valida el ingreso de los datos en el formulario de contacto
function validarFormulario () {
    //Variables
      let lfname = document.getElementById("lfname").value;
      let lemail = document.getElementById("lemail").value;
      let lmessage = document.getElementById("lmessage").value;
    
      console.log("Nombre " + lfname);
      console.log("Correo" + lemail);
      console.log("Mensaje" + lmessage);
      
     // Realizamos las validaciones de los Datos
     if ((lfname.length ==0) || (lemail.length==0) || (lmessage.length==0))
       {
         alert('Aprende a leer y llena los datos completos');
         alert('Completar los datos');
       }
       else
       {
        alert('Hemos recibido su mensaje, nuestro equipo se pondrá en contacto con usted.');
       }
    
    };

   
    /*** Esto es jQuery ***/
    $(document).ready(function () {
      $('#tablaProductos').DataTable();
    });
