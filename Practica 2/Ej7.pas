{7. Se desea modelar la información necesaria para un sistema de recuentos de casos de covid
para el ministerio de salud de la provincia de buenos aires.
Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad de
casos activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.
El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad de casos activos, cantidad de casos
nuevos, cantidad de recuperados y cantidad de fallecidos.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.
Para la actualización se debe proceder de la siguiente manera:
1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2. Idem anterior para los recuperados.
3. Los casos activos se actualizan con el valor recibido en el detalle.
4. Idem anterior para los casos nuevos hallados.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).}
program Ej7;
const
    corte = 9999;
    dimF = 10;
type

    informeDetalle = record
        codigoLoc: integer;
        codigoCepa: integer;
        casosActivos: integer;
        casosNuevos: integer;
        casosRecuperados:integer;
        casosFallecidos: integer;
    end;

    informeMaestro = record
        codigoLoc: integer;
        nombreLoc: string;
        codigoCepa: integer;
        casosActivos: integer;
        casosNuevos: integer;
        casosRecuperados: integer;
        casosFallecidos: integer;
    end;

    detalle = file of informeDetalle;
    maestro = file of informeMaestro;

    vDetalle = array[1..dimF] of detalle;
    vInforme = array[1..dimF] of informeDetalle;

procedure LeerDetalle(var archD: detalle; var inf: informeDetalle);
begin
    if(not eof(archD)) then
        read(archD, inf)
    else
        inf.codigoLoc:= corte;
end;

procedure Minimo(var vd: vDetalle; var vi: vInforme; var min: informeDetalle);
var
    i, pos: integer;
begin
    min.codigoLoc:= corte;
    min.codigoCepa:= corte;
    pos:= -1;
    for i:=1 to dimF do
        if(vi[i].codigoLoc <= min.codigoLoc) and (vi[i].codigoCepa <= min.codigoCepa) then begin
            min:= vi[i];
            pos:= i;
        end;
    if(vi[i].codigoLoc <> corte) then
        read(vd[pos], vi[pos]);
end;

procedure AsignarLeerVectores(var vd: vDetalle; var vi: vInforme);
var
    i: integer;
    num: string;
begin
    for i:= 1 to dimF do begin
        Str(i, num);
        assign(vd[i], 'detalle'+num+'.dat');
        reset(vd[i]);
        LeerDetalle(vd[i], vi[i]);
    end;
end;

procedure CerrarArchivos(var vd: vDetalle);
var
    i: integer;
begin
    for i:= 1 to dimF do
        close(vd[i]);
end;

procedure ActualizarMaestro(var archM: maestro; var vd: vDetalle; var vi: vInforme);
var
    min: informeDetalle;
    regM: informeMaestro;
    i: integer;
begin
    AsignarLeerVectores(vd, vi);
    assign(archM, 'maestro.dat');
    reset(archM);
    Minimo(vd, vi, min);
    while(min.codigoLoc <> corte) do begin
        read(archM, regM);
        while(regM.codigoLoc = min.codigoLoc) do begin
            regM.casosFallecidos:= regM.casosFallecidos + min.casosFallecidos;
            regM.casosRecuperados:= regM.casosRecuperados + min.casosRecuperados;
            regM.casosActivos:= regM.casosActivos + min.casosActivos;
            regM.casosNuevos:= regM.casosNuevos + min.casosNuevos;
            Minimo(vd, vi, min);
        end;
        seek(archM, filepos(archM)-1);
        write(archM, regM);
    end;
    close(archM);
    CerrarArchivos(vd);
end;

procedure InformarCantidad(var archM: maestro);
var
    regM: informeMaestro;
    temp: integer;
begin
    temp:= 0;
    while(not eof(archM)) do begin
        read(archM, regM);
        if(regM.casosActivos > 50) then
            temp:= temp + 1;
    end;
    writeln('Se encontraron ', temp, ' con mas de 50 casos activos.');
end;

var
    archM: maestro;
    vd: vDetalle;
    vi: vInforme;
begin
    ActualizarMaestro(archM, vd, vi);
    InformarCantidad(archM);
end.
