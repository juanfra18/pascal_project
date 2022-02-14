Unit personas;
{$codepage UTF8}


interface
uses crt, unit_arbol, usa_arbol, unidad_gral,archivos;


procedure mostrar_paciente(x:t_dato_p);
procedure modificar_fecha(var f,aux:t_fecha);
procedure carga_individual(var paciente:t_dato_p);
procedure carga(var arch:t_archivo_p;var raiz_dni,raiz_nombre:t_punt_arbol);
procedure menu_carga_p(var arch:t_archivo_p;var raiz_dni,raiz_nombre:t_punt_arbol);
procedure crear_arbol_DNI(var arch:t_archivo_p; var raiz_dni:t_punt_arbol);
procedure crear_arbol_nombre(var arch:t_archivo_p; var raiz_nombre:t_punt_arbol);
procedure mostrar_persona(var arch:t_archivo_p;pos:word);
procedure PREORDEN2(var arch:t_archivo_p; RAIZ:T_PUNT_arbol;BUSCADO:string; var cont:byte);
function nombre_a_dni(var arch:t_archivo_p;var raiz_nombre:t_punt_arbol;nombre:string):string;
procedure baja(var arch:t_archivo_p;var raiz_dni:t_punt_arbol; dni:string);
procedure menu_baja(var arch:t_archivo_p;var raiz_dni,raiz_nombre:t_punt_arbol);
procedure baja_masiva(var arch:t_archivo_p;var raiz_dni,raiz_nombre:t_punt_arbol);
procedure modificar_paciente(var paciente:t_dato_p);
procedure modificacion(var arch:t_archivo_p;var raiz_dni:t_punt_arbol; dni:string);
procedure menu_modificacion(var arch:t_archivo_p;var raiz_dni,raiz_nombre:t_punt_arbol);
procedure modificacion_masiva(var arch:t_archivo_p;var raiz_dni,raiz_nombre:t_punt_arbol);
procedure consulta(var arch:t_archivo_p;var raiz_dni:t_punt_arbol; dni:string);
procedure menu_consulta_p(var arch:t_archivo_p;var raiz_dni,raiz_nombre:t_punt_arbol);


implementation

procedure mostrar_paciente(x:t_dato_p);
begin
	writeln('***************************');
	if not x.estado then writeln('(paciente inactivo)');
	write('- DNI: ',x.dni,'     ');
        write('- Fecha de nacimiento: ',fecha(x.fecha_nac),'      ');
        writeln('- Teléfono: ',x.tel);
	writeln('- Nombre: ',x.nom);
	writeln('- Dirección: ',x.dir);
	writeln('- Ciudad: ',x.ciudad);
	writeln('- Obra social: ',x.obra_social);
	writeln('- Número de afiliado: ',x.nro_afiliado,'.');
	writeln('***************************');
end;

procedure modificar_fecha(var f,aux:t_fecha);
begin
	repeat
repeat
write('Ingrese el día de nacimiento: ');
readln(f.dia);
if f.dia='' then f.dia:=aux.dia;
until (f.dia>='01') and (f.dia<='31') and es_numero(f.dia);

repeat
write('Ingrese el mes de nacimiento: ');
readln(f.mes);
if f.mes='' then f.mes:=aux.mes;
until (f.mes>='01') and (f.mes<='12') and es_numero(f.mes);

repeat
write('Ingrese el año de nacimiento: ');
readln(f.ano);
if f.ano='' then f.ano:=aux.ano;
until (f.ano>='1908') and (f.ano<='2021') and es_numero(f.ano);
	until fecha_legal(f);
end;

procedure carga_individual(var paciente:t_dato_p);
begin
write('Ingrese el nombre: ');
readln(paciente.nom);
writeln('Ingrese la fecha de nacimiento: ');
cargar_fecha(paciente.fecha_nac);
write('Ingrese la dirección: ');
readln(paciente.dir);
write('Ingrese la ciudad: ');
readln(paciente.ciudad);
repeat
write('Ingrese el teléfono: ');
readln(paciente.tel);
until es_numero(paciente.tel);
write('Ingrese la obra social: ');
readln(paciente.obra_social);
repeat
write('Ingrese el número de afiliado: ');
readln(paciente.nro_afiliado);
until es_numero(paciente.nro_afiliado);
paciente.estado:=True;
end;

