{5. Realizar un programa para una tienda de celulares, que presente un men� con
opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado �celulares.txt�. Los registros
correspondientes a los celulares deben contener: c�digo de celular, nombre,
descripci�n, marca, precio, stock m�nimo y stock disponible.
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock m�nimo.
c. Listar en pantalla los celulares del archivo cuya descripci�n contenga una
cadena de caracteres proporcionada por el usuario.
d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
�celulares.txt� con todos los celulares del mismo. El archivo de texto generado
podr�a ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
deber�a respetar el formato dado para este tipo de archivos en la NOTA 2.
NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.
NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
tres l�neas consecutivas. En la primera se especifica: c�digo de celular, el precio y
marca, en la segunda el stock disponible, stock m�nimo y la descripci�n y en la tercera
nombre en ese orden. Cada celular se carga leyendo tres l�neas del archivo
�celulares.txt�.}
program Ej5;
type
    str20 = String[20];

    celular = record
        codigo: integer;
        nombre: str20;
        descripcion: String;
        marca: str20;
        precio: real;
        stock_min: integer;
        stock_act: integer;
    end;

    arch_celular = file of celular;

procedure MenuPrincipal(var opc: char);
begin
    writeln('-------------------');
    writeln('Seleccione que tipo de operacion desea realizar.');
    writeln('1.Crear un archivo desde celulares.txt.');
    writeln('2.Listar celulares con stock menor al minimo.');
    writeln('3.Listar celular con descripcion ingresada por el usuario.');
    writeln('4.Exportar a celulares.txt.');
    writeln('Ingrese cualquier otro caracter para salir.');
    writeln('-------------------');
    readln(opc);
end;

procedure ListarCelular(c:celular);
begin
	writeln('---------------------------------------------------------');
	writeln('Codigo: ', c.codigo, ' -- Precio: ', c.precio, ' -- Marca: ', c.marca);
	writeln('Disponibles: ', c.stock_act, ' -- StockMinimo: ', c.stock_min, ' -- Descripcion: ', c.descripcion);
	writeln('Nombre: ', c.nombre);
	writeln('---------------------------------------------------------');
end;

procedure CrearArchivo(var archLogico: arch_celular);

    procedure CargarArchivo(var archLogico: arch_celular);
    var
        c: celular;
        txt: Text;
    begin
        assign(txt, 'celulares.txt');
        reset(txt);
        while (not eof(txt)) do begin
            read(archLogico, c);
            with c do begin
                readln(txt, codigo, precio, marca);
                readln(txt, stock_act, stock_min, descripcion);
                readln(txt, nombre);
            end;
            write(archLogico, c);
        end;
    end;

var
    archFisico: str20;
begin
    write('Ingrese el nombre del archivo a crear: ');
    readln(archFisico);
    assign(archLogico, archFisico);
    rewrite(archLogico);
    CargarArchivo(archLogico);
    close(archLogico);
end;

procedure SeleccionarArchivo(var archFisico: str20);
begin
    write('Ingrese el nombre del archivo que desea utilizar: ');
    readln(archFisico);
end;

procedure ListarPorStock(var archLogico: arch_celular);
var
    c: celular;
    archFisico: str20;
begin
    SeleccionarArchivo(archFisico);
    assign(archLogico, archFisico);
    reset(archLogico);
    while (not eof(archLogico)) do begin
        read(archLogico, c);
        if(c.stock_act < c.stock_min) then
            ListarCelular(c)
    end;
    close(archLogico);
end;

procedure ListarPorDescripcion(var archLogico: arch_celular);
var
    c: celular;
    cadena: String;
    archFisico: str20;
begin
    SeleccionarArchivo(archFisico);
    assign(archLogico, archFisico);
    reset(archLogico);
    writeln('Ingrese descripcion a buscar: ');
    readln(cadena);
    while (not eof(archLogico)) do begin
        read(archLogico, c);
        if(c.descripcion = cadena) then
            ListarCelular(c);
    end;
    close(archLogico);
end;

procedure GenerarTxt(var archLogico: arch_celular);
var
    c: celular;
    txt: Text;
    archFisico: str20;
begin
    SeleccionarArchivo(archFisico);
    assign(archLogico, archFisico);
    reset(archLogico);
    assign(txt, 'celulares.txt');
    rewrite(txt);
    while(not eof(archLogico)) do begin
        read(archLogico, c);
        writeln(txt, c.codigo, ' ', c.precio, ' ', c.marca);
        writeln(txt, c.stock_act, ' ', c.stock_min, ' ', c.descripcion);
        writeln(txt, c.nombre);
    end;
    close(archLogico);
    close(txt);
end;

var
    archLogico: arch_celular;
    ejecucion: boolean;
    opc: char;
    archFisico: str20;
begin
    ejecucion:= true;
    while (ejecucion) do begin
        MenuPrincipal(opc);
        case opc of
            '1':begin
                    CrearArchivo(archLogico);
                end;
            '2':begin
                    ListarPorStock(archLogico);
                end;
            '3':begin
                    ListarPorDescripcion(archLogico);
                end;
            '4':begin
                    GenerarTxt(archLogico);
                end;
            else
                ejecucion:= false;
        end;
    end;
end.



