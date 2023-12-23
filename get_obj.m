function weight = get_obj(x)

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
        6,9; 6,10; 3,7; 4,8; 5,9];  % elemenet's node pair
    
    Le = zeros(1,25);
    for i = 1:25
        ni = en_pair(i,1);
        nj = en_pair(i,2);
        Le(i) = norm( (node_coord(ni,:) - node_coord(nj,:)) );  % element length
    end

    A = [x(1)*ones(1,1); ...
         x(2)*ones(4,1); ...
         x(3)*ones(4,1); ...
         x(4)*ones(2,1); ...
         x(5)*ones(2,1); ...
         x(6)*ones(4,1); ...
         x(7)*ones(4,1); ...
         x(8)*ones(4,1)]';

    D = 0.1;  % density lb/in3
    weight = sum(D*A.*Le);
    
end