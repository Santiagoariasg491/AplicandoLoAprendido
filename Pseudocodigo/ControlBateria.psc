SubProceso estado <- EstadoBateria(nivel, minimo)
    Definir estado Como Caracter;
    Si nivel >= 50 Entonces
        estado <- "TRANQUILO";
    SiNo
        Si nivel >= minimo Entonces
            estado <- "CUIDADO";
        SiNo
            estado <- "PELIGRO";
        FinSi
    FinSi
FinSubProceso

Proceso ControlBateria
    Definir lineaDoble, lineaSimple Como Caracter;
    Definir horas Como Caracter;
    Dimension horas[3];
    Definir estados Como Caracter;
    Dimension estados[3];
    Definir minimos Como Entero;
    Dimension minimos[30];
    Definir baterias Como Entero;
    Dimension baterias[30,3];
    Definir i, j, tranquilos, cuidados, peligros, finalEnPeligro Como Entero;

    lineaDoble <- "=================================================================";
    lineaSimple <- "-----------------------------------------------------------------";

    horas[0] <- "10am";
    horas[1] <- "12pm";
    horas[2] <- "2pm";

    Para i <- 0 Hasta 29 Con Paso 1 Hacer
        minimos[i] <- 15 + ((i * 7) MOD 31);
        Para j <- 0 Hasta 2 Con Paso 1 Hacer
            baterias[i,j] <- 10 + ((i * 17 + j * 29) MOD 90);
        FinPara
    FinPara

    Escribir lineaDoble;
    Escribir "              CONTROL DE BATERIA - GRUPO DE 30 PERSONAS";
    Escribir lineaDoble;
    Escribir "Chequeos del dia: ", horas[0], ", ", horas[1], ", ", horas[2];
    Escribir "Estados: TRANQUILO (50% o mas) - CUIDADO (alcanza su minimo) - PELIGRO";
    Escribir "";
    Escribir "No.  Min  10am  12pm   2pm   Estados";
    Escribir lineaSimple;

    tranquilos <- 0;
    cuidados <- 0;
    peligros <- 0;
    finalEnPeligro <- 0;

    Para i <- 0 Hasta 29 Con Paso 1 Hacer
        Si i + 1 < 10 Entonces
            Escribir Sin Saltar "  ";
        SiNo
            Escribir Sin Saltar " ";
        FinSi
        Escribir Sin Saltar i + 1, "  ", minimos[i], "%";
        Para j <- 0 Hasta 2 Con Paso 1 Hacer
            estados[j] <- EstadoBateria(baterias[i,j], minimos[i]);
            Escribir Sin Saltar "    ", baterias[i,j];
            Si estados[j] = "TRANQUILO" Entonces
                tranquilos <- tranquilos + 1;
            SiNo
                Si estados[j] = "CUIDADO" Entonces
                    cuidados <- cuidados + 1;
                SiNo
                    peligros <- peligros + 1;
                FinSi
            FinSi
        FinPara
        Escribir Sin Saltar "   ";
        Para j <- 0 Hasta 2 Con Paso 1 Hacer
            Escribir Sin Saltar estados[j];
            Si j < 2 Entonces
                Escribir Sin Saltar " / ";
            FinSi
        FinPara
        Escribir "";
        Si estados[2] = "PELIGRO" Entonces
            finalEnPeligro <- finalEnPeligro + 1;
        FinSi
    FinPara

    Escribir lineaSimple;
    Escribir "RESUMEN DEL DIA";
    Escribir "   Chequeos revisados : ", tranquilos + cuidados + peligros;
    Escribir "   TRANQUILO          : ", tranquilos;
    Escribir "   CUIDADO            : ", cuidados;
    Escribir "   PELIGRO            : ", peligros;
    Escribir "   Personas que terminan el dia en PELIGRO: ", finalEnPeligro;
    Escribir lineaDoble;
FinProceso
