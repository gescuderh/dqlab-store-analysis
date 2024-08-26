# DQLab Store Analysis

![Dashboard baseline](images/filtrado-all.JPG)

## Descripción

En este proyecto se utiliza un dataset obtenido en **Kaggle** 👉 https://www.kaggle.com/datasets/dhawyfarrasputra/sales-performance-report-dqlab-store.

Este dataset proporciona datos históricos de ventas desde 2009 hasta 2012. Los datos contienen 3 categorías de productos: suministros de oficina, tecnología y muebles. A su vez, cada categoría tiene varia subcategorías. La empresa realiza promociones en forma de descuento.

**Este proyecto incluye:**
1. La revisión de la consistencia de la base de datos y su limpieza, si se necesita, mediante Jupyter Lab.
2. Un dashboard elaborado en PowerBI donde se realiza un análisis estacional de las ventas netas, se analizan las categorías de producto y productos más rentables y populares, se identifican los clientes más valiosos y su valor estimado de por vida, se analiza el desempeño de los pedidos para evaluar la eficiencia en la gestión de pedidos y la satisfacción del cliente y se analiza el impacto de los descuentos en las ventas.
3. Una hoja de consultas a la base de datos en lenguaje SQL para realizar diferentes comprobaciones de la veracidad de los datos obtenidos en PowerBI. 

## Objetivos

- Evaluar la tendencia de ventas a lo largo de los últimos 3 años.
- Determinar la rentabilidad de las ventas considerando descuento y el volumen de ventas.
- Identificar qué productos y categorías son más rentables y populares.
- Identificar los clientes más valiosos y su comportamiento.
- Determinar el impacto de los descuentos en las ventas.
- Identificar patrones estacionales en las ventas.

## Consideraciones iniciales (IMPORTANTE)

- Para el cálculo de Net sales, Gross sales, Total discounts, Avg discount applied, Orders with discount, Orders without discount, Avg products per order, Avg Ticket, Customer lifespan y Projected CLV 2013 se han tenido únicamente en cuenta aquellos pedidos que han sido completados, es decir, aquellos pedidos cuyo valor de campo order_status es "Order Finished".
- Consideraremos los pedidos cuyo valor de campo order_status es "Order Returned" como aquellos pedidos cuyos productos se han añadido al carrito pero no se ha finalizado la compra. Por lo tanto, estos registros no se tienen en cuenta para el cálculo métricas anteriormente mencionadas. La métrica Return rate, en este caso, se tratará del porcentaje de pedidos que no se han finalizado.
- En el caso de los pedidos cuyo valor de campo order_status es "Order Cancelled", ya que se generan dos registros con el mismo order_id: uno con "Order Finished" y otro con "Order Cancelled"; estos registros no se tienen en cuenta en cuenta para el cálculo de las métricas anteriormente mencionadas.
- La métrica Customer lifespan indica la duración de la relación del cliente seleccionado o del conjunto total de clientes con la empresa.
- La métrica Projected CLV 2013 indica el valor estimado a futuro, para el año 2013, del cliente seleccionado o del conjunto total de clientes, es decir, se trata de una estimación de las ventas que se van a generar en el próximo año basándonos en dos métricas: Finished Avg Ticket y Finished Avg Orders Per Day (el promedio del ticket medio y el promedio de ordenes por día), siempre teniendo como condición las anteriores mencionadas sobre lo que consideramos un pedido como válido.

## Consideraciones futuras

Puesto que esta base de datos consta de una única tabla se propone desarrollar una base de datos más completa con las siguientes tablas:
- Tabla de clientes: esta tabla contendrá información detallada de cada cliente (nombre, apellido, edad, estado civil, salario anual, país, localidad, email)
- Tabla de Productos: esta tabla contendrá información detallada de cada producto (producto, precio, coste de venta)

## Descripción del Dataset

**order_id**: número único identificador de pedido.

**order_status**: estado del pedido (finalizado, devuelto o cancelado)

**customer**: nombre y apellido del cliente.

**order_date**: fecha del pedido.

**order_quantity**: cantidad de productos comprados en un pedido en particular.

**sales**: ventas generadas en un pedido en particular, se utiliza como moneda la Rupia Indonesia.

**discount**: porcentaje de descuento aplicado en el pedido.

**discount_value**: ventas multiplicadas por el descuento, se utiliza como moneda la Rupia Indonesia

**product_category**: categoría del producto adquirido.

**product_sub_category**: subcategoría del producto adquirido.

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

## Vistas del dashboard con filtros aplicados

1. Filtrado por año
![Dashboard filtrado year](images/filtrado-year.JPG)
2. Filtrado por trimestre
![Dashboard filtrado quarter](images/filtrado-quarter.JPG)
3. Filtrado por mes
![Dashboard filtrado month](images/filtrado-month.JPG)

## EDA (Exploratory Data Analysis)

1. Evaluar la tendencia de ventas a lo largo de los últimos 4 años.
2. Determinar la rentabilidad de las ventas considerando descuento y el volumen de ventas.
3. Identificar qué productos y categorías son más rentables y populares.
4. Identificar los clientes más valiosos y su comportamiento.
5. Determinar el impacto de los descuentos en las ventas.
6. Identificar patrones estacionales en las ventas.

