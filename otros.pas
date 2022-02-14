unit otros;
{$codepage UTF8}

interface

uses
  crt,personas, atenciones, unidad_gral, sysutils,unit_arbol,usa_arbol,u_listas,archivos;

procedure listado_atenciones(var arch:t_archivo_a);
procedure consulta_general(var arch_p:t_archivo_p; var arch_a:t_archivo_a;var raiz_dni:t_punt_arbol; dni:string);
procedure menu_consulta_general(var arch_p:t_archivo_p; var arch_a:t_archivo_a; var raiz_dni,raiz_nombre:t_punt_arbol);
function edad(actual,nac:t_fecha):integer;
procedure impresion_orden(var x:t_dato_p; var y:t_dato_a);
procedure busqueda_orden(var arch_p:t_archivo_p; var arch_a:t_archivo_a;var raiz_nombre,raiz_dni:t_punt_arbol; dni:string;fech:t_fecha);
procedure menu_impresion(var arch_p:t_archivo_p; var arch_a:t_archivo_a;var raiz_nombre, raiz_dni:t_punt_arbol);
function fecha_a_dias(f:t_fecha):word;
function atenciones_entre_fechas(var arch_a:t_archivo_a; f_inicio,f_fin:t_fecha):word;
procedure menu_atenciones_entre_fechas(var arch_a:t_archivo_a);
function promedio_atenciones_diarias(var arch_a:t_archivo_a):real;
procedure menu_promedio(var arch_a:t_archivo_a);
function porc_atenciones_ciudad(var arch_p:t_archivo_p;var arch_a:t_archivo_a;raiz_dni:t_punt_arbol):real;
procedure menu_porc_atenciones_ciudad(var arch_p:t_archivo_p;var arch_a:t_archivo_a;raiz_dni:t_punt_arbol);
procedure porc_atenciones_meses(var arch_a:t_archivo_a;anio:word);
procedure menu_porc_atenciones_meses(var arch_a:t_archivo_a);
procedure mostrar_atenciones_obra_social(var l:t_lista);
procedure lista_atenciones_obra_social(var arch_p:t_archivo_p;var arch_a:t_archivo_a; var l:t_lista;var raiz_dni:t_punt_arbol);
procedure atenciones_obra_social(var arch_p:t_archivo_p;var arch_a:t_archivo_a;var raiz_dni:t_punt_arbol);

implementation
procedure listado_atenciones(var arch:t_archivo_a);
var i: word;
x:t_dato_a;
begin
	If filesize(arch)=0 then writeln('No se puede mostrar el listado. No hay atenciones cargadas')
	else
	begin
       for i:=0 to filesize(arch)-1 do
begin
seek(arch,i);
read(arch,x);
mostrar_atencion(x);
       if ((i+1) mod 3=0) then begin
       		writeln;
                       writeln('Presione enter para ver las atenciones faltantes.');
       		readkey;
       		clrscr;
       end;

       end;
	end;
end;

procedure consulta_general(var arch_p:t_archivo_p; var arch_a:t_archivo_a;var raiz_dni:t_punt_arbol; dni:string);
var x:t_dato_p;
pre:t_punt_arbol;
begin
       pre:=preorden(raiz_dni,dni);
       if pre<>NIL then
       begin
       seek(arch_p,pre^.info.pos);
       read(arch_p,x);
       mostrar_paciente(x);
       if filesize(arch_a)<>0 then
       	buscar_mostrar(arch_a,x.dni)
       else
       	writeln('No hay atenciones registradas.');
end
else writeln('No se halló el paciente con DNI ',dni);
end;

procedure menu_consulta_general(var arch_p:t_archivo_p; var arch_a:t_archivo_a; var raiz_dni,raiz_nombre:t_punt_arbol);
var dni:string[8];
nombre:string[40];
op:char;
begin
if filesize(arch_p)<>0 then
begin
       opcion(op,'¿Dispone del DNI del paciente? s/n ');
if (op='s') or (op='S') then
begin
       repeat
       	write('Ingrese el DNI: ');
       	readln(dni);
       until es_numero(dni);
       consulta_general(arch_p,arch_a,raiz_dni,dni);
end
else
begin
       write('Ingrese nombre: ');
       readln(nombre);
dni:=nombre_a_dni(arch_p,raiz_nombre,nombre);
if dni<>'0' then
begin
clrscr;
consulta_general(arch_p,arch_a,raiz_dni,dni);
end
else writeln('No se halló el paciente ',nombre);
end;
end
else writeln('No se puede consultar porque no hay pacientes cargados.');
end;

