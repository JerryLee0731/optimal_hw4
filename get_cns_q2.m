function [c, ceq] = get_cns_q2(x, E)

[Q, stress] = get_model_result_q2(x, E);

allow_stress = 40000;  % psi
allow_disp = 0.35;  % inch

c(1:25) = abs(stress)/allow_stress - 1.0;

disp = zeros(1,2);
for i = 1:2  % node 1, 2
    disp(i) = sqrt(Q(3*i-2)^2 + Q(3*i-1)^2 + Q(3*i)^2);
end

c = [c, disp./allow_disp - 1.0];
ceq = [];
