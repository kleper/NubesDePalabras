# Nubes De Palabras

Guía para crear de forma semi-automatizada nubes de palabras basadas en las frecuencias de las mismas encontradas en corpus de textos.

Las nubes de palabras suelen ser utiles para mostrar de manera grafica la palabras que mas se utilizan en lo que escribimos o escriben otros, es una visualización de datos que puede ayudarnos a entender la forma como está escrita un texto.

En algunas de estas visualizaciones podemos leer, las acciones que mas se repiten, o las cualidades o los lugares en donde se realiza las acciones de las que nos habla un texto.

Pueden leer un poco más sobre este tema en el siguiente enlace: https://es.wikipedia.org/wiki/Nube_de_palabras

## Detalles Tecnicos.

** El sistema operativo utilizado para hacer estas nuves de palabras es Linux, cada uno de los comandos usados vienen de manera nativa en las versiones recientes de Linux, aunque una personas con conocimientos basicos puede hacer correr los diferentes scripts en otros sistemas operativos. **

### Extracción y creación de los corpus de palabras.

Para crear los diferentes corpus de palabras he utilizado una serie de herramientas paso a paso:

* Lo primero que se debe hacer es crear un archivo de texto con el contenido de todo lo que queremos analizar, por ejemplo un libro o los comentarios de un blog, o las entradas de un blog, un informe que es puro texto y cosas asi, a eso lo llamaremos corpus.
* Despues de tener nuestro archivo .txt vamos a hacerle una serie de transformaciones, por ejemplo para mis nubes de palabras decidi eliminar las palabras que son menores a cuatro caracteres, para asegurarme de eliminar articulos, preposiciones, el verbo amor e ir que suelen hacer mucho ruido en los textos (Fue algo arbitrario), uso el siguiente comando para genera un corpus sin las palabras mencionadas `sed -E 's/\b\w{1,4}\b[[:blank:]]*//g' Corpus.txt > CorpusRecortado.txt`
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
* De esta forma tendremos un archivo csv separado por espacios, este archivo lo podemos abrir el LibreOffice para ver cuales son las palabraas que más se repiten en un texto.
* Para el proceso que queremos hacer es necesario que este archivo lo convirtamos en un archivo separado por comas, para eso podemos abrir el archivo en un editor de texto y remplazar los espacios por comas y listo.

