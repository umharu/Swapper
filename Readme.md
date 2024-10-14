## Para testear el swapper primero debemos:


## Participantes 
Roldan Capponi Maximiliano
Marfeo Marcos 
Toloza Gabriel
Distel Cristian


## Estructura del proyecto:

##El proyecto esta organizado en los siguientes archivos:
Swapper.sol 
Ethereum.sol
Bitcoin.sol 


Utilizar Remix:

Se debe desplegar los tres archivos .sol dentro del IDE 

-El contrato ETH pertenecera al userA

-El contrato BTC pertenecera al userB


IMPORTANTE:
    Debera tener en cuenta que por cada contrato debera ser desplegado con una address diferente. 

    
Luego debemos buscar las direcciones del contrato y del usuario correspondiente para poder
desplegar el contrato Swapper.sol


El contrato Swapper.sol solicita cuatro parametros: el address del token A(eth), el address del userA, 
el address del tokenB(btc) y el address del userB.


Luego de desplegar los contratos correspondientes del usuario A y del usuario B deberan aprobar la direccion del contrato Swapper.sol

Despues llamamos a "depositUserA" para depositar el balance en el contrato, esto depositara ETH 
y quedara en custodia dentro del contrato.

Luego llamamos a "depositUserB" para depositar el balance dentro del contrato, esto depositara BTC
y quedara en custodia del mismo.

Para controlar que de momento, esta todo correcto podemos usar las funciones de vista o mapping para ver los balances mappeados.

Luego de testear los balances de ambos user, debemos llamar a la funcion Swap para intercambiar el token A del user A 
por el token B del user B 

Podemos volver a usar las funciones de vista para chequear como cambiaron los balances.

Reclamar los tokens: llamamos a withdrawUserA, y si pasa las comprobaciones, obtiene los tokens que hay en el balance
del contrato. La misma accion la realizamos con la funcion withdrawUserB.


Si todo salio correctamente, se puede comprobar los balances de los usuarios en los contratos de los tokens usando
balanceOf.


