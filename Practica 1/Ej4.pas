{4. Agregar al men� del programa del ejercicio 3, opciones para:
a. A�adir uno o m�s empleados al final del archivo con sus datos ingresados por
teclado. Tener en cuenta que no se debe agregar al archivo un empleado con
un n�mero de empleado ya registrado (control de unicidad).
b. Modificar la edad de un empleado dado.
c. Exportar el contenido del archivo a un archivo de texto llamado
�todos_empleados.txt�.
d. Exportar a un archivo de texto llamado: �faltaDNIEmpleado.txt�, los empleados
que no tengan cargado el DNI (DNI en 00).
NOTA: Las b�squedas deben realizarse por n�mero de empleado.}
program Ej3;
const
    corte = 'fin';
type
    str20 = string[20];

    empleado = record
        nro_emp: integer;
        apellido: str20;
        nombre: str20;
        edad: integer;
        dni: integer;
    end;

    arch_empleados = file of empleado;

procedure LeerEmpleado(var e: empleado);
begin
    write('Apellido del empleado["fin" para finalizar]: '); readln(e.apellido);
    if(e.apellido <> corte) then begin
        write('Nombre del empleado: '); readln(e.nombre);
        write('Numero de empleado: '); readln(e.nro_emp);
        e.edad:= random(86);
        e.dni:= random(15001);
        {write('Numero de empleado: '); readln(e.nro_emp);
        write('Edad del empleado: '); readln(e.edad);
        write('DNI del empleado: '); readln(e.dni);}
    end;
end;

procedure ListarEmpleado(e: empleado);
begin
    writeln('Nombre: ', e.nombre, ' - Apellido: ', e.apellido, ' - Numero de empleado: ', e.nro_emp, ' - Edad: ', e.edad, ' - DNI: ', e.dni);
end;

procedure NombrarArchivo(var archFisico: str20);
begin
    write('Ingrese nombre del archivo: ');
    readln(archFisico);
end;


procedure CrearArchivoEmpleados(var archLogico: arch_empleados);

    procedure CargarRegistros(var archLogico: arch_empleados);
    var
        e: empleado;
    begin
        LeerEmpleado(e);
        while(e.apellido <> corte) do begin
            write(archLogico, e);
            LeerEmpleado(e);
        end;
    end;

var
    archFisico: str20;
begin
    writeln('CREACION DE ARCHIVO');
    writeln();
    NombrarArchivo(archFisico);
    assign(archLogico, archFisico);
    rewrite(archLogico);
    CargarRegistros(archLogico);
    close(archLogico);
    writeln();
end;

