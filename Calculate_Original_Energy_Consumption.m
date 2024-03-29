%Initialize an empty vector to store the original torque values
original_torque = zeros(length(speed_vector), 1);            
original_motor_speed= zeros (length(speed_vector),1);
original_efficiencies=zeros(length(speed_vector),1);

for i = 1:length(speed_vector)
    
    [Tm, efficiency, n] = get_efficiency_torque(speed_vector(i), acceleration_vector(i), gearnumber_vector(i), wm_list, Tm_list, efficiency_map, m,wr,cr,cd,g,rho_a,gear_ratios,Tmmax);

    original_torque(i) = Tm;
    original_motor_speed (i) = n;
    original_efficiencies(i) = efficiency;  
    
end

Pt_original  =   original_torque.*original_motor_speed; 

Pt_regenerative_original=zeros(661,1);

for i = 1:length(acceleration_vector)

    if acceleration_vector(i)>0

        Pt_regenerative_original(i)=Pt_original(i);
    else 
        Pt_regenerative_original(i)=Pt_original(i)*0.7;
    end

    %Pt_regenerative(i) = Pt_regenerative;
end 

%Pt_regenerative = ; %Power at each time step
%Pt=Pt_regenerative;


E_kW_original    = sum(Pt_original)/1000;                          %Total Energy Consumed 

E_kW_regenerative = sum(Pt_regenerative_original)/1000;


% figure;
% 
% % Original Torque subplot
% subplot(2, 1, 1);
% plot(original_torque);
% title('Original Torque');
% ylabel('Torque (Nm)');
% % 
% % % Optimal Torque subplot
% subplot(2, 1, 2);
% plot(optimal_torque_values);
% title('Optimal Torque');
% ylabel('Torque (Nm)');
