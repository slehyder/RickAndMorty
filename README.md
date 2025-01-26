# Proyecto de Prueba: Rick and Morty Characters

Este es un proyecto de ejemplo que consume la [API de Rick and Morty](https://rickandmortyapi.com/) para **consultar**, **paginar** y **filtrar** personajes. Se ha desarrollado en **Swift** utilizando **Alamofire** para las peticiones de red y **Kingfisher** para la carga y el cache de imágenes.

## Características

- **Listado de personajes**: muestra información relevante (nombre, estado, especie, etc.).
- **Paginación**: permite cargar progresivamente más personajes al llegar al final del listado.
- **Búsqueda y filtrado**: se puede filtrar por nombre, estado o especie, aprovechando los parámetros de la API.

## Requisitos

- **Xcode 15+**
- **Swift 5+**.
- **iOS 15.6+**
- **Swift Package Manager**

## Arquitectura

- **ViewModel**: Contiene la lógica de negocio y maneja las peticiones a la API.  
- **Models**: Estructuras de datos (`Character`, `Location`, `Info`, etc.) que representan la información obtenida de la API.  
- **Views/Controllers**: Interfaces de usuario que se comunican con los ViewModels y presentan los datos (imagen, nombre, estado, etc.).

## Dependencias Principales

- [**Alamofire**](https://github.com/Alamofire/Alamofire): Para realizar las peticiones de red de forma sencilla y manejar respuestas asíncronas de la API.  
- [**Kingfisher**](https://github.com/onevcat/Kingfisher): Para la carga y cache de imágenes de forma eficiente.
