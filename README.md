# Nubes De Palabras

![Nube de Palabras](https://raw.githubusercontent.com/kleper/NubesDePalabras/master/NubePalabras.png)

Guía para crear de forma semi-automatizada nubes de palabras basadas en las frecuencias de las mismas encontradas en corpus de textos.

Las nubes de palabras suelen ser útiles para mostrar de manera gráfica la palabras que mas se utilizan en lo que escribimos o escriben otros, es una visualización de datos que puede ayudarnos a entender la forma como está escrita un texto.

En algunas de estas visualizaciones podemos leer, las acciones que mas se repiten, o las cualidades o los lugares en donde se realiza las acciones de las que nos habla un texto.

Pueden leer un poco más sobre este tema en el siguiente enlace: https://es.wikipedia.org/wiki/Nube_de_palabras

## Detalles Tecnicos.

** El sistema operativo utilizado para hacer estas nuves de palabras es Linux, cada uno de los comandos usados vienen de manera nativa en las versiones recientes de Linux, aunque una personas con conocimientos basicos puede hacer correr los diferentes scripts en otros sistemas operativos. **

- Todos los archivos que se mencionan en las instrucciones se pueden encontrar en la carpeta **scripts**

- El código con el que se genera la nube de palabras es una copia de este repo: https://github.com/wvengen/d3-wordcloud lo copie en la carpeta d3-nubepalabras para traducirlo y subir mis ejemplos.

### Extracción y creación de los corpus de palabras.

Para crear los diferentes corpus de palabras he utilizado una serie de herramientas paso a paso:

* Lo primero que se debe hacer es crear un archivo de texto con el contenido de todo lo que queremos analizar, por ejemplo un libro o los comentarios de un blog, o las entradas de un blog, un informe que es puro texto y cosas así, a eso lo llamaremos corpus.
* Después de tener nuestro archivo .txt vamos a hacerle una serie de transformaciones, por ejemplo para mis nubes de palabras decidí eliminar las palabras que son menores a cuatro caracteres, para asegurarme de eliminar artículos, preposiciones, el verbo amor e ir que suelen hacer mucho ruido en los textos (Fue algo arbitrario), uso el siguiente comando para genera un corpus sin las palabras mencionadas `sed -E 's/\b\w{1,4}\b[[:blank:]]*//g' Corpus.txt > CorpusRecortado.txt`
* Una cosa que hago casi que a mano con un editor de texto simple es eliminar caracteres especiales como puntos, comas, punto y comas etc que pueden hacer ruido a la hora de hacer el conteo de palabras.

### Contando las palabras.

* Para contar las palabras encontré en la red un script en python3 que se encarga de la tarea:

```
"""Counts the frequency of each word in the given text; words are defined as
entities separated by whitespaces; punctuations and other symbols are ignored;
case-insensitive; input can be passed through stdin or through a file specified
as an argument; prints highest frequency words first"""

# Case-insensitive
# Ignore punctuations `~!@#$%^&*()_-+={}[]\|:;"'<>,.?/

import sys

# Find if input is being given through stdin or from a file
lines = None
if len(sys.argv) == 1:
    lines = sys.stdin
else:
    lines = open(sys.argv[1])

D = {}
for line in lines:
    for word in line.split():
        word = ''.join(list(filter(
            lambda ch: ch not in "`~!@#$%^&*()_-+={}[]\\|:;\"'<>,.?/",
            word)))
        word = word.lower()
        if word in D:
            D[word] += 1
        else:
            D[word] = 1

for word in sorted(D, key=D.get, reverse=True):
    print(word + ' ' + str(D[word]))
```

* Se utiliza de una forma muy sencilla, copias el script en un archivo que puede llamarse frecuencia.py
* Luego puedes ejecutarlo de la siguiente forma: `python frecuencias.py CorpusRecortado.txt > Frecuencias.csv` 
* De esta forma tendremos un archivo csv separado por espacios, este archivo lo podemos abrir el LibreOffice para ver cuales son las palabras que más se repiten en un texto.
* Para el proceso que queremos hacer es necesario que este archivo lo convirtamos en un archivo separado por comas, para eso podemos abrir el archivo en un editor de texto y remplazar los espacios por comas y listo.

### Creando el diccionario para hacer la nube de palabras.

* Después de tener las palabras con sus respectivas frecuencias separadas por comas es necesario convertir estos datos en un formato que se conoce como JSON (https://es.wikipedia.org/wiki/JSON) y almacenarlo en una variable de JavaScript que es el lenguaje de programación que vamos a usar para crear nuestra nube de palabras en formato web.

- Se debe crear un archivo de plantilla de la siguiente forma:

```
{text: 'word', size: count},

```

- Luego un Script en Bash para crear el Json yo llamo el script: **crearjson.sh**

```
#!/bin/bash
IMPORT="Frecuencias.csv"
TEMPLATE="plantilla"

for i in `cat ${IMPORT}`
do 
  word=`echo $i | awk -F, '{print $1}'`
  count=`echo $i | awk -F, '{print $2}'`
  cat $TEMPLATE | sed -e s/word/$word/g \
                      -e s/count/$count/g 
done

```
- Luego solo es ejecutar el Script de la siguiente forma: `bash crearjson.sh > frecuencias.json`

- El Script anterior tomara nuestro archivo de frecuencias y los convertirá en un arreglo JSON del siguiente tipo:

```
{text: 'clase', size: 164},
{text: 'microtaller', size: 82},
{text: 'están', size: 66},
{text: 'asistentes', size: 61},
{text: 'profesora', size: 60},
{text: 'personas', size: 57},
{text: 'profesor', size: 56},
```

- Lo siguiente que debemos hacer es agregar la definición de la variable para completar el arreglo de datos, debe quedar así:

```
// word frequencies of My Text
var words = [
{text: 'clase', size: 164},
{text: 'microtaller', size: 82},
{text: 'están', size: 66},
{text: 'asistentes', size: 61},
{text: 'profesora', size: 60},
{text: 'personas', size: 57},
{text: 'profesor', size: 56},
];

```

- Después de tener el archivo frecuencias.json con la definición de la variable procedemos de copiar el archivo a la carpeta d3-nubepalabras/example alli podemos copiar cualquiera de los archivos .html y remplazar `<script src="activaciones.json"></script>` por `<script src="frecuencias.json"></script>` y listo luego abrimos con el navegador el archivo html que generamos o modificamos y tenemos nuestra nube de palabras.

#### NOTA

Esta nube de palabras permite si queremos que las palabras tengan un enlace para tener mas información sobre el tema o algo que queramos mostrar, para eso solo tenemos que agregar la variable **href:** en el arreglo de palabras con el enlace al que queremos asociar a una palabra, ejemplo:

```
{text: 'personas', size: 57, href: 'https://es.wikipedia.org/wiki/Persona'},

```
