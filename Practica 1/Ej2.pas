{2. Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creado en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.}
program Ej2;
const
     control = 1500;
type
     archivo_int = file of integer;

procedure Informar(var a: archivo_int);
var
   suma, n, menores: integer;
   promedio: real;
begin
     menores:= 0;
     suma:= 0;
     seek(a, 0);
     while (not eof(a)) do begin
           read(a, n);
           suma:= suma + n;
           if(n < control) then
                menores:= menores + 1;
           write(n);
     end;
     promedio:= suma / filesize(a);
     writeln('Promedio: ', promedio:0:1);
     writeln('Cantidad de numeros menores a 1500: ', menores);
end;

var
   a: archivo_int;
   a_nom: string[20];
begin
   write('Ingrese nombre del archivo: ');
   readln(a_nom);
   assign(a, a_nom);
   reset(a);
   Informar(a);
   close(a);
end.

