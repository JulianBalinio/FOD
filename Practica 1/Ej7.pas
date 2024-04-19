{7. Realizar un programa que permita:
a) Crear un archivo binario a partir de la información almacenada en un archivo de
texto. El nombre del archivo de texto es: “novelas.txt”. La información en el
archivo de texto consiste en: código de novela, nombre, género y precio de
diferentes novelas argentinas. Los datos de cada novela se almacenan en dos
líneas en el archivo de texto. La primera línea contendrá la siguiente información:
código novela, precio y género, y la segunda línea almacenará el nombre de la
novela.
b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder
agregar una novela y modificar una existente. Las búsquedas se realizan por
código de novela.
NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado.}
program Ej7;
type
    str40 = string[40];
    str20 = string[20];

    novela = record
        codigo: integer;
        nombre: str40;
        genero: str20;
        precio: real;
    end;

    arch_novela = file of novela;

procedure MenuPrincipal(var opc: char);
begin
    writeln('-----------------------------');
    writeln('MENU PRINCIPAL');
    writeln('Seleccione la operacion que desea realizar.');
    writeln('1. Crear archivo binario con datos de novelas.txt.');
    writeln('2. Abrir archivo existente.');
    writeln('Ingrese otro caracter para salir.');
    writeln('-----------------------------');
    write('Ingrese opcion: '); readln(opc);
end;

procedure CrearArchivoBinario(var archLogico: arch_novela);

    procedure CopiarInformacion(var archLogico: arch_novela);
    var
        txt: Text;
        n: novela;
    begin
        assign(txt, 'novelas.txt');
        reset(txt);
        while(not eof(txt)) do begin;
            with n do begin
                readln(txt, codigo, nombre, precio, genero);
                readln(txt, nombre);
            end;
            write(archLogico, n);
        end;
        close(txt);
    end;

var
    archFisico: str20;
begin
    write('Ingrese el nombre del archivo a crear: ');
    readln(archFisico);
    assign(archLogico, archFisico);
    rewrite(archLogico);
    CopiarInformacion(archLogico);
    close(archLogico);
end;

procedure LeerNovela(var n: novela);
begin
    write('Codigo de novela: '); readln(n.codigo);
    write('Nombre de la novela: '); readln(n.nombre);
    write('Genero de la novela: '); readln(n.genero);
    write('Precio: '); readln(n.precio);
end;

procedure AbrirArchivo(var archLogico: arch_novela);

    procedure MenuAbrirArchivo(var opc: char);
    begin
        writeln('-----------------------------');
        writeln('Seleccione la operacion que desea realizar.');
        writeln('1.Agregar novela.');
        writeln('2.Modificar una novela existente.');
        writeln('Ingrese otro caracter para salir del menu.');
        writeln('-----------------------------');
        write('Ingrese opcion: '); readln(opc);
    end;

    procedure AgregarNovela(var archLogico: arch_novela);

    var
        n: novela;
    begin
        seek(archLogico, filesize(archLogico));
        LeerNovela(n);
        write(archLogico, n);
    end;

    procedure ModificarNovela(var archLogico: arch_novela);

        procedure MenuModificar(var opc: char);
        begin
            writeln('-----------------------------');
            writeln('Que desea modificar?');
            writeln('1.Nombre.');
            writeln('2.Genero.');
            writeln('3.Precio.');
            writeln('Ingrese otro caracter para salir del menu.');
            writeln('-----------------------------');
            write('Ingrese opcion: '); readln(opc);
        end;

        procedure ModificarNombre(var n: novela);
        var
            nombre: str40;
        begin
            write('Nombre actualizado: ');
            readln(nombre);
            n.nombre := nombre;
        end;

        procedure ModificarGenero(var n: novela);
        var
            genero: str20;
        begin
            write('Genero actualizado: ');
            readln(genero);
            n.genero := genero;
        end;

        procedure ModificarPrecio(var n: novela);
        var
            precio: real;
        begin
            write('Precio actualizado: ');
            readln(precio);
            n.precio := precio;
        end;

    var
        n: novela;
        codigo: integer;
        ejecucion, encontrado: boolean;
        opc: char;
    begin
        write('Ingrese el codigo de la novela a modificar: ');
        readln(codigo);
        encontrado:= false;
        while(not eof(archLogico)) and (not encontrado) do begin
            read(archLogico, n);
            if(n.codigo = codigo) then begin
                seek(archLogico, filesize(archLogico)-1);
                encontrado:= true;
            end;
        end;

        if(encontrado) then begin
            ejecucion:= true;
            while (ejecucion) do begin
                MenuModificar(opc);
                case opc of
                    '1':begin
                            ModificarNombre(n);
                            write(archLogico, n);
                        end;
                    '2':begin
                            ModificarGenero(n);
                            write(archLogico, n);
                        end;
                    '3':begin
                            ModificarPrecio(n);
                            write(archLogico, n);
                        end;
                    else
                        ejecucion:=false;
                end;
            end;
            close(archLogico);
        end
        else
            writeln('Novela no encontrada.');
    end;

var
    archFisico: str20;
    opc: char;
    ejecutando: boolean;
begin
    write('Ingrese el nombre del archivo que desea abrir: ');
    readln(archFisico);
    assign(archLogico, archFisico);
    reset(archLogico);
    ejecutando:= true;
    while (ejecutando) do begin
        MenuAbrirArchivo(opc);
        case opc of
            '1':begin
                    AgregarNovela(archLogico);
                end;
            '2':begin
                    ModificarNovela(archLogico);
                end;
            else
                ejecutando:= false
        end;
    end;
    close(archLogico);
end;

var
    archLogico: arch_novela;
    opc: char;
    ejecucion: boolean;
    str: str20;
begin
    ejecucion:= true;

    while (ejecucion) do begin
        MenuPrincipal(opc);
        case opc of
            '1':begin
                    CrearArchivoBinario(archLogico);
                end;
            '2':begin
                    AbrirArchivo(archLogico);
                end;
            else
                ejecucion:= false;
        end;
    end;
end.
