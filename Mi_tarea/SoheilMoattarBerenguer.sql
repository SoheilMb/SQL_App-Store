

-- Para ver un registro utilizamos SELECT
-- Para modificar un registro utilizamos UPDATE

-- El inner join sirve para ver todos los registros counes de dos tablas

-- En caso de no querer todos los registros comunes usaremos left join or right join



-- Definir un data base con el nombre APPStore
-- en la que estaran todas nuestras tablas



DROP DATABASE IF EXISTS APPSTORE;
CREATE DATABASE APPSTORE;
use APPSTORE;







# Drop Already Existing tables with the following names:

#Entitidades
DROP TABLE IF EXISTS empresa; 
DROP TABLE IF EXISTS telefono; 
DROP TABLE IF EXISTS empleado;
DROP TABLE IF EXISTS tienda; #tienda de aplicaciones
DROP TABLE IF EXISTS app;
DROP TABLE IF EXISTS usuario;
DROP TABLE IF EXISTS pais;
DROP TABLE IF EXISTS categoria;

#Relaciones
DROP TABLE IF EXISTS ExpLabo; #Cardinalidad entre empresa y empleado
DROP TABLE IF EXISTS estaDisponible;   #Cardinalidad entre app y tienda
DROP TABLE IF EXISTS haRealizado;  #Cardinalidad entre empleado y app
DROP TABLE IF EXISTS Descarga; # #Cardinalidad entre usuario y app
DROP TABLE IF EXISTS esCategoria; # #Cardinalidad entre app y categoria




#Paso a Tablas

CREATE TABLE pais(
CodPais INT PRIMARY KEY,
NomPais VARCHAR (30),
RentPCapi numeric(10,2) default 0   # 10 digitos de los cuales 2 son decimales
);



CREATE TABLE empresa(
CodEmpresa INT PRIMARY KEY,
Nombre VARCHAR(30) NOT NULL,
AñoCreacion CHAR (4), 
direccion_ofi_cntrl VARCHAR (30), # Ciudad, Calle, Numero
FacturacionAnual numeric(9,2), #Facturacion en Millones de $
PaginaWeb VARCHAR(30) NOT NULL,
Email VARCHAR (30) NOT NULL,
codPais INT,
FOREIGN KEY (codPais) REFERENCES pais(CodPais)
ON DELETE restrict ON UPDATE cascade
);




#Una empresa puede tener varios numeros de telefono, 
#lo que lo convierte en un atributo multivariado
#Los atributos multivariados crean tabla




-- Algo works: +1-844-96-WORKS (96757), +1-877-284-1028 (Toll Free)
-- Orange Soft: +1-424-208-02-09
-- Alphabet: 	(650) 253-0000
-- Meta

CREATE TABLE telefono(
NumTelefono VARCHAR (10),
codempresa INT,
Primary Key (NumTelefono),
#Foreign Key significa que es clave primaria (Primary Key) en otra tabla
Foreign Key (codempresa)
References empresa (CodEmpresa) 
ON DELETE CASCADE
ON UPDATE CASCADE
);


/*
El empleado no puede trabajar en varias empresas al mismo tiempo
empresa y empleado tienen una relacion 1:N
asi que pondremos el codigo de la empresa
en la tabla empleado
( Se coloca la clave primaria del lado 1 en la entidad que esta 
en la parte N)
*/
CREATE TABLE empleado(
CodEmpleado CHAR(6) PRIMARY KEY ,
NIF VARCHAR (30) NOT NULL,
nombreCompleto VARCHAR(30) NOT NULL,
CargoActual VARCHAR (30),
Salario numeric (9,2), # Salario en $
direccion VARCHAR(100),
telefono VARCHAR (20) NOT NULL,
emailEmpleado VARCHAR (50) NOT NULL,
cod_empresa  INT, #Codigo (Primary Key) de la empresa para la que trabaja ahora
FOREIGN KEY (cod_empresa)
REFERENCES empresa(CodEmpresa)
ON DELETE CASCADE
ON UPDATE CASCADE
);
# Si se elimina una empresa, se elimina todo el personal que trabaja 
#en el ahora

/*
Los comandos ON DELETE CASCADE
ON UPDATE CASCADE son para saber que hacer con los foreign key en
caso de aplicar cambios

*/






CREATE TABLE tienda (
NombreTienda VARCHAR (30) PRIMARY KEY,
EmpresaGestora VARCHAR (30) NOT NULL,
Website VARCHAR(30)
);







/*Empresa y App tienen una relacion 1:N
asi que pondremos el codigo de la empresa
en la tabla app
( Se coloca la clave primaria del lado 1 en la entidad que esta 
en la parte N)
*/

/* Ademas el empleado que 
dirige la app y la App tienen una relacion 1:N
asi que pondremos el codigo del empleado que dirige la app
en la tabla app
( Se coloca la clave primaria del lado 1 en la entidad que esta 
en la parte N)
*/


