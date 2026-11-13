# Aplicando lo aprendido — Control de batería de 30 personas

### El mismo programa escrito tres veces: pseudocódigo PSeInt, Python y Rust

> **Para qué sirve:** ver un problema completo —vector, matriz, función, ciclo anidado, contadores y decisiones— resuelto tres veces con la misma lógica, para poder comparar renglón por renglón qué cambia y qué no cuando se pasa del pseudocódigo a un lenguaje real.
> **Los tres programas imprimen exactamente la misma salida**, carácter por carácter.
> **Para quién es:** estudiantes que vienen de [Ejercicios_1](../Ejercicios_1/README.md), [Ejercicios_2](../Ejercicios_2/README.md) y [Ejercicios_3](../Ejercicios_3/README.md).

---

## Qué hay en esta carpeta

| Archivo | Qué es | Con qué se abre |
|---|---|---|
| [Pseudocodigo/ControlBateria.psc](Pseudocodigo/ControlBateria.psc) | El programa en pseudocódigo | PSeInt, perfil Estricto |
| [Python/ControlBateria.ipynb](Python/ControlBateria.ipynb) | El programa en Python, armado por partes y explicado | VS Code o Jupyter |
| [Rust/control_bateria/](Rust/control_bateria/) | El programa en Rust, como proyecto de cargo | Terminal, con `cargo run` |
| `README.md` | Este archivo: la explicación de las tres versiones | Cualquier editor |

```
AplicandoLoAprendido/
├── README.md
├── Pseudocodigo/
│   └── ControlBateria.psc
├── Python/
│   └── ControlBateria.ipynb
└── Rust/
    └── control_bateria/
        ├── Cargo.toml          <- nombre y configuración del proyecto
        └── src/
            └── main.rs         <- el código
```

---

## El caso

Un grupo de **30 personas** sale de paseo. Cada dos horas revisan la batería del celular: tres chequeos, a las 10am, 12pm y 2pm. Cada persona necesita un mínimo distinto de batería para llegar a casa sin quedarse incomunicada.

El programa revisa las 90 mediciones (30 personas × 3 chequeos), clasifica cada una en uno de tres estados y muestra una tabla con el resumen del día.

| Elemento del caso | Estructura que lo representa |
|---|---|
| Las tres horas de chequeo | Vector de 3 textos: `horas` |
| El mínimo que necesita cada persona | Vector de 30 enteros: `minimos` |
| La batería de cada persona en cada chequeo | Matriz de 30 filas × 3 columnas: `baterias` |
| Los estados de una persona en sus tres chequeos | Vector de 3 textos: `estados` |
| Decidir cómo está una persona | Función `EstadoBateria` / `estado_bateria` |
| Revisar a todos en todos los chequeos | Ciclo anidado: `j` dentro de `i` |
| Saber cuántos hubo de cada estado | Contadores: `tranquilos`, `cuidados`, `peligros` |

### De dónde salen los datos

Escribir a mano 90 niveles de batería y 30 mínimos sería repetir más de 120 números en cada uno de los tres lenguajes. En vez de eso, los datos se calculan con dos fórmulas fijas:

```
minimos[i]      = 15 + ((i * 7) MOD 31)              -> valores entre 15 y 45
baterias[i][j]  = 10 + ((i * 17 + j * 29) MOD 90)    -> valores entre 10 y 99
```

`MOD` (en Python y Rust, `%`) es el **residuo** de la división: lo que sobra. `(i * 7) MOD 31` nunca pasa de 30, así que el mínimo siempre cae entre 15 y 45. No hay azar: las fórmulas dan siempre los mismos números, y por eso los tres programas muestran lo mismo. Además todos los valores quedan de dos dígitos, lo que permite alinear la tabla sin complicaciones.

### La regla de decisión

| Condición | Estado | Qué significa |
|---|---|---|
| `nivel >= 50` | `TRANQUILO` | Tiene batería de sobra |
| `nivel >= minimo` (pero menor que 50) | `CUIDADO` | Le alcanza justo para llegar |
| en cualquier otro caso | `PELIGRO` | No le alcanza para llegar a casa |

El orden importa: se pregunta primero por `TRANQUILO`, y solo si esa condición falla se pregunta por `CUIDADO`. Si se invirtieran las dos preguntas, nadie sería nunca `TRANQUILO`.

