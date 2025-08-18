# 🛍️ Marketplace de Productos en Sui

Este proyecto implementa un sistema básico de gestión de productos en la blockchain Sui, permitiendo la creación, actualización y eliminación de productos con sus respectivos eventos.

## 🚀 Características

- ✅ Creación de productos con SKU, descripción y precio
- 🔄 Actualización de descripción y precio
- ❌ Eliminación de productos
- 📝 Eventos emitidos para cada acción
- 🧪 Tests unitarios completos

## 📦 Estructura del Módulo

### Structs Principales
- `Product`: Objeto almacenable con:
  - `id`: Identificador único
  - `sku`: Código del producto
  - `description`: Descripción detallada
  - `price`: Precio en formato u64

### Eventos
- `ProductCreated`: Emitido al crear un producto
- `ProductUpdated`: Emitido al actualizar un campo
- `ProductDeleted`: Emitido al eliminar un producto

### Funciones Públicas
- `create_product()`: Crea un nuevo producto
- `update_description()`: Actualiza la descripción
- `update_price()`: Actualiza el precio
- `delete_product()`: Elimina un producto
- Getters para obtener información (`get_sku`, `get_description`, `get_price`)

## 🛠️ Requisitos

- [Sui CLI](https://docs.sui.io/build/install) instalado
- Conocimientos básicos de Move

## 🔧 Instalación y Uso

1. Clona el repositorio
```bash
git clone https://github.com/ruldiaz/suiproductos.git
cd product-crud
```
2. Ejecuta los tests
```bash
sui move test
```
Move Registry

mvr add @pkg/productos