#El nombre de cada app es unico, por eso podemos utilizar este
#atributo como primary key
CREATE TABLE app(
Nombre VARCHAR (50) PRIMARY KEY,
CodigoApp CHAR (4) NOT NULL,
StartDevDate DATE ,
EndDevDate DATE,
Precio numeric(6,2) not null,
EspacioMemoria numeric(6,2) not null,
cod_empresa INT,
cod_empleado_dirigido CHAR(6),

FOREIGN KEY (cod_empresa) REFERENCES empresa(CodEmpresa)
ON DELETE CASCADE ON UPDATE CASCADE,

FOREIGN KEY (cod_empleado_dirigido) 
REFERENCES empleado(CodEmpleado)
ON DELETE RESTRICT ON UPDATE CASCADE
);



/*
En este caso la app es eliminada en caso de eliminacion
de la empresa pero no es eliminada
en el caso que el empleado que dirigio la app sea eliminado

Aun asi los update seran en cascada
*/



CREATE TABLE categoria (
idCategoria INT AUTO_INCREMENT PRIMARY KEY,
nombre_categoria VARCHAR (50) NOT NULL
);




CREATE TABLE usuario (
  CuentaUsuario VARCHAR (10) PRIMARY KEY,
  nombreUsuario varchar(40) not null,
  direccion varchar(40), #Hoy en dia la direccion no es muy importante
  telefono varchar(9), #Podemos tenerlo o no
  email varchar(30) NOT NULL, # Ya que el telefono podemos no tenerlo o no,
  #es vital tener el email del usuario
  sexo char (2) NOT NULL,
  edad SMALLINT NOT NULL,
  Codpais INT,
  FOREIGN KEY (Codpais) REFERENCES pais(CodPais)
  ON DELETE RESTRICT ON UPDATE CASCADE
);






###########################################################




/*
El empleado puede trabajar en la misma empresa en distintos 
periodos de tiempo o trabajar en diferentes empresas, por eso nos interesa incluir las fechas de inicio y finalizacion 
de cada etapa y su puesto en aquel entonces (Vamos mas o menos como se constaria en un CV)

Asi el empleado puede trabajar o dejar de trabajar para una empresa todas las veces 
que quiera
*/




CREATE TABLE ExpLabo(
cod_empresa INT NOT NULL,
cod_empleado CHAR(6) NOT NULL,
Puesto VARCHAR (30),
FechaInicio DATE NOT NULL,
FechaFin DATETIME NOT NULL DEFAULT NOW(),  #Si la fecha fin no ha sido
#introducida asumimos por defecto que aun a dia de hoy sigue trabajndo ahi
PRIMARY KEY (cod_empresa,cod_empleado, FechaInicio,FechaFin),
FOREIGN KEY (cod_empresa) REFERENCES empresa(CodEmpresa)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (cod_empleado) REFERENCES empleado(CodEmpleado)
ON DELETE CASCADE ON UPDATE CASCADE
);
/*
Eliminamos la experiencia laboral en caso de eliminacion
de la empresa o el empleado
*/






/*
Las aplicaciones son subidas a las tiendas o plataformas 
Una misma aplicación puede ser subida a varias tiendas, 
por supuesto una tienda tiene muchas aplicaciones. (N:N)

App esta disponible en tienda, relación N:N se convierte en una tabla, 
cuya clave primaria es la unión de las claves primarias de 
las entidades que participan en la relación (app y tienda),
 además tendrá los atributos de la relación

*/

CREATE TABLE estaDisponible(
nombre_tienda VARCHAR (30),
nombre_app VARCHAR (50),
PRIMARY KEY (nombre_tienda,nombre_app),
FOREIGN KEY (nombre_tienda) REFERENCES tienda(NombreTienda)
ON DELETE CASCADE ON UPDATE CASCADE,

FOREIGN KEY (nombre_app) REFERENCES app(Nombre)
ON DELETE CASCADE ON UPDATE CASCADE
);







/*Cada aplicación está realizada por un grupo de empleados
La relacion entre cada app con cada empleado (N:N) debe quedar 
registrada, asi si en un futuro se quiere subir el sueldo de los
realizadores de cierta app podremos tener acceso a los empleados que
trabajaron sobre ella

Empleado realiza app, relación N:N se convierte en una tabla, 
cuya clave primaria es la unión de las claves primarias de 
las entidades que participan en la relación (empleado y app),
 además tendrá los atributos de la relación
*/

CREATE TABLE harealizado(
codigo_empleado CHAR (6),
nombre_App VARCHAR (50),
PRIMARY KEY (codigo_empleado,nombre_App),
FOREIGN KEY (codigo_empleado) REFERENCES empleado (CodEmpleado)
ON DELETE CASCADE ON UPDATE CASCADE,

FOREIGN KEY (nombre_App) REFERENCES app(Nombre)
ON DELETE CASCADE ON UPDATE CASCADE
);


#Cada app puede ser incluida en una o varias categorias

#relación N:N se convierte en una tabla, 
#cuya clave primaria es la unión de las claves primarias de 
#las entidades que participan en la relación (usuario y app),
#además tendrá los atributos de la relación
 
 
Create Table es_categoria(
nomb_app VARCHAR (50),
id_categ  Int,
PRIMARY KEY (nomb_app,id_categ),
FOREIGN KEY (nomb_app) REFERENCES app(Nombre)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (id_categ) REFERENCES categoria(idCategoria)
ON DELETE CASCADE ON UPDATE CASCADE
);