procedure AbrirArchivoExistente(var archLogico: arch_empleados);

    procedure ListarNombreApellido(var archLogico: arch_empleados);
    var
        e: empleado;
        aux: str20;
        opc: char;
    begin
        writeln('Buscar empleado por nombre o apellido. Seleccione la opcion de interes.');
        writeln('1.Nombre.');
        writeln('2.Apellido.');
        readln(opc);
        case opc of
            '1':begin
                    write('Ingrese el nombre del empleado: '); readln(aux);
                    while(not eof(archLogico)) do begin
                        read(archLogico, e);
                        if(e.nombre = aux) then
                            ListarEmpleado(e);
                    end;
                end;
            '2':begin
                    write('Ingrese el apellido del empleado: '); readln(aux);
                    while(not eof(archLogico)) do begin
                        read(archLogico, e);
                        if(e.apellido = aux) then
                            ListarEmpleado(e);
                    end;
                end;
        end;
    end;

    procedure ListadoCompleto(var archLogico: arch_empleados);
    var
        e: empleado;
    begin
        while (not eof(archLogico)) do begin
            read(archLogico, e);
            ListarEmpleado(e);
        end;
    end;

    procedure ListadoMayores(var archLogico: arch_empleados);
    var
        e: empleado;
    begin
        while(not eof(archLogico)) do begin
            read(archLogico, e);
            if(e.edad > 70) then
                ListarEmpleado(e);
        end;
    end;

    procedure AgregarEmpleado(var archLogico: arch_empleados);

        procedure Existe(var archLogico: arch_empleados; var existe: boolean; n: integer);
        var
            e: empleado;
            control: boolean;
        begin
            control:= true;
            while(not eof(archLogico)) and (control) do begin
                read(archLogico, e);
                if(e.nro_emp = n) then begin
                    control:= false;
                    existe:= true;
                end;
            end;
        end;

    var
        e: empleado;
        ok: boolean;
    begin
        ok:= true;
        LeerEmpleado(e);
        Existe(archLogico, ok, e.nro_emp);
        if(not ok) then begin
            seek(archLogico, filesize(archLogico));
            write(archLogico, e);
        end
        else
            writeln('El numero de empleado ya se encuentra registrado.');
    end;

    procedure ModificarEdad(var archLogico: arch_empleados);
    var
        modificado: boolean;
        e: empleado;
        n, edad: integer;
    begin
        modificado:= false;
        write('Ingrese numero de empleado a modificar(0 - 15000): '); readln(n);
        while((not eof(archLogico)) and (not modificado)) do begin
            read(archLogico, e);
            if(e.nro_emp = n) then begin
                write('Ingrese la edad actual del empleado: '); readln(edad);
                e.edad:= edad;
                seek(archLogico, filePos(archLogico)-1);
                write(archLogico, e);
                modificado:= true;
            end;
        end;
        if (not modificado) then
            writeln('Numero de empleado inexistente.');
    end;

    procedure ExportarTxt(var archLogico: arch_empleados);
    var
        e: empleado;
        txt: Text;
    begin
        assign(txt, 'todos_empleados.txt');
        rewrite(txt);
        while(not eof(archLogico)) do begin
            read(archLogico, e);
            with e do
                writeln(nro_emp:5, apellido:5, nombre:5, edad:5, dni:5);
        end;
        close(txt);
    end;

    procedure ExportarCondicionTxt(var archLogico: arch_empleados);
    var
        e: empleado;
        txt: Text;
    begin
        assign(txt, 'faltaDNIEmpleado.txt');
        rewrite(txt);
        while(not eof(archLogico)) do begin
            read(archLogico, e);
            if(e.dni = 00) then begin
                with e do
                    writeln(nro_emp:5, apellido:5, nombre:5, edad:5, dni:5);
                with e do
                    writeln(txt, ' ', nro_emp, ' ', apellido, ' ', nombre, ' ', edad, ' ', dni);
            end;
        end;
        close(txt);
    end;

    procedure MenuSecundario(var opc: char);
    begin
    writeln('Elija una de las siguientes opciones para continuar:');
    writeln('1.Buscar empleado(nombre/apellido).');
    writeln('2.Lista completa.');
    writeln('3.Proximos a jubilares');
    writeln('4.Agregar empleado');
    writeln('5.Modificar edad de un empleado');
    writeln('6.Exportar a txt.');
    writeln('7.Exportar empleados con dni 00 a txt.');
    writeln('Presione cualquier tecla para terminar.');
    readln(opc);
    end;

var
    opc: char;
    archFisico: str20;
    ok: boolean;
begin
    ok:= true;
    writeln('GESTOR DE ARCHIVOS');
    NombrarArchivo(archFisico);
    assign(archLogico, archFisico);
    reset(archLogico);
    while(ok) do begin
        MenuSecundario(opc);
        seek(archLogico, 0);
        writeln();
        case opc of
            '1':begin
                    ListarNombreApellido(archLogico);
                end;
            '2':begin
                    ListadoCompleto(archLogico);
                end;
            '3':begin
                    ListadoMayores(archLogico);
                end;
            '4':begin
                    AgregarEmpleado(archLogico);
                end;
            '5':begin
                    ModificarEdad(archLogico);
                end;
            '6':begin
                    ExportarTxt(archLogico);
                end;
            '7':begin
                    ExportarCondicionTxt(archLogico);
                end;
            else
                ok:= false;
        end;
        writeln();
    end;
    close(archLogico);
end;

procedure MenuPrincipal(var opc: char);
begin
    writeln('-------------------');
    writeln('Elija una opcion:;');
    writeln('1.Crear archivo nuevo.');
    writeln('2.Abrir un archivo existente.');
    readln(opc);
end;

var
    archLogico: arch_empleados;
    opc: char;
    ejecucion: boolean;
begin
    Randomize;
    ejecucion:= true;

    while(ejecucion) do begin
        MenuPrincipal(opc);
        case opc of
            '1':begin
                    CrearArchivoEmpleados(archLogico);
                end;
            '2':begin
                    AbrirArchivoExistente(archLogico);
                end;
            else
                ejecucion:= false;
        end;
    end;
end.


