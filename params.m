
clear,clc;
% LOAD DRIVE CYCLE
load ('JN1015.mat')

% LOAD VEHICLE PARAMETERS
dt      = 1     ;   % Time step duration in seconds
m       = 1000  ;   % Vehicle mass in kg
wr      = 0.3   ;   % Wheel Radius in meters        
cr      = 0.012 ;   % 
cd      = 0.7   ;   % cd*Af for a full-size vehicle
g       = 9.8   ;   % gravity                          
rho_a   = 1.2   ;   %
 
drivetrainEfficiency = 0.85; 



%ELECTRIC MOTOR PARAMETERS
Tmmax       = [130, 130, 130, 110, 105, 95, 80, 70, 59, 50, 40, 32, 28];  % Max motor torque based on motor speed (Nm)

wm_list     = [0   50  100  150  200  250  300  350  400  450  500  550  600];  % Motor speed list (rad/s)

Tm_list     = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160];  % Motor torque list (Nm)

gear_ratios = [3.5, 2.8, 2.0, 1.5, 1.0];


% EFFICIENCY MAP
efficiency_map = 0.01*[...
              50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50   
              68 70 71 71 71 71 70 70 69 69 69 68 67 67 67 67 67  
              68 75 80 81 81 81 70 81 81 81 80 80 79 78 77 76 76
              68 77 81 85 85 85 85 85 85 84 84 83 83 82 82 80 79
              68 78 82 87 88 88 88 88 88 87 87 86 86 85 84 83 83
              68 78 82 88 88 89 89 89 88 88 87 85 85 84 84 84 83
              69 78 83 87 88 89 89 88 87 85 85 84 84 84 84 84 83
              69 73 82 86 87 88 87 86 85 84 84 84 84 84 84 84 83
              69 71 80 83 85 86 85 85 84 84 84 84 84 84 83 83 83
              69 69 79 82 84 84 84 84 83 83 83 83 83 83 83 82 82
              69 68 75 81 82 81 81 81 81 81 81 80 80 80 80 80 80
              69 68 73 80 81 80 76 76 76 76 76 76 76 76 75 75 75
              69 68 71 75 75 75 75 75 75 75 75 75 74 74 74 74 74];


