%%
clear all;
clc
%% values motor
Va = 48;        % 입력전압
La = 0.000658;  % H
Ra = 1.76;      % Ohm

Kt = 0.0683;    % Nm/A
Ke = 0.0683;    % Nm/A

Jm = 0.00000995;% kgm^2
Jg = 0.0000005; % kgm^2
% Dc_val
b = Jm / 0.00376; % Mechanical Tie Constant (J/t Nms/rad)
Tl_ = 0;          % Nm (not used)
%

gear_ratio = 1/81;
gear_alpha = 0.72;%(72%)

gain = gear_ratio;

Jeq = Jm + (1 / gear_alpha) * gear_ratio * gear_ratio * Jg;
Beq = Jeq / 0.00376;

% load materials

%bar value
Mb=0.175;   % kg
Lb=0.3;     % m
Hb=0.025;   % m

Jbar = (1/3) * Mb * (Lb^2 + (1/4) * Hb^2);
% Bbar = (Jbar*(1/gear_alpha)*gear_ratio*gear_ratio)/0.00376;

%plate value
Mp=0.34;    % kg
Rp=0.05;    % m
Lp=0.3;     % m
 
Jp = (1/2) * Mp * Rp^2 + Mp * Lp^2; % kgm^2
% Bp=(Jp*(1/gear_alpha)*gear_ratio*gear_ratio)/0.00376;
% 
% 
% % load value
% Plate = Jp+Bp;
% Bar = Jbar+Bbar;
% 
% %loaded

J_load = 0; %Jbar + Jp;        % kgm^2
B_load = 0; %J_load / 0.00376; % kgm^2

% Jlf = (1/gear_alpha)*(gear_ratio^2)*J_load; % kgm^2
% Blf = (1/gear_alpha)*(gear_ratio^2)*B_load; % kgm^2

%% global
DC_res = sim('dc_motor_');
Geared_res = sim('geared_motor_load');

%% plot
time = DC_res.angle.time;
DC_curr = DC_res.current.data;
DC_angular_vel = DC_res.angle.data;
DC_angle = cumtrapz(time, DC_res.angle.data) * 57.2598; 

time_ = Geared_res.angle.time;
Geared_current = Geared_res.current.data;
Geared_angular_vel = Geared_res.angle.data;
Geared_angle = cumtrapz(time_, Geared_angular_vel)* 57.2958; %% 라디안에서 도

%% 1. DC 모터와 Geared 모터의 전류, 각속도, 각도 비교 분석 plot
figure;

% 첫 번째 그래프: Current
subplot(3, 1, 1);
xlabel('time (s)');
ylabel('current (A)');
title('Current');
hold on;
plot(time, DC_curr, 'r--', 'LineWidth', 2);
plot(time, Geared_current, 'b-', 'LineWidth', 3);
legend('dc', 'geared', 'Location', 'best');
hold off;

% 두 번째 그래프: Angular Velocity
subplot(3, 1, 2);
xlabel('time (s)');
ylabel('angular velocity (rad/s)');
title('Angular Velocity');
hold on;
plot(time, DC_angular_vel*9.5492968, 'r--', 'LineWidth', 2);
plot(time, Geared_angular_vel*9.5492968, 'b-', 'LineWidth', 3);
legend('dc', 'geared', 'Location', 'best');
hold off;

% 세 번째 그래프: Angle
subplot(3, 1, 3);
xlabel('time (s)');
ylabel('angle (degrees)');
title('Angle');
hold on;
plot(time, DC_angle, 'r--', 'LineWidth', 2);
plot(time, Geared_angle, 'b-', 'LineWidth', 3);
legend('dc', 'geared', 'Location', 'best');
hold off;

%% 2. Geared 모터에 부하가 부착되어 있을 때 Geared 모터의 전류, 각속도, 각도 plot
figure;
subplot(3, 1, 1);
hold on;
xlabel('time (s)');
ylabel('current (A)');
title('Current (Geared Motor load)');
plot(time_, Geared_current);
hold off;

subplot(3, 1, 2);
hold on;
xlabel('time (s)');
ylabel('angular velocity (rad/s)');
title('Angular Velocity (Geared Motor load)');
plot(time_, Geared_angular_vel*9.5492968);
hold off;

subplot(3, 1, 3);
hold on;
xlabel('time (s)');
ylabel('angle (degrees)');
title('Angle (Geared Motor load)');
plot(time_, Geared_angle);
hold off;

