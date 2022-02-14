Unit atenciones;
{$codepage UTF8}
interface

Uses unidad_gral, usa_arbol, unit_arbol, personas, crt,archivos;


procedure inicializar_atencion(var a:t_dato_a);
procedure mostrar_tratamientos(t: t_vector);
procedure mostrar_atencion(a:t_dato_a);
procedure cargar_tratamientos(var v:t_vector);
procedure carga(var arch:t_archivo_a;dni:string);
procedure menu_carga(var arch:t_archivo_a; var arch_p:t_archivo_p; var raiz_dni,raiz_nombre:t_punt_arbol);
procedure carga_masiva(var arch:t_archivo_a; var arch_p:t_archivo_p; var raiz_dni,raiz_nombre:t_punt_arbol);
procedure buscar_mostrar(var arch:t_archivo_a; dni:string);
procedure menu_consulta(var arch:t_archivo_a; var arch_p:t_archivo_p; var raiz_dni,raiz_nombre:t_punt_arbol);
procedure consulta_masiva(var arch:t_archivo_a; var arch_p:t_archivo_p; var raiz_dni,raiz_nombre:t_punt_arbol);

implementation



procedure inicializar_atencion(var a:t_dato_a);
var i:1..n;
begin
	a.dni:='';
	a.fecha.dia:='';
	a.fecha.mes:='';
	a.fecha.ano:='';
for i:=1 to n do
begin
a.tratamiento[i].descripcion:='';
a.tratamiento[i].codigo:='';
end;
end;

procedure mostrar_tratamientos(t: t_vector);
var i:byte;
begin
	for i:=1 to n do
	begin
		if t[i].codigo<>'' then
		begin
			write('Código del tratamiento ',i,': ',t[i].codigo,'. ');
			writeln('Descripción del tratamiento ',i,': ',t[i].descripcion);
		end
		else if i=1 then writeln('No hay tratamientos.');
	end;
end;

procedure mostrar_atencion(a:t_dato_a);
begin
     writeln('***************************');
        write('DNI: ', a.dni);
	writeln('. Fecha: ', fecha(a.fecha));
	writeln('Tratamientos: ');
	mostrar_tratamientos(a.tratamiento);
	writeln('***************************');
end;

procedure cargar_tratamientos(var v:t_vector);
var i:1..n;
op:char;
begin
	i:=1;
	opcion(op,'¿Carga tratamiento? s/n ');
	while (i<=n) and (op='s') do
	begin
		write('Ingrese el código del tratamiento: ');
		readln(v[i].codigo);
		write('Ingrese la descripción del tratamiento: ');
		readln(v[i].descripcion);
		inc(i);
		if i<=n then
		opcion(op,'¿Carga más tratamientos? s/n ')
	else writeln('No se pueden cargar más tratamientos. Si desea cargar más cree otra atención. ');
	end;
end;

procedure carga(var arch:t_archivo_a;dni:string);
var atencion:t_dato_a;
op:char;
begin
	inicializar_atencion(atencion);
	atencion.dni:=dni;
	writeln('Ingrese la fecha de la atención: ');
	cargar_fecha(atencion.fecha);
	cargar_tratamientos(atencion.tratamiento);
	clrscr;
	mostrar_atencion(atencion);
	opcion(op,'¿Está seguro de ingresar estos datos? s/n ');
if (op='s') or (op='S') then write(arch,atencion);
	clrscr;
end;

procedure menu_carga(var arch:t_archivo_a; var arch_p:t_archivo_p; var raiz_dni,raiz_nombre:t_punt_arbol);
var op:char;
dni:string[8];
nombre:string[40];
pre:t_punt_arbol;
x:t_dato_p;
begin
opcion(op,'¿Dispone del DNI del paciente? s/n ');
if (op='s') or (op='S') then
begin
	repeat
		write('Ingrese el DNI: ');
			readln(dni);
		until es_numero(dni);
                pre:=preorden(raiz_dni,dni);
		if pre=NIL then writeln('No existe paciente registrado con ese DNI')
		else
                begin
                seek(arch_p,pre^.info.pos);
                read(arch_p,x);
                if x.estado then carga(arch,dni) else begin clrscr; writeln('El paciente se encuentra inactivo. Delo de alta y luego vuelva');  end;
                end;
end else
begin
	write('Ingrese nombre: ');
	readln(nombre);
dni:=nombre_a_dni(arch_p,raiz_nombre,nombre);
if dni<>'0' then carga(arch,dni)
else writeln('No se halló el paciente ',nombre);
end;

end;

procedure carga_masiva(var arch:t_archivo_a; var arch_p:t_archivo_p; var raiz_dni,raiz_nombre:t_punt_arbol);
var op:char;
i:word;
begin
	opcion(op,'¿Ingresa? s/n ');
	while (op<>'n') and (op<>'N') do
	begin
     			seek(arch,filesize(arch));
              	menu_carga(arch,arch_p,raiz_dni,raiz_nombre);
              	opcion(op,'¿Quiere añadir más atenciones? s/n ');
	end;
end;

procedure buscar_mostrar(var arch:t_archivo_a; dni:string);
var i,j:word;
encontrado:boolean;
x:t_dato_a;
begin
	i:=0;
        j:=0;
	encontrado:=false;
for i:=0 to filesize(arch)-1 do
	begin
		seek(arch,i);
		read(arch,x);
		if (x.dni=dni) then
begin
encontrado:=true;
mostrar_atencion(x);
inc(j);
       if ((j+1) mod 4=0) then begin
                		writeln;
                                writeln('Presione enter para ver las atenciones faltantes.');
                		readkey;
                		clrscr;
                end;

end;
	end;
	if not encontrado then writeln('No se ha encontrado ninguna atención con ese número de DNI. ');
end;

procedure menu_consulta(var arch:t_archivo_a; var arch_p:t_archivo_p; var raiz_dni,raiz_nombre:t_punt_arbol);
var dni:string[8];
nombre:string[40];
op:char;
begin
	if filesize(arch)=0 then writeln('Es imposible consultar atenciones. No hay atenciones registradas. ') else
	begin
	opcion(op,'¿Dispone del DNI del paciente? s/n ');
if (op='s') or (op='S') then
begin
	repeat
		write('Ingrese el DNI: ');
			readln(dni);
		until es_numero(dni);
		if preorden(raiz_dni,dni)=NIL then writeln('No existe paciente registrado con ese DNI')
		else buscar_mostrar(arch,dni);
end else
begin
	write('Ingrese nombre: ');
	readln(nombre);
dni:=nombre_a_dni(arch_p,raiz_nombre,nombre);
if dni<>'0' then buscar_mostrar(arch,dni)
else writeln('No se halló el paciente ',nombre);
end;
end;
end;

procedure consulta_masiva(var arch:t_archivo_a; var arch_p:t_archivo_p; var raiz_dni,raiz_nombre:t_punt_arbol);
var op:char;
begin
opcion(op,'¿Consulta atención? s/n ');
	while (op<>'n') and (op<>'N') do
	begin
              	menu_consulta(arch,arch_p,raiz_dni,raiz_nombre);
opcion(op,'¿Quiere consultar más atenciones? s/n ');
	end;
end;

end.
