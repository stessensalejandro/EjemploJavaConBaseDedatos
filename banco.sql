# Creación de base de datos
CREATE DATABASE banco;

use banco;

#Creacion de las tablas

CREATE TABLE Ciudad
(
	cod_postal INT(4) UNSIGNED NOT NULL,
	nombre VARCHAR(40) NOT NULL,
	CONSTRAINT pk_Ciudad
	PRIMARY KEY(cod_postal)

)ENGINE=InnoDB;

CREATE TABLE Sucursal
(
	nro_suc	 INT(3) UNSIGNED AUTO_INCREMENT NOT NULL,
	nombre VARCHAR(40) NOT NULL,	
	direccion VARCHAR(40) NOT NULL,
	telefono VARCHAR(40) NOT NULL,
	horario VARCHAR(40) NOT NULL,
	cod_postal INT(4) UNSIGNED NOT NULL,
	CONSTRAINT pk_Sucursal
	PRIMARY KEY(nro_suc),
	CONSTRAINT fk_Sucursal
	FOREIGN KEY (cod_postal) REFERENCES Ciudad(cod_postal)
	
)ENGINE=InnoDB;

CREATE TABLE Empleado
(
	legajo			INT(4) UNSIGNED AUTO_INCREMENT	NOT NULL,
	apellido		VARCHAR(40)		NOT NULL,
	nombre 		    VARCHAR(40)		NOT NULL,
    tipo_doc      VARCHAR (20) NOT NULL,	
	nro_doc		INT(8) UNSIGNED	NOT NULL,
	
	direccion		VARCHAR(40)		NOT NULL,
	telefono		VARCHAR(40) NOT NULL,
	
	cargo           VARCHAR(40) NOT NULL,
	password    VARCHAR(32) NOT NULL,
	nro_suc	INT(3) UNSIGNED	NOT NULL,
	CONSTRAINT pk_Empleado
	PRIMARY KEY(legajo),
	CONSTRAINT fk_Empleado
	FOREIGN KEY (nro_suc) REFERENCES Sucursal(nro_suc) 

)ENGINE=InnoDB;

CREATE TABLE Cliente
(
	nro_cliente			INT(5) UNSIGNED	AUTO_INCREMENT NOT NULL,
	apellido		VARCHAR(40)		NOT NULL,
	nombre 		VARCHAR(40)		NOT NULL,	
	tipo_doc      VARCHAR (20) NOT NULL,
	nro_doc		INT(8) UNSIGNED	NOT NULL,
	direccion		VARCHAR(40)		NOT NULL,
	telefono		VARCHAR(40) NOT NULL,
	fecha_nac DATE NOT NULL,
	CONSTRAINT pk_Cliente
	PRIMARY KEY(nro_cliente)
)ENGINE=InnoDB;

CREATE TABLE Plazo_Fijo
(
	nro_plazo INT(8) UNSIGNED AUTO_INCREMENT NOT NULL,
	fecha_inicio DATE NOT NULL, 
	fecha_fin DATE NOT NULL,
	capital		Decimal(16,2) UNSIGNED	NOT NULL,
	tasa_interes DECIMAL(4,2) UNSIGNED NOT NULL,
	Interes DECIMAL(16,2) UNSIGNED  NOT NULL,
	nro_suc	 INT(3) UNSIGNED NOT NULL,
	CONSTRAINT pk_Plazo_Fijo
	PRIMARY KEY(nro_plazo),
	CONSTRAINT fk_Plazo_Fijo
	FOREIGN KEY (nro_suc) REFERENCES Sucursal(nro_suc) 

)ENGINE=InnoDB;

CREATE TABLE Tasa_Plazo_Fijo
(
	periodo		INT(3) UNSIGNED	NOT NULL,
	monto_inf DECIMAL(16,2) UNSIGNED NOT NULL,
	monto_sup DECIMAL(16,2) UNSIGNED NOT NULL,
	tasa DECIMAL(4,2) UNSIGNED NOT NULL,
	CONSTRAINT pk_Tasa_Plazo_Fijo
	PRIMARY KEY(periodo, monto_sup, monto_inf)

)ENGINE=InnoDB;

