clear all;
close all;
clc;
format long;
name = 'Ryan Dunn';
id = 'A15600858';
hw_num = 'project';

%% Declaring global values
global m r A rho g Cd Cm goal
m = 0.4; % mass
r = 0.11; % radius
A = pi*r^2; % cross-sectional area of ball
rho = 1.2; % air density
g = 9.81; % acceleration due to gravity
Cd = 0.3; % Drag coeff
Cm = 0.6; % Magnus coeff

%% Increasing Efficiency
T = cell(1,7);
X = cell(1,7);
Y = cell(1,7);
Z = cell(1,7);
U = cell(1,7);
V = cell(1,7);
W = cell(1,7);
Velo = cell(1,7);
Accel = cell(1,7);
sim_res = struct([]);

%% Extracting and interpreting the data
for u = 1:7
    goal = false;
    [x0,y0,z0,Umag0,theta,phi,omgX,omgY,omgZ] = read_input('input_parameter.txt',u);
    [T{u},X{u},Y{u},Z{u},U{u},V{u},W{u}] = soccer(x0,y0,z0,Umag0,theta,phi,omgX,omgY,omgZ);
    alpha = sprintf('Finished simulation of kick #%d \n',u);
    fprintf(alpha);
end

%% Generating Colors
colors = 'rgbcmyk';
for n=1:length(colors)
    color{n} = sprintf('%s%s',colors(n),'.');
end

%% Plotting Figure 1 - Field & Kicks
figure('unit', 'in', 'position', [1 3 14 5]); 
hold on
for n = 1:7
    plot3(X{n},Y{n},Z{n},colors(n),'LineWidth',1.5)
end
for x=1:7
    stringL{x} = sprintf('Kick #%1d',x);
    plot3(X{x}(end),Y{x}(end),Z{x}(end),color{x},'MarkerSize',20);
    plot3(X{x}(1),Y{x}(1),Z{x}(1),color{x},'MarkerSize',20);
end
for n=1:7
    max_time(n) = T{n}(end);
end
max_time = max_time(max_time == max(max_time));
plot_layout(max_time);
legend(stringL);
fprintf('Finished Plot 1\n')

%% Plotting Figure 2 - Velo & Accel Graphs
dt = 1/1000;
for n = 1:7
    Velo{n} = sqrt(U{n}.^2+V{n}.^2+W{n}.^2);
    Accel{n} = diff(Velo{n})./(dt);
end

%% Velocity Subplot
figure(2)
subplot(2,1,1)
hold on
for n = 1:7
    plot(T{n},Velo{n},colors(n),'LineWidth',1.5);
    plot(T{n}(end),Velo{n}(end),color{n},'MarkerSize',12);
end
title('Velocity versus Time')
xlabel('Time (s)')
ylabel('Velocity (m/s)')
axis([0 2 15 45])

%% Acceleration Subplot
subplot(2,1,2)
hold on
for n = 1:7
    plot(T{n}(2:end),Accel{n},colors(n),'LineWidth',1.5);
end
for n=1:7
    plot(T{n}(end-1),Accel{n}(end),color{n},'MarkerSize',12);
end
title('Acceleration versus Time')
xlabel('Time (s)')
ylabel('Acceleration (m/s^2)')
legend(stringL,'Location','southeast')
axis([0 2 -35 0])
fprintf('Finished Plot 2\n')

%% Miscellaneous calculation
for n=1:7
    total_dist(n) = sum(sqrt(diff(X{n}).^2+diff(Y{n}).^2+diff(Z{n}).^2));
end

%% Creating sim_res Structure
for n = 1:7
    sim_res(n).kick_ID = n;
    sim_res(n).final_time = T{n}(end);
    temp_index = find(Z{n} == max(Z{n}));
    sim_res(n).max_height_location = [X{n}(temp_index), Y{n}(temp_index), Z{n}(temp_index)];
    sim_res(n).final_location = [X{n}(end), Y{n}(end), Z{n}(end)];    
    sim_res(n).final_speed = Velo{n}(end);
    sim_res(n).final_acceleration = Accel{n}(end);
    sim_res(n).travel_distance = total_dist(n);
end
fprintf('Finished generating structure ''sim_res''\n');

%% Saving report.txt
fid = fopen('report.txt','w');
fprintf(fid,'Ryan Dunn\n');
fprintf(fid,'A15600858\n');
fprintf(fid,'kick_ID, final_time(s), final_speed(m/s), final_acceleration(m/sˆ2), travel_distance(m)\n');
for n=1:7
    fprintf(fid,'%1d %15.9e %15.9e %15.9e %15.9e\n',sim_res(n).kick_ID,...
            sim_res(n).final_time,sim_res(n).final_speed,...
            sim_res(n).final_acceleration,sim_res(n).travel_distance);
end
fclose(fid);
fprintf('Finished generating ''report.txt''\n');

%% Final Variables
p1a = evalc('help read_input'); 
p1b = evalc('help soccer'); 
p2a ='See figure 1'; 
p2b ='See figure 2'; 
p3a = sim_res(1); 
p3b = sim_res(2); 
p3c = sim_res(3); 
p3d = sim_res(4); 
p3e = sim_res(5); 
p3f = sim_res(6); 
p3g = sim_res(7); 
p4 = evalc('type report.txt');