procedure carga(var arch:t_archivo_p;var raiz_dni,raiz_nombre:t_punt_arbol);
var paciente:t_dato_p;
pre:t_punt_arbol;
op:char;
x,y:t_dato_arbol;
begin
repeat
write('Ingrese el DNI: ');
readln(paciente.dni);
until es_numero(paciente.dni);
pre:=preorden(raiz_dni,paciente.dni);
if pre=NIL then
begin
carga_individual(paciente);
clrscr;
mostrar_paciente(paciente);
opcion(op,'¿Está seguro de ingresar estos datos? s/n ');
if (op='s') or (op='S') then
begin
x.pos:=filesize(arch);            // GUARDA EN ARBOL DNI
x.clave:=paciente.dni;
agregar(raiz_dni,x);
y.pos:=x.pos;                     // GUARDA EN ARBOL NOMBRE
y.clave:=paciente.nom;
agregar(raiz_nombre,y);
seek(arch,filesize(arch));
write(arch,paciente);               // ESCRIBE EN ARCHIVO
writeln('El paciente ha sido cargado correctamente.');
	end;
end
else
begin
writeln('El paciente ya estaba registrado, se ha dado de alta');
seek(arch,pre^.info.pos);
	read(arch,paciente);
	paciente.estado:=True;                 // DA DE ALTA
	seek(arch,pre^.info.pos);
	write(arch,paciente);
end;
clrscr;
end;

procedure menu_carga_p(var arch:t_archivo_p;var raiz_dni,raiz_nombre:t_punt_arbol);
var op:char;
begin
	opcion(op, '¿Ingresa? s/n ');
	while (op<>'n') and (op<>'N') do
	begin
              carga(arch,raiz_dni,raiz_nombre);
              readkey;
              opcion(op,'¿Quiere añadir más pacientes? s/n: ');
	end;
end;

procedure crear_arbol_DNI(var arch:t_archivo_p; var raiz_dni:t_punt_arbol);
var i:word;
x:t_dato_arbol;
p:t_dato_p;
begin
	crear_arbol(raiz_dni);
	for i:=0 to filesize(arch)-1 do
	begin
		seek(arch,i);
		read(arch,p);
		x.clave:=p.dni;
		x.pos:=i;
		agregar(raiz_dni,x);
	end;
end;

procedure crear_arbol_nombre(var arch:t_archivo_p; var raiz_nombre:t_punt_arbol);
var i:word;
x:t_dato_arbol;
p:t_dato_p;
begin
	crear_arbol(raiz_nombre);
	for i:=0 to filesize(arch)-1 do
	begin
		seek(arch,i);
		read(arch,p);
		x.clave:=p.nom;
		x.pos:=i;
		agregar(raiz_nombre,x);
	end;
end;

procedure mostrar_persona(var arch:t_archivo_p;pos:word);
var x:t_dato_p;
begin
	seek(arch,pos);
	read(arch,x);
	mostrar_paciente(x);
end;

procedure PREORDEN2(var arch:t_archivo_p; RAIZ:T_PUNT_arbol;BUSCADO:string; var cont:byte);
BEGIN
        IF (RAIZ<>NIL) THEN
begin
                 IF ( RAIZ^.INFO.clave  = BUSCADO) THEN
begin
mostrar_persona(arch,raiz^.info.pos);
	inc(cont);
	PREORDEN2(arch,RAIZ^.SAD,BUSCADO,cont);
end
       ELSE
If cont=0 then
begin
IF (RAIZ^.INFO.clave > BUSCADO) THEN        PREORDEN2(arch,RAIZ^.SAI,BUSCADO,cont) else preorden2(arch,raiz^.sad,buscado,cont);
end;
end;
END;

function nombre_a_dni(var arch:t_archivo_p;var raiz_nombre:t_punt_arbol;nombre:string):string;
var contador:byte;
dni_ingresado:string[8];
begin
	contador:=0;
	preorden2(arch,raiz_nombre,nombre,contador);
	if contador<>0 then
	begin

write('Si el paciente es alguno de los anteriores, ingrese el DNI correspondiente. Sino, presione enter: ');
	readln(dni_ingresado);
	if dni_ingresado<>'' then
nombre_a_dni:=dni_ingresado
else nombre_a_dni:='0';
end
else nombre_a_dni:='0';
end;

procedure baja(var arch:t_archivo_p;var raiz_dni:t_punt_arbol; dni:string);
var x:t_dato_p;
pre:t_punt_arbol;
begin
	pre:=preorden(raiz_dni,dni);
	if pre<>NIL then
	begin
	seek(arch,pre^.info.pos);
	read(arch,x);
	x.estado:=false;
	seek(arch,pre^.info.pos);
	write(arch,x);
end
else writeln('No se halló el paciente con dni ',dni);
end;

procedure menu_baja(var arch:t_archivo_p;var raiz_dni,raiz_nombre:t_punt_arbol);
var op:char;
dni,nombre:string;
begin
opcion(op,'¿Dispone del DNI del paciente? s/n ');
if (op='s') or (op='S') then
begin

	repeat
		write('Ingrese el DNI: ');
			readln(dni);
		until es_numero(dni);
	baja(arch,raiz_dni,dni);
end else
begin
	write('Ingrese nombre: ');
	readln(nombre);
dni:=nombre_a_dni(arch,raiz_nombre,nombre);
if dni<>'0' then baja(arch,raiz_dni,dni)
else writeln('No se halló el paciente ',nombre);
end;

