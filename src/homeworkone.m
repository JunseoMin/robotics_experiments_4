%% simulink first work_space
clear all
clc

%% Basical
% result=sim('untitled');% sim('slx file name')
% 
% %plot
% x=result.simout.time; % check to workspace block
% y=result.simout.data;
% 
% plot(x,y)


%% HW
% block diagram in p.7


% select veriable careful!
Va=1;

La = 1;
Ra = 0.01;

Kt=1;
Ke=1;

Tl=0;

J=0.2;
b=0.1;
% plot

res=sim('motor_modeling');
x1=res.current.time;
y1=res.current.data;

x2=res.torque.time;
y2=res.torque.data;

plot(x1,y1)
plot(x2,y2)