/*
Usuario descarga app, relación N:N se convierte en una tabla, 
cuya clave primaria es la unión de las claves primarias de 
las entidades que participan en la relación (usuario y app),
 además tendrá los atributos de la relación
*/


CREATE TABLE descarga(
idusuario VARCHAR (10) NOT NULL,
nombre_app VARCHAR (50) NOT NULL,
#Nombre de la tienda de la que el usuario 
#se ha descargado la app
#Puede ser Null en caso de que no haya descarga
nombre_tienda VARCHAR (30),
#Si la jamas ha sido descargada la 
#fecha de descarga sera null
fecha_descarga  date not null ,
# Por defecto asumimos que el usuario se ha descargado la app
num_descargas integer default 1,

constraint check (num_descargas<2),
PRIMARY KEY (idusuario,nombre_app),
FOREIGN KEY (idusuario) REFERENCES usuario(CuentaUsuario)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (nombre_app) REFERENCES app(Nombre)
ON DELETE CASCADE ON UPDATE CASCADE

);


/*
El numero de descargas siempre sera 0 (no descargado) o 1 (descargado)
El usuario solo puede descargarse la app una vez
El trigger check nos ayuda a validar los datos entrantes
*/



 ####################################    ####################################  ####################################

INSERT INTO pais(CodPais,NomPais,RentPCapi) VALUES (1,'USA',74725.10);
INSERT INTO pais(CodPais,NomPais,RentPCapi) VALUES (2,'China',10500.40);
INSERT INTO pais(CodPais,NomPais,RentPCapi) VALUES (3,'Canada',43258.17);
INSERT INTO pais(CodPais,NomPais,RentPCapi) VALUES (4,'Germany',46208.42);
INSERT INTO pais(CodPais,NomPais,RentPCapi) VALUES (5,'Sweden',52274.41);
INSERT INTO pais(CodPais,NomPais,RentPCapi) VALUES (6,'Spain',27063.19);
INSERT INTO pais(CodPais,NomPais,RentPCapi) VALUES (7,'Russia',10126.72);
INSERT INTO pais(CodPais,NomPais,RentPCapi) VALUES (8,'France',39030.36);
INSERT INTO pais(CodPais,NomPais,RentPCapi) VALUES (9,'India',1927.708);
INSERT INTO pais(CodPais,NomPais,RentPCapi) VALUES (10,'Saudi Arabia',20110.31);
INSERT INTO pais(CodPais,NomPais,RentPCapi) VALUES (11,'Brazil',6796.84);
INSERT INTO pais(CodPais,NomPais,RentPCapi) VALUES (12,'Australia',51692.84);
INSERT INTO pais(CodPais,NomPais,RentPCapi) VALUES (13,'Japan',40193.25);


 ####################################    ####################################  ####################################



-- En caso de que tengamos el comando "Load Data Local Infile"
-- desactivado nos dara error 


 #show global variables like 'local_infile'; ==> Nos indica el estado de 'local_infile'
 
 #set global local_infile=true; ==> Nos permite Cargar datos desde cualquier carpeta local
 
 
 
 #!!!! Tengo un mac asi que no podia usar SELECT [GLOBAL | SESSION] VARIABLES [LIKE 'pattern' | WHERE expr]
 #Para que me de el nombre del directorio donde tengo que poner los archivos csv
 
 
 
 
  ####################################    ####################################  ####################################
 
  #Insertar datos del archivo csv a la tabla empresa
 
