{1. Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.}

program Ej1;
const
    corte = 9999;
type
    str20 = string[20];

    empleado = record 
        codigo: integer;
        nombre: str20;
        monto: real;
    end;

    arch_empleado = file of empleado;

procedure Leer(var archL: arch_empleado; var dato: empleado);
begin
    if(not eof(archL)) then
        read(archL, dato)
    else
        dato.codigo:= corte;
end;

procedure Procesar(var archL: arch_empleado; var archN: arch_empleado);
var
    e, empNuevo: empleado;
begin
    reset(archL);
    reset(archN);
    Leer(archL, e);
    while(e.codigo <> corte) do begin
        empNuevo:= e;
        empNuevo.monto:= 0;
        while(empNuevo.codigo = e.codigo) do begin
            empNuevo.monto:= empNuevo.monto + e.monto;
            Leer(archL, e);
        end;
        write(archN, empNuevo);
    end;
    close(archL);
    close(archN);
end;

var
    archL, archN: arch_empleado;
    archFisico: str20;
begin
    write('Ingrese nombre del archivo a crear: ');
    readln(archFisico);
    assign(archN, archFisico);
    write('Ingrese nombre del archivo detalle: ');
    readln(archFisico);
    assign(archL, archFisico);
    Procesar(archL, archN);
end.
