unit menu;
{$codepage UTF8}

interface

uses crt, personas, atenciones, otros, unidad_gral, unit_arbol;
const ruta_a='atenciones.dat';
      ruta_p='personas.dat';

procedure menu_otros(var arch_a:t_archivo_a; var arch_p:t_archivo_p; var raiz_dni,raiz_nombre:t_punt_arbol);
procedure menu_estadisticas(var arch_a:t_archivo_a; var arch_p:t_archivo_p; var raiz_dni,raiz_nombre:t_punt_arbol);
procedure menu_atenciones(var arch_a:t_archivo_a; var arch_p:t_archivo_p; var raiz_dni,raiz_nombre:t_punt_arbol);
procedure menu_pacientes(var arch_p:t_archivo_p; var raiz_dni,raiz_nombre:t_punt_arbol);
procedure menu_general(var arch_a:t_archivo_a; var arch_p:t_archivo_p; var raiz_dni,raiz_nombre:t_punt_arbol);
procedure subprograma_principal;

implementation

procedure menu_otros(var arch_a:t_archivo_a; var arch_p:t_archivo_p; var raiz_dni,raiz_nombre:t_punt_arbol);
var op1:char;
begin
clrscr;
repeat

gotoxy(55,3);
  write('LISTADOS Y OTROS');
  gotoxy(32,5);
  write('Seleccione de acuerdo a lo que quiera realizar y presione enter.');
  gotoxy(36,11);
  write('1. LISTADO POR FECHA DE TODAS LAS ATENCIONES');
  gotoxy(36,14);
  write('2. CONSULTAR DATOS DE PACIENTE (PERSONALES + ATENCIONES)');
  gotoxy(36,17);
  write('3. IMPRESIÓN DE ORDEN PARA OBRA SOCIAL');
  gotoxy(36,20);
  write('0. SALIR AL MENÚ PRINCIPAL');
  gotoxy(36,27);
  write('OPCIÓN ELEGIDA: ');
  readln(op1);
clrscr;

case op1 of
'1':listado_atenciones(arch_a);
'2':menu_consulta_general(arch_p,arch_a,raiz_dni,raiz_nombre);
'3':menu_impresion(arch_p,arch_a,raiz_nombre,raiz_dni);
End;
If op1 in ['1','2'] then
readkey;
clrscr;
until (op1='0');


end;

procedure menu_estadisticas(var arch_a:t_archivo_a; var arch_p:t_archivo_p; var raiz_dni,raiz_nombre:t_punt_arbol);
var op1:char;
begin
clrscr;
repeat

gotoxy(55,3);
  write('ESTADÍSTICAS');
  gotoxy(32,5);
  write('Seleccione de acuerdo a lo que quiera realizar y presione enter.');
  gotoxy(36,8);
  write('1. CANTIDAD DE ATENCIONES ENTRE DOS FECHAS');
  gotoxy(36,11);
  write('2. CANTIDAD DE ATENCIONES POR OBRA SOCIAL');
  gotoxy(36,14);
  write('3. PORCENTAJE DE ATENCIONES POR MES');
  gotoxy(36,17);
  write('4. PROMEDIO DE ATENCIONES DIARIAS');
  gotoxy(36,20);
  write('5. PORCENTAJE DE ATENCIONES DE PACIENTES DE OTRA CIUDAD');
  gotoxy(36,23);
  write('0. SALIR AL MENÚ PRINCIPAL');
  gotoxy(36,27);
  write('OPCIÓN ELEGIDA: ');
  readln(op1);
clrscr;

case op1 of
'1':menu_atenciones_entre_fechas(arch_a);
'2':atenciones_obra_social(arch_p,arch_a,raiz_dni);
'3':menu_porc_atenciones_meses(arch_a);
'4':menu_promedio(arch_a);
'5':menu_porc_atenciones_ciudad(arch_p,arch_a,raiz_dni);
End;
If op1 in ['1','2','3','4','5'] then
readkey;
clrscr;
until (op1 ='0');


end;

procedure menu_atenciones(var arch_a:t_archivo_a; var arch_p:t_archivo_p; var raiz_dni,raiz_nombre:t_punt_arbol);
var op1:char;
begin
clrscr;
repeat

