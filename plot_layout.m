function plot_layout(t)
% This script provides the layout of the soccer field which includes
% soccer ball, defenders 1 to 4, the goalkeeper (defender 5), field and goal.
% The script calls function defender to get defenders' surface data.
% To call, use plot_layout(t), with input of the longest time

% Load field and goal geometries
load('field.mat');
load('goal.mat');

% Open figure window and change window dimension
hold on;

% Plot the ball at location X0, Y0, Z0
% X0 = -15; 
% Y0 = 30;
% Z0 = 0.11;
% plot3(X0, Y0, Z0, 'ko', 'MarkerSize', 6, 'MarkerFaceColor', 'k');

% Render the defenders' surface at time t;
time = t;
defender_color = 'bgmcr';
for nd = 1:5
    [Dx, Dy, Dz] = defender(nd, time); % Outputs are 2-D matrices
    surf(Dx, Dy, Dz, 'FaceColor', defender_color(nd), 'EdgeColor', 'none'); 
end

% Plot field and goal;
plot3(field.X, field.Y, field.Z, 'go', 'MarkerSize', 1);
plot3(goal.X, goal.Y, goal.Z, 'k-', 'LineWidth',2);

title('Simulation of Free Kicks in a Soccer Game');
axis([-45 45 0 65 0 10]); 
view(-20.5,45); % set view angle
box on; grid on;
xlabel('x (m)'); ylabel('y (m)'); zlabel('z (m)');
set(gca, 'Position', [0.1 0.12 0.85 .7]); % set position of the axis area
set(gca, 'FontSize', 14);

end