unit USA_ARBOL;
{$codepage UTF8}

interface
uses CRT, UNIT_ARBOL;

FUNCTION PREORDEN( RAIZ:T_PUNT_arbol;BUSCADO:string):T_PUNT_arbol;

implementation

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

