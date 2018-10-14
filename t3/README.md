# Taller de representación

## Propósitos

1. Estudiar la relación entre las [aplicaciones de mallas poligonales](https://github.com/VisualComputing/representation), su modo de [representación](https://en.wikipedia.org/wiki/Polygon_mesh) (i.e., estructuras de datos empleadas para representar la malla en RAM) y su modo de [renderizado](https://processing.org/tutorials/pshape/) (i.e., modo de transferencia de la geometría a la GPU).
2. Estudiar algunos tipos de [curvas y superficies paramétricas](https://github.com/VisualComputing/Curves) y sus propiedades.

## Tareas

Empleando el [FlockOfBoids](https://github.com/VisualComputing/frames/tree/master/examples/demos/FlockOfBoids):

1. Represente la malla del [boid](https://github.com/VisualComputing/frames/blob/master/examples/demos/FlockOfBoids/Boid.pde) al menos de dos formas distintas.
2. Renderice el _flock_ en modo inmediato y retenido, implementando la función ```render()``` del [boid](https://github.com/VisualComputing/frames/blob/master/examples/demos/FlockOfBoids/Boid.pde).
3. Implemente las curvas cúbicas de Hermite y Bezier (cúbica y de grado 7), empleando la posición del `frame` del _boid_ como punto de control.

## Opcionales

1. Represente los _boids_ mediante superficies de spline.
2. Implemente las curvas cúbicas naturales.

## Integrantes

Uno, o máximo dos si van a realizar al menos un opcional.

Complete la tabla:

| Integrante | github nick |
|------------|-------------|
| Santiago Orloff Orloff Rodríguez | Orloffyeah |

## Discusión

Para la representación de los Boids, se escogió usar las estructuras Vertex-Vertex y Face-Vertex, las cuales fueron implementadas como clases aparte para facilitar su uso.

En la representación [Vertex-Vertex](https://en.wikipedia.org/wiki/Polygon_mesh#Vertex-vertex_meshes) se tiene una lista, la cual relaciona cada vertice con los vertices con los que se une por medio de una arista. Para poder renderizar el objeto, es necesario recorrer esta lista e ir formando las líneas correspondientes.

En la representación [Face-Vertex](https://en.wikipedia.org/wiki/Polygon_mesh#Face-vertex_meshes) se tienen dos listas, una que relaciona cada cara con los vertices que la componen, y otra que relaciona cada vertice con las caras que lo rodean. Para poder renderizar el objeto, se recorren estas listas y se van formando las diferentes caras, para finalmente juntarlas.

Para el renderizado en modo inmediato no fue necesario realizar alguna modificación, ya que en este modo es que trabajan Processing. Para el modo retenido, fue necesario crear PShapes que guardan la información de los objetos, para que después estos sean renderizados. Esto resultó en un rendimiento inferior al momento de representar la escena, ya que los Boids se mueven constantemente, haciendo que almacenar la información de forma retenida necesite de mas cálculos por fotograma.

En cuanto a la implementación de las diferentes curvas, se utilizaron los métodos encontrados para [Hermite](https://en.wikipedia.org/wiki/Cubic_Hermite_spline#Representations) y [Bezier](https://en.wikipedia.org/wiki/B%C3%A9zier_curve#General_definition).
Estas se realizaron en diferentes clases para facilitar su instanciación y modificación. Para poder lograr trazados suaves, fue necesario dibujar varias lineas que conforman pequeñas fracciones de cada trazo entre los puntos de control.

## Entrega

* Subir el código al repositorio de la materia antes del 14/10/18 a las 24h.
* Presentar el trabajo en la clase del 17/10/18 o 18/10/18.