
cd "C:\Reporte_mensual\Bases"

import excel "C:\Reporte_mensual\Bases\CUBO_MENSUAL.xlsx", sheet("Cubo de información 01-01-2021 ") firstrow

save "CUBO_MENSUAL.dta", replace

tab CADENA_PRODUCTIVA,m
tab SECTOR,m
tab servicio,m
tab tipo_capacitacion,m
tab duracion_horas,m
tab MESTERMINA,m
tab municipio,m
tab accion_movil,m
tab dirigido_a,m
tab GRUPO_VULNERABLE,m
tab programa_capacitacion,m
tab empresa,m
tab tipo_empresa,m
tab PLANTEL,m
tab ESTATUS_ALUMNO,m
tab edadparticipantealtomarelcu,m
tab RANGODEEDAD,m
tab ESCOLARIDAD_ALUMNO,m
tab SEXO_ALUMNO,m
tab EscolaridadAgrupacion,m
tab Discapacidadvisual,m
tab Discapacidadauditiva,m 
tab Discapacidadlenguaje,m
tab Discapacidadfisica,m 
tab Discapacidadintelectual,m

**---------------CORREGIR EL SECTOR DE LAS EMPRESAS----------------**

joinby id_empresa using EMPRESAS_HISTORICO.dta, unmatched(master)
tab _merge
tab id_empresa if _merge==1,m

*----------------------ACTUALIZAR BASE EMPRESAS--------------------**
gen capacitandos=1
collapse (sum) capacitandos if _merge==1, by(id_empresa SECTOR CADENA_PRODUCTIVA empresa)
order id_empresa SECTOR

export excel using "C:\Reporte_mensual\Bases\Empresas_nuevas.xlsx", sheetreplace firstrow(variables)
clear

import excel "C:\Reporte_mensual\Bases\Empresas_nuevas.xlsx", sheet("Sheet1") firstrow
drop if missing(empresa)
drop capacitandos
rename SECTOR SECTOR_V
rename CADENA_PRODUCTIVA CADENA_V
rename empresa EMPRESAS_V
save "Empresas_nuevas.dta", replace
append using "EMPRESAS_HISTORICO.dta", force
tab CADENA_V
gsort id_empresa
export excel using "C:\Reporte_mensual\Bases\EMPRESAS_HISTORICO.xlsx", sheetreplace firstrow(variables)
save "C:\Reporte_mensual\Bases\EMPRESAS_HISTORICO.dta", replace
clear

use CUBO_MENSUAL.dta
joinby id_empresa using EMPRESAS_HISTORICO.dta, unmatched(master)
tab _merge
tab id_empresa if _merge==1,m

**-----------------------------------------------------------------**


replace SECTOR_V="SOCIAL" if missing(empresa)

tab empresa if SECTOR_V=="EMPRESARIAL"
tab empresa if SECTOR_V=="GOBIERNO"
tab empresa if SECTOR_V=="EDUCATIVO"
tab empresa if SECTOR_V=="SOCIAL"

tab SECTOR 
tab SECTOR_V

order SECTOR_V, after(SECTOR)

**-----------CORREGIR CADENA PRODUCTIVA----------------------------**
**NINGUNA**
replace CADENA_V="» NINGUNA" if inlist(SECTOR_V,"GOBIERNO","EDUCATIVO","SOCIAL")
replace CADENA_V="» NINGUNA" if inlist(id_empresa,4341,1477)
replace CADENA_V="» NINGUNA" if CADENA_V=="NINGUNA"

tab CADENA_PRODUCTIVA
tab CADENA_V

order CADENA_V, after(CADENA_PRODUCTIVA)

drop _merge EMPRESAS_V CADENA_PRODUCTIVA SECTOR

rename CADENA_V CADENA_PRODUCTIVA
rename SECTOR_V SECTOR

save "Acum_mens_corregido.dta", replace


**-----------------------INDICADORES MENSUALES-------------------**
clear

**Unir la base historica con la base 2020**
	 append using Historica_2021 Acum_mens_corregido, force

	**Guardamos el archivo generado como .dta**
	 save "Historica_2022.dta", replace
	 
