{9. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
Presentar en pantalla un listado como se muestra a continuación:
Código de Provincia
Código de Localidad Total de Votos
................................ ......................
................................ ......................
Total de Votos Provincia: ____
Código de Provincia
Código de Localidad Total de Votos
................................ ......................
Total de Votos Provincia: ___
…………………………………………………………..
Total General de Votos: ___
NOTA: La información está ordenada por código de provincia y código de localidad.}

program Ej9;
const
    corte = 9999;
type

    informe = record
        codProv: integer;
        codLoc: integer;
        numeroMesa: integer;
        votosMesa: integer;
    end;

    maestro = file of informe;

procedure Leer(var archM: maestro; var inf: informe);
begin
    if(not eof(archM)) then
        read(archM, inf)
    else
        inf.codProv:= corte;
end;

procedure Procesar(var archM: maestro);
var
    codLoc, codProv: integer;
    totalLoc, totalProv, total: integer;
    inf: informe;
begin
    assign(archM, 'maestro.bin');
    reset(archM);
    Leer(archM, inf);
    total:= 0;
    while(inf.codProv <> corte) do begin
        codProv:= inf.codProv;
        writeln('Codigo de provincia: ', codProv);
        totalProv:= 0;
        while (inf.codProv = codProv) do begin
            codLoc:= inf.codLoc;
            writeln('Codigo de localidad: ', codLoc);
            totalLoc:= 0;
            while(inf.codLoc = codLoc) do begin
                totalLoc:= totalLoc + inf.votosMesa;
                Leer(archM, inf);
            end;
            writeln('Codigo de localidad: ', codLoc, ' Total votos: ', totalLoc);
            totalProv:= totalProv + totalLoc;
            writeln();
        end;
        totalProv:= totalProv + totalLoc;
        writeln('Codigo de provincia: ', codProv, ' Total votos: ', totalProv);
        total:= total + totalProv;
        writeln();
    end;
    close(archM);
end;

var
    archM: maestro;
begin
    Procesar(archM);
end.