function edad(actual,nac:t_fecha):integer;
type t_fecha2=record
       		dia,mes,ano:word;
       end;
var
fecha_actual,fecha_nac:t_fecha2;
act,nacimiento:real;
begin

       fecha_nac.ano:=strtoint(nac.ano);
       fecha_nac.mes:=strtoint(nac.mes);
       fecha_nac.dia:=strtoint(nac.dia);

       fecha_actual.dia:=strtoint(actual.dia);
       fecha_actual.mes:=strtoint(actual.mes);
       fecha_actual.ano:=strtoint(actual.ano);

       act:=(fecha_actual.dia/365.242)+(fecha_actual.mes/30.42)+(fecha_actual.ano);

       nacimiento:=(fecha_nac.dia/365.242)+(fecha_nac.mes/30.42)+(fecha_nac.ano);

       edad:=(round(act-nacimiento));

end;

procedure impresion_orden(var x:t_dato_p; var y:t_dato_a);
var i:word;
begin
   clrscr;
       gotoxy(5,4);
 write(x.obra_social);
   gotoxy(50,2);
 write('ORDEN PARA ENTREGAR');

 //DERECHA

   gotoxy(90,6);
 	write('FECHA: ',fecha(y.fecha));
   gotoxy(90,8);

 write('EDAD: ',edad(y.fecha,x.fecha_nac));
   gotoxy(90,10);
 write('TELÉFONO: ',x.tel);

 //CENTRO

   gotoxy(25,6);
 write('NOMBRE Y APELLIDO: ',x.nom);
   gotoxy(25,8);
 write('DNI: ',x.dni);
   gotoxy(25,10);
 write('NÚMERO DE AFILIADO: ',x.nro_afiliado);
   gotoxy(25,12);
 write('DIRECCIÓN: ',x.dir);

 //TRATAMIENTOS

 gotoxy(5,14);
 write('TRATAMIENTOS: ');
 gotoxy(5,16);
 write('CÓDIGO');
 gotoxy(25,16);
 write('DESCRIPCIÓN');
 for i:=1 to n do
 begin
          gotoxy(5,17+i);
          Write(y.tratamiento[i].codigo);
          gotoxy(25,17+i);
          Write(y.tratamiento[i].descripcion);
 end;

 gotoxy(90,18);
 write('NOMBRE DEL PROFESIONAL:');
 gotoxy(90,22);
 write('FIRMA DEL PROFESIONAL: ');
 readkey;
 clrscr;
end;

procedure busqueda_orden(var arch_p:t_archivo_p; var arch_a:t_archivo_a;var raiz_nombre,raiz_dni:t_punt_arbol; dni:string;fech:t_fecha);
var i,cont:word;
x:t_dato_p;
y:t_dato_a;
pre:t_punt_arbol;
begin

       pre:=preorden(raiz_dni,dni);
       if pre<>NIL then
       begin
       seek(arch_p,pre^.info.pos);
       read(arch_p,x);
       if filesize(arch_a)<>0 then
       begin
       	cont:=0;
       	for i:=0 to filesize(arch_a)-1 do
       	begin
       		seek(arch_a,i);
                       read(arch_a,y);
       		if (y.dni=dni) and (fecha(y.fecha)=fecha(fech)) then
begin
impresion_orden(x,y);
inc(cont);
end;
       	end;
       	if cont=0 then writeln('No se halló una atención con el paciente y fecha ingresados.');
       end
       else
       	writeln('No hay atenciones registradas.');
end
else writeln('No se halló el paciente con DNI ',dni);

end;

procedure menu_impresion(var arch_p:t_archivo_p; var arch_a:t_archivo_a;var raiz_nombre, raiz_dni:t_punt_arbol);
var dni:string[8];
nombre:string[40];
op:char;
fecha:t_fecha;
begin
if (filesize(arch_p)<>0) and (filesize(arch_a)<>0) then
begin
       opcion(op,'¿Dispone del DNI del paciente? s/n ');
if (op='s') or (op='S') then
begin
       repeat
       	write('Ingrese el DNI: ');
       	readln(dni);
       until es_numero(dni);
       cargar_fecha(fecha);
       busqueda_orden(arch_p,arch_a,raiz_nombre,raiz_dni,dni,fecha);