**-----------------------Adecuaciones de variables-----------** 

	**Comprime el archivo**
	 compress
	 
	 **Renombrar la variable**
	 rename AÃotermino anio_termina

	 keep if inlist(anio_termina,2019,2022)
	 tab anio_termina
	 
	**Corrige errores en la variable PLANTEL**
	 replace PLANTEL="MISIÓN DE CHICHIMECAS" if PLANTEL=="MISIÃ“N DE CHICHIMECAS"

	**Creamos una variable tipo entero para el mes**
	 gen MES=1
		 replace MES=1 if MESTERMINA=="ENERO"
		 replace MES=2 if MESTERMINA=="FEBRERO"
		 replace MES=3 if MESTERMINA=="MARZO"
		 replace MES=4 if MESTERMINA=="ABRIL"
		 replace MES=5 if MESTERMINA=="MAYO"
		 replace MES=6 if MESTERMINA=="JUNIO"
		 replace MES=7 if MESTERMINA=="JULIO"
		 replace MES=8 if MESTERMINA=="AGOSTO"
		 replace MES=9 if MESTERMINA=="SEPTIEMBRE"
		 replace MES=10 if MESTERMINA=="OCTUBRE"
		 replace MES=11 if MESTERMINA=="NOVIEMBRE"
		 replace MES=12 if MESTERMINA=="DICIEMBRE"
		 
	 **Creamos una variable para la clave del plantel**
		gen clv_plan=1
		replace clv_plan=100 if PLANTEL=="DIRECCIÓN GENERAL"
		replace clv_plan=101 if PLANTEL=="ACÁMBARO"
		replace clv_plan=102 if PLANTEL=="APASEO EL GRANDE"
		replace clv_plan=103 if PLANTEL=="CELAYA"
		replace clv_plan=104 if PLANTEL=="COMONFORT"
		replace clv_plan=105 if PLANTEL=="CORONEO"
		replace clv_plan=106 if PLANTEL=="DOCTOR MORA"
		replace clv_plan=107 if PLANTEL=="GUANAJUATO"
		replace clv_plan=108 if PLANTEL=="IRAPUATO"
		replace clv_plan=109 if PLANTEL=="JERÉCUARO"
		replace clv_plan=110 if PLANTEL=="MOROLEÓN"
		replace clv_plan=111 if PLANTEL=="OCAMPO"
		replace clv_plan=112 if PLANTEL=="PÉNJAMO"
		replace clv_plan=113 if PLANTEL=="SALAMANCA"
		replace clv_plan=114 if PLANTEL=="SALVATIERRA"
		replace clv_plan=115 if PLANTEL=="SAN FRANCISCO DEL RINCÓN"
		replace clv_plan=116 if PLANTEL=="SAN JOSÉ ITURBIDE"
		replace clv_plan=117 if PLANTEL=="SAN LUIS DE LA PAZ"
		replace clv_plan=118 if PLANTEL=="MISIÓN DE CHICHIMECAS"
		replace clv_plan=119 if PLANTEL=="SAN MIGUEL DE ALLENDE"
		replace clv_plan=120 if PLANTEL=="SANTA CATARINA"
		replace clv_plan=121 if PLANTEL=="SANTIAGO MARAVATÍO"
		replace clv_plan=122 if PLANTEL=="SILAO"
		replace clv_plan=123 if PLANTEL=="TARANDACUAO"
		replace clv_plan=124 if PLANTEL=="TIERRA BLANCA"
		replace clv_plan=125 if PLANTEL=="VICTORIA"
		replace clv_plan=126 if PLANTEL=="VILLAGRÁN"
		replace clv_plan=127 if PLANTEL=="YURIRIA"
		replace clv_plan=128 if PLANTEL=="LEÓN"
		replace clv_plan=129 if PLANTEL=="SALAMANCA ALTA ESPECIALIDAD"
		replace clv_plan=131 if PLANTEL=="INSTITUTO DE EDUCACION Y DESARROLLO RICHARD E. DAUCH"
		replace clv_plan=132 if PLANTEL=="PURÍSIMA DEL RINCÓN"

	 **Genera una variable para controlar el periodo**
	 gen     periodo=1 if inlist(MES,1) 
	 replace periodo = 0 if missing(periodo)

/*-------------------Calculo de Indicadores----------------------*/


**Capacitandos**

gen capacitandos=1

gen capacitandos22=1 if anio_termina==2022 & periodo>0
gen capacitandos19=1 if anio_termina==2019 & periodo>0

mvencode capacitandos21-capacitandos19, mv(0)

tabstat capacitandos22, by(MES) s(sum)
tabstat capacitandos19, by(MES) s(sum)


**Personas Periodo**

sort anio_termina ID_ALUMNO MES
bys anio_termina ID_ALUMNO: gen dup_persperiodo = cond(_N==1,1,_n)
gen persPeriodo=1 if dup_persperiodo==1
replace persPeriodo = 0 if missing(persPeriodo)

