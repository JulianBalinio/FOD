{1. Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. La carga finaliza
cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del
archivo debe ser proporcionado por el usuario desde teclado}
program Ej1;
const
	corte = 30000;
type
	archivo_int = file of integer;

procedure AgregarElemento(var a: archivo_int);
var
	n: integer;
begin
	write('Ingrese un entero: ');
	readln(n);
	while (n <> corte) do begin
		write(a, n);
		write('Ingrese nuevamente un entero: ');
		readln(n);
	end;
end;

var
	a: archivo_int;
	nom_fis: string[20];
begin
	write('Ingrese nombre del archivo: ');
	readln(nom_fis);
	assign(a, nom_fis);
	rewrite(a);
	AgregarElemento(a);
	close(a);
end.