end
else
begin
       write('Ingrese nombre: ');
       readln(nombre);
dni:=nombre_a_dni(arch_p,raiz_nombre,nombre);
if dni<>'0' then
begin
clrscr;
       cargar_fecha(fecha);
busqueda_orden(arch_p,arch_a,raiz_nombre,raiz_dni,dni,fecha);
end
else writeln('No se halló el paciente ',nombre);
end;
end
else
begin
if filesize(arch_p)=0 then writeln('No hay pacientes cargados.');
if filesize(arch_a)=0 then writeln('No hay atenciones cargadas.');
readkey;
end;
end;

function fecha_a_dias(f:t_fecha):word;
begin
fecha_a_dias:=strtoint(f.dia)+strtoint(f.mes)*30+strtoint(f.ano)*365;
end;

function atenciones_entre_fechas(var arch_a:t_archivo_a; f_inicio,f_fin:t_fecha):word;
var i,cont:word;
y:t_dato_a;
final:boolean;
begin
       i:=0;
       cont:=0;
       final:=False;
       while (not final) and (i<filesize(arch_a)) do
       begin
       	seek(arch_a,i);
       	read(arch_a,y);
       	inc(i);
       	if (fecha_a_dias(y.fecha)>=fecha_a_dias(f_inicio)) and (fecha_a_dias(y.fecha)<=fecha_a_dias(f_fin)) then inc(cont) else if fecha_a_dias(y.fecha)>fecha_a_dias(f_fin) then final:=true;
       end;
       atenciones_entre_fechas:=cont;
end;

procedure menu_atenciones_entre_fechas(var arch_a:t_archivo_a);
var f1,f2:t_fecha;
begin
       writeln('Ingrese las fechas entre las cuales quiere averiguar la cantidad de atenciones: ');
       writeln('FECHA DE INICIO: ');
       cargar_fecha(f1);
       writeln('FECHA DE FIN: ');
       cargar_fecha(f2);
     clrscr;
if fecha_a_dias(f1)>fecha_a_dias(f2) then
       writeln('La fecha de inicio debe ser anterior o igual a la de fin.') else
               writeln('La cantidad de atenciones entre el ',fecha(f1),' y el ',fecha(f2),' es de ',atenciones_entre_fechas(arch_a,f1,f2));
end;

function promedio_atenciones_diarias(var arch_a:t_archivo_a):real;
var aux:string;
cont,i:word;
y:t_dato_a;
begin
       cont:=1;
       seek(arch_a,0);
       read(arch_a,y);
       aux:=fecha(y.fecha);
       for i:=1 to filesize(arch_a)-1 do
       begin
       	seek(arch_a,i);
       	read(arch_a,y);
       	if fecha(y.fecha)<>aux then
       		begin
       			inc(cont);
       			aux:=fecha(y.fecha);
       		end;
       end;
       promedio_atenciones_diarias:=filesize(arch_a)/cont;
end;

procedure menu_promedio(var arch_a:t_archivo_a);
begin
       if filesize(arch_a)<>0 then writeln('El promedio de atenciones diarias es de ', promedio_atenciones_diarias(arch_a):2:2) else writeln('No hay atenciones registradas, no se puede calcular el promedio de atenciones diarias.');
end;

function porc_atenciones_ciudad(var arch_p:t_archivo_p;var arch_a:t_archivo_a;raiz_dni:t_punt_arbol):real;
var cont,i:word;
y:t_dato_a;
x:t_dato_p;
begin
       cont:=0;
       for i:=0 to filesize(arch_a)-1 do
       begin
       	seek(arch_a,i);
       	read(arch_a,y);
       	seek(arch_p,preorden(raiz_dni,y.dni)^.info.pos);
       	read(arch_p,x);
       	if lowercase(x.ciudad)<>'concepcion del uruguay' then inc(cont);
       end;
       porc_atenciones_ciudad:=cont/filesize(arch_a)*100;
end;

procedure menu_porc_atenciones_ciudad(var arch_p:t_archivo_p;var arch_a:t_archivo_a;raiz_dni:t_punt_arbol);
begin
       if (filesize(arch_a)<>0) and (filesize(arch_p)<>0) then writeln('El porcentaje de atenciones a pacientes de otra ciudad es de ', porc_atenciones_ciudad(arch_p,arch_a,raiz_dni):2:2, '%')
       else begin
