[optimal_torque, ~] = minimize_energy_consumption(speed_vector, acceleration_vector, gearnumber_vector, wm_list, Tm_list, efficiency_map, m,wr,cr,cd,g,rho_a,gear_ratios ,dt,Tmmax);

%Pt_Optimized        = n*optimal_torque;
Pt_Optimized        = optimal_torque;

E_kW_Optimized      = sum(Pt_Optimized);

figure;

% Original Torque subplot
subplot(2, 1, 1);
plot(original_torque);
title('Original Torque');
ylabel('Torque (Nm)');

% Optimal Torque subplot
subplot(2, 1, 2);
plot(optimal_torque);
title('Optimal Torque');
ylabel('Torque (Nm)');


gear_ratio_vector=gear_ratios(gearnumber_vector);
optimal_wheel_torque= optimal_torque.*gear_ratio_vector';

Optimal_Tractive_Force = optimal_wheel_torque/wr; 

Ft = m * acceleration_vector';

speed_vector_optimized =  sqrt ((Optimal_Tractive_Force-Ft)/(0.5*rho_a*cd));


speed_vector_optimized =  sqrt(sqrt(abs(speed_vector_optimized.^2)));
figure; 

plot(speed_vector_optimized');

subplot(2, 1, 1);
plot(original_torque);
title('Original Torque');
ylabel('Torque (Nm)');
% 
% % Optimal Torque subplot
subplot(2, 1, 2);
plot(optimal_torque_values);
title('Optimal Torque');
ylabel('Torque (Nm)');


