{10. Se tiene información en un archivo de las horas extras realizadas por los empleados de una
empresa en un mes. Para cada empleado se tiene la siguiente información: departamento,
división, número de empleado, categoría y cantidad de horas extras realizadas por el
empleado. Se sabe que el archivo se encuentra ordenado por departamento, luego por
división y, por último, por número de empleado. Presentar en pantalla un listado con el
siguiente formato:
Departamento
División
Número de Empleado Total de Hs. Importe a cobrar
...... .......... .........
...... .......... .........
Total de horas división: ____
Monto total por división: ____
División
.................
Total horas departamento: ____
Monto total departamento: ____
Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía
de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número}
program Ej10;
const
    corte = 9999;
    dimF = 15;
type

    rango_cat = 1..dimF;

    empleado = record
        depto: integer; //podria ser tipo string
        division: integer; //Idem depto
        numero: integer;
        categoria: integer; //Idem depto
        horasExtra: integer;
    end;

    regTxt = record
        categoria: integer;
        valorHora: real;
    end;

    archivo = file of empleado;

    vectorValores = array[rango_cat] of real;

procedure Leer(var arch: archivo; var e: empleado);
begin
    if(not eof(arch)) then
        read(arch, e)
    else
        e.depto:= corte;
end;

procedure GenerarVectorValor(var v: vectorValores);
var
    reg: regTxt;
    txt: text;
begin
    assign(txt, 'horasExtra.txt'); //El nombre tendria que ser ingresado por teclado, pero se asume que ya existe
    reset(txt);
    while(not eof(txt)) do begin
        read(txt, reg.categoria, reg.valorHora);
        v[reg.categoria]:= reg.valorHora;
    end;
    close(txt);
end;

procedure Procesar(var arch: archivo);
var
    deptoActual, divActual: integer;
    totalDepto, totalDivision: real;
    totalHorasDepto, totalHorasDiv: integer;
    e: empleado;
    v: vectorValores;
begin
    assign(arch, 'infoEmpleados.bin'); //Se asume que el archivo existe, el nombre tendria que ingresar por teclado
    reset(arch);
    Leer(arch, e);
    GenerarVectorValor(v);
    while (e.depto <> corte) do begin
        deptoActual:= e.depto;
        writeln('Departamento ', deptoActual);
        totalDepto:= 0;
        totalHorasDepto:= 0;
        while(e.depto = deptoActual)do begin
            divActual:= e.division;
            writeln('Division ', divActual);
            totalDivision:= 0;
            totalHorasDiv:= 0;
            while (e.division = divActual) and (e.depto = deptoActual) do begin
                totalHorasDiv:= totalHorasDiv + e.horasExtra;
                totalDivision:= totalDivision + (e.horasExtra * v[e.categoria]);
                writeln('Numero de empleado  Total de horas Importe a cobrar');
                writeln(e.numero, ' ', e.horasExtra, ' $', (e.horasExtra * v[e.categoria]));
                Leer(arch, e);
            end;
            totalHorasDepto:= totalHorasDepto + totalHorasDiv;
            totalDepto:= totalDepto + totalDivision;
            writeln('Total horas division ', divActual, ': ', totalHorasDiv);
            writeln('Monto total division ', divActual, ': $', totalDivision:2:2);
        end;
        writeln('Total horas departamento ', deptoActual, ': ', totalHorasDepto);
        writeln('Monto total horas departamento ', deptoActual, ': $', totalDepto:2:2);
    end;
    close(arch);
end;

var
    arch: archivo;
begin
    Procesar(arch);
end.
