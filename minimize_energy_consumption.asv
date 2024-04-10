%% This is a gear ratio optimization, in this case electric motors might have between 2 or 3 gear ratio, specially trucks that require more torque 
%% https://www.ncbi.nlm.nih.gov/pmc/articles/PMC9399168/#bib4  - Main Source
%% https://www.sciencedirect.com/science/article/abs/pii/S0888327014002210 - Read

%This function optimizes the powertrain of a Battery electric vehicle based
%on a torque optimization process. The Optimization process is a based on
%a Dynamic Programming Algorithm. The main inputs of this test are speed,  
% acceleration, there are other secondary inputs which are the vehicle and motor 
% parameters. The main output are the optimal torque sequence and the total minimized energy
%consumption from this optimized speed profile. 

function [optimal_gear_sequence, min_energy] = minimize_energy_consumption(speed_vector, acceleration_vector, m, wr, cr, cd, g, rho_a, gear_ratios, dt, Tmmax)
    num_steps = length(speed_vector);
    num_gears = length(gear_ratios); % Assuming gear_ratios has the EV's 2 gear ratios

    % Initialize dynamic programming matrices
    dp = inf(num_steps, num_gears); % Stores total energy up to step i in gear j
    prev_gear = zeros(num_steps, num_gears); % Stores previous gear choice

    gear_change_penalty = 5; % Penalty for changing gears

    % Function to calculate energy consumption
    % This is a simplified version that calculates energy based on speed, acceleration, gear ratio, and vehicle parameters.
    calculate_energy = @(speed, acceleration, gear_ratio) (0.5 * rho_a * cd * speed^2 + cr * m * g + m * acceleration) * speed * dt / gear_ratio;

    % Initial condition: minimally select between the two gears for the first step
    for j = 1:num_gears
        dp(1, j) = calculate_energy(speed_vector(1), acceleration_vector(1), gear_ratios(j));
    end

    % Dynamic Programming to find optimal gear selection
    for i = 2:num_steps
        for j = 1:num_gears
            for k = 1:num_gears
                energy_step = calculate_energy(speed_vector(i), acceleration_vector(i), gear_ratios(k));
                
                % Include gear change penalty if gear is changed
                if k ~= j % not equal to prev gear 
                    energy_step = energy_step + gear_change_penalty;
                end
                
                % Calculate total energy and update dp matrix
                total_energy = dp(i-1, j) + energy_step;
                if total_energy < dp(i, k)
                    dp(i, k) = total_energy;
                    prev_gear(i, k) = j;
                end
            end
        end
    end

    % Backtracking to find the optimal gear sequence
    optimal_gear_sequence = zeros(num_steps, 1);
    [~, optimal_gear_sequence(num_steps)] = min(dp(num_steps, :));
    for i = num_steps:-1:2
        optimal_gear_sequence(i-1) = prev_gear(i, optimal_gear_sequence(i));
    end

    % Calculate minimum energy from dp matrix
    min_energy = min(dp(num_steps, :));
end

% 
% function [optimal_torque, min_energy] = minimize_energy_consumption(speed_vector, acceleration_vector, gearnumber_vector, wm_list, Tm_list, efficiency_map, m,wr,cr,cd,g,rho_a,gear_ratios ,dt,Tmmax)
% 
%     num_steps = length(speed_vector);
%     num_gears = length(unique(gearnumber_vector));
% 
%     % Initialize matrices for dynamic programming
%     dp = zeros(num_steps, num_gears); % dp(i, j) stores the total energy up to step i in gear j
%     prev_gear = zeros(num_steps, num_gears); % prev_gear(i, j) stores the previous gear at step i in gear j
% 
%     gear_change_penalty = 5; % Arbitrary penalty value for changing gears. You may want to adjust based on real-world data.
% 
%     % Initial Condition Considering all gears
%     for j = 1:num_gears
%         [Tm, efficiency, n] = get_efficiency_torque(speed_vector(1), acceleration_vector(1), j, wm_list, Tm_list, efficiency_map, m,wr,cr,cd,g,rho_a,gear_ratios,Tmmax);
%         power = Tm * n;
%         dp(1, j) = power * dt / efficiency;
%     end
% 
%     % DP algorithm
% 
%     for i = 2:num_steps
%         for j = 1:num_gears
%             min_energy = inf;
% 
%             % Check if acceleration is non-negative.
%             if acceleration_vector(i) >= 0
%                 for k = 1:num_gears
%                     [Tm, efficiency, n] = get_efficiency_torque(speed_vector(i), acceleration_vector(i), k, wm_list, Tm_list, efficiency_map, m, wr, cr, cd, g, rho_a, gear_ratios, Tmmax);
% 
%                     power = Tm * n;
%                     energy_step = power * dt / efficiency;
% 
%                     % Calculate the energy penalty for changing gears.
%                     energy_change = 0;
%                     if k ~= j % i.e., if the gear changed.
%                         energy_change = gear_change_penalty;
%                     end
% 
%                     % Calculate the total energy consumption for the current time step and gear.
%                     total_energy = dp(i-1, k) + energy_step + energy_change;
% 
%                     % Update the minimum energy if the calculated total energy is smaller.
%                     if total_energy < min_energy
%                         min_energy = total_energy;
%                         prev_gear(i, j) = k; % Store the optimal gear choice at this time step.
%                     end
%                 end
%                 dp(i, j) = min_energy; % Store the minimum energy consumption for this time step and gear.
%             end
%         end
%     end
% 
%     % Backtracking to find the optimal gear sequence and torques
%     % Initialize arrays
%     optimal_gear_sequence = zeros(num_steps, 1);
%     optimal_torque = zeros(num_steps, 1);
% 
%     % Set the starting point for backtracking (the gear with the minimum energy at the last step)
%     [~, optimal_gear_sequence(num_steps)] = min(dp(num_steps, :));
% 
%     % Backtrack through the dynamic programming matrix
%     for i = num_steps:-1:2
%         current_gear = optimal_gear_sequence(i);
% 
%         % Ensure the current gear is valid
%         if current_gear > 0 && current_gear <= num_gears
%             optimal_gear_sequence(i-1) = prev_gear(i, current_gear);
%         else
%             % Default to the first gear if an invalid gear is detected. This is a failsafe mechanism.
%             optimal_gear_sequence(i) = 1;  
%         end
% 
%         % Get motor torque for the optimal gear
%         [Tm, ~, ~] = get_efficiency_torque(speed_vector(i), acceleration_vector(i), optimal_gear_sequence(i), wm_list, Tm_list, efficiency_map, m, wr, cr, cd, g, rho_a, gear_ratios, Tmmax);
%         optimal_torque(i) = Tm;
%         min_energy = min(dp(num_steps, :));
% 
%     end
% 
% 
% 
% 
% end

    