CREATE TABLE Plazo_Cliente
(
	nro_plazo INT(8) UNSIGNED NOT NULL,
	nro_cliente INT(5) UNSIGNED	NOT NULL,
	CONSTRAINT pk_Plazo_Cliente
	PRIMARY KEY(nro_plazo,nro_cliente), 
	CONSTRAINT fk_Plazo_ClienteNroPlazo
	FOREIGN KEY (nro_plazo) REFERENCES Plazo_Fijo(nro_plazo), 
	CONSTRAINT fk_Plazo_ClienteNroCliente
	FOREIGN KEY (nro_cliente) REFERENCES cliente(nro_cliente) 
	
	
)ENGINE=InnoDB;

CREATE TABLE Prestamo
(
	nro_prestamo INT(8) UNSIGNED AUTO_INCREMENT	NOT NULL,
	fecha DATE	NOT NULL,
	cant_meses INT(2) UNSIGNED NOT NULL,
	monto      DECIMAL(10,2) UNSIGNED NOT NULL, 
	tasa_interes DECIMAL(4,2) UNSIGNED NOT NULL,
	interes      DECIMAL(9,2) UNSIGNED NOT NULL,
	valor_cuota  DECIMAL(9,2) UNSIGNED NOT NULL,
	legajo			INT(4) UNSIGNED	NOT NULL,
	nro_cliente INT(5) UNSIGNED	NOT NULL,
	
	CONSTRAINT pk_Plazo_Cliente
	PRIMARY KEY(nro_prestamo),
	CONSTRAINT FK_PrestamoEmpleado
	FOREIGN KEY (legajo) REFERENCES Empleado(legajo),
	CONSTRAINT FK_Prestamo_Cliente
	FOREIGN KEY (nro_cliente) REFERENCES Cliente(nro_cliente)
	
)ENGINE=InnoDB;

CREATE TABLE Pago
(
	nro_prestamo INT(8) UNSIGNED	NOT NULL,
	nro_pago		INT(2) UNSIGNED	NOT NULL,
	fecha_venc DATE NOT NULL,
	fecha_pago     DATE,
	CONSTRAINT pk_Pago
	PRIMARY KEY(nro_prestamo,nro_pago),
	CONSTRAINT FK_Pago
	FOREIGN KEY (nro_prestamo) REFERENCES Prestamo(nro_prestamo)

)ENGINE=InnoDB;

CREATE TABLE Tasa_Prestamo
(
	periodo		INT(3) UNSIGNED	NOT NULL,
	monto_inf DECIMAL(10,2) UNSIGNED NOT NULL,
    monto_sup DECIMAL(10,2) UNSIGNED NOT NULL,
	tasa DECIMAL(4,2) UNSIGNED NOT NULL,
	CONSTRAINT pk_Tasa_Prestamo
	PRIMARY KEY(periodo, monto_sup, monto_inf)

)ENGINE=InnoDB;

CREATE TABLE Caja_Ahorro
(
	nro_ca INT(8) UNSIGNED AUTO_INCREMENT NOT NULL,
	CBU BIGINT UNSIGNED NOT NULL,
	saldo DECIMAL(16,2) UNSIGNED NOT NULL,
	CONSTRAINT pk_Caja_Ahorro	
	PRIMARY KEY(nro_ca)
)ENGINE=InnoDB;

CREATE TABLE Cliente_CA
(
	nro_cliente	INT(5) UNSIGNED	NOT NULL,
	nro_ca INT(8) UNSIGNED NOT NULL,
	CONSTRAINT pk_Cliente_CA
	PRIMARY KEY(nro_cliente,nro_ca),
	CONSTRAINT fk_Cliente_CA_Cliente
	FOREIGN KEY (nro_cliente) REFERENCES Cliente(nro_cliente),
	CONSTRAINT fk_Cliente_CA_CA
	FOREIGN KEY (nro_ca) REFERENCES Caja_Ahorro(nro_ca)

)ENGINE=InnoDB;

