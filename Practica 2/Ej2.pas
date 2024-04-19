{2. Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:
a. Actualizar el archivo maestro de la siguiente manera:
i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado,
y se decrementa en uno la cantidad de materias sin final aprobado.
ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
final.
b. Listar en un archivo de texto aquellos alumnos que tengan más materias con finales
aprobados que materias sin finales aprobados. Teniendo en cuenta que este listado
es un reporte de salida (no se usa con fines de carga), debe informar todos los
campos de cada alumno en una sola línea del archivo de texto.
NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez.}
program Ej2;
const
    corte = 9999;
type
    str20 = string[20];

    alumno = record
        codigo: integer;
        apellido: str20;
        nombre: str20;
        cursadasAp: integer;
        finalesAp: integer;
    end;

    det = record
        codigo: integer;
        cursada: boolean;
        final: boolean;
    end;

    maestro = file of alumno;
    detalle = file of det;

procedure LeerDetalle(var archD: detalle; var d: det);
begin
    if(not eof(archD)) then
        read(archD, d)
    else
        d.codigo:= corte;
end;

procedure ActualizarMaestro(var archM: maestro; var archD: detalle);
var
    aD: det;
    aM: alumno;
begin
    assign(archM, 'maestro.dat');
    reset(archM);
    assign(archD, 'detalle.dat');
    reset(archD);
    LeerDetalle(archD, aD);
    while(aD.codigo <> corte) do begin
        read(archM, aM);
        while(aM.codigo <> aD.codigo) do
            read(archM, aM);
        while(aM.codigo = aD.codigo) do begin
            if(aD.cursada) then
                aM.cursadasAp:= aM.cursadasAp + 1;
            if(aD.final) then
                aM.finalesAp:= aM.finalesAp + 1;
            LeerDetalle(archD, aD);
        end; 
        seek(archM, filepos(archM) - 1);
        write(archM, aM);
    end;
    close(archM);
    close(archD);
end;

procedure GenerarTxt(var archM: maestro);
var
    a: alumno;
    txt: Text;
    txtFisico: str20;
begin
    assign(archM, 'maestro.dat');
    reset(archM);
    write('Nombre del txt: ');
    readln(txtFisico);
    assign(txt, txtFisico);
    rewrite(txt);
    while (not eof(archM)) do begin
        read(archM, a);
        if(a.finalesAp > a.cursadasAp) then
            writeln(txt, a.codigo, ' ', a.nombre, ' ', a.apellido, ' ', a.cursadasAp, ' ', a.finalesAp);
    end;
    close(txt);
    close(archM);
end;

procedure Main(var opc: char);
begin
    writeln('----------------------------------');
    writeln('Seleccione la operacion que desea realizar.');
    writeln('1.Modificar finales/cursadas.');
    writeln('2.Listar contenido en txt.');
    readln(opc);
    writeln('----------------------------------');
end;

var
    archM: maestro;
    archD: detalle;
    opc: char;
    ejec: boolean;
begin
    ejec:= true;
    while ejec do begin
        Main(opc);
        case opc of
            '1':begin
                    ActualizarMaestro(archM, archD);
                end;
            '2':begin
                    GenerarTxt(archM);
                end;
            else
                ejec:= false;
        end;
    end;
end.