---

## La salida en pantalla

```
=================================================================
              CONTROL DE BATERIA - GRUPO DE 30 PERSONAS
=================================================================
Chequeos del dia: 10am, 12pm, 2pm
Estados: TRANQUILO (50% o mas) - CUIDADO (alcanza su minimo) - PELIGRO

No.  Min  10am  12pm   2pm   Estados
-----------------------------------------------------------------
  1  15%    10    39    68   PELIGRO / CUIDADO / TRANQUILO
  2  22%    27    56    85   CUIDADO / TRANQUILO / TRANQUILO
  3  29%    44    73    12   CUIDADO / TRANQUILO / PELIGRO
  4  36%    61    90    29   TRANQUILO / TRANQUILO / PELIGRO
  5  43%    78    17    46   TRANQUILO / PELIGRO / CUIDADO
  6  19%    95    34    63   TRANQUILO / CUIDADO / TRANQUILO
  7  26%    22    51    80   PELIGRO / TRANQUILO / TRANQUILO
  8  33%    39    68    97   CUIDADO / TRANQUILO / TRANQUILO
  9  40%    56    85    24   TRANQUILO / TRANQUILO / PELIGRO
 10  16%    73    12    41   TRANQUILO / PELIGRO / CUIDADO
 11  23%    90    29    58   TRANQUILO / CUIDADO / TRANQUILO
 12  30%    17    46    75   PELIGRO / CUIDADO / TRANQUILO
 13  37%    34    63    92   PELIGRO / TRANQUILO / TRANQUILO
 14  44%    51    80    19   TRANQUILO / TRANQUILO / PELIGRO
 15  20%    68    97    36   TRANQUILO / TRANQUILO / CUIDADO
 16  27%    85    24    53   TRANQUILO / PELIGRO / TRANQUILO
 17  34%    12    41    70   PELIGRO / CUIDADO / TRANQUILO
 18  41%    29    58    87   PELIGRO / TRANQUILO / TRANQUILO
 19  17%    46    75    14   CUIDADO / TRANQUILO / PELIGRO
 20  24%    63    92    31   TRANQUILO / TRANQUILO / CUIDADO
 21  31%    80    19    48   TRANQUILO / PELIGRO / CUIDADO
 22  38%    97    36    65   TRANQUILO / PELIGRO / TRANQUILO
 23  45%    24    53    82   PELIGRO / TRANQUILO / TRANQUILO
 24  21%    41    70    99   CUIDADO / TRANQUILO / TRANQUILO
 25  28%    58    87    26   TRANQUILO / TRANQUILO / PELIGRO
 26  35%    75    14    43   TRANQUILO / PELIGRO / CUIDADO
 27  42%    92    31    60   TRANQUILO / PELIGRO / TRANQUILO
 28  18%    19    48    77   CUIDADO / CUIDADO / TRANQUILO
 29  25%    36    65    94   CUIDADO / TRANQUILO / TRANQUILO
 30  32%    53    82    21   TRANQUILO / TRANQUILO / PELIGRO
-----------------------------------------------------------------
RESUMEN DEL DIA
   Chequeos revisados : 90
   TRANQUILO          : 50
   CUIDADO            : 19
   PELIGRO            : 21
   Personas que terminan el dia en PELIGRO: 7
=================================================================
```

Todo el texto es ASCII: sin emojis y sin tildes, ni siquiera dentro de las comillas. La consola de Windows y la de PSeInt los muestran rotos. Por eso en el código se escribe `bateria` y `dia`, mientras que este README sí lleva ortografía completa.

---

## Cómo se ejecuta cada versión

### PSeInt

1. Abrir PSeInt y poner el perfil **Estricto** en `Configurar → Opciones del lenguaje`.
2. Abrir `Pseudocodigo/ControlBateria.psc`.
3. `F9` revisa la sintaxis sin ejecutar.
4. `F5` ejecuta y abre la consola.
5. `F4` ejecuta paso a paso, útil para ver cómo cambian `i`, `j` y los contadores.
6. `Ctrl + D` dibuja el diagrama de flujo.

Este perfil cuenta las posiciones de los arreglos **desde 0**, igual que Python y Rust, y por eso el código funciona sin cambios.

### Python