CREATE TABLE Tarjeta
(
	nro_tarjeta BIGINT UNSIGNED AUTO_INCREMENT	NOT NULL,
	PIN	    VARCHAR(32)		NOT NULL,	
	CVT		VARCHAR(32)		NOT NULL,
	fecha_venc DATE NOT NULL,
	nro_cliente	INT(5) UNSIGNED	NOT NULL,
	nro_ca INT(8) UNSIGNED NOT NULL,
	CONSTRAINT pk_Tarjeta
	PRIMARY KEY(nro_tarjeta),
	CONSTRAINT fk_TarjetaCliente
	FOREIGN KEY(nro_cliente,nro_ca) REFERENCES Cliente_CA(nro_cliente,nro_ca)
	
)ENGINE=InnoDB;

CREATE TABLE Caja
(
	cod_caja		INT(5) UNSIGNED AUTO_INCREMENT	NOT NULL,
	CONSTRAINT pk_Caja
	PRIMARY KEY(cod_caja)

)ENGINE=InnoDB;

CREATE TABLE Ventanilla
(
	cod_caja		INT(5) UNSIGNED	NOT NULL,
	nro_suc	 INT(3) UNSIGNED NOT NULL,
	CONSTRAINT pk_Ventanilla
	PRIMARY KEY(cod_caja),
	CONSTRAINT fk_VentanillaSuc
	FOREIGN KEY(nro_suc) REFERENCES Sucursal(nro_suc),
    CONSTRAINT fk_VentanillaCaj
	FOREIGN KEY(cod_caja) REFERENCES Caja(cod_caja)

	
)ENGINE=InnoDB;

CREATE TABLE ATM
(
	cod_caja		INT(5) UNSIGNED	NOT NULL,
	cod_postal INT(4) UNSIGNED NOT NULL,
	direccion VARCHAR(40) NOT NULL,
	CONSTRAINT pk_ATM
	PRIMARY KEY(cod_caja),
	CONSTRAINT fk_ATMCiudad
	FOREIGN KEY(cod_postal) REFERENCES Ciudad(cod_postal),
	   CONSTRAINT fk_ATMcaja
	FOREIGN KEY(cod_caja) REFERENCES Caja(cod_caja)

)ENGINE=InnoDB;

CREATE TABLE Transaccion
(
	nro_trans		INT(10) UNSIGNED AUTO_INCREMENT	NOT NULL,
	fecha DATE NOT NULL,
	hora TIME NOT NULL,
	monto DECIMAL(16,2) UNSIGNED NOT NULL,
	CONSTRAINT pk_Transaccion
	PRIMARY KEY(nro_trans)

)ENGINE=InnoDB;

CREATE TABLE Debito
(
    nro_trans INT(10) UNSIGNED	NOT NULL,
	descripcion TINYTEXT,
	nro_cliente	INT(5) UNSIGNED	NOT NULL,
	nro_ca INT(8) UNSIGNED NOT NULL,
	CONSTRAINT pk_Debito
	PRIMARY KEY(nro_trans),
	CONSTRAINT fk_Debito_clienteCajaAhorro
	FOREIGN KEY(nro_cliente,nro_ca) REFERENCES Cliente_CA(nro_cliente,nro_ca),
    CONSTRAINT fk_Debito_Transaccion
	FOREIGN KEY(nro_trans) REFERENCES transaccion(nro_trans)
)ENGINE=InnoDB;

CREATE TABLE Transaccion_por_caja
(
	nro_trans INT(10) UNSIGNED	NOT NULL,
	cod_caja  INT(5) UNSIGNED	NOT NULL,
	CONSTRAINT pk_Transaccion_por_caja
	PRIMARY KEY(nro_trans),
	CONSTRAINT fk_Transaccion_por_cajaACaja
	FOREIGN KEY(cod_caja) REFERENCES Caja(cod_caja),
	CONSTRAINT fk_Transaccion_por_cajaTransaccion
	FOREIGN KEY(nro_trans) REFERENCES Transaccion(nro_trans)

)ENGINE=InnoDB;

CREATE TABLE Deposito
(
nro_trans INT(10) UNSIGNED	NOT NULL,
nro_ca INT(8) UNSIGNED NOT NULL,
CONSTRAINT pk_Deposito
PRIMARY KEY(nro_trans),
CONSTRAINT fk_DepositoTransaccionPorCaja
FOREIGN KEY(nro_trans) REFERENCES Transaccion_por_caja(nro_trans),
CONSTRAINT fk_DepositoCajaAhorro
FOREIGN KEY(nro_ca) REFERENCES Caja_Ahorro(nro_ca)

)ENGINE=InnoDB;

