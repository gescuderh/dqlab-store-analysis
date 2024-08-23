# DQLab Store Analysis

[!Dashboard baseline](images/filtrado-all.JPG)

## Descripción

Este proyecto incluye:
- La revisión de la consistencia de la base de datos y su limpieza, si se necesita, mediante Jupyter Lab.
- Un dashboard elaborado en PowerBI donde se realiza un análisis estacional de las ventas netas, se analizan las categorías de producto y productos más rentables y populares, se identifican los clientes más valiosos y su valor estimado de por vida, se analiza el desempeño de los pedidos para evaluar la eficiencia en la gestión de pedidos y la satisfacción del cliente y se analiza el impacto de los descuentos en las ventas.
- Una hoja de consultas a la base de datos en lenguaje SQL para realizar diferentes comprobaciones de la veracidad de los datos obtenidos en PowerBI. 

## Objetivos

- Evaluar la tendencia de ventas a lo largo de los últimos 3 años.
- Determinar la rentabilidad de las ventas considerando descuento y el volumen de ventas.
- Identificar qué productos y categorías son más rentables y populares.
- Identificar los clientes más valiosos y su comportamiento.
- Determinar el impacto de los descuentos en las ventas.
- Identificar patrones estacionales en las ventas.

## Consideraciones futuras

Puesto que esta base de datos consta de una única tabla se propone desarrollar una base de datos más completa con las siguientes tablas:
- Tabla de clientes: esta tabla contendrá información detallada de cada cliente (nombre, apellido, edad, estado civil, salario anual, país, localidad, email)
- Tabla de Productos: esta tabla contendrá información detallada de cada producto (producto, precio, coste de venta)

## Descripción del Dataset

order_id: número único identificador del pedido.

order_status: estado del pedido.

customer: nombre y apellido del cliente.

order_date: fecha del pedido.

order_quantity: cantidad de productos comprados.

sales: precio de venta final después de descuentos.

discount: porcentaje de descuento aplicado en el pedido.

discount_value: valor monetario del descuento aplicado.

product_category: categoría del producto adquirido.

product_sub_category: sub categoría del producto adquirido.

## Cómo Ejecutar el Proyecto
1. Clona el repositorio:
   ```bash
   git clone https://github.com/gescuderh/dqlab-store-analysis.git

2. Navega al directorio del proyecto:
   ```bash
   cd dqlab-store-analysis

4. Instala las dependencias:

   Crea un archivo `requirements.txt` para listar las dependencias del proyecto:

   ```text
   jupyter
   numpy
   pandas 
   os
   seaborn
   matplotlib.pyplot
   missingno
   warnings
   ````
   
   ```bash
   pip install -r requirements.txt
   ```

6. Ejecuta el notebook:
   ```bash
   jupyter notebook notebooks/dqlab-store-analysis.ipynb
   ```
