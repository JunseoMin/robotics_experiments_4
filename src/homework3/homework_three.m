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
Bbar = (Jbar*(1/gear_alpha)*gear_ratio*gear_ratio)/0.00376;

%plate value
Mp=0.34;    % kg
Rp=0.05;    % m
Lp=0.3;     % m
 
Jp = (1/2) * Mp * Rp^2 + Mp * Lp^2; % kgm^2

J_load = 0;%Jbar + Jp;        % kgm^2
B_load = 0;%J_load / 0.00376; % kgm^2

%% Current Control (PI)
fcc = 100;
wcc = 2 * 3.1415 * fcc;
    
% PI gain
Kp_c = La * wcc;
Ki_c = Ra * wcc;
    
% Anti-windup gain
Ka_c = 1 / Kp_c;

% Current Plot and experiment
% reference_current_values = [1, 5, 10, 25]; % A
% res Initialize
% current_response_data = cell(length(reference_current_values), 1);
% 
% % Response time initialize
% time_to_95_percent = zeros(length(reference_current_values), 1);
% 
% for i = 1:length(reference_current_values)
%     c_ref = reference_current_values(i);
% 
%     res = sim('geared_motor_load_fixed');
% 
%     current_response_data{i}.time = res.current_measure.time;
%     current_response_data{i}.current_data = res.current_measure.data;
% 
%     % response time
%     idx_95_percent = find(res.current_measure.data >= 0.95 * c_ref, 1);
%     if ~isempty(idx_95_percent)
%         time_to_95_percent(i) = res.current_measure.time(idx_95_percent);
%     else
%         time_to_95_percent(i) = NaN; % If 95% is not reached, mark as NaN
%     end
% end
% 
% %% Current plot for different reference current values
% figure;
% hold on;
% 
% for i = 1:length(reference_current_values)
%     % Plot the measured current response
%     plot(current_response_data{i}.time, current_response_data{i}.current_data, 'LineWidth', 1.5);
% 
%     % reference value
%     ref_line = ones(size(current_response_data{i}.time)) * reference_current_values(i);
%     plot(current_response_data{i}.time, ref_line, 'r--', 'LineWidth', 1);
% 
%     % Plot respons time
%     if ~isnan(time_to_95_percent(i))
%         plot([0, time_to_95_percent(i)], [0.95 * reference_current_values(i), 0.95 * reference_current_values(i)], 'g--', 'LineWidth', 1);
%     end
% end
% 
% 
% % Add labels and a legend
% xlabel('Time (s)');
% ylabel('Current (A)');
% title('Current Control Graph for Different Reference Current Values');
% legend('1A', '5A', '10A', '25A');
% 
% hold off;

%% Velocity Control (PI)
wcv=wcc/10; % 전류 제어기의 제어폭보다 충분히 작게 (1/10)

%PI gain
Kp_v=(Jeq+(J_load*0.00021))*wcv*81*Kt;
Ki_v=(Beq+(B_load*0.00021))*wcv*81/Kt;

%anti windup gain
Ka_v = 1/Kp_v;

% Velocity plot and experiment
% values
% x_velocity_measure = [];
% y_velocity_measure = [];
% 
% v_ref = 1;
% res = sim('geared_motor_load_fixed');
% 
% x_velocity_measure = res.velocity_measure.time;
% y_velocity_measure = res.velocity_measure.data;
% 
% % Velocity plot for a specific reference value (1 rad/s)
% figure;
% plot(x_velocity_measure, y_velocity_measure, 'b', 'LineWidth', 1.5);
% xlabel('Time (s)');
% ylabel('Velocity (rad/s)');
% title('Velocity Control Response for 1 rad/s Reference');
% grid on;
% 
% % reference
% ref_line = ones(size(x_velocity_measure)) * v_ref;
% hold on;
% plot(x_velocity_measure, ref_line, 'r--', 'LineWidth', 1);
% hold off;
% 
% % Analyze the response for different velocity reference values ( 1, 2, 3, 5 rad/s)
% velocity_reference_values = [1, 2, 3, 5]; % 변경할 참조 속도값을 지정합니다.
% 
% figure;
% hold on;
% 
% for i = 1:length(velocity_reference_values)
%     v_ref = velocity_reference_values(i);
% 
%     res = sim('geared_motor_load_fixed');
% 
%     x_velocity_measure = res.velocity_measure.time;
%     y_velocity_measure = res.velocity_measure.data;
% 
%     plot(x_velocity_measure, y_velocity_measure, 'LineWidth', 1.5);
% 
%     ref_line = ones(size(x_velocity_measure)) * v_ref;
%     plot(x_velocity_measure, ref_line, 'r--', 'LineWidth', 1);
% end
% 
% xlabel('Time (s)');
% ylabel('Velocity (rad/s)');
% title('Velocity Control Response for Different Velocity Reference');
% legend('1V','1V','2V','2V','3V','3V','5V','5V', 'Reference');
% grid on;
% 
% hold off;

%% Angle control (PD)
wcp=wcv/10; %속도 제이기의 제어폭 / 10

%PD gain
Kp_p=wcp;
Kd_p=wcp/wcv;

% Angle plot and experiment
% values
x_angle_measure = [];
y_angle_measure = [];

angle_ref = 1;
res = sim('geared_motor_load_fixed');

x_angle_measure = res.angle_measure.time;
y_angle_measure = res.angle_measure.data;

% Velocity plot for a specific reference value (1 [degree])
figure;
plot(x_angle_measure, y_angle_measure, 'b', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Angle (degree)');
title('Angle Control Graph');
grid on;

% reference
ref_line = ones(size(x_angle_measure)) * angle_ref;
hold on;
plot(x_angle_measure, ref_line, 'r--', 'LineWidth', 1);
hold off;

% Analyze the response for different angle reference values ( 10, 45, 90 [degree])
Angle_reference_values= [10, 45, 90]; 

figure;
hold on;

for i = 1:length(Angle_reference_values)
    angle_ref = Angle_reference_values(i);

    res = sim('geared_motor_load_fixed');

    x_angle_measure = res.angle_measure.time;
    y_angle_measure = res.angle_measure.data;

    plot(x_angle_measure, y_angle_measure, 'LineWidth', 1.5);

    ref_line = ones(size(x_angle_measure)) * angle_ref;
    plot(x_angle_measure, ref_line, 'r--', 'LineWidth', 1);
end

xlabel('Time (s)');
ylabel('Angle (degree)');
title('Angle Control Response');
legend('10','10','45','45','90','90', 'Reference');
grid on;

hold off;