CREATE TABLE Extraccion
(
nro_trans INT(10) UNSIGNED	NOT NULL,
nro_cliente	INT(5) UNSIGNED	NOT NULL,
nro_ca INT(8) UNSIGNED NOT NULL,
CONSTRAINT pk_Extraccion
PRIMARY KEY(nro_trans),
CONSTRAINT fk_ExtraccionTransaccionPorCaja
FOREIGN KEY(nro_trans) REFERENCES Transaccion_por_caja(nro_trans),
CONSTRAINT fk_ExtraccionClienteCA
FOREIGN KEY(nro_cliente,nro_ca) REFERENCES Cliente_CA(nro_cliente,nro_ca)

)ENGINE=InnoDB;

CREATE TABLE Transferencia
(
nro_trans INT(10) UNSIGNED	NOT NULL,
nro_cliente	INT(5) UNSIGNED	NOT NULL,
origen INT(8) UNSIGNED NOT NULL,
destino INT(8) UNSIGNED NOT NULL,
CONSTRAINT pk_Transferencia
PRIMARY KEY(nro_trans),
CONSTRAINT fk_TransferenciaTransaccionPorCaja
FOREIGN KEY(nro_trans) REFERENCES Transaccion_por_caja(nro_trans),
CONSTRAINT fk_TransferenciaOrigen
FOREIGN KEY(nro_cliente,origen) REFERENCES Cliente_CA(nro_cliente,nro_ca),
CONSTRAINT fk_TransferenciaDestino
FOREIGN KEY(destino) REFERENCES Caja_ahorro(nro_ca)

)ENGINE=InnoDB;









#Creacion de la vista

#Vistas auxiliares

CREATE VIEW datos_Deposito 
AS
 SELECT d.nro_ca,saldo,d.nro_trans,fecha,hora,"deposito" as Tipo,monto,"-------" as Destino,cod_caja,'------' as nro_cliente,'----' as tipo_doc,'----' as nro_doc,'-----' as nombre,'---' as apellido 
 from Deposito d join caja_ahorro ca on d.nro_ca=ca.nro_ca join transaccion t on d.nro_trans=t.nro_trans 
 join transaccion_por_caja tpc on d.nro_trans=tpc.nro_trans
 join cliente_CA cc on cc.nro_ca=d.nro_ca join cliente c on c.nro_cliente=cc.nro_cliente;

 
 CREATE VIEW datos_Debito
AS
 SELECT d.nro_ca,saldo,t.nro_trans,t.fecha,t.hora,"Debito" as Tipo,monto,"-------" as Destino,"-------" as "codigo de caja",c.nro_cliente,c.tipo_doc,c.nro_doc,c.nombre,c.apellido
 from Debito d join caja_ahorro ca on d.nro_ca=ca.nro_ca 
 join transaccion t on t.nro_trans=d.nro_trans
 join cliente c on c.nro_cliente=d.nro_cliente;
 
 CREATE VIEW datos_Extraccion
AS
 SELECT e.nro_ca,saldo,e.nro_trans,t.fecha,t.hora,"Extraccion" as Tipo,monto,"-------" as Destino,tpc.cod_caja,cli.nro_cliente,cli.tipo_doc,cli.nro_doc,cli.nombre,cli.apellido 
 from Extraccion e join caja_ahorro ca on e.nro_ca=ca.nro_ca
 join transaccion t on t.nro_trans=e.nro_trans
 join transaccion_por_caja tpc on tpc.nro_trans=e.nro_trans
 join cliente cli on cli.nro_cliente=e.nro_cliente;
 
  CREATE VIEW datos_Transferencia
