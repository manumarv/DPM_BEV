function [X C I out] = bev(inp, par)
%function [X C I out] = BEV(inp, par)
%BEV Computes the resulting state-of-charge based on current state-
%   of-charge, inputs and drive cycle demand.
%
%   [X C I out] = BEV(INP, PAR)
%
%   INP   = input structure
%   PAR   = user defined parameters
%
%   X     = resulting state-of-charge
%   C     = cost matrix (in terms of energy consumption)
%   I     = infeasible matrix
%   out   = user defined output signals

% VEHICLE
%   wheel radius            = 0.3 m
%   rolling friction        = 144 N
%   aerodynamic coefficient = 0.48 Ns^2/m^2
%   vehicle mass            = 1800 kg

% Wheel speed (rad/s)
wv = inp.W{1} ./ 0.3;

% Wheel acceleration (rad/s^2)
dwv = inp.W{2} ./ 0.3;

% Wheel torque (Nm) due to vehicle dynamics
Tv = (144 + 0.48.*inp.W{1}.^2 + 1800.*inp.W{2}) .* 0.3;

% As this is a BEV, the wheel torque is directly catered by the motor
Tm = Tv;

% MOTOR (using the ADVISOR PM25 model as in your HEV model)
% motor speed list
wm_list = [0   50  100  150  200  250  300  350  400  450  500  550  600];
% motor torque list
Tm_list = [0 10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160];
% motor maximum torque (indexed by speed list)
Tmmax   = [130 130 130 110 105 95 80 70 59 50 40 32 28];
% motor minimum torque (indexed by speed list)
Tmmin   = -Tmmax;
% motor efficiency map (indexed by speed list and torque list)
etam = 0.01*[...
      50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50 50   
      68 70 71 71 71 71 70 70 69 69 69 68 67 67 67 67 67  
      68 75 80 81 81 81 81 81 81 81 80 80 79 78 77 76 76
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

% Electric motor efficiency
e = interp2(Tm_list, wm_list, etam, abs(Tm), wv .* ones(size(Tm)));
inm = (isnan(e)) + (Tm < 0) .* (Tm < interp1(wm_list, Tmmin, wv, 'linear', 'extrap')) +...
(Tm >= 0) .* (Tm > interp1(wm_list, Tmmax, wv, 'linear', 'extrap'));
e(isnan(e)) = 1;

% Calculate electric power consumption
Pm = wv.*Tm./e;

% BATTERY
% state-of-charge list
soc_list = [0 0.2 0.4 0.6 0.8 1];
% discharging resistance (indexed by state-of-charge list)
R_dis    = [1.75    0.60    0.40    0.30    0.30    0.30]; % ohm
% charging resistance (indexed by state-of-charge list)
R_chg    = [0.35    0.50    0.85    1.00    2.00    5.00]; % ohm
% open circuit voltage (indexed by state-of-charge list)
V_oc     = [230     240     245     250     255     257]; % volt

% Battery efficiency
% columbic efficiency (0.9 when charging)
e = (Pm>0) + (Pm<=0) .* 0.9;
% Battery internal resistance
r = (Pm>0)  .* interp1(soc_list, R_dis, inp.X{1},'linear','extrap')...
  + (Pm<=0) .* interp1(soc_list, R_chg, inp.X{1},'linear','extrap');

% Battery current limitations
%   battery capacity            = 6 Ah 
%   maximum discharging current = 100A
%   maximum charging current    = 125A
im = (Pm>0) .* 100 + (Pm<=0) .* 125;
% Battery voltage
v = interp1(soc_list, V_oc, inp.X{1},'linear','extrap');
% Battery current
Ib  =   e .* (v-sqrt(v.^2 - 4.*r.*Pm))./(2.*r);
% New battery state of charge
X{1}  = - Ib / (6 * 3600) + inp.X{1};
% Battery power consumption
Pb =   Ib .* v;
% Update infeasible 
inb = (v.^2 < 4.*r.*Pm) + (abs(Ib)>im);
% Set new state of charge to real values
X{1} = (conj(X{1})+X{1})/2;
Pb   = (conj(Pb)+Pb)/2;
Ib   = (conj(Ib)+Ib)/2;

% COST
% Summarize infeasible matrix
I = (inm+inb~=0);
% Calculate cost matrix (energy consumption from the battery)
C{1} = abs(Pm);

% SIGNALS
%   store relevant signals in out
out.Tm = Tm;
out.wv = wv;
out.Ib = Ib;
out.Pb = Pb;

% REVISION HISTORY
% =========================================================================
% DATE      WHO                 WHAT
% -------------------------------------------------------------------------

end
