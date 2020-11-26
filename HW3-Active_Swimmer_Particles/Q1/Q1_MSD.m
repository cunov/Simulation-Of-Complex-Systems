clear all
cla reset
numActives = 4;
numPassives = 0;
Dt = .22;
Dr = .16;
dt = .05;
T = 20000;
T0 = 1;
rC = 1;
numSims = 100;

SD = cell(numSims,1);
for simNum = 1:numSims
    v = [0 1 2 3];
    phi = 2*pi*rand(numActives,1);
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
            dphi(n) = torque * dt + sqrt(2*Dr*dt) * normrnd(0,1);
            dx(n) = v(n) * cos(phi(n)) * dt + sqrt(2*Dt*dt) * normrnd(0,1);
            dy(n) = v(n) * sin(phi(n)) * dt + sqrt(2*Dt*dt) * normrnd(0,1);
%             dphi(n) = sqrt(2*Dr) * normrnd(0,1) + torque;
%             dx(n) = dt * ( v(n) * cos(phi(n)) + sqrt(2*Dt) * normrnd(0,1) );
%             dy(n) = dt * ( v(n) * sin(phi(n)) + sqrt(2*Dt) * normrnd(0,1) );
        end
        phi = phi + dphi;
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

    for i = 1:4
        SD{simNum} = [SD{simNum} CalculateSDVector(pos{i})];
    end
    simNum
end

MSD = zeros(4,T-1);
subplot(1,2,1)
hold on
fin = 5000;
plot(pos{1}(1:fin-1,1),pos{1}(1:fin-1,2),'r')
plot(pos{2}(1:fin-1,1),pos{2}(1:fin-1,2),'b')
plot(pos{3}(1:fin-1,1),pos{3}(1:fin-1,2),'m')
plot(pos{4}(1:fin-1,1),pos{4}(1:fin-1,2),'k')
scatter(pos{1}(fin,1),pos{1}(fin,2),'ro','filled')
scatter(pos{2}(fin,1),pos{2}(fin,2),'bo','filled')
scatter(pos{3}(fin,1),pos{3}(fin,2),'mo','filled')
scatter(pos{4}(fin,1),pos{4}(fin,2),'ko','filled')
xlabel('X')
ylabel('Y')
hold off
subplot(1,2,2)
for i = 1:4
    for t = 1 : T-1
        tmp = [];
        for simNum = 1:numSims
            tmp = [tmp SD{simNum}(t,i)];
        end
        MSD(i,t) = mean(tmp);
    end
end
xAxis = log(dt*(1:T-1));
color = {'r','b','m','k'};
hold on
for i = 1:4
    plot(xAxis,log(MSD(i,:)),color{i});
end
axis('equal')
xlabel('log(t)')
ylabel('log(MSD(t))')