AS
 SELECT nro_ca,saldo,t.nro_trans,fecha,hora,"Transferencia" as Tipo,monto,destino,cod_caja,c.nro_cliente,c.tipo_doc,c.nro_doc,c.nombre,c.apellido
 from Transferencia t
 join caja_ahorro on (t.origen=caja_ahorro.nro_ca)
 join transaccion tr on tr.nro_trans=t.nro_trans 
 join transaccion_por_caja tpc on tpc.nro_trans=tr.nro_trans 
 join cliente c on t.nro_cliente=c.nro_cliente;
 
#Creo la vista uniendo vistas auxiliares
 
#Vista Principal
 
CREATE VIEW trans_cajas_ahorro
AS 
SELECT * FROM
datos_Deposito
UNION
SELECT * FROM
datos_Debito
UNION
SELECT * FROM
datos_Extraccion
UNION
SELECT * FROM
datos_Transferencia;




#-------------------------------------------------------------------------
# Creación de usuarios y otorgamiento de privilegios
# primero creo un usuario con CREATE USER

    GRANT ALL PRIVILEGES ON banco.* TO admin@localhost 
    IDENTIFIED BY 'admin' WITH GRANT OPTION;

# El usuario 'admin' tiene acceso total a todas las tablas de 
# la B.D. banco, puede conectarse solo desde la desde la computadora 
# donde se encuentra el servidor de MySQL (localhost), el password de su 
# cuenta es 'admin' y puede otorgar privilegios 

#-------------------------------------------------------------------------
# Creación de usuarios y otorgamiento de privilegios
# primero creo un usuario con CREATE USER
CREATE USER 'empleado'@'%' IDENTIFIED BY 'empleado';

#otorgo permisos a usuario empleado
GRANT SELECT ON banco.Empleado TO empleado@'%';
GRANT SELECT ON banco.Sucursal TO empleado@'%';
GRANT SELECT ON banco.Tasa_Plazo_Fijo TO empleado@'%';
GRANT SELECT ON banco.Tasa_Prestamo TO empleado@'%';
GRANT SELECT,INSERT ON banco.Prestamo TO empleado@'%';
GRANT SELECT,INSERT ON banco.Plazo_Fijo TO empleado@'%';
GRANT SELECT,INSERT ON banco.Plazo_Cliente TO empleado@'%';
GRANT SELECT,INSERT ON banco.Caja_Ahorro TO empleado@'%';
GRANT SELECT,INSERT ON banco.Tarjeta TO empleado@'%';
GRANT SELECT,INSERT,UPDATE ON banco.Cliente_CA TO empleado@'%';
GRANT SELECT,INSERT,UPDATE ON banco.Cliente TO empleado@'%';
GRANT SELECT,INSERT,UPDATE ON banco.Pago TO empleado@'%';

#-------------------------------------------------------------------------
# Creación de usuarios y otorgamiento de privilegios
# primero creo un usuario con CREATE USER
CREATE USER 'atm'@'%' IDENTIFIED BY 'atm';

#otorgo permisos a usuario atm
GRANT SELECT ON banco.Tarjeta TO atm@'%';
GRANT UPDATE(PIN) ON banco.Tarjeta TO atm@'%';


GRANT SELECT ON trans_cajas_ahorro TO atm@'%';
GRANT SELECT ON banco.Caja_Ahorro TO atm@'%';


# Defino '!' como delimitador de sentencias
delimiter !


