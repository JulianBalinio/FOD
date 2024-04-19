{3. Realizar un programa que presente un men� con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: n�mero de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String �fin� como apellido.
b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado, el cual se proporciona desde el teclado.
ii. Listar en pantalla los empleados de a uno por l�nea.
iii. Listar en pantalla los empleados mayores de 70 a�os, pr�ximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.}
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
        e.nro_emp:= random(1501);
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
        writeln('1.Nombre - 2.Apellido');
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

    procedure MenuSecundario(var opc: char);
    begin
    writeln('Elija una de las siguientes opciones para continuar:');
    writeln('1.Buscar empleado(nombre/apellido).');
    writeln('2.Lista completa.');
    writeln('3.Proximos a jubilares');
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
    writeln('Elija la opcion que desee ejecutar: ');
    writeln('1.Crear archivo nuevo.');
    writeln('2.Abrir archivo existente.');
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
