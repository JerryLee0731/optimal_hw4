function [Q, stress] = get_model_result(x)

    E = 1e7;  % young's modulus
    
    node_coord(1,:) = [-37.5, 0, 200];
    node_coord(2,:) = [37.5, 0, 200];
    node_coord(3,:) = [-37.5, 37.5, 100];
    node_coord(4,:) = [37.5, 37.5, 100];
    node_coord(5,:) = [37.5, -37.5, 100];
    node_coord(6,:) = [-37.5,-37.5,100];
    node_coord(7,:) = [-100, 100, 0];
    node_coord(8,:) = [100, 100, 0];
    node_coord(9,:) = [100, -100, 0];
    node_coord(10,:) = [-100, -100, 0];  % node coord.
    
    en_pair = [ ...
        1,2; 1,4; 2,3; 1,5; 2,6; ...
        2,4; 2,5; 1,3; 1,6; 3,6; ...
        4,5; 3,4; 5,6; 3,10; 6,7; ...
        4,9; 5,8; 4,7; 3,8; 5,10; ...
        6,9; 6,10; 3,7; 4,8; 5,9];  % elemenet node pair

    A = [x(1)*ones(1,1); ...
         x(2)*ones(4,1); ...
         x(3)*ones(4,1); ...
         x(4)*ones(2,1); ...
         x(5)*ones(2,1); ...
         x(6)*ones(4,1); ...
         x(7)*ones(4,1); ...
         x(8)*ones(4,1)]';  % element section area

    F = zeros(18,1);
    F(1) = 1;
    F(2) = -10;
    F(3) = -10;
    F(4) = 0;
    F(5) = -10;
    F(6) = -10;
    F(7) = 0.5;
    F(8) = 0;
    F(9) = 0;
    F(16) = 0.6;
    F(17) = 0;
    F(18) = 0;
    F = F*1e3;

    % -- stiffness matrixs
    for i = 1:25
        ni = en_pair(i,1);
        nj = en_pair(i,2);
        Le(i) = norm( (node_coord(ni,:) - node_coord(nj,:)) );
        cx(i) = (node_coord(ni,1) - node_coord(nj,1)) / Le(i); % x
        cy(i) = (node_coord(ni,2) - node_coord(nj,2)) / Le(i); % y
        cz(i) = (node_coord(ni,3) - node_coord(nj,3)) / Le(i); % z
    end

    K = zeros(30,30);  % stiffness matrix
    for i = 1:25
        ni = en_pair(i,1);
        nj = en_pair(i,2);
        sk = [cx(i), cy(i), cz(i)]'*[cx(i), cy(i), cz(i)];
        tmp = zeros(30,30);
        tmp(3*ni-2:3*ni, 3*ni-2:3*ni) =  sk;
        tmp(3*nj-2:3*nj, 3*nj-2:3*nj) =  sk;
        tmp(3*ni-2:3*ni, 3*nj-2:3*nj) = -sk;
        tmp(3*nj-2:3*nj, 3*ni-2:3*ni) = -sk;
        K = K + E*A(i)/Le(i)*tmp;
    end

    Kr = K(1:18,1:18);  % Reduce matrix of K

    % -- displacement
    Qr = Kr^-1*F;
    Q = [Qr; zeros(12,1)];

    % -- stress
    stress = zeros(1,25);
    for i = 1:25
        ni = en_pair(i,1);
        nj = en_pair(i,2);
        stress(1,i) = ...
            E/Le(i)* ...
            [-1*cx(i), -1*cy(i), -1*cz(i), cx(i), cy(i), cz(i)]* ...
            [Q(ni*3-2); Q(ni*3-1); Q(ni*3); Q(nj*3-2); Q(nj*3-1); Q(nj*3)];
    end
end
