% -- 25-bar truss optimization
% -- Units: in-lb-s-lbf-psi

clear
close
clc

x0 = 1.0*ones(1,8);
lb = 0.1*ones(1,8);
ub = 5.0*ones(1,8);
options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'active-set');

[x, fval, exitflag] = fmincon('get_obj', x0, [], [], [], [], lb, ub, 'get_cns', options);

% MCS
mux = x; % you should change to the optimal design you obtained
muE = 1e7;
stdx= 0.0052.*ones(1, length(x)); % you should change this value according to the homework descriptions
stdE = 1e6;
covE = stdE.^2;
covX=zeros(length(x));
for i = 1:length(x)
    for j = 1:length(x)
        if i==j
            covX(i, j) = stdx(i).^2;
        end
    end
end

% Basic MCS

N=1e6; % you should change this value according to the homework descriptions
N1 = 1;

for j = 1:N1

    RandX=mvnrnd(mux, covX, N);
    RandE=mvnrnd(muE, covE, N);
    
    Y=zeros(N,27); % you should change Y to constraints, therefore you have three different function evaluations
    for i = 1:N
        temp = get_cns_q2(RandX(i,:), RandE(i));
        [Y(i,:)] = temp;

        w(i) = get_obj(RandX(i,:));
    end
    
    for i = 1:27
        Nf(i,j)=sum(Y(:,i)>0); % you should have three Nf values w.r.t different constraints
        pf(i,j)=Nf(i,j)./N; % you should have three pf values w.r.t different constraints
        % sprintf('Failure probability using MCS with %d samples is %0.5g percent ', N, pf(i)*100)
    end
end

figure()
for i = 1:27
    plot(pf(i,:), 'o-')
    hold on;
end

hold off;
axis padded;
xlabel('[i]th times MCS')
ylabel('pf')
ylim([0 1]);
xticks(1:1:N1)
title('MCS with N = 1000000')

figure()
for i = 26:27
    plot(pf(i,:), 'o-')
    hold on;
    text(1.1,pf(i,:),num2str(pf(i,1)))
end

axis padded;
xlabel('[i]th times MCS')
ylabel('pf')
ylim([0 1]);
xticks(1:1:N1);
legend('pf violating constraint of displacement of joint1', 'pf violating constraint of displacement of joint 2')
title('MCS with N = 1000000')

figure()
plot(w, '.')
xlabel("sample point in MCS");
ylabel("weight");

figure()
hist(w);
title("histogram of weight in MCS with N = 1000000")
xlabel("weight")

fileID = fopen('w.txt','w');
fprintf(fileID,'%d\n',w);
fclose(fileID);