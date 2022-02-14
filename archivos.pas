unit archivos;

interface
uses unidad_gral;

const
N=10;

type
        t_dato_p=record
			nom: string[40];
                        dir: string[40];
                        ciudad: string[30];
                        dni: string[8];
                        fecha_nac: t_fecha;
                        tel: string[14];
                        obra_social: string[15];
                        nro_afiliado: string[20];
                        estado:boolean;
end;
t_archivo_p=file of t_dato_p;
t_tratamiento=record
            codigo:string[8];
            descripcion:string[100];
end;
t_vector=array[1..n]of t_tratamiento;
	t_dato_a=record
			DNI:string[8];
			fecha:t_fecha;
				tratamiento:t_vector;
		end;
t_archivo_a=file of t_dato_a;

Procedure iniciar_a(var arch:t_archivo_a);
Procedure iniciar_p(var arch:t_archivo_p);
implementation
Procedure iniciar_p(var arch:t_archivo_p);
begin
{$I-}
Reset(arch);
{$I+}
if IOResult <> 0 then Rewrite(arch);
end;
Procedure iniciar_a(var arch:t_archivo_a);
begin
{$I-}
Reset(arch);
{$I+}
if IOResult <> 0 then Rewrite(arch);
end;
end.

