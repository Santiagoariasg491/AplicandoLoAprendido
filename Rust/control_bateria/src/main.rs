fn estado_bateria(nivel: i32, minimo: i32) -> &'static str {
    if nivel >= 50 {
        "TRANQUILO"
    } else if nivel >= minimo {
        "CUIDADO"
    } else {
        "PELIGRO"
    }
}

fn main() {
    let linea_doble = "=================================================================";
    let linea_simple = "-----------------------------------------------------------------";

    let horas = ["10am", "12pm", "2pm"];
    let mut minimos = [0; 30];
    let mut baterias = [[0; 3]; 30];
    let mut estados = [""; 3];

    for i in 0..30 {
        minimos[i] = 15 + ((i as i32 * 7) % 31);
        for j in 0..3 {
            baterias[i][j] = 10 + ((i as i32 * 17 + j as i32 * 29) % 90);
        }
    }

    println!("{}", linea_doble);
    println!("              CONTROL DE BATERIA - GRUPO DE 30 PERSONAS");
    println!("{}", linea_doble);
    println!("Chequeos del dia: {}, {}, {}", horas[0], horas[1], horas[2]);
    println!("Estados: TRANQUILO (50% o mas) - CUIDADO (alcanza su minimo) - PELIGRO");
    println!("");
    println!("No.  Min  10am  12pm   2pm   Estados");
    println!("{}", linea_simple);

    let mut tranquilos = 0;
    let mut cuidados = 0;
    let mut peligros = 0;
    let mut final_en_peligro = 0;

    for i in 0..30 {
        print!("{:>3}  {:>2}%", i + 1, minimos[i]);
        for j in 0..3 {
            estados[j] = estado_bateria(baterias[i][j], minimos[i]);
            print!("  {:>4}", baterias[i][j]);
            if estados[j] == "TRANQUILO" {
                tranquilos = tranquilos + 1;
            } else if estados[j] == "CUIDADO" {
                cuidados = cuidados + 1;
            } else {
                peligros = peligros + 1;
            }
        }
        print!("   ");
        for j in 0..3 {
            print!("{}", estados[j]);
            if j < 2 {
                print!(" / ");
            }
        }
        println!("");
        if estados[2] == "PELIGRO" {
            final_en_peligro = final_en_peligro + 1;
        }
    }

    println!("{}", linea_simple);
    println!("RESUMEN DEL DIA");
    println!("   Chequeos revisados : {}", tranquilos + cuidados + peligros);
    println!("   TRANQUILO          : {}", tranquilos);
    println!("   CUIDADO            : {}", cuidados);
    println!("   PELIGRO            : {}", peligros);
    println!("   Personas que terminan el dia en PELIGRO: {}", final_en_peligro);
    println!("{}", linea_doble);
}