gen persPeriodo21=1 if persPeriodo==1 & anio_termina==2021 & periodo>0
gen persPeriodo19=1 if persPeriodo==1 & anio_termina==2019 & periodo>0

mvencode persPeriodo21 persPeriodo19 , mv(0)

tabstat persPeriodo21, by(MES) s(sum)
tabstat persPeriodo19, by(MES) s(sum)

**Personas Periodo Plantel**

sort anio_termina clv_plan ID_ALUMNO MES
bys anio_termina clv_plan ID_ALUMNO : gen dup_persperiodoPL = cond(_N ==1,1,_n)
gen persPeriodoPL=1 if dup_persperiodoPL==1
replace persPeriodoPL = 0 if missing(persPeriodoPL)

gen persPeriodoPL21=1 if persPeriodoPL==1 & anio_termina==2021 & periodo>0
gen persPeriodoPL19=1 if persPeriodoPL==1 & anio_termina==2019 & periodo>0

mvencode persPeriodoPL21 persPeriodoPL19 , mv(0)

tabstat persPeriodoPL21, by(PLANTEL) s(sum)
tabstat persPeriodoPL19, by(PLANTEL) s(sum)

**Cursos**
bys anio_termina id_grupo_solicitud: gen cursos_dup = cond(_N==1,1,_n)
gen cursos=1 if cursos_dup==1
replace cursos=0 if missing(cursos)

gen cursos21=1 if cursos==1 & anio_termina==2021 & periodo>0
gen cursos19=1 if cursos==1 & anio_termina==2019 & periodo>0

mvencode cursos21 cursos19 , mv(0)

tabstat cursos21, by(MES) s(sum)
tabstat cursos19, by(MES) s(sum)

**Horas Curso**
 gen horas21=duracion_horas if cursos21==1
 gen horas19=duracion_horas if cursos19==1
 
 mvencode horas21 horas19 , mv(0)

 tabstat horas21, by(MES) s(sum)
 tabstat horas19, by(MES) s(sum)

 **Horas Personas**
 gen horas_per21=duracion_horas if anio_termina==2021 & periodo>0
 gen horas_per19=duracion_horas if anio_termina==2019 & periodo>0
 tabstat horas_per21, by(MES) s(sum)
 tabstat horas_per19, by(MES) s(sum)
 
 **Aprobados**
 gen cap_apro21=1 if capacitandos21==1 & ESTATUS_ALUMNO=="APROBADO"
 gen cap_apro19=1 if capacitandos19==1 & ESTATUS_ALUMNO=="APROBADO"
 
 mvencode cap_apro21 cap_apro19 , mv(0)

 tabstat cap_apro21, by(MES) s(sum)
 tabstat cap_apro19, by(MES) s(sum)
 
 **Guardamos una archivo para el calculo por mes**
 save"base_mes.dta", replace
 
 collapse (sum) capacitandos21 capacitandos19 persPeriodoPL21 persPeriodoPL19 cursos21 cursos19 cap_apro21 cap_apro19 horas21 horas19 horas_per21 horas_per19, by(clv_plan PLANTEL)

 order clv_plan
 
 **Eficiencia terminal** 
 gen eficiencia21=cap_apro21/capacitandos21
 gen eficiencia19=cap_apro19/capacitandos19
 
 **Capacitandos por Persona**
 gen cap_per21=capacitandos21/persPeriodoPL21
 gen cap_per19=capacitandos19/persPeriodoPL19
 
 **Diferencias**
 gen cap_dif=capacitandos21-capacitandos19
 gen per_dif=persPeriodoPL21-persPeriodoPL19
 gen cur_dif=cursos21-cursos19
 gen hor_dif=horas21-horas19
 gen efic_dif=eficiencia21-eficiencia19
 gen cap_per_dif=cap_per21-cap_per19
  
order clv_plan PLANTEL capacitandos21 capacitandos19 cap_dif persPeriodoPL21 persPeriodoPL19 per_dif cursos21 cursos19 cur_dif horas21 horas19 hor_dif cap_apro21 cap_apro19 eficiencia21 eficiencia19 efic_dif  horas_per21 horas_per19 cap_per21 cap_per19 cap_per_dif

 **Guardar como .dta**
  save"comparativo.dta", replace
  
  export excel using "C:\Reporte_mensual\Insumos\base_inf_mensual.xlsx", sheetreplace firstrow(variables)
  
  **Limpiar memoria**
  clear
  
  **Exportamos archivo para calculo por mes**
  use base_mes
  
  **Reorganizamos la base por mes*
  collapse (sum) capacitandos21 capacitandos19 persPeriodo21 persPeriodo19 cursos21 cursos19 horas21 horas19 horas_per21 horas_per19 cap_apro21 cap_apro19, by(MES MESTERMINA)
  
  save "comparativo_mes.dta", replace
  
 
 export excel using "C:\Reporte_mensual\Insumos\comparativo_mes.xlsx", sheetreplace firstrow(variables)
 
 clear