if filesize(arch_a)=0 then writeln('No hay atenciones cargadas.');
if filesize(arch_p)=0 then writeln('No hay pacientes cargados.');
end;
end;

procedure porc_atenciones_meses(var arch_a:t_archivo_a;anio:word);
var aux:array[1..12]of word;
final:boolean;
i,cont:word;
y:t_dato_a;
begin
               cont:=0;
       	for i:=1 to 12 do aux[i]:=0;
       	final:=false;
       	i:=0;
       	while (i<filesize(arch_a)) and not final do
       	begin
       		seek(arch_a,i);
       		read(arch_a,y);
       		inc(i);
       		if strtoint(y.fecha.ano)>anio then final:=true
       		else if strtoint(y.fecha.ano)=anio then
begin
inc(aux[strtoint(y.fecha.mes)]);
inc(cont);
end;
       	end;
       	if cont<>0 then
       	begin
clrscr;
       	writeln('PORCENTAJE DE ATENCIONES POR MES DE ',anio);
       	writeln('Enero: ');
       	writeln('Febrero: ');
       	writeln('Marzo: ');
       	writeln('Abril: ');
       	writeln('Mayo: ');
       	writeln('Junio: ');
       	writeln('Julio: ');
       	writeln('Agosto: ');
       	writeln('Septiembre: ');
       	writeln('Octubre: ');
       	writeln('Noviembre: ');
       	writeln('Diciembre: ');
       	for i:=1 to 12 do
       	begin
       		gotoxy(15,1+i);
       		write((aux[i]/cont*100):2:2,'%' );
       	end;
       	end
       	else writeln('No se hallaron atenciones en el año dado.');
end;

procedure menu_porc_atenciones_meses(var arch_a:t_archivo_a);
var anio:word;
anio_string:string;
begin
If filesize(arch_a)<>0 then
begin
     repeat
             repeat
                     write('Ingrese el año a analizar: ');
                     readln(anio_string);
             until es_numero(anio_string);
             anio:=strtoint(anio_string);
     until (anio>1907) and (anio<2022);
     porc_atenciones_meses(arch_a,anio);
     end
     else writeln('No hay atenciones cargadas. ');
end;

procedure mostrar_atenciones_obra_social(var l:t_lista);
var z:t_dato_lista;
i:word;
begin
       writeln('Si no aparece la obra social que busca, presione cualquier tecla para avanzar en el listado.');
       gotoxy(5,2);
       write('OBRA SOCIAL');
       gotoxy(25,2);
       write('ATENCIONES');

       i:=0;
       primero(l);
       while (not fin(l)) do
       begin
       	recuperar(l,z);
       	inc(i);
       	gotoxy(5,i+4);
       	write(z.obra_social);
       	gotoxy(25,i+4);
       	write(z.cont);
       	siguiente(l);
       	if i>25 then
begin
i:=0;
readkey;
clrscr;
end;
       end;
end;

procedure lista_atenciones_obra_social(var arch_p:t_archivo_p;var arch_a:t_archivo_a; var l:t_lista;var raiz_dni:t_punt_arbol);
VAR
i:word;
x:t_dato_p;
y:t_dato_a;
z:t_dato_lista;
encontrado:boolean;
begin
       crearlista(l);
       for i:=0 to filesize(arch_a)-1 do
       begin
       	seek(arch_a,i);
       	read(arch_a,y);
       	seek(arch_p,preorden(raiz_dni,y.dni)^.info.pos);
       	read(arch_p,x);
       	buscar(l,x.obra_social,encontrado);
       	if not encontrado then
       	begin
       		z.obra_social:=x.obra_social;
       		z.cont:=1;
       		agregar(l,z);
       	end
       	else
       	begin
       		eliminarlista(l,x.obra_social,z);
       		z.cont:=z.cont+1;
       		agregar(l,z);
       	end;
       end;
end;

procedure atenciones_obra_social(var arch_p:t_archivo_p;var arch_a:t_archivo_a;var raiz_dni:t_punt_arbol);
var l:t_lista;
begin
       if (filesize(arch_a)=0) or (filesize(arch_p)=0) then
       begin
       if filesize(arch_a)=0 then writeln('No hay atenciones cargadas.');
if filesize(arch_p)=0 then writeln('No hay pacientes cargados.');
       end
       else
       begin
       	lista_atenciones_obra_social(arch_p,arch_a,l,raiz_dni);
       	mostrar_atenciones_obra_social(l);
       end;
end;
end.