#1a)
CREATE PROCEDURE transferenciaACajaDeAhorro(IN nro_tarjeta BIGINT(16), IN nro_ca_destino INT(5), IN codigo_caja INT(5) , IN monto DECIMAL(7,2))                         
BEGIN   
	# Declaro una variables locales
	DECLARE saldo_actual_origen DECIMAL(16,2);
	DECLARE nro_cliente INT(5);
	DECLARE nro_ca_origen INT(8);
	DECLARE nro_trans INT(10);
    DECLARE saldo_nuevo DECIMAL(16,2);
     
   
	# Declaro variables locales para recuperar los errores 
	DECLARE codigo_SQL  CHAR(5) DEFAULT '00000';	 
	DECLARE codigo_MYSQL INT DEFAULT 0;
	DECLARE mensaje_error TEXT; 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 	 	 
	BEGIN 
		GET DIAGNOSTICS CONDITION 1  codigo_MYSQL= MYSQL_ERRNO,  
		                             codigo_SQL= RETURNED_SQLSTATE, 
									 mensaje_error= MESSAGE_TEXT;
	    SELECT 'Excepcion de SQL!, transaccion fallida, podria ser porque la tarjeta no existe o por otro motivo' AS resultado, 
		        codigo_MySQL, codigo_SQL,  mensaje_error;		
        ROLLBACK;
	END;

    # Inicializo variables
		SELECT tarjeta.nro_cliente INTO nro_cliente FROM tarjeta WHERE tarjeta.nro_tarjeta=nro_tarjeta;
		SELECT tarjeta.nro_ca INTO nro_ca_origen FROM tarjeta WHERE tarjeta.nro_tarjeta=nro_tarjeta;
		SELECT saldo INTO saldo_actual_origen FROM caja_ahorro WHERE caja_ahorro.nro_ca=nro_ca_origen FOR UPDATE;     
	

	
	
	START TRANSACTION;	
			IF NOT EXISTS (SELECT * FROM caja WHERE cod_caja=codigo_caja)
				THEN SELECT 'El codigo de caja no existe' AS resultado;
			ELSE
		IF monto<=0
		THEN SELECT 'El monto deberá ser mayor a 0' AS resultado;
		ELSE
			IF monto > saldo_actual_origen 
			THEN SELECT 'Saldo insuficiente para realizar la extraccion' AS resultado;
			ELSE 
				IF NOT EXISTS (SELECT * FROM caja_ahorro WHERE nro_ca=nro_ca_destino)
				THEN SELECT 'La caja ahorro destino no existe' AS resultado;
				ELSE
					INSERT INTO transaccion(nro_trans, fecha, hora, monto) VALUES(NULL,CURDATE(),CURTIME(), monto); 
					SELECT LAST_INSERT_ID() into nro_trans;
					INSERT INTO transaccion_por_caja(nro_trans, cod_caja) VALUES(nro_trans,codigo_caja);  
					INSERT INTO transferencia(nro_trans, nro_cliente, origen, destino) VALUES(nro_trans, nro_cliente, nro_ca_origen, nro_ca_destino);
					INSERT INTO Deposito(nro_trans,nro_ca) VALUES(nro_trans,nro_ca_destino);
					UPDATE caja_ahorro SET saldo = saldo - monto WHERE caja_ahorro.nro_ca=nro_ca_origen; 	#Resto Caja origen
					UPDATE caja_ahorro SET saldo = saldo + monto WHERE caja_ahorro.nro_ca=nro_ca_destino; 	#Sumo Caja Destino
				    
					
					#INSERT INTO Transaccion(nro_trans, fecha, hora, monto) VALUES (NULL ,CURDATE(), CURTIME(), monto); 
					#SELECT LAST_INSERT_ID() INTO nro_trans;
					#INSERT INTO Transaccion_por_caja(nro_trans, cod_caja) VALUES(nro_trans,codigo_caja);  
					#INSERT INTO Transferencia(nro_trans, nro_cliente, origen, destino) VALUES(nro_trans,nro_cliente_origen,nro_ca_origen, nro_ca_destino);
					#UPDATE Caja_Ahorro SET saldo = saldo - monto WHERE Caja_Ahorro.nro_ca=nro_ca_origen;
					
					#INSERT INTO Transaccion( nro_trans, fecha,hora,monto) VALUES (NULL, CURDATE(), CURTIME(), monto);
					#SELECT LAST_INSERT_ID() INTO nro_trans;
					#INSERT INTO Transaccion_por_caja(nro_trans, cod_caja) VALUES(nro_trans,codigo_caja); 
					#INSERT INTO Deposito(nro_trans,nro_ca) VALUES ( nro_trans, nro_ca_destino);
					#UPDATE Caja_Ahorro SET saldo=saldo +  monto WHERE Caja_Ahorro.nro_ca=nro_ca_destino;
					
					SELECT saldo INTO saldo_nuevo FROM caja_ahorro WHERE caja_ahorro.nro_ca=nro_ca_origen; #FOR UPDATE;     
     			    SELECT CONCAT('La Transferencia ha sido exitosa. Su saldo actual es: $',saldo_nuevo);
		#END IF;
			
			END IF;
				END IF;
			END IF;
		END IF;
		
	COMMIT;