LOAD DATA LOCAL  INFILE '/Users/soheilmoattarmohammadiberenguer/Documents/Complu_Uni/HomeWork/SQL/Mi_tarea/Empresas.csv'
 INTO TABLE empresa
 CHARACTER SET latin1
 FIELDS TERMINATED BY ','
 LINES TERMINATED BY '\n';
 
 
   ####################################    ####################################  ####################################
 
 #Insertar datos del archivo csv a la tabla tienda
 
 LOAD DATA LOCAL  INFILE '/Users/soheilmoattarmohammadiberenguer/Documents/Complu_Uni/HomeWork/SQL/Mi_tarea/tiendas.csv'
 INTO TABLE tienda
 CHARACTER SET latin1
 FIELDS TERMINATED BY ','
 LINES TERMINATED BY '\n';
 
 
 

 
 ####################################    ####################################  ####################################
 
 
 #Insertar en tabla empleado
 INSERT INTO empleado(CodEmpleado,NIF,nombreCompleto,CargoActual,Salario,
 direccion,telefono,emailEmpleado,cod_empresa) VALUES ('100001', '85732996020' 
 ,"Jane Doe","Senior Software Engineer",520000.00,
 "(California, Mountain View, St. Shoreline Blv. 34)","+185 4155552671",
 "JDoe@hotmail.com",3);
 
  INSERT INTO empleado(CodEmpleado,NIF,nombreCompleto,CargoActual,Salario,
 direccion,telefono,emailEmpleado,cod_empresa) VALUES ('100002', '938568K' 
 ,"Marcel Dettmann","VR Engineer",345500.00,"(Berlin, Friedrichschain Strasse 54)",
 "+49 654030418","MarcelDettmann@yahoo.de",6);
 INSERT INTO empleado(CodEmpleado,NIF,nombreCompleto,CargoActual,Salario,
 direccion,telefono,emailEmpleado,cod_empresa) VALUES ('100003', '57326020B' 
 ,"Pierre Boulez", "Backend Developer",187000.00,"(Paris, Vie de Arc 57)",
 "+33 4155552671","PBou75@yahoo.fr",7);
 
  INSERT INTO empleado(CodEmpleado,NIF,nombreCompleto,CargoActual,Salario,
 direccion,telefono,emailEmpleado,cod_empresa) VALUES ('100004', '287632004020' 
 ,"Jeff Mills","Mobile Developer",180700.00,"(California, PaloAlto, Fifth Road 12)",
 "+185 732996020","JMILLS@gmail.com",2);
 
 INSERT INTO empleado(CodEmpleado,NIF,nombreCompleto,CargoActual,Salario,
 direccion,telefono,emailEmpleado,cod_empresa) VALUES ('100005', '831630054191'
 ,"Niki Istrefi","Mobile Developer",215000.00,"(California, SanFrancisco 128)",
 "+185 654983520","nIstrefi@gmail.com",1);
 
 
 INSERT INTO empleado(CodEmpleado,NIF,nombreCompleto,CargoActual,Salario,
 direccion,telefono,emailEmpleado,cod_empresa) VALUES ('100006', '123831630054191' 
 ,"Wang Zhang Liu","VR Engineer",98000.00,"(Beijing, Ping Li Un 77)"
 ,"+86 727 9863 5566","wzLiu@gmail.com",9);
 
  INSERT INTO empleado(CodEmpleado,NIF,nombreCompleto,CargoActual,Salario,
 direccion,telefono,emailEmpleado,cod_empresa) VALUES ('100007', '789831630054228' ,
 "Chen Yang Li","Principal Engineer",150000.00,"(Pekin, Mao Street, 99)",
 "+86 433 3083 2270","ChenYangLi@yahoo.com",8);
INSERT INTO empleado(CodEmpleado,NIF,nombreCompleto,CargoActual,Salario,
 direccion,telefono,emailEmpleado,cod_empresa) VALUES ('100008', '554831630059090' ,
 "Yang Zhao Hun","Mobile Developer",140000.00,"","+86 128 5352 2266",
 "YangZhao1995@yahoo.com",9);
 INSERT INTO empleado(CodEmpleado,NIF,nombreCompleto,CargoActual,Salario,
 direccion,telefono,emailEmpleado,cod_empresa) VALUES ('100009', 'SW57326020' ,
 "Ida Engberg","Data Developer",183000.00,"(Estokholm, Norrmalm 55)","+45 636555129",
 "Engberg_Ida@gmail.com",10);
 INSERT INTO empleado(CodEmpleado,NIF,nombreCompleto,CargoActual,Salario,
 direccion,telefono,emailEmpleado,cod_empresa) VALUES ('100010', '46571178Z' ,
 "Esteban García",
 "Data Developer",98000.00,"(Madrid, Calle Cuatro Amigos 6)",
 "+34 636555129","e_garcia@yahoo.es",5);
 
 
 
 
  INSERT INTO empleado(CodEmpleado,NIF,nombreCompleto,CargoActual,Salario,
 direccion,telefono,emailEmpleado,cod_empresa) VALUES ('100011', '15789733456509' ,
 "Richie Hawtin","Senior Software Engineer",NULL,"(London, St. John 88)", "+25 392996011",
 "Richard_H@yahoo.com",3);
 
  INSERT INTO empleado(CodEmpleado,NIF,nombreCompleto,CargoActual,Salario,
 direccion,telefono,emailEmpleado,cod_empresa) VALUES ('100012', '47823344M' ,"Cesar Almena",
 "Mobile Developer",63000.00,"(Madrid, Calle San Bernardo 72)", "+34 883665218",
 "C_Almena_91@yahoo.es",5);
 
   INSERT INTO empleado(CodEmpleado,NIF,nombreCompleto,CargoActual,Salario,
 direccion,telefono,emailEmpleado,cod_empresa) VALUES ('100013', '85732996020' 
 ,"Peter Griffin","Backend Developer",187000.00, "","+185 8225552115",
 "petergriff@gmail.com",4);
 
 
 
 
 
 
 
 



 
 ####################################    ####################################  ####################################

 
 
 #Insertar en tabla telefono
 
 
INSERT INTO telefono VALUES ('918697890',1);
INSERT INTO telefono VALUES ('686789098',1);

INSERT INTO telefono VALUES ('918430034',2);
INSERT INTO telefono VALUES ('918693456',2);
INSERT INTO telefono VALUES ('688699890',2);

INSERT INTO telefono VALUES ('550089090',3);

INSERT INTO telefono VALUES ('118430035',4);
INSERT INTO telefono VALUES ('448693459',4);

INSERT INTO telefono VALUES ('198697890',5);

INSERT INTO telefono VALUES ('686009098',6);

INSERT INTO telefono VALUES ('773430030',7);
INSERT INTO telefono VALUES ('775693456',7);

INSERT INTO telefono VALUES ('880699890',8);
INSERT INTO telefono VALUES ('882489090',8);
INSERT INTO telefono VALUES ('257330035',9);

 INSERT INTO telefono VALUES ('330699890',10);
