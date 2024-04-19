{5. Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. 
Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo. Pensar alternativas sobre realizar el informe en el mismo
procedimiento de actualización, o realizarlo en un procedimiento separado (analizar
ventajas/desventajas en cada caso).
Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.}
program Ej5;
const
    dimF = 30;
    corte = 9999;
type
    str20 = string[20];

    producto = record
        codigo: integer;
        nombre: str20;
        descripcion: string;
        stockDisp: integer;
        stockMin: integer;
        precio: real;
    end;

    productoDetalle = record
        codigo: integer;
        cantidad: integer;
    end;

    maestro = file of producto;
    detalle = file of productoDetalle;

    vDetalle = array[1..dimF] of detalle;
    vRegistro = array[1..dimF] of productoDetalle;

procedure LeerDetalle(var archD: detalle; var d: productoDetalle);
begin
    if(not eof(archD)) then
        read(archD, d)
    else
        d.codigo:= corte;
end;

procedure Minimo(var v: vDetalle; var vr: vRegistro; var min: productoDetalle);
var
    i, pos: integer;
begin
    min.codigo:= corte;
    pos:= -1;
    for i:= 1 to dimF do begin
        if(vr[i].codigo < min.codigo) then begin
            min:= vr[i];
            pos:= i;
        end;
    end;
    if(min.codigo <> corte) then
        LeerDetalle(v[pos], vr[pos]);
end;

procedure AsignarLeerVectores(var v: vDetalle; var vr: vRegistro);
var
    i: integer;
    num: string;
begin
    for i:= 1 to dimF do begin
        Str(i, num);
        assign(v[i], 'detalle'+num+'.dat');
        reset(v[i]);
        LeerDetalle(v[i], vr[i]);
    end;
end;

procedure ActualizarMaestro(var archM: maestro; var v: vDetalle; var vr: vRegistro);
var
    i: integer;
    p: producto;
    min: productoDetalle;
begin
    AsignarLeerVectores(v, vr);
    assign(archM, 'maestro.dat');
    reset(archM);
    Minimo(v, vr, min);
    while(min.codigo <> corte) do begin
        read(archM, p);
        while(p.codigo <> min.codigo) do
            read(archM, p);
        while(p.codigo = min.codigo) do begin
            p.stockDisp:= p.stockDisp - min.cantidad;
            if(p.stockDisp < 0) then
                p.stockDisp:= 0;
            minimo(v, vr, min);
        end;
        seek(archM, filepos(archM)-1);
        write(archM, p);
    end;
    close(archM);
    for i:= 1 to dimF do
        close(v[i]);
end;

procedure GenerarTxt(var archM: maestro);
var
    txt: text;
    archF: str20;
    p: producto;
begin
    write('Nombre del archivo de texto: ');
    readln(archF);
    assign(archM, archF);
    rewrite(txt);
    reset(archM);
    while(not eof(archM)) do begin
        read(archM, p);
        writeln(txt, p.codigo, ' ', p.nombre, ' ', p.descripcion, ' ', p.stockDisp, ' ', p.stockMin, ' $',p.precio);
    end;
    close(archM);
    close(txt);
end;

var
    archM: maestro;
    v: vDetalle;
    vr: vRegistro;
begin
    ActualizarMaestro(archM, v, vr);
    GenerarTxt(archM);
end.
