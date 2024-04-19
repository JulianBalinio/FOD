{8. Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
cliente. Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido
por la empresa.
El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
mes, día y monto de la venta. El orden del archivo está dado por: cod cliente, año y mes.
Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
compras. No es necesario que informe tales meses en el reporte.}
program Ej8;
const
    corte = 9999;
type
    str20 = string[20];
    informeCliente = record
        cod: integer;
        nombre: str20;
        apellido: str20;
    end;

    informeMaestro = record
        cliente: informeCliente;
        anio: integer;
        dia: integer;
        mes: integer;
        monto: real;
    end;

    maestro = file of informeMaestro;

procedure  Leer(var archM: maestro; var im: informeMaestro);
begin
    if(not eof(archM)) then
        read(archM, im)
    else
        im.cliente.cod:= corte;
end;

procedure Procesar(var archM: maestro);
var
    total, totalAnio, totalMes: real;
    anioActual, mesActual, codActual: integer;
    im: informeMaestro;
begin
    assign(archM, 'maestro.bin');
    reset(archM);
    Leer(archM, im);
    total:= 0;
    while(im.cliente.cod <> corte) do begin
        codActual:= im.cliente.cod;
        writeln('Cliente ', im.cliente.nombre, ' ', im.cliente.apellido);
        while(codActual = im.cliente.cod) do begin
            anioActual:= im.anio;
            totalAnio:= 0;
            while(codActual = im.cliente.cod) and (anioActual = im.anio) do begin
                mesActual:= im.mes;
                totalMes:= 0;
                while(codActual = im.cliente.cod) and (mesActual = im.mes) and (anioActual = im.anio) do begin
                    totalMes:= totalMes + im.monto;
                    Leer(archM, im);
                end;
                if(totalMes > 0) then begin
                    write('Mes ', mesActual, ' | ');
                    writeln('Monto mensual: ', totalMes:2:2);
                    totalAnio:= totalAnio + totalMes;
                end;
            end;
            write('Año ', anioActual, ' | ');
            writeln('Monto anual: ', totalAnio:2:2);
            writeln();
            total:= total + totalAnio;
        end;
    end;
    writeln('Se ha facturado un total de $', total:2:2);
    close(archM);
end;

var
    archM: maestro;
begin
    Procesar(archM);
end.
