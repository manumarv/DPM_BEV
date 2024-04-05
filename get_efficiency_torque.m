%% Dont need this for an EV - EV motors Torque is more direct
function [Tm, efficiency, n] = get_efficiency_torque(speed_vector, acceleration_vector, gearnumber_vector, wm_list, Tm_list, efficiency_map,m,wr,cr,cd,g,rho_a,gear_ratios, Tmmax)

    % % Calculate motor torque needed for a given speed and acceleration
    % 
    % Ft = m * acceleration_vector;       % F = ma, required forced by the prime mover
    % Fa = 0.5*rho_a*cd*speed_vector^2;   % Aerodynamic Friction Force
    % Fr = cr*m*g*cos(0);                 % Rolling Friction Force, angle is 0 since we assume plain surface
    % Fg = m*g*sin(0);                    % Uphill Driving Force, angle is 0 since plain surface
    % Fd = 0;                             % Disturbance Forces, neglected in this case
    % 
    % % Summation of all Forces
    % Ft = Ft +Fr + Fa + Fg + Fd; 
    % 
    % Tw = Ft * wr;                                      % Required Torque at the wheels Tw in Nm 
    % 
    % %Motor Torque  
    % 
    % Tm = abs(Tw /gear_ratios(gearnumber_vector));      
    % 
    % % Calculate the motor speed
    % 
    % n = speed_vector*gear_ratios(gearnumber_vector)/wr; % n is motor speed
    % 
    % % Get the closest matching motor speed from wm_list
    % [~, idx] = min(abs(wm_list - n));
    % max_torque_at_speed = Tmmax(idx);
    % 
    % % Cap the motor_torque to the maximum allowed
    % Tm = min(Tm, max_torque_at_speed);
    % 
    % % Interpolate to get the efficiency for the given motor torque and speed
    % efficiency = interp2(wm_list, Tm_list, efficiency_map', n, Tm, 'linear');


    % Calculate forces
    Ft = m * acceleration_vector; % Total force required
    Fa = 0.5 * rho_a * cd * speed_vector^2; % Aerodynamic drag force
    Fr = cr * m * g; % Rolling resistance
    Ftotal = Ft + Fa + Fr; % Sum of forces

    % Required torque at the wheels
    Tw = Ftotal * wr;
    
    % Motor torque considering the gear ratio
    Tm = Tw / gear_ratios();
    
    % Motor speed (rad/s)
    n = speed * gear_ratios / wr;
    
    % Get the closest matching motor speed from wm_list and cap Tm to max available at that speed
    [~, idx] = min(abs(wm_list - n));
    max_torque_at_speed = Tmmax(idx);
    Tm = min(Tm, max_torque_at_speed);
    
    % Interpolate to find efficiency
    efficiency = interp2(wm_list, Tm_list, efficiency_map', n, Tm, 'linear');



end
