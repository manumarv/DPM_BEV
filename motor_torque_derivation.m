% Calculate Motor Torque based on the speed vector

motorTorque = zeros(size(speed_vector)); % Initialize torque vector

for i = 1:length(speed_vector)
    if speed_vector(i) == 0 && acceleration_vector(i) == 0
        % If both speed and acceleration are zero, torque is zero
        motorTorque(i) = 0;
    else
        rollingResistanceForce = cr * m * 9.81;
        dragForce = 0.5 * rho_a * speed_vector(i)^2 * cd;
        totalForce = m * acceleration_vector(i) + rollingResistanceForce + dragForce;
        wheelTorque = totalForce * wr;
        motorTorque(i) = wheelTorque / (gear_ratios(gearnumber_vector(i)) * drivetrainEfficiency);
    end
end

