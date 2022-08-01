function [x0,y0,z0,Umag0,theta,phi,omgX,omgY,omgZ] = read_input(filename,kick_id)
% Extracts the initial conditions for a given soccer kick from a file
% To call, use read_input('filename', kick_id), where kick_id is between 1
% and 7

param = importdata(filename,'\t',5);

if any(param.data(:,1) == kick_id)
    row = find(param.data(:,1) == kick_id);
    x0 = param.data(row,2);
    y0 = param.data(row,3);
    z0 = param.data(row,4);
    Umag0 = param.data(row,5);
    theta = param.data(row,6);
    phi = param.data(row,7);
    omgX = param.data(row,8);
    omgY = param.data(row,9);
    omgZ = param.data(row,10);
else
    row = Nan;
    x0 = Nan;
    y0 = Nan;
    z0 = Nan;
    Umag0 = Nan;
    theta = Nan;
    phi = Nan;
    omgX = Nan;
    omgY = Nan;
    omgZ = Nan;
    disp('Warning: kick_id not found in read_input');
end

end