Unit unidad_gral;
{$codepage UTF8}
interface

uses sysutils;

type
	t_fecha=record
				dia:string[2];
				mes:string[2];
				ano:string[4];
	end;

const opciones=['S','s','n','N'];

function fecha_legal(f:t_fecha):boolean;
function es_numero(cad:string):boolean;
procedure cargar_fecha(var f:t_fecha);
procedure opcion(var op: char; texto:string);
function fecha(f:t_fecha):string;

implementation

function fecha_legal(f:t_fecha):boolean;
var valido:boolean;
begin
	valido:=True;
	case f.mes of
	'04','06','09','11': if f.dia>'30' then valido:=false;
	'02':
		begin
			if (strtoint(f.ano) mod 4 =0) and ((strtoint(f.ano) mod 100 <>0) or (strtoint(f.ano) mod 400 = 0)) then
			begin
if (f.dia>'29') then valido:=false
end
else if (f.dia>'28') then valido:=false;
		end;
	end;
	if not valido then writeln('La fecha ingresada no es válida. ');
	fecha_legal:=valido;
end;

function es_numero(cad:string):boolean;
var no_nro:boolean;
i:byte;
begin
no_nro:=false;
	for i:=1 to length(cad) do
	begin
		if not (cad[i] in ['0'..'9']) then no_nro:=True;
	end;
	es_numero:=not no_nro;
end;

procedure cargar_fecha(var f:t_fecha);
begin
repeat
repeat
write('Ingrese día: ');
readln(f.dia);
until (f.dia>='01') and (f.dia<='31') and es_numero(f.dia);
repeat
write('Ingrese mes: ');
readln(f.mes);
until (f.mes>='01') and (f.mes<='12') and es_numero(f.mes);
repeat
write('Ingrese año: ');
readln(f.ano);
until (f.ano>='1908') and (f.ano<='2021') and es_numero(f.ano);
until fecha_legal(f);
end;



procedure opcion(var op: char; texto:string);
begin
	repeat
		write(texto);
		readln(op);
	until op in opciones;
end;

function fecha(f:t_fecha):string;
begin
	fecha:=f.dia+'/'+f.mes+'/'+f.ano;
end;

end.


