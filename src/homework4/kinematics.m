clear all
clc


%% Kinematics
alpha = [0 0 0];
a = [0 0.5 0.45];
d = [0 0 0];
theta = [0*pi/180 0*pi/180 0];

% transformation matrix
T01 = dhTransform(theta(1), d(1), a(1), alpha(1));
T12 = dhTransform(theta(2), d(2), a(2), alpha(2));
T23 = dhTransform(theta(3), d(3), a(3), alpha(3));

%% Calculate the end-effector transformation matrix
T03 = T01 * T12 * T23;

%% inverse kinematics
syms theta1  theta2;
theta_i = [theta1*pi/180 theta2*pi/180 0];
T_i01 = dhTransform(theta_i(1), d(1), a(1), alpha(1));
T_i12 = dhTransform(theta_i(2), d(2), a(2), alpha(2));
T_i23 = dhTransform(theta_i(3), d(3), a(3), alpha(3));

T_i03 = T_i01 * T_i12 * T_i23;

%end effector pose
x = T_i03(1,4);
y = T_i03(2,4);
z = T_i03(3,4);

x_desired;
y_desired; 
z_desired; 

T_d = [
    1, 0, 0, x_desired;
    0, 1, 0, y_desired;
    0, 0, 1, z_desired;
    0, 0, 0, 1;
];

eq1 = T_i03(1,4) == T_d(1,4);
eq2 = T_i03(2,4) == T_d(2,4);


solutions = solve([eq1, eq2], [theta1, theta2]);

theta1_solution = solutions.theta1;
theta2_solution = solutions.theta2;
%% DH transformation matrix
function T = dhTransform(theta, d, a, alpha)
    T = [
        cos(theta), -sin(theta)*cos(alpha), sin(theta)*sin(alpha), a*cos(theta);
        sin(theta), cos(theta)*cos(alpha), -cos(theta)*sin(alpha), a*sin(theta);
        0, sin(alpha), cos(alpha), d;
        0, 0, 0, 1;
    ];
end