INSERT INTO telefono VALUES ('330489091',10);



 ####################################    ####################################  ####################################




#Insertar en tabla Exp Labo
INSERT INTO ExpLabo(cod_empresa,cod_empleado,Puesto,FechaInicio,FechaFin) 
VALUES (3,'100001',"Data Developer","2010-08-25","2013-03-30");
INSERT INTO ExpLabo(cod_empresa,cod_empleado,Puesto,FechaInicio,FechaFin)  
VALUES (6,'100001',"Software Engineer","2013-04-15","2015-08-21");
 
INSERT INTO ExpLabo(cod_empresa,cod_empleado,Puesto,FechaInicio) 
VALUES (3,'100001',"Data Developer","2016-01-21");

INSERT INTO ExpLabo VALUES (4,'100002', "VR Engineer","2008-02-01","2018-09-21");

INSERT INTO ExpLabo(cod_empresa,cod_empleado,Puesto,FechaInicio) 
VALUES (6,'100002', "VR Engineer","2018-10-12");

INSERT INTO ExpLabo(cod_empresa,cod_empleado,Puesto,FechaInicio) 
VALUES (7,'100003',  "Backend Developer","2018-10-12");

INSERT INTO ExpLabo 
VALUES (1,'100004',   "Mobile Developer","2012-09-01","2019-03-18");


INSERT INTO ExpLabo(cod_empresa,cod_empleado,Puesto,FechaInicio) 
VALUES (2,'100004',  "Mobile Developer","2020-10-12");

INSERT INTO ExpLabo(cod_empresa,cod_empleado,Puesto,FechaInicio) 
VALUES (1,'100005',  "Mobile Developer","2013-08-15");

INSERT INTO ExpLabo 
VALUES (9,'100006',  "Mobile Developer","2017-10-14","2020-05-07");
INSERT INTO ExpLabo 
VALUES (8,'100006',  "Mobile Developer","2020-06-1","2021-06-30");
INSERT INTO ExpLabo(cod_empresa,cod_empleado,Puesto,FechaInicio) 
VALUES (9,'100006',  "Production Engineer","2020-07-01");

INSERT INTO ExpLabo(cod_empresa,cod_empleado,Puesto,FechaInicio) 
VALUES (8,'100007',  "Principal Engineer","2019-03-04");

INSERT INTO ExpLabo(cod_empresa,cod_empleado,Puesto,FechaInicio) 
VALUES (9,'100008',  "Mobile Developer","2017-10-15");

INSERT INTO ExpLabo 
VALUES (3,'100009',  "Data Developer","2013-09-15","2018-03-08");
INSERT INTO ExpLabo(cod_empresa,cod_empleado,Puesto,FechaInicio) 
VALUES (10,'100009',  "Data Developer","2018-04-01");



INSERT INTO ExpLabo 
VALUES (3,'100010',  "Data Developer","2014-07-10","2017-12-01");
INSERT INTO ExpLabo(cod_empresa,cod_empleado,Puesto,FechaInicio) 
VALUES (10,'100010',  "Data Developer","2018-01-01");


INSERT INTO ExpLabo(cod_empresa,cod_empleado,Puesto,FechaInicio) 
VALUES (10,'100011',   "Senior Software Engineer","2008-06-01");

INSERT INTO ExpLabo 
VALUES (9,'100012',   "Mobile Developer","2017-11-01","2018-11-13");
INSERT INTO ExpLabo(cod_empresa,cod_empleado,Puesto,FechaInicio) 
VALUES (5,'100012',   "Mobile Developer","2019-01-01");

INSERT INTO ExpLabo 
VALUES (3,'100013',  "Backend Developer"  ,"2006-12-01","2021-09-01");
INSERT INTO ExpLabo(cod_empresa,cod_empleado,Puesto,FechaInicio) 
VALUES (2,'100013',  "Backend Developer","2021-10-01");




 ####################################    ####################################  ####################################



#Insertar en tabla Apps

LOAD DATA LOCAL  INFILE '/Users/soheilmoattarmohammadiberenguer/Documents/Complu_Uni/HomeWork/SQL/Mi_tarea/Apps.csv'
 INTO TABLE app
 CHARACTER SET latin1
 FIELDS TERMINATED BY ','
 LINES TERMINATED BY '\n';



 ####################################    ####################################  ####################################



#Insertar en tabla Apps

LOAD DATA LOCAL  INFILE '/Users/soheilmoattarmohammadiberenguer/Documents/Complu_Uni/HomeWork/SQL/Mi_tarea/Usuarios.csv'
 INTO TABLE usuario
 CHARACTER SET latin1
 FIELDS TERMINATED BY ','
 LINES TERMINATED BY '\n';

 ####################################    ####################################  ####################################

 #Insertar en tabla categoria