gotoxy(55,3);
  write('ATENCIONES');
  gotoxy(32,5);
  write('Seleccione de acuerdo a lo que quiera realizar y presione enter.');
  gotoxy(52,12);
  write('1. DAR DE ALTA');
  gotoxy(52,16);
  write('2. CONSULTAR');
  gotoxy(52,20);
  write('0. SALIR AL MENÚ PRINCIPAL');
  gotoxy(52,27);
  write('OPCIÓN ELEGIDA: ');
  readln(op1);
clrscr;

case op1 of
'1':carga_masiva(arch_a,arch_p,raiz_dni,raiz_nombre);
'2':consulta_masiva(arch_a,arch_p,raiz_dni,raiz_nombre);
End;
If op1 in ['1','2'] then
readkey;
clrscr;
until (op1='0');

end;

procedure menu_pacientes(var arch_p:t_archivo_p; var raiz_dni,raiz_nombre:t_punt_arbol);
var op1:char;
begin
clrscr;
repeat

gotoxy(55,3);
  write('PACIENTES');
  gotoxy(32,5);
  write('Seleccione de acuerdo a lo que quiera realizar y presione enter.');
  gotoxy(52,10);
  write('1. DAR DE ALTA');
  gotoxy(52,13);
  write('2. DAR DE BAJA');
  gotoxy(52,16);
  write('3. MODIFICAR');
  gotoxy(52,19);
  write('4. CONSULTAR');
  gotoxy(52,22);
  write('0. SALIR AL MENÚ PRINCIPAL');
  gotoxy(52,27);
  write('OPCIÓN ELEGIDA: ');
  readln(op1);
clrscr;

case op1 of
'1':menu_carga_p(arch_p,raiz_dni,raiz_nombre);
'2':baja_masiva(arch_p,raiz_dni,raiz_nombre);
'3':modificacion_masiva(arch_p,raiz_dni,raiz_nombre);
'4':menu_consulta_p(arch_p,raiz_dni,raiz_nombre);
End;
If op1 in ['1','2','3','4'] then
readkey;
clrscr;
until op1='0';


end;

procedure menu_general(var arch_a:t_archivo_a; var arch_p:t_archivo_p; var raiz_dni,raiz_nombre:t_punt_arbol);
var op,op_final:char;
begin

op_final:='n';

repeat

gotoxy(48,3);
write('CONSULTORIO DE DENTISTA');
gotoxy(32,5);
write('Seleccione de acuerdo a lo que quiera realizar y presione enter.');
gotoxy(52,10);
write('1. PACIENTES');
gotoxy(52,13);
write('2. ATENCIONES');
gotoxy(52,16);
write('3. ESTADÍSTICAS');
gotoxy(52,19);
write('4. LISTADOS Y OTROS');
gotoxy(52,22);
write('0. SALIR');
gotoxy(52,27);
write('OPCIÓN ELEGIDA: ');
readln(op);

clrscr;

case op of
'1':menu_pacientes(arch_p,raiz_dni,raiz_nombre);
'2':menu_atenciones(arch_a,arch_p,raiz_dni,raiz_nombre);
'3':menu_estadisticas(arch_a,arch_p,raiz_dni,raiz_nombre);
'4':menu_otros(arch_a,arch_p,raiz_dni,raiz_nombre);
'0':begin
         clrscr;
         gotoxy(40,15);
	    opcion(op_final,'¿Está seguro de que quiere salir? s/n: ');
    end;
End;
clrscr;
until (op_final='s') or (op_final='S');

end;

procedure subprograma_principal;
var archivo_a:t_archivo_a;
  archivo_p:t_archivo_p;
  arbol_nombre,arbol_dni:t_punt_arbol;
  begin
     assign(archivo_a,ruta_a);
     assign(archivo_p,ruta_p);
     iniciar_a(archivo_a);
     iniciar_p(archivo_p);
     if filesize(archivo_p)<>0 then
     begin
        crear_arbol_dni(archivo_p,arbol_dni);
        crear_arbol_nombre(archivo_p,arbol_nombre);
     end;
     textbackground(white);
     clrscr;
     textcolor(black);
     menu_general(archivo_a,archivo_p,arbol_dni,arbol_nombre);
     close(archivo_a);
     close(archivo_p);
end;

end.



