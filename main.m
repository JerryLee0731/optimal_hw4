% -- 25-bar truss optimization
% -- Units: in-lb-s-lbf-psi

clear
close all;
clc

x0 = 1.0*ones(1,8);
lb = 0.1*ones(1,8);
ub = 5.0*ones(1,8);
options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'active-set');

[x, fval, exitflag] = fmincon('get_obj', x0, [], [], [], [], lb, ub, 'get_cns', options);

find_active_constraint = get_cns(x)

figure()
plot(find_active_constraint, 'o')
xlabel("constraint[i]");
ylabel("value");
title("Each constraint value at optima")
xticks(1:1:27);
axis padded