INSERT INTO categoria VALUES (1,'Medical');
INSERT INTO categoria VALUES (2,'Entertainment');
INSERT INTO categoria VALUES (3,'Educational');
INSERT INTO categoria VALUES (4,'Games');
INSERT INTO categoria VALUES (5,'Utilities');
INSERT INTO categoria VALUES (6,'Traveling');
INSERT INTO categoria VALUES (7,'Sports');
INSERT INTO categoria VALUES (8,'News');
INSERT INTO categoria VALUES (9,'Lifestyle');
INSERT INTO categoria VALUES (10,'Video and Image');
INSERT INTO categoria VALUES (11,'Fashion');
INSERT INTO categoria VALUES (12,'Music');
INSERT INTO categoria VALUES (13,'Social Networking');
INSERT INTO categoria VALUES (14,'Business');
INSERT INTO categoria VALUES (15,'Cooking');

####################################    ####################################  ####################################


#Insertar en tabla estaDisponible


LOAD DATA LOCAL  INFILE '/Users/soheilmoattarmohammadiberenguer/Documents/Complu_Uni/HomeWork/SQL/Mi_tarea/EstaDisp.csv'
 INTO TABLE estaDisponible
 CHARACTER SET latin1
 FIELDS TERMINATED BY ','
 LINES TERMINATED BY '\n';




 ####################################    ####################################  ####################################

#Insertar en tabñla es_categoria

INSERT INTO es_categoria VALUES ("Birdees",2);#Entertainment
INSERT INTO es_categoria VALUES ("Birdees",13); # Social Networking

INSERT INTO es_categoria VALUES ("DentistPro",1);#Medical

INSERT INTO es_categoria VALUES ("My Job Angel",5); #Utilitities
INSERT INTO es_categoria VALUES ("My Job Angel",13);#Social Networking
INSERT INTO es_categoria VALUES ("My Job Angel",14);#Business

INSERT INTO es_categoria VALUES ("Merry Kitchen",3); #Educational
INSERT INTO es_categoria VALUES ("Merry Kitchen",9); #Lifestyle
INSERT INTO es_categoria VALUES ("Merry Kitchen",15); #Cooking

INSERT INTO es_categoria VALUES ("Gmail",5); #Utilitities
INSERT INTO es_categoria VALUES ("Gmail",13);#Social Networking

INSERT INTO es_categoria VALUES ("Google Drive",5); #Utilitities

INSERT INTO es_categoria VALUES ("Google Maps",6);#Traveling
INSERT INTO es_categoria VALUES ("Google Maps",5); #Utilitities

--

INSERT INTO es_categoria VALUES ("Facebook",2);#Entertainment
INSERT INTO es_categoria VALUES ("Facebook",4);#Games

INSERT INTO es_categoria VALUES ("Facebook",9);#Lifestyle
INSERT INTO es_categoria VALUES ("Facebook",13);#Social Networking

INSERT INTO es_categoria VALUES ("Instagram",2);#Entertainment
INSERT INTO es_categoria VALUES ("Instagram",9);#Lifestyle
INSERT INTO es_categoria VALUES ("Instagram",10);#Video and Image
INSERT INTO es_categoria VALUES ("Instagram",13);#Social Networking

INSERT INTO es_categoria VALUES ("Whatsapp",5);#Utilities
INSERT INTO es_categoria VALUES ("Whatsapp",13);#Social Networking

INSERT INTO es_categoria VALUES ("Cabify",5);#Utilities
INSERT INTO es_categoria VALUES ("Cabify",6);#Traveling

INSERT INTO es_categoria VALUES ("Flow",5);#Utilities
INSERT INTO es_categoria VALUES ("Flow",14);#Business

#INSERT INTO es_categoria VALUES ("Lequipe Sports",2);#Entertainment
#INSERT INTO es_categoria VALUES ("Lequipe Sports",8);#News


--

INSERT INTO es_categoria VALUES ("TikTok",2);#Entertainment
INSERT INTO es_categoria VALUES ("TikTok",4);#Games
INSERT INTO es_categoria VALUES ("TikTok",9);#Lifestyle
INSERT INTO es_categoria VALUES ("TikTok",10);#Video and Image
INSERT INTO es_categoria VALUES ("TikTok",13);#Social Networking

INSERT INTO es_categoria VALUES ("Helo",13);#Social Networking

INSERT INTO es_categoria VALUES ("QQ",2);#Entertainment
INSERT INTO es_categoria VALUES ("QQ",13);#Social Networking

INSERT INTO es_categoria VALUES ("Tencent Music",2);#Entertainment
INSERT INTO es_categoria VALUES ("Tencent Music",12);#Music

INSERT INTO es_categoria VALUES ("PubG",2);#Entertainment
INSERT INTO es_categoria VALUES ("PubG",4);#Games

INSERT INTO es_categoria VALUES ("Spotify",2);#Entertainment
INSERT INTO es_categoria VALUES ("Spotify",12);#Music



 ####################################    ####################################  ####################################


#Insertar en tabla harealizado
#El empleado que dirige la app tambien es incluído en el grupo
# de empleados que han dirigido la app aunque podríamos no hacerlo.

INSERT INTO  harealizado VALUES ("100001","Flow");
INSERT INTO  harealizado VALUES ("100001","Google Maps");

INSERT INTO  harealizado VALUES ("100002","Facebook");
INSERT INTO harealizado VALUES ("100002","Instagram");
INSERT INTO harealizado VALUES ("100002","Flow");

#INSERT INTO harealizado VALUES ("000003","Lequipe Sports");

