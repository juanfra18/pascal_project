unit UNIT_ARBOL;
{$codepage UTF8}
INTERFACE
USES CRT;
TYPE

T_DATO_arbol = RECORD
			clave:string[40];
			pos:word;
 end;

T_PUNT_arbol = ^T_NODO_arbol;

T_NODO_arbol = RECORD
           INFO:T_DATO_arbol;
           SAI,SAD: T_PUNT_arbol;
         END;

 PROCEDURE CREAR_ARBOL (VAR RAIZ:T_PUNT_arbol);
 PROCEDURE AGREGAR (VAR RAIZ:T_PUNT_arbol; X:T_DATO_arbol);
 FUNCTION ARBOL_VACIO (RAIZ:T_PUNT_arbol): BOOLEAN;
  FUNCTION ARBOL_LLENO (RAIZ:T_PUNT_arbol): BOOLEAN;

implementation
PROCEDURE CREAR_ARBOL (VAR RAIZ:T_PUNT_arbol);
BEGIN
    RAIZ:= NIL;
  END;

 PROCEDURE AGREGAR (VAR RAIZ:T_PUNT_arbol; X:T_DATO_arbol);
  BEGIN
        IF RAIZ = NIL THEN
                            BEGIN
                            NEW (RAIZ);
                            RAIZ^.INFO:= X;
                            RAIZ^.SAI:= NIL;
                            RAIZ^.SAD:= NIL;
                            END
                    ELSE   IF RAIZ^.INFO.clave > X.clave THEN AGREGAR (RAIZ^.SAI,X)
                                             ELSE AGREGAR (RAIZ^.SAD,X)

   END;

 FUNCTION ARBOL_VACIO (RAIZ:T_PUNT_arbol): BOOLEAN;
   BEGIN
        ARBOL_VACIO:= RAIZ  = NIL;
   END;

 FUNCTION ARBOL_LLENO (RAIZ:T_PUNT_arbol): BOOLEAN;
    BEGIN
         ARBOL_LLENO:= GETHEAPSTATUS.TOTALFREE < SIZEOF (T_NODO_arbol);
    END;
 END.




