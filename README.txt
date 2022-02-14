CONSIGNA
1. Simulación Consultorio Dentista (Pacientes con Obra Social)
Archivo de personas
- Nombre y Apellido
- Dirección
- Ciudad
- DNI
- Fecha de nacimiento
- Teléfono
- Nombre Obra Social
- Número de afiliado de la Obra social
- Estado (para la baja lógica)
Archivo de atenciones
- DNI
- Fecha
- Tratamiento: array [1..N] of ...(código, descripción )
Se pide:
- Alta, Baja, Modificación y Consulta de personas
- Alta y Consulta de atenciones
- Listado ordenado por fecha de todas las atenciones
- Listado ordenado por fecha de las atenciones a un paciente
- Consulta de datos de un paciente (registro de la persona y todos sus atenciones)
- Impresión por pantalla de una orden para entregar en Obra Social (con todos los
datos)
- Estadísticas:
  . Cantidad de atenciones entre dos fechas
  . Cantidad de atenciones por obra social
  . Porcentaje de atenciones detallado por meses en el año
  . Promedio de atenciones diarias
  . Porcentaje de atenciones de pacientes de otra ciudad
El trabajo se deberá implementar con archivos random.
Los datos de las personas se mantendrán ordenados mediante árboles binarios de
búsqueda (uno ordenado por DNI y otro ordenado por Apellido y Nombre)
Debe estar modularizado en Units.
Se puede agregar cualquier aporte que considere conveniente, justificando el mismo.
Se presupone que el usuario administrativo será personal del consultorio, por lo que la
carga y visualización de los datos debe ser práctica y amigable.