end;

procedure baja_masiva(var arch:t_archivo_p;var raiz_dni,raiz_nombre:t_punt_arbol);
var op:char;
begin
	if filesize(arch)<>0 then
	begin

	opcion(op,'¿Da de baja pacientes? s/n ');

while (op='s') or (op='S') do
	begin
		menu_baja(arch,raiz_dni,raiz_nombre);
		opcion(op,'¿Continua? s/n ');
	end;
	end
	else writeln('No se puede dar de baja a pacientes porque no hay pacientes registrados.');
end;

procedure modificar_paciente(var paciente:t_dato_p);
var aux:t_dato_p;
begin
			writeln('SI NO MODIFICA UN CAMPO, PRESIONE ENTER');
			aux:=paciente;
write('Ingrese el nombre: ');
readln(paciente.nom);
if paciente.nom='' then paciente.nom:=aux.nom;

modificar_fecha(paciente.fecha_nac,aux.fecha_nac);


write('Ingrese la dirección: ');
readln(paciente.dir);
if paciente.dir='' then paciente.dir:=aux.dir;

write('Ingrese la ciudad: ');
readln(paciente.ciudad);
if paciente.ciudad='' then paciente.ciudad:=aux.ciudad;

repeat
write('Ingrese el teléfono: ');
readln(paciente.tel);
if paciente.tel='' then paciente.tel:=aux.tel;
until es_numero(paciente.tel);

write('Ingrese la obra social: ');
readln(paciente.obra_social);
if paciente.obra_social='' then paciente.obra_social:=aux.obra_social;

repeat
write('Ingrese el número de afiliado: ');
readln(paciente.nro_afiliado);
if paciente.nro_afiliado='' then paciente.nro_afiliado:=aux.nro_afiliado;
			until es_numero(paciente.nro_afiliado);
end;

procedure modificacion(var arch:t_archivo_p;var raiz_dni:t_punt_arbol; dni:string);
var x:t_dato_p;
pre:t_punt_arbol;
begin
	pre:=preorden(raiz_dni,dni);
	if pre<>NIL then
	begin
	seek(arch,pre^.info.pos);
	read(arch,x);
	mostrar_paciente(x);
	modificar_paciente(x);
	seek(arch,pre^.info.pos);
	write(arch,x);
end
else writeln('No se halló el paciente con DNI ',dni);
end;

procedure menu_modificacion(var arch:t_archivo_p;var raiz_dni,raiz_nombre:t_punt_arbol);
var op:char;
dni,nombre:string;
begin

opcion(op,'¿Dispone del DNI del paciente? s/n ');
if (op='s') or (op='S') then
begin
		write('Ingrese el DNI: ');
		readln(dni);
		modificacion(arch,raiz_dni,dni);
end else
begin
	write('Ingrese nombre: ');
	readln(nombre);
dni:=nombre_a_dni(arch,raiz_nombre,nombre);
clrscr;
if dni<>'0' then modificacion(arch,raiz_dni,dni)
else writeln('No se halló el paciente ',nombre);
end;

end;

procedure modificacion_masiva(var arch:t_archivo_p;var raiz_dni,raiz_nombre:t_punt_arbol);
var op:char;
begin
if filesize(arch)<>0 then
begin
	opcion(op,'¿Modifica datos de pacientes? s/n ');
while (op='s') or (op='S') do
	begin
		menu_modificacion(arch,raiz_dni,raiz_nombre);
opcion(op,'¿Continua? s/n ');
	end;
end
else
writeln('No se puede modificar pacientes, pues no hay pacientes cargados.');
end;

procedure consulta(var arch:t_archivo_p;var raiz_dni:t_punt_arbol; dni:string);
var x:t_dato_p;
pre:t_punt_arbol;
begin
	pre:=preorden(raiz_dni,dni);
	if pre<>NIL then
	begin
	seek(arch,pre^.info.pos);
	read(arch,x);
	mostrar_paciente(x);
end
else writeln('No se halló el paciente con DNI ',dni);
end;

procedure menu_consulta_p(var arch:t_archivo_p;var raiz_dni,raiz_nombre:t_punt_arbol);
var op:char;
dni,nombre:string;
contador:byte;
begin
if filesize(arch)<>0 then
begin
opcion(op,'¿Dispone del DNI del paciente? s/n ');
if (op='s') or (op='S') then
begin
		write('Ingrese el DNI: ');
		readln(dni);
		consulta(arch,raiz_dni,dni);
end else
begin
	write('Ingrese nombre: ');
	readln(nombre);
	contador:=0;
	preorden2(arch,raiz_nombre,nombre,contador);
if contador=0 then writeln('No se halló el paciente ',nombre);
end;
end
else writeln('No se puede consultar pacientes, pues no hay ninguno cargado.');
end;
end.



