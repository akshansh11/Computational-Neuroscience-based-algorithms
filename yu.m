% Parameters
num_neurons = 10;
num_steps = 100;
frame_rate = 30;
output_file = 'hebbian_learning.mp4';
video_quality = 100; % Adjust for better quality (0-100)

% Initialize connection weights (synapses)
weights = rand(num_neurons, num_neurons);

% Setup figure
figure('Color', 'k', 'Position', [100, 100, 1920, 1080]);

% Create a video writer object
v = VideoWriter(output_file, 'MPEG-4');
v.FrameRate = frame_rate;
v.Quality = video_quality;
open(v);

% Create color map for neurons
colors = hsv(num_neurons);

% Create neuron positions
theta = linspace(0, 2*pi, num_neurons+1);
theta = theta(1:end-1);
x = cos(theta);
y = sin(theta);

% Simulation loop
for step = 1:num_steps
    % Randomly choose neurons to fire
    firing_neurons = randi([0, 1], num_neurons, 1);

    % Update weights according to Hebbian learning rule
    for i = 1:num_neurons
        for j = 1:num_neurons
            if firing_neurons(i) && firing_neurons(j)
                weights(i, j) = weights(i, j) + 0.1; % Learning rate
            end
        end
    end

    % Normalize weights to avoid explosion
    weights = weights ./ max(weights(:));

    % Plot neurons
    clf;
    hold on;
    for i = 1:num_neurons
        plot(x(i), y(i), 'o', 'MarkerSize', 20, 'MarkerFaceColor', colors(i,:), 'MarkerEdgeColor', 'w');
        % Label neurons
        text(x(i), y(i), sprintf('N%d', i), 'Color', 'w', 'FontSize', 12, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    end

    % Plot connections
    for i = 1:num_neurons
        for j = 1:num_neurons
            if i ~= j
                line([x(i) x(j)], [y(i) y(j)], 'Color', [1 1 1]*0.2, 'LineWidth', weights(i, j) * 10);
            end
        end
    end

    % Add text annotations
    text(0, 1.3, sprintf('Step: %d', step), 'Color', 'w', 'FontSize', 14, 'HorizontalAlignment', 'center');
    title('Hebbian Learning Visualization', 'Color', 'w', 'FontSize', 20);

    % Adjust axis
    axis equal off;
    set(gca, 'Color', 'k');

    % Capture frame
    frame = getframe(gcf);
    writeVideo(v, frame);
end

% Close video file
close(v);
disp(['Video saved to ', output_file]);



