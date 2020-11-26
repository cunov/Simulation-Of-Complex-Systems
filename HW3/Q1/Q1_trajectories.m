clear all
cla reset
numActives = 4;
numPassives = 0;
Dt = .22;
Dr = .16;
dt = .01;
T = 5000;
T0 = 1;
rC = 1;

v = [1 0 2 3];
phi = 2*pi*rand(numActives,1);
% phi = zeros(numActives,1);
xy0 = 50 * ([[-1 1];[1 1];[-1 -1];[1 -1]]);
xy = cell(numActives,T);
xy{1} = xy0;

passiveXY={};
dx = zeros(numActives,1);
dy = zeros(numActives,1);
dphi = zeros(numActives,1);

activeParticles = 1:numActives;
activeXYpast = xy{1};
for t = 1:T
    activeXYcurr = xy{t};
    for n = activeParticles
        torque = CalculateTorque(activeXYcurr,activeXYpast,passiveXY,n,T0,rC);
        dphi = sqrt(2*Dr) * normrnd(0,1) + torque;
        phi(n) = phi(n) + dt * dphi;
        dx(n) = dt * (v(n) * cos(phi(n)) + sqrt(2*Dt) * normrnd(0,1) );
        dy(n) = dt * (v(n) * sin(phi(n)) + sqrt(2*Dt) * normrnd(0,1) );
    end
    activeXYpast = activeXYcurr;
    activeXYcurr = activeXYcurr + [dx dy];
    xy{t+1} = activeXYcurr;
end

pos = cell(4,1);
for t = 1:T
    for i = 1:4
        pos{i} = [pos{i}; xy{t}(i,:)];
    end
end
subplot(1,2,1)
hold on
plot(pos{1}(1:end-1,1),pos{1}(1:end-1,2),'r')
plot(pos{2}(1:end-1,1),pos{2}(1:end-1,2),'b')
plot(pos{3}(1:end-1,1),pos{3}(1:end-1,2),'m')
plot(pos{4}(1:end-1,1),pos{4}(1:end-1,2),'k')
scatter(pos{1}(end,1),pos{1}(end,2),'ro','filled')
scatter(pos{2}(end,1),pos{2}(end,2),'bo','filled')
scatter(pos{3}(end,1),pos{3}(end,2),'mo','filled')
scatter(pos{4}(end,1),pos{4}(end,2),'ko','filled')
xlabel('X')
ylabel('Y')
hold off