INSERT INTO  harealizado VALUES ("100004","Birdees");
INSERT INTO harealizado VALUES ("100004","My Job Angel");

INSERT INTO  harealizado VALUES ("100005","Birdees");
INSERT INTO harealizado VALUES ("100005","My Job Angel");
INSERT INTO  harealizado VALUES ("100005","DentistPro");

INSERT INTO  harealizado VALUES ("100006","QQ");
INSERT INTO  harealizado VALUES ("100006","Tencent Music");
INSERT INTO  harealizado VALUES ("100006","PubG");






INSERT INTO  harealizado VALUES ("100007","TikTok");
INSERT INTO  harealizado VALUES ("100007","DentistPro");
INSERT INTO  harealizado VALUES ("100007","My Job Angel");

INSERT INTO  harealizado VALUES ("100008","QQ");
INSERT INTO  harealizado VALUES ("100008","Tencent Music");
INSERT INTO  harealizado VALUES ("100008","PubG");

INSERT INTO  harealizado VALUES ("100009","Google Maps");
INSERT INTO  harealizado VALUES ("100009","Gmail");
INSERT INTO  harealizado VALUES ("100009","Spotify");

INSERT INTO  harealizado VALUES ("100010","Merry Kitchen");
INSERT INTO  harealizado VALUES ("100010","Cabify");

INSERT INTO  harealizado VALUES ("100011","Facebook");
INSERT INTO  harealizado VALUES ("100011","Instagram");
INSERT INTO  harealizado VALUES ("100011","Whatsapp");

INSERT INTO  harealizado VALUES ("100012","QQ");
INSERT INTO  harealizado VALUES ("100012","Cabify");

INSERT INTO  harealizado VALUES ("100013","Gmail");
INSERT INTO  harealizado VALUES ("100013","Google Drive");
 ####################################    ####################################  ####################################




#insertar en tabla descargas
INSERT INTO descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga) 
VALUES ("50000001","Birdees","Appstore","2020-11-14");
INSERT INTO  descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga) 
VALUES ("50000001","Spotify","Appstore","2020-10-23");

INSERT INTO  descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga)
 VALUES ("50000013","DentistPro","App Store","2021-01-10");
INSERT INTO  descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga)
 VALUES ("50000013","Gmail","App Store","2022-01-03");
INSERT INTO  descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga)
 VALUES ("50000013","Flow","App Store","2021-01-03");
INSERT INTO  descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga)
 VALUES ("50000013","Cabify","App Store","2022-01-06");

INSERT INTO  descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga)
 VALUES ("50000003","TikTok","AppGallery","2020-12-15");
INSERT INTO  descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga)
 VALUES ("50000003","QQ","AppGallery","2022-01-01");

INSERT INTO  descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga)
 VALUES ("50000004","TikTok","MyApp","2020-12-15");
INSERT INTO  descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga)
 VALUES ("50000004","Tencent Music","MyApp","2022-01-01");


INSERT INTO  descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga)
 VALUES ("50000006","Cabify","Google Play","2020-09-21");
INSERT INTO  descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga)
 VALUES ("50000006","Instagram","Google Play","2020-09-21");
INSERT INTO  descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga)
 VALUES ("50000006","Facebook","Google Play","2020-09-30");
INSERT INTO  descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga)
 VALUES ("50000006","Whatsapp","Google Play","2020-10-02");
INSERT INTO  descarga (idusuario,nombre_app,nombre_tienda,fecha_descarga)
VALUES ("50000006","TikTok","Google Play","2020-10-02");

INSERT INTO  descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga)
 VALUES ("50000007","Flow","App World","2021-01-03");
INSERT INTO  descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga)
 VALUES ("50000007","Instagram","Google Drive","2020-09-21");

INSERT INTO  descarga (idusuario,nombre_app,nombre_tienda,fecha_descarga)
VALUES ("50000008","Flow","App World","2021-01-01");

INSERT INTO  descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga)
 VALUES ("50000009","Instagram","App Store","2021-11-11");
INSERT INTO  descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga)
 VALUES ("50000009","Google Maps","App Store","2021-09-21");
 
 
 
INSERT INTO  descarga (idusuario,nombre_app,nombre_tienda,fecha_descarga)
VALUES ("50000009","TikTok","App Store","2021-01-10");
INSERT INTO  descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga)
 VALUES ("50000011","Instagram","Google Play","2021-01-08");
INSERT INTO  descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga)
 VALUES ("50000011","Birdees","Google Play","2021-01-07");
INSERT INTO  descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga)
 VALUES ("50000011","TikTok","Google Play","2021-09-21");
INSERT INTO  descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga)
 VALUES ("50000012","TikTok","App Store","2021-01-21");
INSERT INTO  descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga)
 VALUES ("50000012","Instagram","Google Play","2021-01-10");
INSERT INTO  descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga)
 VALUES ("50000012","Facebook","Google Play","2022-01-08");
INSERT INTO  descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga)
 VALUES ("50000014","Google Maps","App Store","2022-01-21");
