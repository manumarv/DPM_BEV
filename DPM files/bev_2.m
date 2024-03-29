function [X, C, I, signals] = bev_2(inp,par)


%   wheel radius            = 0.3 m
%   rolling friction        = 144 N
%   aerodynamic coefficient = 0.48 Ns^2/m^2
%   vehicle mass            = 1800 kg
%   air density             = 1.293 kg/m^3
 

F_drag = 0.5*1.293*1.2.*inp.W{1}.^2;
F_roll = 144;


ak = 1/1800*(inp.U{1}/0.3-F_drag-F_roll);


% New Vehicle State Variables 
X{1} = inp.W{1}.*inp.Ts;                                         %distance from the start
X{2} = sqrt(inp.W{1}.^2+2*(X{1}-cumsum(X{1}))*inp.W{2});         % updated vehicle speed      
X{3} = inp.Ts+ 2*(X{1}-cumsum(X{1}))/(X{2}+inp.W{1});            % updated time 

%Motor Torque and motor speed calculation 
%TM_k= inp.U{1}/inp.W{3}
E_total=0;

for k = 1:661-1
    % Determine motor torque and speed based on gear ratio and control input
    T_Mk = inp.U{1}/inp.W{3}; % Calculate motor torque based on gear ratio and control input
    n_k = (1/0.3)*((X{1}+inp.W{1})/2)*inp.W{3}; % Calculate motor speed based on gear ratio and control input

    % Determine traction or recuperation case
    if T_Mk >= 0
        % Traction case
        E_k = (T_Mk * n_k) * (X{3} - inp.Ts);
    else
        % Recuperation case
        E_k = (-T_Mk * n_k) * (X{3} - inp.Ts);
    end

    % Add energy consumption to total
    E_total = E_total + E_k;
end


% cost
C{1} = E_total;                                       
% infeasibility
I = 0;
signals.U{1} = inp.U{1};


