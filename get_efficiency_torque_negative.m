function [Tm, efficiency, n] = get_efficiency_torque_negative(speed_vector, acceleration_vector, gearnumber_vector, wm_list, Tm_list, efficiency_map,m,wr,cr,cd,g,rho_a,gear_ratios, Tmmax)

    % Calculate motor torque needed for a given speed and acceleration

    
    Ft = m * acceleration_vector;       % F = ma, required forced by the prime mover
    Fa = 0.5*rho_a*cd*speed_vector^2;   % Aerodynamic Friction Force
    Fr = cr*m*g*cos(0);                 % Rolling Friction Force, angle is 0 since we assume plain surface
    Fg = m*g*sin(0);                    % Uphill Driving Force, angle is 0 since plain surface
    Fd = 0;                             % Disturbance Forces, neglected in this case

    % Summation of all Forces
    Ft = Ft +Fr + Fa + Fg + Fd; 


    % Required Torque at the wheels Tw in Nm 

    Tw = Ft * wr;                                      
    
    Tm = abs(Tw /gear_ratios(gearnumber_vector));      %Motor Torque  
    
    % Calculate the motor speed
    
    n = speed_vector*gear_ratios(gearnumber_vector)/wr; % n is motor speed in rad/s
    
    % Get the closest matching motor speed from wm_list
    [~, idx] = min(abs(wm_list - n));
    max_torque_at_speed = Tmmax(idx);
    
    % Cap the motor_torque to the maximum allowed
    Tm = min(Tm, max_torque_at_speed);
    
    % Interpolate to get the efficiency for the given motor torque and speed
    efficiency = interp2(wm_list, Tm_list, efficiency_map', n, Tm, 'linear');

end
