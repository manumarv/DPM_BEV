%ESTIMATION OF TRAVELED DISTANCE, SPEED VD DISTANCE PLOT - 

% Time interval
dt = 1;  % second

% Calculate distance vector
distance_vector = cumsum(speed_vector * dt);

% Total distance
total_distance = distance_vector(end);


% Calculate time vector
time_vector = (0:length(speed_vector)-1) * dt;

% Create a plot
figure;

% Speed vs. Distance subplot
subplot(1, 2, 1);
plot(distance_vector, speed_vector);
xlabel('Distance (meters)');
ylabel('Speed (m/s)');
title('Speed vs. Distance');
grid on;



% Time vs. Distance subplot
subplot(1, 2, 2);
plot(time_vector, distance_vector);
xlabel('Time (seconds)');
ylabel('Distance (meters)');
title('Time vs. Distance');
grid on;

% Adjust subplot layout
sgtitle('Speed and Time vs. Distance Plots');

fprintf('Total distance traveled: %.2f meters\n', total_distance);