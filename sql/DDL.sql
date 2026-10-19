CREATE DATABASE Veterinaria;

USE Veterinaria;

CREATE TABLE clientes (
	IdCliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    correoElectronico VARCHAR(100) UNIQUE NOT NULL,
    activo BOOLEAN DEFAULT 1
);

CREATE TABLE mascotas (
	IdMascota INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL,
    nPatas INT NOT NULL CHECK (nPatas >= 0),
    estatura FLOAT NOT NULL CHECK (estatura > 0),
    IdCliente INT NOT NULL,
    FOREIGN KEY (IdCliente) REFERENCES clientes(IdCliente)
);

CREATE TABLE servicios (
	IdServicio INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL,
    precio DECIMAL (10,2) NOT NULL CHECK (precio > 0)
);

CREATE TABLE mascota_servicio (
	idMascota_Servicio INT AUTO_INCREMENT PRIMARY KEY,
	IdMascota INT NOT NULL,
    IdServicio INT NOT NULL,
    fecha DATE DEFAULT (CURDATE()),
    FOREIGN KEY (IdMascota) REFERENCES mascotas(IdMascota),
    FOREIGN KEY (IdServicio) REFERENCES servicios(IdServicio)
);