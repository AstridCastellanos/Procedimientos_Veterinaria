USE Veterinaria;

-- Clientes
INSERT INTO clientes (nombre, direccion, correoElectronico, activo) VALUES
('María López', 'Zona 1, Ciudad de Guatemala', 'maria.lopez@gmail.com', 1),
('José Ramírez', 'Zona 7, Mixco', 'jose.ramirez@hotmail.com', 1),
('Ana Morales', 'Zona 15, Vista Hermosa', 'ana.morales@gmail.com', 1),
('Carlos García', 'Antigua Guatemala, Sacatepéquez', 'carlos.garcia@yahoo.com', 1),
('Luisa Hernández', 'Zona 5, Quetzaltenango', 'luisa.hernandez@gmail.com', 1),
('Pedro Ajpacajá', 'Chichicastenango, Quiché', 'pedro.ajpacaja@gmail.com', 1),
('Rosa Tzul', 'Sololá', 'rosa.tzul@hotmail.com', 0),
('Juan Coc', 'Cobán, Alta Verapaz', 'juan.coc@gmail.com', 1),
('Marta Chávez', 'Escuintla', 'marta.chavez@gmail.com', 1),
('Diego Xicay', 'Zona 11, Ciudad de Guatemala', 'diego.xicay@yahoo.com', 1);

-- Mascotas
INSERT INTO mascotas (nombre, nPatas, estatura, IdCliente) VALUES
('Firulais', 4, 0.45, 1),
('Michín', 4, 0.25, 2),
('Rocky', 4, 0.60, 3),
('Luna', 4, 0.35, 4),
('Toby', 4, 0.50, 5),
('Pelusa', 4, 0.20, 6),
('Max', 4, 0.55, 7),
('Canela', 4, 0.30, 8),
('Simba', 4, 0.40, 9),
('Nala', 4, 0.38, 10);

-- Servicios
INSERT INTO servicios (nombre, precio) VALUES
('Consulta General', 150.00),
('Vacuna Antirrábica', 75.00),
('Desparasitación', 100.00),
('Baño y Corte', 125.00),
('Esterilización', 850.00),
('Limpieza Dental', 400.00),
('Radiografía', 300.00),
('Examen de Sangre', 250.00),
('Microchip', 200.00),
('Consulta de Emergencia', 350.00);

-- Macota_Servicio
INSERT INTO mascota_servicio (IdMascota, IdServicio, fecha) VALUES
(1, 1, '2026-09-01'),
(2, 2, '2026-09-03'),
(3, 4, '2026-09-05'),
(4, 3, '2026-09-07'),
(5, 5, '2026-09-10'),
(6, 6, '2026-09-12'),
(7, 8, '2026-09-15'),
(8, 9, '2026-09-18'),
(1, 4, '2026-10-01'),
(10, 10, '2026-10-05');