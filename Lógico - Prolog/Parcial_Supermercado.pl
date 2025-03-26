%primeraMarca(Marca)
primeraMarca(laSerenisima).
primeraMarca(gallo).
primeraMarca(vienisima).

%precioUnitario(Producto,Precio)
%donde Producto puede ser arroz(Marca), lacteo(Marca,TipoDeLacteo), salchicas(Marca,Cantidad)
precioUnitario(arroz(gallo),25.10).
precioUnitario(lacteo(laSerenisima,leche), 6.00).
precioUnitario(lacteo(laSerenisima,crema), 4.00).
precioUnitario(lacteo(gandara,queso(gouda)), 13.00).
precioUnitario(lacteo(vacalin,queso(mozzarella)), 12.50).
precioUnitario(salchichas(vienisima,12), 9.80).
precioUnitario(salchichas(vienisima, 6), 5.80).
precioUnitario(salchichas(granjaDelSol, 8), 5.10).

%descuento(Producto, Descuento)
descuento(lacteo(laSerenisima,leche), 0.20).
descuento(lacteo(laSerenisima,crema), 0.70).
descuento(lacteo(gandara,queso(gouda)), 0.70).
descuento(lacteo(vacalin,queso(mozzarella)), 0.05).

%compro(Cliente,Producto,Cantidad)
compro(juan,lacteo(laSerenisima,crema),2).

% 1)
descuentoAplicado(arroz(_), NuevoPrecio):-
    aplicarDescuento(arroz(_), NuevoPrecio, 1.50).
descuentoAplicado(salchichas(Salchichas, _), NuevoPrecio):-
    not(esVienisima(Salchichas)),
    aplicarDescuento(salchichas(Salchichas), NuevoPrecio, 0.5).
descuentoAplicado(lacteo(_, leche), NuevoPrecio):-
    aplicarDescuento(lacteo(_, leche), NuevoPrecio, 2).
descuentoAplicado(lacteo(Marca, queso(_)), NuevoPrecio):-
    primeraMarca(Marca),
    aplicarDescuento(lacteo(Marca, queso(_)), NuevoPrecio, 2).
descuentoAplicado(Producto, NuevoPrecio):-
    productoMasCaro(Producto),
    aplicarDescuento(Producto, NuevoPrecio, 5).

esVienisima(vienisima).

aplicarDescuento(Producto, NuevoPrecio, Descuento):-
    precioUnitario(Producto, Precio),
    NuevoPrecio is Precio - Descuento.

productoMasCaro(Producto):-
    precioUnitario(Producto, Precio),
    forall((precioUnitario(OtroProducto, OtroPrecio), Producto \= OtroPrecio),
            Precio >= OtroPrecio).

% 2)
clienteCompulsivo(Cliente):-
    compro(Cliente, _, _),
    forall(compro(Cliente, Producto, _), esDePrimeraMarca(Producto)).

esDePrimeraMarca(lacteo(Marca), _):-
    primeraMarca(Marca).
esDePrimeraMarca(salchichas(Marca, _)):-
    primeraMarca(Marca).

% 3)
totalAPagar(Cliente, TotalCompra):-
    compro(Cliente, _, _),
    findall(Compra, (compro(Cliente, Producto, Cantidad), 
    valorProducto(Producto, Cantidad, Compra)), Compras),
    sumlist(Compras, TotalCompra).

valorProducto(Producto, Cantidad, Precio):-
    precioUnitario(Producto, PrecioUnitario),
    Precio is PrecioUnitario * Cantidad.

% 4)
clienteFiel(Cliente, Marca):-
    compro(Cliente, _, _),
    forall(compro(Cliente, Producto, _), (esDeMismaMarca(Producto, Marca), 
    otraMarcaVendeProducto(Producto, Marca))).

esDeMismaMarca(Producto, Marca):-
    marcaProducto(Producto, Marca).

otraMarcaVendeProducto(Producto, Marca):-
    marcaProducto(Producto, Marca),
    marcaProducto(Producto, OtraMarca),
    Marca \= OtraMarca.

marcaProducto(arroz(Marca), Marca).
marcaProducto(lacteo(Marca, _), Marca).
marcaProducto(salchicas(Marca, _), Marca).

% 5) Se agrega el predicado dueño que relaciona dos marcas siendo que la primera es dueña de la otra.
duenio(laSerenisima, gandara).
duenio(gandara, vacalín).

aCargo(Empresa, OtraEmpresa):-
    duenio(Empresa, OtraEmpresa).
aCargo(Empresa, OtraEmpresa):-
    duenio(Empresa, AlgunaEmpresa),
    aCargo(AlgunaEmpresa, OtraEmpresa).

provee(Empresa, Productos):-
    aCargo(Empresa, OtraEmpresa),
    findall(ProductoEmpresa, marcaProducto(ProductoEmpresa, Empresa), ProductosEmpresa),
    findall(ProductoOtraEmpresa, marcaProducto(ProductoOtraEmpresa, OtraEmpresa), ProductosOtraEmpresa),
    append(ProductosEmpresa, ProductosOtraEmpresa, Productos).
    