{4. A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.}
program Ej4;
const
    corte = -1;
type
    str20 = string[20];

    provincia = record
        nombre: str20;
        alfabetizados: integer;
        encuestados: integer;
    end;

    censo = record
        nombreProvincia: str20;
        codigoLoc: integer;
        alfabetizados: integer;
        encuestados: integer;
    end;

    maestro = file of provincia;
    detalle = file of censo;

var
    det1, det2: detalle;

procedure LeerDetalle(var archD: detalle; var c: censo);
begin
    if(not eof(archD)) then
        read(archD, c)
    else
        c.codigoLoc:= corte;
end;

procedure Minimo(var c1, c2: censo; var min: censo);
begin
    if(c1.nombreProvincia <= c2.nombreProvincia)then begin
        min:= c1;
        LeerDetalle(det1, c1);
    end
    else begin
        min:= c2;
        LeerDetalle(det2, c2);
    end;
end;

procedure ActualizarMaestro(var archM: maestro);
var
    c1, c2, min: censo;
    p: provincia;
begin
    assign(archM, 'maestro.dat');
    assign(det1, 'detalle1.dat');
    assign(det2, 'detalle2.dat');
    reset(archM);
    reset(det1); 
    reset(det2);
    LeerDetalle(det1, c1); 
    LeerDetalle(det2, c2);
    Minimo(c1, c2, min);
    while(min.codigoLoc <> corte) do begin
        read(archM, p);
        while(p.nombre <> min.nombreProvincia) do
            read(archM, p);
        while(p.nombre = min.nombreProvincia) do begin
            p.alfabetizados:= p.alfabetizados + min.alfabetizados;
            p.encuestados:= p.encuestados + min.encuestados;
            Minimo(c1, c2, min);
        end;
        seek(archM, filepos(archM)-1);
        write(archM, p);
    end;
    close(archM);
    close(det1);
    close(det2);
end;

var
    archM: maestro;
begin
    ActualizarMaestro(archM);
end.
