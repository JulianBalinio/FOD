{12. Suponga que usted es administrador de un servidor de correo electrónico. En los logs del
mismo (información guardada acerca de los movimientos que ocurren en el server) que se
encuentra en la siguiente ruta: /var/log/logmail.dat se guarda la siguiente información:
nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados. Diariamente el
servidor de correo genera un archivo con la siguiente información: nro_usuario,
cuentaDestino, cuerpoMensaje. Este archivo representa todos los correos enviados por los
usuarios en un día determinado. Ambos archivos están ordenados por nro_usuario y se
sabe que un usuario puede enviar cero, uno o más mails por día.
a. Realice el procedimiento necesario para actualizar la información del log en un
día particular. Defina las estructuras de datos que utilice su procedimiento.
b. Genere un archivo de texto que contenga el siguiente informe dado un archivo
detalle de un día determinado:
nro_usuarioX…………..cantidadMensajesEnviados
………….
nro_usuarioX+n………..cantidadMensajesEnviados
Nota: tener en cuenta que en el listado deberán aparecer todos los usuarios que
existen en el sistema. Considere la implementación de esta opción de las
siguientes maneras:
i- Como un procedimiento separado del punto a).
ii- En el mismo procedimiento de actualización del punto a). Qué cambios
se requieren en el procedimiento del punto a) para realizar el informe en
el mismo recorrido?}
program Ej12;
const
    corte = 9999;
type

    correo = record
        nroUsuario: integer;
        nombreUsuario: string;
        nombre: string;
        apellido: string;
        mailEnviados: integer;
    end;

    infoDiaria = record
        nroUsuario: integer;
        cuentaDestino: string;
        cuerpoMensaje: string;
    end;

    maestro = file of correo;
    detalle = file of infoDiaria;

procedure LeerDetalle(var arch: detalle; var id: infoDiaria);
begin
    if(not eof(arch)) then
        read(arch, id)
    else
        id.nroUsuario:= corte;
end;

procedure LeerMaestro(var arch: maestro; var c: correo);
begin
    if(not eof(arch)) then
        read(arch, c)
    else
        c.nroUsuario:= corte;
end;

procedure ActualizarMaestro(var archM: maestro; var archD: detalle);
var
    regM: correo;
    regD: infoDiaria;
    enviados: integer;
    txt: text;
begin
    assign(archM, '/var/log/logmail.dat');
    assign(archD, 'reporteDiario.dat');
    assign(txt, 'reporte.txt');
    reset(archM);
    reset(archD);
    rewrite(txt);
    LeerMaestro(archM, regM);
    LeerDetalle(archD, regD);
    while(regM.nroUsuario <> corte) do begin
        while(regM.nroUsuario <> corte) and (regD.nroUsuario <> regM.nroUsuario) do
            LeerMaestro(archM, regM);
        if(regM.nroUsuario <> corte) then begin
            enviados:= 0;
            while(regM.nroUsuario = regD.nroUsuario) do begin
                enviados:= enviados + 1;
                regM.mailEnviados:= regM.mailEnviados + 1;
                LeerDetalle(archD, regD);
            end;
            seek(archM, filepos(archM)-1);
            write(archM, regM);
            writeln(txt, regD.nroUsuario, ' ', enviados);
            LeerMaestro(archM, regM);
        end;
    end;
    close(archM);
    close(archD);
end;

// Al hacer por separado el generador de txt, se estaria recorriendo nuevamente el archivo, haciendo lectura y escritura
// Esto es ineficiente

var
    archM: maestro;
    archD: detalle;
begin
    ActualizarMaestro(archM, archD);
end.