END; !

#1b)
CREATE PROCEDURE extraerDeCajaDeAhorro(IN nro_tarjeta BIGINT(16), IN cod_caja INT(5) , IN monto DECIMAL(7,2))                         
BEGIN   
	# Declaro variables locales
	DECLARE saldo_actual DECIMAL(16,2);
	DECLARE nro_cliente INT(5);
	DECLARE nro_ca INT(8);
	DECLARE nro_trans INT(10);
    DECLARE saldo_nuevo DECIMAL(16,2);
    DECLARE mensajeDeExito VARCHAR(50);

		
	# Declaro variables locales para recuperar los errores 
	DECLARE codigo_SQL  CHAR(5) DEFAULT '00000';	 
	DECLARE codigo_MYSQL INT DEFAULT 0;
	DECLARE mensaje_error TEXT; 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION 	 	 
	BEGIN 
		GET DIAGNOSTICS CONDITION 1  codigo_MYSQL= MYSQL_ERRNO,  
		                             codigo_SQL= RETURNED_SQLSTATE, 
									 mensaje_error= MESSAGE_TEXT;
	   SELECT 'Excepcion de SQL!, transaccion fallida por que no existe un numero de tarjeta o bien por otro motivo' AS resultado, 
		        codigo_MySQL, codigo_SQL,  mensaje_error;		
       ROLLBACK;
	END;

	
	
    # Inicializo variables
		SELECT tarjeta.nro_cliente INTO nro_cliente FROM tarjeta WHERE tarjeta.nro_tarjeta=nro_tarjeta;
		SELECT tarjeta.nro_ca INTO nro_ca FROM tarjeta WHERE tarjeta.nro_tarjeta=nro_tarjeta;
		SELECT saldo INTO saldo_actual FROM caja_ahorro WHERE caja_ahorro.nro_ca=nro_ca FOR UPDATE;     

	START TRANSACTION;	
			IF NOT EXISTS (SELECT * FROM caja WHERE caja.cod_caja=cod_caja)
				THEN SELECT 'El codigo de caja no existe' AS resultado;
			ELSE
			
		IF monto>0
		    THEN 
			IF monto > saldo_actual 
			THEN SELECT 'Saldo insuficiente para realizar la extraccion' AS resultado;
			ELSE
				INSERT INTO transaccion(nro_trans, fecha, hora, monto) VALUES(NULL,CURDATE(),CURTIME(), monto); 
				SELECT LAST_INSERT_ID() into nro_trans;
				INSERT INTO transaccion_por_caja(nro_trans, cod_caja) VALUES(nro_trans,cod_caja);  
				INSERT INTO extraccion(nro_trans, nro_cliente, nro_ca) VALUES(nro_trans,nro_cliente,nro_ca);
				UPDATE caja_ahorro SET saldo = saldo - monto WHERE caja_ahorro.nro_ca=nro_ca;
			    SELECT saldo INTO saldo_nuevo FROM caja_ahorro WHERE caja_ahorro.nro_ca=nro_ca FOR UPDATE;     
			    SELECT CONCAT('La Extraccion ha sido exitosa. Su saldo actual es: $',saldo_nuevo);
			END IF;
			
		ELSE SELECT 'Error: Debe ser el monto>0' AS resultado;
		END IF;
		END IF;	
	COMMIT;
END; !




#3	
CREATE TRIGGER realizar_pagos
AFTER INSERT ON prestamo
FOR EACH ROW
BEGIN
	DECLARE nro_pago INT DEFAULT 1;
	WHILE nro_pago<=NEW.cant_meses DO
		INSERT INTO pago(nro_prestamo, nro_pago, fecha_venc, fecha_pago) 
			VALUES(NEW.nro_prestamo, nro_pago, date_add(CURDATE(),interval nro_pago month), null);
		SET nro_pago=nro_pago+1;
	END WHILE;
END; !

delimiter ;

GRANT EXECUTE ON PROCEDURE banco.extraerDeCajaDeAhorro TO atm@'%';
GRANT EXECUTE ON PROCEDURE banco.transferenciaACajaDeAhorro TO atm@'%';


