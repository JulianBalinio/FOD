{6. Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma fue
construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
● Cada archivo detalle está ordenado por cod_usuario y fecha.
● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o
inclusive, en diferentes máquinas.
● El archivo maestro debe crearse en la siguiente ubicación física: /var/log.}
program Ej6;
const
    corte = 9999;
    dimF = 5;
type
    informeDetalle = record
        codUsuario: integer;
        fecha: integer;
        tiempoSesion: integer;
    end;

    informeMaestro = record
        codUsuario: integer;
        fecha: integer;
        tiempoTotal: integer;
    end;

    maestro = file of informeMaestro;
    detalle = file of informeDetalle;

    vDetalle = array[1..dimF] of detalle;
    vInformeDet = array[1..dimF] of informeDetalle;

procedure LeerDetalle(var archD: detalle; var id: informeDetalle);
begin
    if(not eof(archD)) then
        read(archD, id)
    else
        id.codUsuario:= corte;
end;

procedure AsignarLeerVectores(var vd: vDetalle; var vi: vInformeDet);
var
    i: integer;
    num: string;
begin
    for i:=1 to dimF do begin
        Str(i, num);
        assign(vd[i], 'detalle'+num+'.dat');
        reset(vd[i]);
        LeerDetalle(vd[i], vi[i]);
    end;
end;

procedure Minimo(var vd: vDetalle; var vi: vInformeDet; var min: informeDetalle);
var
    i, pos: integer;
begin
    min.codUsuario:= corte;
    min.fecha:= corte;
    pos:= -1;
    for i:= 1 to dimF do
        if(vi[i].codUsuario <= min.codUsuario) and (vi[i].fecha <= min.fecha) then begin
            min:= vi[i];
            pos:= i;
        end;
    if(min.codUsuario <> corte) then
        read(vd[pos], vi[pos]);
end;


procedure ActualizarMaestro(var archM: maestro; var vd: vDetalle; var vi: vInformeDet);
var
    min: informeDetalle;
    i: integer;
    infoM: informeMaestro;
begin
    AsignarLeerVectores(vd, vi);
    assign(archM, '/var/log/maestro.dat');
    rewrite(archM);
    Minimo(vd, vi, min);
    while(min.codUsuario <> corte) do begin
        read(archM, infoM);
        while(infoM.codUsuario <> min.codUsuario) do
            read(archM, infoM);
        while(infoM.codUsuario = min.codUsuario) do begin
            infoM.tiempoTotal:= infoM.tiempoTotal + min.tiempoSesion;
            Minimo(vd, vi, min);
        end;
        seek(archM, filepos(archM)-1);
        write(archM, infoM);
    end;
    close(archM);
    for i:= 1 to dimF do
        close(vd[i]);
end;

var
    vd: vDetalle;
    vi: vInformeDet;
    archM: maestro;
begin
    ActualizarMaestro(archM, vd, vi);
end.
