%% simulink work_space
clear all
clc

%% HW(torque)
% block diagram in p.7
Va = 48;       % V

La = 0.000658;     % H (dataseet * 1/1000)
Ra = 1.76;  % Ohm

Kt=0.0683;       % Nm/A (dataseet * 1/1000)
Ke=0.0683;       % Nm/A (dataseet * 1/1000)

Tl=[0,0.5,1];       % Nm 

J=0.00000995;      % kgm^2 (dataseet * 1/10000000)
b=0.00000995/0.00376;      % Mechanical Tie Constant (J/t Nms/rad)

angle_res = cell(length(Tl), 1);
anglevel_res = cell(length(Tl),1);
% plot
for i = 1: length(Tl)
    Tl_=Tl(i);

    res=sim('moterhomework');
    
    time_=res.torque.time;
    angle_vel=res.torque.data;

    angle = cumtrapz(time_,angle_vel)*57.2958;
    
    anglevel_res{i} = {time_,angle_vel};
    angle_res{i} = {time_,angle};
end

figure;
hold on;
xlabel('time (s)');
ylabel('rad/s');

%for i = 1:length(Tl)
%    plot(angle_res{i}{1},angle_res{i}{2})
%end

for i = 1:length(Tl)
    plot(anglevel_res{i}{1},anglevel_res{i}{2})
end

title('Angular Velocity');
legend('Load Torque = 0','Load Torque = 0.5','Load Torque = 1','Location', 'best');
grid on;

%% HW(input volt)
% block diagram in p.7
Va = [5,12,24,48];       % V

La = 0.000658;     % H (dataseet * 1/1000)
Ra = 1.76;  % Ohm

Kt=0.0683;       % Nm/A (dataseet * 1/1000)
Ke=0.0683;       % Nm/A (dataseet * 1/1000)

Tl=0;       % Nm 

J=0.00000995;      % kgm^2 (dataseet * 1/10000000)
b=0.00000995/0.00376;      % Mechanical Tie Constant (J/t Nms/rad)

angle_res = cell(length(Va), 1);
anglevel_res = cell(length(Va),1);
% plot
for i = 1: length(Va)
    Va_=Va(i);

    res=sim('moterhomework');
    
    time_=res.torque.time;
    angle_vel=res.torque.data;

    angle = cumtrapz(time_,angle_vel)*57.2958;
    
    anglevel_res{i} = {time_,angle_vel};
    angle_res{i} = {time_,angle};
end

figure;
hold on;
xlabel('time (s)');
ylabel('rad/s');

%for i = 1:length(Va)
%    plot(angle_res{i}{1},angle_res{i}{2})
%end

for i = 1:length(Va)
    plot(anglevel_res{i}{1},anglevel_res{i}{2})
end

title('Angular Velocity');
legend('Load Torque = 0','Load Torque = 0.5','Load Torque = 1','Location', 'best');
grid on;
