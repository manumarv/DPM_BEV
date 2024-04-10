% Vehicle parameters
m = 1500; % mass of the vehicle in kg
a = 2; % acceleration in m/s^2 (example value)
r = 0.3; % radius of the wheel in meters
G = 1; % transmission gear ratio (example value)
eta = 0.95; % transmission efficiency (example value)
v = 30; % desired velocity in m/s (example value)

% Resistive forces (for illustration purposes)
F_rolling_resistance = m * 9.81 * 0.015; % Rolling resistance with coefficient of 0.015
F_aerodynamic_drag = 0.5 * 1.225 * 2.2 * (v^2); % Aerodynamic drag, where 2.2 is Cd*A
F_gradient = m * 9.81 * sin(0); % Gradient resistance, 0 for flat surface

% Total resistive force
F_resist = F_rolling_resistance + F_aerodynamic_drag + F_gradient;

% Traction force (assuming it's given or calculated previously)
F_trac = m * a + F_resist;

% Calculate wheel torque
tau_wheel = F_trac * r;

% Calculate motor torque considering transmission gear ratio and efficiency
tau_motor = tau_wheel / (G * eta);

% Calculate motor speed in rad/s (assuming the speed of the vehicle is the linear speed at the wheel's edge)
omega_motor = (v / r) * G * (2 * pi / 60);

% Calculate motor power in watts
P_watts = tau_motor * omega_motor

% Convert power to kilowatts if needed
P_kW = P_watts / 1000;
