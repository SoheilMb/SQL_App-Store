#DROP DATABASE IF EXISTS APPSTORE;
#CREATE DATABASE APPSTORE;
use APPSTORE;


 
 show global variables like 'local_infile';
 
 set global local_infile=true;
 
/*
DROP TABLE IF EXISTS tienda; #tienda de aplicaciones

 DROP TABLE IF EXISTS app;
 
  
 DROP TABLE IF EXISTS categoria;
 

DROP TABLE IF EXISTS empleado;

DROP TABLE IF EXISTS empresa; 
DROP TABLE IF EXISTS pais;
*/



DROP TABLE IF EXISTS ExpLabo; #Cardinalidad entre empresa y empleado



CREATE TABLE pais(
CodPais INT PRIMARY KEY,
NomPais VARCHAR (30),
RentPCapi numeric(10,2) default 0   # 10 digitos de los cuales 2 son decimales
);








CREATE TABLE empresa(
CodEmpresa INT PRIMARY KEY auto_increment,
Nombre VARCHAR(30) NOT NULL,
AnoCreacion CHAR (4), 
direccion_ofi_cntrl VARCHAR (30), # Ciudad, Calle, Numero
FacturacionAnual numeric(9,2), #Facturacion en Millones de $
PaginaWeb VARCHAR(30) NOT NULL,
Email VARCHAR (30) NOT NULL,
codPais INT,
FOREIGN KEY (codPais) REFERENCES pais(CodPais)
ON DELETE restrict ON UPDATE cascade
);

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

CREATE TABLE ExpLabo(
cod_empresa INT NOT NULL,
cod_empleado CHAR(6) NOT NULL,
Puesto VARCHAR (30),
FechaInicio DATE NOT NULL,
FechaFin DATETIME DEFAULT NOW(),  #Si la fecha fin no ha sido
#introducida asumimos por defecto que aun a dia de hoy sigue trabajndo ahi
PRIMARY KEY (cod_empresa,cod_empleado, FechaInicio,FechaFin),
FOREIGN KEY (cod_empresa) REFERENCES empresa(CodEmpresa)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (cod_empleado) REFERENCES empleado(CodEmpleado)
ON DELETE CASCADE ON UPDATE CASCADE
);





