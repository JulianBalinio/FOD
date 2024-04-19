{3. El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: código de
producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De
cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
realizar un programa con opciones para:
a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.
● El archivo detalle sólo contiene registros que están en el archivo maestro.
b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido.}
program Ej3;
const
    corte = -1;
type
    str20 = string[20];
    producto = record
        codigo: integer;
        nombre: str20;
        precio: real;
        stockActual: integer;
        stockMinimo: integer;
    end;

    venta = record
        codigo: integer;
        cantidad: integer;
    end;

    maestro = file of producto;
    detalle = file of venta;

procedure Main(var opc: char);
begin
    writeln('---------------------------------');
    writeln('Seleccione la operacion que desea realizar.');
    writeln('1.Modificar archivo maestro.');
    writeln('2.Listar .dat a stock_minimo.txt');
    readln(opc);
    writeln('---------------------------------');
end;

procedure LeerDetalle(var archD: detalle; var v: venta);
begin
    if(not eof(archD)) then
        read(archD, v)
    else
        v.codigo:= corte;
end;

procedure ActualizarMaestro(var archM: maestro; var archD: detalle);
var
    v: venta;
    p: producto;
begin
    assign(archM, 'maestro.dat');
    assign(archD, 'detalle.dat');
    reset(archM);
    reset(archD);
    LeerDetalle(archD, v);
    while(v.codigo <> corte) do begin
        read(archM, p);
        while(p.codigo <> v.codigo) do
            read(archM, p);
        while(p.codigo = v.codigo) do begin
            p.stockActual:= p.stockActual - v.cantidad;
            if(p.stockActual < 0) then
                p.stockActual:= 0;
            LeerDetalle(archD, v);
        end;
        seek(archM, filepos(archM)-1);
        write(archM, p);
    end;
    close(archM);
end;

procedure GenerarTxt(var archM: maestro);
var
    txt: text;
    p: producto;
begin
    assign(archM, 'maestro.dat');
    reset(archM);
    assign(txt, 'stock_minimo.txt');
    rewrite(txt);
    while(not eof(archM)) do begin
        read(archM, p);
        if(p.stockActual < p.stockMinimo) then
            writeln(txt, p.codigo, ' ', p.nombre, ' $', p.precio, ' Actual:', p.stockActual, ' Minimo', p.stockMinimo);
    end;
    close(archM);
    close(txt);
end;

var
    archM: maestro;
    archD: detalle;
    opc: char;
    ejec: boolean;
begin
    ejec:= true;
    while (ejec) do begin
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
