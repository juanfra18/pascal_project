unit USA_ARBOL;
{$codepage UTF8}

interface
uses CRT, UNIT_ARBOL;


PROCEDURE INORDEN( VAR RAIZ:T_PUNT_arbol);
FUNCTION PREORDEN( RAIZ:T_PUNT_arbol;BUSCADO:string):T_PUNT_arbol;
PROCEDURE LISTAR (RAIZ:T_PUNT_arbol);

implementation


PROCEDURE INORDEN(VAR RAIZ:T_PUNT_arbol);
   BEGIN
        IF RAIZ <> NIL THEN  BEGIN
                            INORDEN (RAIZ^.SAI);
                            WRITELN (RAIZ^.INFO.clave);
                            INORDEN (RAIZ^.SAD);
        end;

   END;

  PROCEDURE LISTAR (RAIZ:T_PUNT_arbol);
    BEGIN
      IF NOT ARBOL_VACIO (RAIZ) THEN INORDEN (RAIZ)
        ELSE WRITELN ('ARBOL VACIO');
      READKEY;
    END;

  FUNCTION PREORDEN(RAIZ:T_PUNT_arbol;BUSCADO:string):T_PUNT_arbol;
   BEGIN
        IF (RAIZ =  NIL) THEN  PREORDEN := NIL
                         ELSE

                 IF ( RAIZ^.INFO.clave  = BUSCADO) THEN
                                     PREORDEN:= RAIZ
                                    ELSE IF RAIZ^.INFO.clave > BUSCADO THEN
                                     PREORDEN := PREORDEN(RAIZ^.SAI,BUSCADO)
                                                ELSE
                                                PREORDEN := PREORDEN(RAIZ^.SAD,BUSCADO)

        END;
end.

