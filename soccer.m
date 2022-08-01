function [T,X,Y,Z,U,V,W] = soccer(x0,y0,z0,Umag0,theta,phi,omgX,omgY,omgZ)
% Creates the Time, 3 position and 3 velocity row vectors for a given kick.
% Stops function if it runs into a defender
% To call, use soccer(x0,y0,z0,Umag0,theta,phi,omgX,omgY,omgZ) with initial
% values

global m r A rho g Cd Cm goal

n=1;
dt=1/1000;
U(n) = Umag0*cosd(theta)*sind(phi);
V(n) = Umag0*sind(theta)*sind(phi);
W(n) = Umag0*cosd(phi);
T(n) = 0;
X(n) = x0;
Y(n) = y0;
Z(n) = z0;

loop_conditions = true;
while loop_conditions
    U(n+1) = U(n)-(Cd*rho*A/(2*m)*U(n)*sqrt(U(n)^2+V(n)^2+W(n)^2)+Cm*rho*A*r/(2*m)*(omgY*W(n)-omgZ*V(n)))*dt;
    V(n+1) = V(n)-(Cd*rho*A/(2*m)*V(n)*sqrt(U(n)^2+V(n)^2+W(n)^2)+Cm*rho*A*r/(2*m)*(omgZ*U(n)-omgX*W(n)))*dt;
    W(n+1) = W(n)-(Cd*rho*A/(2*m)*W(n)*sqrt(U(n)^2+V(n)^2+W(n)^2)+Cm*rho*A*r/(2*m)*(omgX*V(n)-omgY*U(n))+g)*dt;
    X(n+1) = X(n) + U(n+1)*dt;
    Y(n+1) = Y(n) + V(n+1)*dt;
    Z(n+1) = Z(n) + W(n+1)*dt;
    T(n+1) = T(n)+dt;
    n=n+1;
    loop_conditions = conditions_test(T(n),X(n),Y(n),Z(n));
end

U(end) = [];
V(end) = [];
W(end) = [];
X(end) = [];
Y(end) = [];
Z(end) = [];
T(end) = [];

function distance = get_dist(T,X,Y,Z)
    for d_num = 1:5
        [Dx, Dy, Dz] = defender(d_num,T);
        [l, w] = size(Dx);
        omega = l*w;
        for q = 1:omega
            dist(q) = sqrt((X-Dx(q)).^2+(Y-Dy(q)).^2+(Z-Dz(q)).^2);
        end
        distance(d_num) = min(min(dist));
    end
    distance = min(distance);
end
    
function loop_conditions = conditions_test(T,X,Y,Z)
    dist = get_dist(T,X,Y,Z);
    def_test = logical(dist>r);
    X_test = logical(((X-r)>-45) && ((X+r)<45));
    Y_test = logical(((Y-r)>0) && ((Y+r)<60));
    Z_test = logical((Z-r)>0);
    bound_test = (X_test & Y_test & Z_test);
    goal_test = logical(((X-r)>-3.66) && ((X+r)<3.66) && ((Z+r)<2.44));
    if goal_test
        goal = true;
    end
    if goal
        bound_test = true;
        if ~Z_test
            bound_test = false;
        end
    end
    loop_conditions = (def_test && bound_test);
end

end