**--------------------------INGRESOS MESUALES---------------------**
stop
****2019****
 import excel "C:\Reporte_mensual\Bases\BaseHistorica_IngresosDAF_v2.xlsx", sheet("MensualIECA") firstrow

 rename anio_termino anio_termina
 keep if anio_termina==2019

drop if missing(anio_termina)
rename IngresosDAF ingresos

rename ingresos ingresos19

save "ingresos_2019.dta", replace

clear

***2020***
import excel "INGRESOS_MENSUAL.xlsx",sheet("Ingreso cobrado & pendiente") cellrange(A4:P37) firstrow

mvencode Plantel-Pendientedecobro, mv(0)
drop Noviembre-Pendientedecobro
joinby Plantel using "planteles.dta",unmatched(master)
drop if Plantel=="Total"
drop _merge
order clv_plan
rename * inc_=
rename (inc_clv_plan inc_Plantel) ( clv_plan PLANTEL)
drop PLANTEL 

rename *,lower

reshape long inc_,  i(clv_plan) j(mes)
 	 
**Crear variable periodo**
 gen periodo=1 if inlist(MES,1,2,3,4,5,6,7,8,9,10,11) 
 replace periodo = 0 if missing(periodo)
		 
 **Crear variables para ingresos 19-20**
 gen ingresos19=ingresos if anio_termina==2019 & periodo>0
 
  
 **Colapsar la base**
 collapse (sum) ingresos21 ingresos19, by(MES)
 
 joinby MES using  "comparativo_mes.dta", unmatched(master)
 
 order ingresos21, after(cap_apro20)
 order ingresos19, after(ingresos21)
 
 drop _merge
 
 order MESTERMINA
  
 **Guardar archivo**
 export excel using "C:\Reporte_mensual\Insumos\comparativo_mes.xlsx", sheetreplace firstrow(variables)


 
clear
**--------------------INGRESOS POR PLANTEL-------------------------**

import excel "C:\Reporte_mensual\Bases\INGRESOS_MENSUAL.xlsx", sheet("Comparativo oct") cellrange(A4:G36) firstrow