#El nombre de cada app es unico, por eso podemos utilizar este
#atributo como primary key
CREATE TABLE app(
Nombre VARCHAR (50) PRIMARY KEY ,
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



LOAD DATA LOCAL  INFILE '/Users/soheilmoattarmohammadiberenguer/Documents/Complu_Uni/HomeWork/SQL/Mi_tarea/Apps.csv'
 INTO TABLE app
 CHARACTER SET latin1
 FIELDS TERMINATED BY ','
 LINES TERMINATED BY '\n';
 #IGNORE 1 ROWS;
 






CREATE TABLE tienda (
NombreTienda VARCHAR (30) PRIMARY KEY,
EmpresaGestora VARCHAR (30) NOT NULL,
Website VARCHAR(30)
);

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









LOAD DATA LOCAL  INFILE '/Users/soheilmoattarmohammadiberenguer/Documents/Complu_Uni/HomeWork/SQL/Mi_tarea/tiendas.csv'
 INTO TABLE tienda
 CHARACTER SET latin1
 FIELDS TERMINATED BY ','
 LINES TERMINATED BY '\n';
 #IGNORE 1 ROWS;
 







LOAD DATA LOCAL  INFILE '/Users/soheilmoattarmohammadiberenguer/Documents/Complu_Uni/HomeWork/SQL/Mi_tarea/Empresas.csv'
 INTO TABLE empresa
 CHARACTER SET latin1
 FIELDS TERMINATED BY ','
 LINES TERMINATED BY '\n';
 #IGNORE 1 ROWS;





# Si se 


 
 INSERT INTO empleado(CodEmpleado,NIF,nombreCompleto,CargoActual,Salario,
 direccion,telefono,emailEmpleado,cod_empresa) VALUES ('000001', '85732996020' ,"Jane Doe",
 "Senior Software Engineer",520000.00,"(California, Mountain View, St. Shoreline Blv. 34)","+185 4155552671","JDoe@hotmail.com",3);
 
 
 
  INSERT INTO empleado(CodEmpleado,NIF,nombreCompleto,CargoActual,Salario,
 direccion,telefono,emailEmpleado,cod_empresa) VALUES ('000002', '938568K' ,"Marcel Dettmann",
 "VR Engineer",345500.00,"(Berlin, Friedrichschain Strasse 54)","+49 654030418","MarcelDettmann@yahoo.de",6);
 
 INSERT INTO empleado(CodEmpleado,NIF,nombreCompleto,CargoActual,Salario,
 direccion,telefono,emailEmpleado,cod_empresa) VALUES ('000003', '57326020B' ,"Pierre Boulez",
 "Backend Developer",187000.00,"(Paris, Vie de Arc 57)","+33 4155552671","PBou75@yahoo.fr",7);
 
 
 
  INSERT INTO empleado(CodEmpleado,NIF,nombreCompleto,CargoActual,Salario,
 direccion,telefono,emailEmpleado,cod_empresa) VALUES ('000004', '287632004020' ,"Jeff Mills",
 "Mobile Developer",180700.00,"(California, PaloAlto, Fifth Road 12)","+185 732996020","JMILLS@gmail.com",2);
 
 
 INSERT INTO empleado(CodEmpleado,NIF,nombreCompleto,CargoActual,Salario,
 direccion,telefono,emailEmpleado,cod_empresa) VALUES ('000005', '831630054191' ,"Niki Istrefi",
 "Mobile Developer",215000.00,"(California, SanFrancisco 128)","+185 654983520","nIstrefi@gmail.com",1);
 
 INSERT INTO empleado(CodEmpleado,NIF,nombreCompleto,CargoActual,Salario,
 direccion,telefono,emailEmpleado,cod_empresa) VALUES ('000006', '123831630054191' ,"Wang Zhang Liu",
 "Production Engineer",98000.00,"(Beijing, Ping Li Un 77)","+86 727 9863 5566","wzLiu@gmail.com",9);
 
 
 
 
 
  INSERT INTO empleado(CodEmpleado,NIF,nombreCompleto,CargoActual,Salario,
 direccion,telefono,emailEmpleado,cod_empresa) VALUES ('000007', '789831630054228' ,"Chen Yang Li",
 "Principal Engineer",150000.00,"(Pekin, Mao Street, 99)","+86 433 3083 2270","ChenYangLi@yahoo.com",8);
 
 
 
 
INSERT INTO empleado(CodEmpleado,NIF,nombreCompleto,CargoActual,Salario,
 direccion,telefono,emailEmpleado,cod_empresa) VALUES ('000008', '554831630059090' ,"Yang Zhao Hun",
 "Mobile Developer",140000.00,"","+86 128 5352 2266","YangZhao1995@yahoo.com",9);
 
 
 INSERT INTO empleado(CodEmpleado,NIF,nombreCompleto,CargoActual,Salario,
 direccion,telefono,emailEmpleado,cod_empresa) VALUES ('000009', 'SW57326020' ,"Ida Engberg",
 "Data Developer",183000.00,"(Estokholm, Norrmalm 55)","+45 636555129","Engberg_Ida@gmail.com",10);
 
 INSERT INTO empleado(CodEmpleado,NIF,nombreCompleto,CargoActual,Salario,
 direccion,telefono,emailEmpleado,cod_empresa) VALUES ('000010', '46571178Z' ,"Esteban García",
 "Data Developer",98000.00,"(Madrid, Calle Cuatro Amigos 6)","+34 636555129","e_garcia@yahoo.es",5);
 
 
  INSERT INTO empleado(CodEmpleado,NIF,nombreCompleto,CargoActual,Salario,
 direccion,telefono,emailEmpleado,cod_empresa) VALUES ('000011', '15789733456509' ,"Richie Hawtin",
 "Senior Software Engineer",NULL,"(London, St. John 88)", "+25 392996011","Richard_H@yahoo.com",4);
 
  
  INSERT INTO empleado(CodEmpleado,NIF,nombreCompleto,CargoActual,Salario,
 direccion,telefono,emailEmpleado,cod_empresa) VALUES ('000012', '47823344M' ,"Cesar Almena",
 "Mobile Developer",63000.00,"(Madrid, Calle San Bernardo 72)", "+34 883665218","C_Almena_91@yahoo.es",5);
 
INSERT INTO empleado(CodEmpleado,NIF,nombreCompleto,CargoActual,Salario,
 direccion,telefono,emailEmpleado,cod_empresa) VALUES ('000013', '85732996020' ,"Peter Griffin",
 "Backend Developer",187000.00, "","+185 8225552115","petergriff@gmail.com",2);
 
 
 
 
 
 
 
 

 

 
 
 CREATE TABLE categoria (
idCategoria INT AUTO_INCREMENT PRIMARY KEY,
nombre_categoria VARCHAR (50) NOT NULL
);




INSERT INTO categoria VALUES (1,'Medical');
INSERT INTO categoria VALUES (2,'fun');






 
INSERT INTO ExpLabo(cod_empresa,cod_empleado,Puesto,FechaInicio,FechaFin) 
VALUES (3,'000001',"Data Developer","2010-08-25","2013-03-30");


INSERT INTO ExpLabo(cod_empresa,cod_empleado,Puesto,FechaInicio,FechaFin)  VALUES (6,'000001',"Software Engineer","2013-04-15","2015-08-21");

 
INSERT INTO ExpLabo(cod_empresa,cod_empleado,Puesto,FechaInicio) VALUES (3,'000001',"Data Developer","2010-08-25");


INSERT INTO ExpoLabo VALUES (4,'000002', "VR Engineer","2008-02-01","2018-09-21");

INSERT INTO ExpoLabo(cod_empresa,cod_empleado,Puesto,FechaInicio) VALUES (6,'000002', "VR Engineer","2018-10-12");


INSERT INTO ExpoLabo(cod_empresa,cod_empleado,Puesto,FechaInicio) VALUES (7,'000003',  "Backend Developer","2018-10-12");




INSERT INTO ExpoLabo(cod_empresa,cod_empleado,Puesto,FechaInicio) 
VALUES (1,'000004',   "Mobile Developer","2012-09-01","2019-03-18");


INSERT INTO ExpoLabo(cod_empresa,cod_empleado,Puesto,FechaInicio) VALUES (2,'000004',  "Mobile Developer","2020-10-12");




INSERT INTO ExpoLabo(cod_empresa,cod_empleado,Puesto,FechaInicio) VALUES (1,'000005',  "Mobile Developer","2013-08-15");





INSERT INTO ExpoLabo VALUES (9,'000006',  "Mobile Developer","2017-10-14","2020-05-07");
INSERT INTO ExpoLabo VALUES (8,'000006',  "Mobile Developer","2020-06-1","2021-06-30");
INSERT INTO ExpoLabo(cod_empresa,cod_empleado,Puesto,FechaInicio) VALUES (9,'000006',  "Production Engineer","2020-07-01");

INSERT INTO ExpoLabo(cod_empresa,cod_empleado,Puesto,FechaInicio) VALUES (8,'000007',  "Principal Engineer","2019-03-04");


INSERT INTO ExpoLabo(cod_empresa,cod_empleado,Puesto,FechaInicio) VALUES (9,'000008',  "Mobile Developer","2017-10-15");




INSERT INTO ExpoLabo VALUES (3,'000009',  "Data Developer","2013-09-15","2018-03-08");
INSERT INTO ExpoLabo(cod_empresa,cod_empleado,Puesto,FechaInicio) VALUES (10,'000009',  "Data Developer","2018-04-01");



INSERT INTO ExpoLabo VALUES (3,'000010',  "Data Developer","2014-07-10","2017-12-01");
INSERT INTO ExpoLabo(cod_empresa,cod_empleado,Puesto,FechaInicio) VALUES (10,'000010',  "Data Developer","2018-01-01");


INSERT INTO ExpoLabo(cod_empresa,cod_empleado,Puesto,FechaInicio) VALUES (10,'000011',   "Senior Software Engineer","2008-06-01");


INSERT INTO ExpoLabo VALUES (9,'000012',   "Mobile Developer","2017-11-01","2018-11-13");


INSERT INTO ExpoLabo VALUES (9,'000012',   "Mobile Developer","2017-11-01","2018-11-13");
INSERT INTO ExpoLabo(cod_empresa,cod_empleado,Puesto,FechaInicio) VALUES (5,'000012',   "Mobile Developer","2019-01-01");


INSERT INTO ExpoLabo VALUES (3,'000013',  "Backend Developer"  ,"2006-12-01","2021-09-01");
INSERT INTO ExpoLabo(cod_empresa,cod_empleado,Puesto,FechaInicio) VALUES (2,'000013',  "Backend Developer","2021-10-01");