El notebook arma el programa por partes: primero los datos, después la función, después el ciclo, y al final el programa completo.

1. Abrir `Python/ControlBateria.ipynb` en VS Code.
2. La primera vez, elegir el kernel de Python (arriba a la derecha).
3. Ejecutar celda por celda con `Shift + Enter`, o todas con `Run All`.

No pide nada por teclado: los datos ya están en el código. Para ejecutarlo fuera del notebook, se copia la celda del programa completo a un archivo `.py` y se corre con `python ControlBateria.py`.

### Rust

Rust **compila antes de ejecutar**: traduce todo el programa a un ejecutable y, si algo no cuadra, no genera nada. Python, en cambio, interpreta el código línea por línea mientras corre. Por eso en Rust muchos errores aparecen antes de ejecutar, y en Python aparecen a mitad de la ejecución.

Hay que tener instalado Rust (se instala con [rustup](https://rustup.rs)). Desde la carpeta `Rust/control_bateria`:

| Comando | Qué hace |
|---|---|
| `cargo run` | Compila y ejecuta de una sola vez. Es el que se usa mientras se aprende |
| `cargo check` | Solo revisa que el código esté bien, sin generar el ejecutable. Es el más rápido |
| `cargo build` | Compila y deja el ejecutable en `target/debug/control_bateria.exe` |
| `cargo build --release` | Compila optimizado, en `target/release/`. Tarda más, pero el programa corre más rápido |
| `cargo fmt` | Ordena la indentación y los espacios del código |

`Cargo.toml` es la ficha del proyecto: nombre, versión, edición del lenguaje y dependencias. Este proyecto **no usa ninguna dependencia**, así que la sección `[dependencies]` está vacía. La carpeta `target/` la genera cargo y no se guarda en git.

---

## Los tipos de datos

Un tipo de dato define **qué se puede guardar en una variable** y qué operaciones tienen sentido con ella.

| Qué se quiere guardar | PSeInt | Python | Rust |
|---|---|---|---|
| Número entero | `Definir n Como Entero;` | `n = 5` | `let n: i32 = 5;` |
| Número con decimales | `Definir x Como Real;` | `x = 2.5` | `let x: f64 = 2.5;` |
| Texto | `Definir s Como Caracter;` | `s = "hola"` | `let s: &str = "hola";` |
| Verdadero o falso | `Definir b Como Logico;` | `b = True` | `let b: bool = true;` |
| Vector de 3 textos | `Dimension horas[3];` | `horas = ["10am", "12pm", "2pm"]` | `let horas = ["10am", "12pm", "2pm"];` |
| Vector de 30 enteros | `Dimension minimos[30];` | `minimos = [0] * 30` | `let mut minimos = [0; 30];` |
| Matriz de 30 × 3 | `Dimension baterias[30,3];` | `baterias = [[0] * 3 for _ in range(30)]` | `let mut baterias = [[0; 3]; 30];` |

### Tipado dinámico y tipado estático

- **Python es de tipado dinámico**: la variable no se declara y puede cambiar de tipo en cualquier momento. `n = 5` y dos líneas después `n = "hola"` es válido. Cómodo, pero un error de tipo solo aparece cuando el programa ya está corriendo.
- **Rust es de tipado estático**: cada variable tiene un tipo fijo, decidido al compilar. Si se intenta guardar un texto donde iba un entero, el programa **no compila**. Molesta al principio y evita errores después.
- **PSeInt en perfil Estricto se parece a Rust**: obliga a declarar cada variable con `Definir ... Como ...` antes de usarla. Esa es justamente la razón de que el perfil se llame Estricto.

### Qué significa `i32`

En Rust los enteros llevan el tamaño en el nombre: `i32` es un entero con **signo** (puede ser negativo) que ocupa **32 bits**, o sea valores entre -2.147.483.648 y 2.147.483.647. También existen `i64` (más grande), `u32` (solo positivos) y `usize`, que es el tipo que Rust usa para las **posiciones** de los arreglos.

Por eso en el código aparece `i as i32`: dentro del ciclo, `i` es una posición (`usize`), y para usarla en la fórmula junto a números `i32` hay que convertirla. `as` es la conversión. En Python y en PSeInt ese detalle no existe: todos los enteros son "enteros".

### `&str` y `String`

Rust tiene dos tipos de texto:

- `&str` es un texto fijo, que no cambia, normalmente escrito entre comillas en el código: `"TRANQUILO"`.
- `String` es un texto que se puede modificar y crecer, guardado en memoria dinámica.

Este programa solo necesita textos fijos, así que usa `&str`. El `&'static str` que devuelve la función significa "un texto que vive durante todo el programa", que es lo que son los textos escritos entre comillas.

---

## Cómo se crea una función

Una función es un bloque de código con nombre, que recibe datos (los **parámetros**), hace algo y **devuelve** un resultado. Sirve para escribir una vez lo que se usa muchas veces: aquí la decisión se toma 90 veces, pero está escrita una sola vez.

### La forma general

**PSeInt** — una función es un `SubProceso` que asigna un valor a una variable de salida:

```
SubProceso valorDeSalida <- NombreFuncion(parametro1, parametro2)
    Definir valorDeSalida Como Caracter;
    valorDeSalida <- ...;
FinSubProceso
```

**Python** — `def`, los parámetros entre paréntesis y `return` para devolver:

```python
def nombre_funcion(parametro1, parametro2):
    return ...
```

**Rust** — `fn`, el tipo de cada parámetro después de los dos puntos, y el tipo del resultado después de la flecha `->`:

```rust
fn nombre_funcion(parametro1: i32, parametro2: i32) -> &'static str {
    ...
}
```

### La función de este programa, en los tres lenguajes

```
SubProceso estado <- EstadoBateria(nivel, minimo)      PSeInt
def estado_bateria(nivel, minimo):                      Python
fn estado_bateria(nivel: i32, minimo: i32) -> &'static str {   Rust
```

Las tres reciben lo mismo —el nivel de batería y el mínimo de esa persona— y devuelven lo mismo: un texto con el estado. Las diferencias son de forma:

| Detalle | PSeInt | Python | Rust |
|---|---|---|---|
| Palabra que declara | `SubProceso` | `def` | `fn` |
| Tipo de los parámetros | no se escribe | no se escribe | obligatorio (`: i32`) |
| Tipo del resultado | el de la variable de salida | no se escribe | obligatorio (`-> &'static str`) |
| Cómo devuelve el valor | asignando a la variable de salida | `return` | la última expresión, **sin** `return` ni punto y coma |
| Dónde termina | `FinSubProceso` | por la indentación | por la llave `}` |

### El retorno implícito de Rust

En Rust, la última expresión de un bloque es el valor del bloque. Por eso la función se escribe así:

```rust
fn estado_bateria(nivel: i32, minimo: i32) -> &'static str {
    if nivel >= 50 {
        "TRANQUILO"
    } else if nivel >= minimo {
        "CUIDADO"
    } else {
        "PELIGRO"
    }
}
```

`"TRANQUILO"` no lleva punto y coma: **el punto y coma convierte una expresión en instrucción y descarta su valor**. Si se escribiera `"TRANQUILO";` el programa no compilaría, porque la función dejaría de devolver algo. La versión con `return "TRANQUILO";` también es válida en Rust, pero la forma de arriba es la que se usa normalmente.

---

## El código explicado parte por parte

### Versión PSeInt

**1. Declarar antes de usar.** En el perfil Estricto hay que decir de qué tipo es cada cosa, y los arreglos además necesitan `Dimension` con su tamaño:

```
Definir horas Como Caracter;
Dimension horas[3];
Definir baterias Como Entero;
Dimension baterias[30,3];
Definir i, j, tranquilos, cuidados, peligros, finalEnPeligro Como Entero;
```

`Dimension baterias[30,3]` crea la matriz completa: 30 filas y 3 columnas, con las filas numeradas de 0 a 29 y las columnas de 0 a 2. Varias variables del mismo tipo se pueden definir en una sola línea separadas por comas. Cada instrucción termina en **punto y coma**.

**2. Llenar los datos con ciclos anidados.**

```
Para i <- 0 Hasta 29 Con Paso 1 Hacer
    minimos[i] <- 15 + ((i * 7) MOD 31);
    Para j <- 0 Hasta 2 Con Paso 1 Hacer
        baterias[i,j] <- 10 + ((i * 17 + j * 29) MOD 90);
    FinPara
FinPara
```

`<-` es la **asignación**: guarda a la derecha lo que está a la izquierda. `Hasta 29` sí incluye el 29. El elemento de una matriz se escribe con una sola pareja de corchetes y una coma: `baterias[i,j]`.

**3. Escribir en pantalla.**

```
Escribir "Chequeos del dia: ", horas[0], ", ", horas[1], ", ", horas[2];
Escribir Sin Saltar "   ";
```

`Escribir` muestra y salta de línea; las comas pegan los pedazos sin agregar espacios. `Escribir Sin Saltar` deja el cursor en la misma línea, que es como se arma una fila de la tabla por partes.

**4. Alinear a mano.** PSeInt no tiene formato de ancho, así que el número de persona se alinea con un `Si`:

```
Si i + 1 < 10 Entonces
    Escribir Sin Saltar "  ";
SiNo
    Escribir Sin Saltar " ";
FinSi
Escribir Sin Saltar i + 1, "  ", minimos[i], "%";
```

Un espacio extra cuando el número tiene un solo dígito: así el 9 y el 10 quedan en la misma columna. Python y Rust resuelven esto solos con `{:>3}`.

**5. Llamar a la función y contar.**

```
estados[j] <- EstadoBateria(baterias[i,j], minimos[i]);
Si estados[j] = "TRANQUILO" Entonces
    tranquilos <- tranquilos + 1;
SiNo
    ...
FinSi
```

Dentro de un `Si`, el signo `=` **compara**; fuera de él se usa `<-` para asignar. `tranquilos <- tranquilos + 1` es un contador: toma el valor que tenía y le suma uno.

### Versión Python

**1. Crear las estructuras.** No se declara el tipo; la variable nace cuando se le asigna algo:

```python
horas = ["10am", "12pm", "2pm"]
minimos = [0] * 30
baterias = [[0] * 3 for _ in range(30)]
estados = [""] * 3
```

`[0] * 30` repite el 0 treinta veces. Para la matriz hay que crear **una lista por fila**: `[[0] * 3 for _ in range(30)]` hace 30 filas de 3 ceros. El `_` es un nombre que se usa cuando el valor no importa.

**2. Los ciclos.**

```python
for i in range(0, 29 + 1):
    minimos[i] = 15 + ((i * 7) % 31)
    for j in range(0, 2 + 1):
        baterias[i][j] = 10 + ((i * 17 + j * 29) % 90)
```

`range(0, 29 + 1)` produce los números del 0 al 29: **el último no se incluye**, y por eso se escribe `29 + 1`. El elemento de una matriz lleva dos corchetes: `baterias[i][j]`, que se lee "la fila `i`, la columna `j`". Lo que va dentro del ciclo se marca con la **indentación**: no hay `FinPara`, el bloque termina cuando la sangría vuelve atrás.

**3. Imprimir.**

```python
print(f"{i + 1:>3}  {minimos[i]:>2}%", end="")
print("   ", end="")
print("")
```

`print` salta de línea al final, salvo que se le pase `end=""`. El texto con `f` adelante es un *f-string*: lo que va entre llaves se reemplaza por el valor de la expresión. `:>3` alinea a la derecha en 3 caracteres, `:>4` en 4. Eso es lo que mantiene las columnas parejas.

**4. La función y los contadores.**

```python
estados[j] = estado_bateria(baterias[i][j], minimos[i])
if estados[j] == "TRANQUILO":
    tranquilos = tranquilos + 1
elif estados[j] == "CUIDADO":
    cuidados = cuidados + 1
else:
    peligros = peligros + 1
```

En Python `=` **asigna** y `==` **compara**: son dos cosas distintas y confundirlas es el error más común al llegar desde PSeInt. `elif` es "si no, y además esta otra condición".

### Versión Rust

**1. Variables inmutables por defecto.**

```rust
let linea_doble = "=================================================================";
let horas = ["10am", "12pm", "2pm"];
let mut minimos = [0; 30];
let mut baterias = [[0; 3]; 30];
let mut estados = [""; 3];
```

`let` crea una variable que **no se puede cambiar**. Para poder modificarla hay que escribir `let mut` (de *mutable*). `horas` nunca cambia, así que va sin `mut`; `minimos` se llena dentro del ciclo, así que lo lleva. Esto obliga a pensar qué va a cambiar y qué no, y evita modificar por accidente algo que debía quedarse quieto.

`[0; 30]` es un arreglo de 30 ceros y `[[0; 3]; 30]` son 30 filas de 3 ceros: la matriz. El tamaño hace parte del tipo, así que un arreglo en Rust **no puede crecer**, igual que en PSeInt.

**2. Los ciclos y la conversión de tipos.**

```rust
for i in 0..30 {
    minimos[i] = 15 + ((i as i32 * 7) % 31);
    for j in 0..3 {
        baterias[i][j] = 10 + ((i as i32 * 17 + j as i32 * 29) % 90);
    }
}
```

`0..30` es el rango del 0 al 29: como `range` en Python, **el último no se incluye**. `i` sirve como posición (tipo `usize`) y para usarlo en una cuenta con enteros normales hay que convertirlo con `as i32`. El bloque del ciclo va entre llaves `{ }`.

**3. Imprimir.**

```rust
println!("{}", linea_doble);
print!("{:>3}  {:>2}%", i + 1, minimos[i]);
println!("");
```

`println!` imprime y salta de línea; `print!` imprime sin saltar. El signo de admiración indica que son **macros**, no funciones normales: revisan en tiempo de compilación que la cantidad de `{}` coincida con la cantidad de valores. Si sobra o falta uno, el programa no compila. `{}` es el hueco donde entra el valor y `{:>4}` alinea a la derecha en 4 caracteres, exactamente igual que en Python.

**4. La función y los contadores.**

```rust
estados[j] = estado_bateria(baterias[i][j], minimos[i]);
if estados[j] == "TRANQUILO" {
    tranquilos = tranquilos + 1;
} else if estados[j] == "CUIDADO" {
    cuidados = cuidados + 1;
} else {
    peligros = peligros + 1;
}
```

La condición del `if` **no lleva paréntesis** en Rust, pero el bloque **siempre lleva llaves**. `==` compara, incluso entre textos. Los contadores se declararon con `let mut` justamente para poder ir sumándoles.

---

## Tabla de equivalencias

| Qué se quiere hacer | PSeInt | Python | Rust |
|---|---|---|---|
| Inicio del programa | `Proceso Nombre` | (no hace falta) | `fn main() {` |
| Fin del programa | `FinProceso` | (no hace falta) | `}` |
| Declarar una variable | `Definir n Como Entero;` | `n = 0` | `let n = 0;` |
| Variable que va a cambiar | igual | igual | `let mut n = 0;` |
| Asignar | `n <- 5;` | `n = 5` | `n = 5;` |
| Comparar | `n = 5` | `n == 5` | `n == 5` |
| Mostrar y saltar línea | `Escribir "hola";` | `print("hola")` | `println!("hola");` |
| Mostrar sin saltar | `Escribir Sin Saltar "hola";` | `print("hola", end="")` | `print!("hola");` |
| Mostrar un valor dentro del texto | `Escribir "n = ", n;` | `print(f"n = {n}")` | `println!("n = {}", n);` |
| Alinear a la derecha en 4 | (a mano, con espacios) | `f"{n:>4}"` | `{:>4}` |
| Condicional | `Si ... Entonces / SiNo / FinSi` | `if ... : / elif / else:` | `if ... { } else if { } else { }` |
| Ciclo con contador | `Para i <- 0 Hasta 29 Con Paso 1 Hacer ... FinPara` | `for i in range(0, 29 + 1):` | `for i in 0..30 { }` |
| Residuo | `MOD` | `%` | `%` |
| Vector | `Dimension v[30];` | `v = [0] * 30` | `let mut v = [0; 30];` |
| Elemento de un vector | `v[i]` | `v[i]` | `v[i]` |
| Matriz | `Dimension m[30,3];` | `m = [[0] * 3 for _ in range(30)]` | `let mut m = [[0; 3]; 30];` |
| Elemento de una matriz | `m[i,j]` | `m[i][j]` | `m[i][j]` |
| Función | `SubProceso r <- F(a, b)` | `def f(a, b):` | `fn f(a: i32, b: i32) -> i32 {` |
| Fin de bloque | `FinSi`, `FinPara` | la indentación | la llave `}` |

---

## Diferencias que más confunden

**1. Las posiciones empiezan en 0 en los tres.** La primera persona es la 0 y la última es la 29. Por eso, para mostrar "persona 1" hay que escribir `i + 1`. Pedir la posición 30 da error: `Subindice fuera de rango` en PSeInt, `IndexError` en Python y un aviso del compilador o un `panic` en Rust.

**2. El final del ciclo no se incluye igual en todos.** `Hasta 29` de PSeInt **sí** incluye el 29. `range(0, 29 + 1)` de Python y `0..30` de Rust **no** incluyen el último número; por eso hay que sumar uno.

**3. `=` no significa lo mismo.** En PSeInt, dentro de un `Si`, `=` compara y `<-` asigna. En Python y Rust `=` asigna siempre y `==` compara. Escribir `if x = 5` es un error de sintaxis en los dos.

**4. En Rust hay que avisar qué va a cambiar.** Una variable declarada con `let` no se puede modificar: el compilador responde `cannot assign twice to immutable variable`. Hay que declararla `let mut`.

**5. En Rust los tipos tienen que coincidir exactamente.** Sumar un `usize` con un `i32` no compila; hay que convertir con `as`. En Python eso nunca pasa, y en PSeInt tampoco.

**6. El bloque se delimita distinto.** PSeInt usa `FinSi` y `FinPara`, Rust usa llaves, y Python usa **solo la indentación**: una línea mal sangrada cambia el programa o lo rompe.

**7. Python interpreta, Rust compila.** Un error de escritura en la última línea de un programa de Rust impide que el programa arranque siquiera; en Python, el programa corre hasta llegar a esa línea y ahí falla.

---

## Dónde está cada concepto

| Concepto | PSeInt (`ControlBateria.psc`) | Python (notebook) | Rust (`main.rs`) |
|---|---|---|---|
| Función | líneas 1-12 | celda "La función" | líneas 1-9 |
| Declaración de datos | líneas 15-24 | celda "Los datos" | líneas 12-18 |
| Vector | `horas`, `minimos`, `estados` | iguales | iguales |
| Matriz 30 × 3 | `baterias[30,3]`, línea 23 | `baterias`, celda "Los datos" | línea 17 |
| Ciclo anidado que llena los datos | líneas 33-38 | celda "Los datos" | líneas 20-25 |
| Ciclo anidado que revisa y decide | líneas 54-85 | celda "El programa completo" | líneas 41-65 |
| Contadores | líneas 49-52 y dentro del ciclo | celda "El ciclo anidado" | líneas 36-39 |
| Condicional de tres caminos | líneas 3-11 | dentro de la función | líneas 2-8 |

---

## Preguntas para los estudiantes

1. ¿Por qué la persona 1 aparece en `PELIGRO` a las 10am si tiene 10% y su mínimo es 15%? ¿Qué tendría que pasar para que fuera `CUIDADO`?
2. ¿Por qué hay 21 chequeos en `PELIGRO` pero solo 7 personas terminan el día en `PELIGRO`?
3. Si se cambiara el orden de las dos preguntas de la función, ¿qué estado dejaría de aparecer y por qué?
4. ¿Cuántas veces se llama a la función cuando el programa corre completo? ¿Y si hubiera 50 personas?
5. ¿Qué pasaría si el ciclo de afuera llegara `Hasta 30` en lugar de `Hasta 29`?

## Retos

1. Mostrar solo las personas que terminan el día en `PELIGRO`.
2. Calcular y mostrar el promedio de batería de cada persona durante el día.
3. Agregar un cuarto chequeo a las 4pm: la matriz pasa a ser de 30 × 4.
4. Cambiar la función para que devuelva un número (2, 1 o 0) en lugar de un texto, y usar ese número para sumar un puntaje del día.
5. Hacer los tres cambios en los tres lenguajes y comprobar que las salidas siguen siendo idénticas.

---

## Verificación

- **Python**: se ejecutaron todas las celdas del notebook en un kernel de Jupyter, sin errores. La salida del programa completo es la que aparece arriba.
- **Rust**: `cargo build` compila sin advertencias con cargo 1.95 y `cargo run` produce esa misma salida. Se compararon las dos salidas carácter por carácter: son idénticas.
- **PSeInt**: el archivo `.psc` **no se ejecutó**; queda pendiente de prueba en PSeInt con el perfil Estricto.