drop D F
destring CeGe, generate(clv_plan) ignore(`"I"', illegal)
gen dif_ing=AcumuladoaAgo21-AcumuladoaAgo20
rename AcumuladoaAgo20 ing_2020
rename AcumuladoaAgo21 ing_2021
drop CeGe IncrementoóDisminuciónconres

joinby clv_plan using  "comparativo.dta", unmatched(master)

order ing_2021, after(cap_per_dif)
order ing_2020, after(ing_2021)
order dif_ing, after(ing_2020)

drop Plantel _merge
replace PLANTEL="DIRECCIÓN GENERAL" if clv_plan==100

 mvencode capacitandos21-dif_ing , mv(0)
 
 save "comparativo.dta", replace

export excel using "C:\Reporte_mensual\Insumos\base_inf_mensual.xlsx", sheetreplace firstrow(variables)

clear
**--------------------Eficiencia terminal--------------------------**

use "Acum_mens_corregido.dta"

rename AÃotermino anio_termina
 
gen capacitandos=1

gen Aprobados=1 if ESTATUS_ALUMNO=="APROBADO"
gen No_Aprobados=1 if ESTATUS_ALUMNO=="NO APROBADO"
gen Baja=1 if ESTATUS_ALUMNO=="BAJA"
gen Desercion=1 if ESTATUS_ALUMNO=="DESERCION"

mvencode Aprobados-Desercion, mv(0)

collapse (sum) capacitandos-Desercion, by(programa_capacitacion)
gen eficiencia_prog=Aprobados/capacitandos
gsort eficiencia_prog

export excel using "C:\Reporte_mensual\Insumos\eficiencia_programas.xlsx", sheetreplace firstrow(variables)

clear

**------------------------CADENA PRODUCTIVA---------------------**
use "Acum_mens_corregido.dta"

gen capacitandos=1

sort id_empresa
	 bys id_empresa: gen dup_empresas = cond(_N==1,1,_n)
	 gen empresas=1 if dup_empresas==1
	 replace empresas = 0 if missing(empresas)
	 tabstat empresas, by(CADENA_PRODUCTIVA) s(sum)

collapse (sum) capacitandos empresas, by(id_empresa CADENA_PRODUCTIVA empresa)

order CADENA_PRODUCTIVA, before(empresa)

gsort -capacitandos

export excel using "C:\Reporte_mensual\Insumos\cadena productiva.xlsx", sheetreplace firstrow(variables)

clear

**------------------------PARETO---------------------**

use "Acum_mens_corregido.dta"

gen capacitandos=1

keep if SECTOR=="EMPRESARIAL"

collapse (sum) capacitandos, by(empresa)
gsort -capacitandos
gen acumulado=sum(capacitandos)
egen total=sum(capacitandos)
gen porc_acum=acumulado/total

drop total

export excel using "C:\Reporte_mensual\Insumos\pareto.xlsx", sheetreplace firstrow(variables)

 
clear

**------------------------tipo de curso---------------------**

use "Acum_mens_corregido.dta"  

gen capacitandos=1

bys  id_grupo_solicitud: gen cursos_dup = cond(_N==1,1,_n)
gen cursos=1 if cursos_dup==1
replace cursos=0 if missing(cursos)
tabstat cursos, by(tipo_capacitacion) s(sum)

collapse (sum) capacitandos cursos, by(tipo_capacitacion)

export excel using "C:\Reporte_mensual\Insumos\tipo_cursos.xlsx", sheetreplace firstrow(variables)

clear

**------------------------METAS_2020---------------------**

use Metas_2020.dta

gen     periodo=1 if inlist(MES,1,2,3,4,5,6,7,8) 
replace periodo = 0 if missing(periodo)

order Personas, after(Acreditados)

collapse (sum) Ingresos-Personas if periodo>0, by(periodo)
clear

**------------------------METAS_2021---------------------**
use Metas_2021.dta

rename MESES MERTERMINA

gen MES=1
		 replace MES=1 if MESTERMINA=="ENERO"
		 replace MES=2 if MESTERMINA=="FEBRERO"
		 replace MES=3 if MESTERMINA=="MARZO"
		 replace MES=4 if MESTERMINA=="ABRIL"
		 replace MES=5 if MESTERMINA=="MAYO"
		 replace MES=6 if MESTERMINA=="JUNIO"
		 replace MES=7 if MESTERMINA=="JULIO"
		 replace MES=8 if MESTERMINA=="AGOSTO"
		 replace MES=9 if MESTERMINA=="SEPTIEMBRE"
		 replace MES=10 if MESTERMINA=="OCTUBRE"
		 replace MES=11 if MESTERMINA=="NOVIEMBRE"
		 replace MES=12 if MESTERMINA=="DICIEMBRE"

gen periodo=1 if inlist(MES,1,2,3,4,5,6,7,8,9,10,11) 
replace periodo = 0 if missing(periodo)

order personas, after(capacitandos)

collapse (sum) ingresos-cursos if periodo>0, by(periodo)

**------------------------AVANCE METAS_2021---------------------**
 use "base_mes.dta", replace
 
 collapse (sum) cap_apro21 cursos21 persPeriodoPL21, by(clv_plan PLANTEL)
 order clv_plan
 
 order persPeriodoPL21, after(cap_apro21)

 export excel using "C:\Reporte_mensual\Insumos\metas_avance_mens.xlsx", sheetreplace firstrow(variables)






**------------------------Capacitandos Sector---------------------**

use "base_mes.dta"
tab anio_termina

collapse (sum) capacitandos if periodo==1, by(SECTOR anio_termina)
reshape wide capacitandos, i(SECTOR) j(anio_termina)



*---------------------------Programa Capacitación Juvenil--------------**

use "Acum_mens_corregido.dta"  



gen capacitandos=1

keep if programa_capacitacion=="CAPACITACIÓN LABORAL JUVENIL"
drop if programa_capacitacion=="CAPACITACIÓN LABORAL JUVENIL"

gen aprobados=1 if ESTATUS_ALUMNO=="APROBADO"
gen no_aprobados=1 if ESTATUS_ALUMNO=="NO APROBADO"
gen desercion=1 if ESTATUS_ALUMNO=="DESERCION"
gen baja=1 if ESTATUS_ALUMNO=="BAJA"

mvencode aprobados-baja, mv(0)

collapse (sum) capacitandos-baja, by(programa_capacitacion)

collapse (sum) capacitandos-baja, by(PLANTEL)

gen efic_term= aprobados/capacitandos

gsort efic_term































 