INSERT INTO  descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga)
 VALUES ("50000016","Instagram","App Store","2022-01-17");
INSERT INTO  descarga (idusuario,nombre_app,nombre_tienda,fecha_descarga)
VALUES ("50000018","Tencent Music","AppGalley","2021-11-17");
INSERT INTO  descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga)
 VALUES ("50000018","QQ","AppGalley","2022-01-17");
INSERT INTO  descarga(idusuario,nombre_app,nombre_tienda,fecha_descarga)
 VALUES ("50000018","Cabify","Google Play","2020-08-13");






########################################################
#########     Queries, Triggers y Vistas   #############  
########################################################


-- 1- Apps gratis en orden de nombre descendiente
select precio, Nombre
from app
where precio=0
order by Nombre desc;




-- 2- nombre de los empleados por empresa (en la actualidad)

SELECT Nombre, nombreCompleto, CargoActual
from empresa inner join empleado
on empresa.CodEmpresa=empleado.cod_empresa
order by Nombre;






-- 3- Cuantas Apps tiene cada tienda
select NombreTienda, count(nombre_app) as num
from tienda inner join  estaDisponible on 
     tienda.NombreTienda=estaDisponible.nombre_tienda
group by nombreTienda;






-- 4- tienda que tiene todas las apps
select NombreTienda, count(nombre_app) as num
from tienda inner join  estaDisponible on 
     tienda.NombreTienda=estaDisponible.nombre_tienda
group by nombreTienda
having num= (select count(Nombre) from app);

## Vemos que ninguna tienda tiene todas las apps








-- 5-  Que usuario ha descargado el que y 
-- ordene por nombre de usuario
Select NombreUsuario,  nombre_app
from usuario inner join descarga on 
usuario.CuentaUsuario=descarga.idusuario
order by usuario.NombreUsuario desc;









--  6- Que usuario ha descargado el que y 
-- ordene por nombre de usuario y no de edad y pais 
-- del usuario
Select NombreUsuario , edad, nombre_app, NomPais
from usuario inner join descarga on 
usuario.CuentaUsuario=descarga.idusuario
inner join pais on usuario.Codpais=pais.CodPais
order by usuario.NombreUsuario desc;







-- 7- Nombre , Edad  ,sexo y nacionalidad de usuario que han descargado la app Birdee
select NombreUsuario ,edad, sexo,  NomPais as "Nacionalidad"
from usuario inner join descarga on 
usuario.CuentaUsuario=descarga.idusuario
inner join pais on usuario.Codpais=pais.CodPais
where nombre_app= "Birdees"
order by edad;







-- 8-  Numero de descargas por pais
select  NomPais as "Nacionalidad" , 
count(nombre_app) as "Numero Descargas"
from pais inner join usuario on pais.CodPais=usuario.Codpais
inner join descarga on usuario.CuentaUsuario=descarga.idusuario
group by pais.NomPais
order by NomPais ;







-- 9- Crear View con numero de descargas    

DROP VIEW IF EXISTS NumeroDescargas;

create view NumeroDescargas(nombreApp, numDescargas) as
select Nombre, count(nombre_app)
from app inner join descarga on app.Nombre=descarga.nombre_app
group by nombre_app;

select * from NumeroDescargas;






--  10- Las apps con mas descargas
select nombreApp, numDescargas
from NumeroDescargas
where numDescargas = (select max(numDescargas) from NumeroDescargas);










-- 11 - Que empleados han realizado app "google Maps"

select nombreCompleto  as "Nombre Empleado",
salario as "Salario"
from empleado left join  harealizado 
on empleado.CodEmpleado=harealizado.codigo_empleado
where harealizado.nombre_App="Google Maps"
order by nombreCompleto;







-- 12- Nombre de apps que empiezan por f
select Nombre
from app 
where Nombre like 'f%';










-- 13- Nombre de empleados que fueron contratados
-- por Alphabet entre 2000 y 2011
SELECT Nombre , empleado.nombreCompleto, FechaInicio
from empresa inner join ExpLabo on empresa.CodEmpresa=ExpLabo.cod_empresa 
inner join empleado on ExpLabo.cod_empleado=empleado.CodEmpleado
where Nombre="Alphabet" and year(FechaInicio) between 2000 and 2011
order by FechaInicio;







-- 14- After Update Trigger: Aumentar sueldo de empleado 100002
delimiter ;
update empleado set salario = salario + 50000 where CodEmpleado = "100002"; 







-- 15- Cuantas Descargas han tenido las apps realizadas por 
-- cada empleado

select nombreCompleto, nombreApp, numDescargas
from NumeroDescargas inner join  harealizado 
on NumeroDescargas.nombreApp= harealizado.nombre_App
inner join empleado on harealizado.codigo_empleado=empleado.CodEmpleado
order by numDescargas desc;






-- 16 - Mes del año en el que mas descargas hubo

DROP VIEW IF EXISTS Mesdescargas;

CREATE VIEW Mesdescargas(Mes,numeroDescargas) AS SELECT Month(fecha_descarga), count(nombre_app)
 AS totaldescargas FROM 
descarga GROUP BY Month(fecha_descarga) 
ORDER BY COUNT(nombre_app) DESC limit 3;
select * from Mesdescargas;



