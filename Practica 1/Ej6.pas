{6. Agregar al menú del programa del ejercicio 5, opciones para:
a. Añadir uno o más celulares al final del archivo con sus datos ingresados por
teclado.
b. Modificar el stock de un celular dado.
c. Exportar el contenido del archivo binario a un archivo de texto denominado:
”SinStock.txt”, con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular.}

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
    writeln('5.Añadir uno o mas celulares.');
    writeln('6.Modificar stock de un celular.');
    writeln('7.Exportar celulares sin stock a txt.');
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

procedure AgregarCelular(var archLogico: arch_celular);

    procedure LeerCelular(var c: celular);
    begin
        write('Codigo de celular: '); readln(c.codigo);        
        write('Nombre: '); readln(c.nombre);
        write('Descripcion: '); readln(c.descripcion);
        write('Marca: '); readln(c.marca);
        write('Precio: '); readln(c.precio);
        write('Stock minimo: '); readln(c.stock_min);
        write('Stock actual: '); readln(c.stock_act);
    end;

    procedure SeleccionarCantidad(var cant: integer);
    begin
        write('Ingrese la cantidad de celulares a agregar: ');
        readln(cant);
    end;

    procedure AgregarUno (var archLogico: arch_celular);
    var
        c: celular;
    begin
        seek(archLogico, filesize(archLogico));
        LeerCelular(c);
        write(archLogico, c);
    end;

    procedure AgregarVarios(var archLogico: arch_celular; cant: integer);
    var
        c: celular;
        i: integer;
    begin
        for i:=1 to cant do begin
            seek(archLogico, filesize(archLogico));
            LeerCelular(c);
            write(archLogico, c);
        end;
    end;

var
    cant: integer;
    archFisico: str20;
begin
    SeleccionarArchivo(archFisico);
    assign(archLogico, archFisico);
    reset(archLogico);
    SeleccionarCantidad(cant);
    if (cant > 0) and (cant < 2) then
        AgregarUno(archLogico)
    else
        AgregarVarios(archLogico, cant);
    close(archLogico);
end;

procedure ModificarStock(var archLogico: arch_celular);

    procedure SeleccionarCelular(var nombre: str20);
    begin
        write('Ingrese el nombre del celular buscado: ');
        readln(nombre);
    end;

    procedure Modificar(var archLogico: arch_celular; nombre: str20);
    var
        c: celular;
        modificado: boolean;
        cant: integer;
    begin
        modificado:= false;
        while (not eof(archLogico)) and (not modificado) do begin
            read(archLogico, c);
            if(c.nombre = nombre) then begin
                write('Ingrese cantidad para actualizar el stock: ');
                readln(cant);
                c.stock_act:= cant;
                seek(archLogico, filepos(archLogico) - 1);
                write(archLogico, c);
                modificado:= true;
            end;
        end;

        if(modificado)then
            writeln('Se modifico el stock correctamente.')
        else
            writeln('No se encontro el celular en la base de datos.');
    end;

var
    archFisico, nombre: str20;
begin
    SeleccionarArchivo(archFisico);
    assign(archLogico, archFisico);
    reset(archLogico);
    SeleccionarCelular(nombre);
    Modificar(archLogico, nombre);
    close(archLogico);
end;

procedure ExportarSinStock(var archLogico: arch_celular);
var
    txt: Text;
    c: celular;
begin
    assign(txt, 'SinStock.txt');
    rewrite(txt);
    while(not eof(archLogico)) do begin
        read(archLogico, c);
        if(c.stock_act = 0) then begin
            with c do begin
                writeln(txt, codigo, ' ', precio, ' ', marca);
				writeln(txt, stock_act, ' ', stock_min, ' ', descripcion);
				writeln(txt, nombre);
            end;
        end;
    end;
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
            '5':begin
                    AgregarCelular(archLogico);
                end;
            '6':begin
                    ModificarStock(archLogico);
                end;
            '7':begin
                    ExportarSinStock(archLogico);
                end;
            else
                ejecucion:= false;
        end;
    end;
end.
