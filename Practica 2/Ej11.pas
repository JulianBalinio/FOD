{11. La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio web
de la organización. En dicho servidor, se almacenan en un archivo todos los accesos que se
realizan al sitio. La información que se almacena en el archivo es la siguiente: año, mes, día,
idUsuario y tiempo de acceso al sitio de la organización. El archivo se encuentra ordenado
por los siguientes criterios: año, mes, día e idUsuario.
Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará
el año calendario sobre el cual debe realizar el informe. El mismo debe respetar el formato
mostrado a continuación:
Año : ---
Mes:-- 1
día:-- 1
idUsuario 1 Tiempo Total de acceso en el dia 1 mes 1
--------
idusuario N Tiempo total de acceso en el dia 1 mes 1
Tiempo total acceso dia 1 mes 1
-------------
día N
idUsuario 1 Tiempo Total de acceso en el dia N mes 1
--------
idusuario N Tiempo total de acceso en el dia N mes 1
Tiempo total acceso dia N mes 1
Total tiempo de acceso mes 1
------
Mes 12
día 1
idUsuario 1 Tiempo Total de acceso en el dia 1 mes 12
--------
idusuario N Tiempo total de acceso en el dia 1 mes 12
Tiempo total acceso dia 1 mes 12
-------------
día N
idUsuario 1 Tiempo Total de acceso en el dia N mes 12
--------
idusuario N Tiempo total de acceso en el dia N mes 12
Tiempo total acceso dia N mes 12
Total tiempo de acceso mes 12
Total tiempo de acceso año
Se deberá tener en cuenta las siguientes aclaraciones:
● El año sobre el cual realizará el informe de accesos debe leerse desde el teclado.
● El año puede no existir en el archivo, en tal caso, debe informarse en pantalla “año
no encontrado”.
● Debe definir las estructuras de datos necesarias.
● El recorrido del archivo debe realizarse una única vez procesando sólo la información
necesaria.}
program Ej11;
const
    corte = 9999;
type
    rangoDia = 1..31;
    rangoMes = 1..12;

    informe = record
        dia: rangoDia;
        mes: rangoMes;
        anio: integer;
        idUsuario: integer;
        tiempoAcceso: integer;
    end;

    archivo = file of informe;

procedure Leer(var arch: archivo; var inf: informe);
begin
    if(not eof(arch)) then
        read(arch, inf)
    else
        inf.anio:= corte;
end;

procedure Procesar(var arch: archivo);
var
    inf: informe;
    diaAct, mesAct: integer;
    anio, totalDia, totalMes, totalAnio, totalUsuario, usuarioActual: integer;
    encontrado: boolean;
begin
    write('Ingrese el año a buscar: '); readln(anio);
    assign(arch, 'maestro.bin');
    reset(arch);
    Leer(arch, inf);
    writeln('Año ', anio);
    while(inf.anio <> corte) and (inf.anio <= anio) do begin
        encontrado:= inf.anio = anio;

        if(not encontrado) then
            Leer(arch, inf)
        else begin
            totalAnio:= 0;
            while (inf.anio = anio) and (inf.anio <> corte) do begin
                mesAct:= inf.mes;
                totalMes:= 0;
                while(mesAct = inf.mes) and (inf.anio <> corte) do begin
                    diaAct:= inf.dia;
                    totalDia:= 0;
                    writeln('Dia ', diaAct);
                    while(diaAct = inf.dia) and (inf.anio <> corte) do begin
                        usuarioActual:= inf.idUsuario;
                        totalUsuario:= 0;
                        while(usuarioActual = inf.idUsuario) do begin
                            totalUsuario:= totalUsuario + inf.tiempoAcceso;
                            Leer(arch, inf);
                        end;
                        writeln('IdUsuario ', usuarioActual, ' / Tiempo Total: ', totalUsuario, ' en el dia ', diaAct, ' mes', mesAct);
                        totalDia:= totalDia + totalUsuario;
                    end;
                    writeln('Tiempo total de acceso dia ', diaAct, ' mes ', mesAct, ' :', totalDia);
                    totalMes:= totalMes + totalDia;
                end;
                writeln('Tiempo total de acceso mes ', mesAct, ' :', totalMes);
                totalAnio:= totalAnio + totalMes;
            end;
            writeln('Tiempo total de acceso año ', anio, ' :', totalAnio);
        end;
    end;
    close(arch);

    if(not encontrado) then
        writeln('Año no encontrado.');
end;

var
    arch: archivo;
begin
    Procesar(arch);
end.
