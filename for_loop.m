  for i = 2:num_steps
        for j = 1:num_gears
            for k = 1:num_gears
                energy_step = calculate_energy(speed_vector(i), acceleration_vector(i), gear_ratios(k))
                
                % Include gear change penalty if gear is changed
                if k ~= j % not equal to prev gear 
                    energy_step = energy_step + gear_change_penalty
                end
                
                % Calculate total energy and update dp matrix
                total_energy = dp(i-1, j) + energy_step
                if total_energy < dp(i, k)
                    dp(i, k) = total_energy;
                    prev_gear(i, k) = j;
                end
            end
        end
    end