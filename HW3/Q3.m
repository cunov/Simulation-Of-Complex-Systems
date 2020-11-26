clear all

modelChoice = 0;

if modelChoice == 0
    numTrailsToPlot = 100000;
    particleDiameter = 1;
    numActives = 20;
    numPassives = 500;
    environmentSize = 20;
    T = 100000;
    rC = particleDiameter * 3.5;
    dt = 0.001;
    T0 = 5;
    k = physconst('Boltzmann');                     % J/K
    temp = 300;                                     % K
    eta = .001;                                     % Ns/m^2
    gamma = 6 * pi * (particleDiameter/2) * eta;    % Ns/m
    Dt = k * temp / gamma;                          % m^2/s
    Dr = 6 * Dt / (8*(particleDiameter/2)^3);       % rad^2/s
    v = 5*ones(numActives,1);                      % 1e-5 m/s
else
    numActives = 20;
    numPassives = 100;
    environmentSize = 10;                               % 1e-6 m
    particleDiameter = 1;                               % 1e-6 m
    T = 100000;
    T0 = 1;
    rC = 2;                                             % 1e-6 m
    dt = .001;                                          % s
    v = .05*ones(numActives,1);                     
    Dt = .22;
    Dr = .16;
    eta = .1;
    numTrailsToPlot = 0;
end


theta = 2*pi*rand(numActives,1);
xy = cell(numActives,T);
xy{1} = -environmentSize + 2 * environmentSize * rand(numActives,2);
passiveXY = cell(numPassives,T);
passiveXY{1} = GeneratePassiveXY(numPassives,environmentSize,particleDiameter);

torque = zeros(numActives,1);
dx = zeros(numActives,1);
dy = zeros(numActives,1);
dtheta = zeros(numActives,1);
activeParticles = 1:numActives;
markerWidth = 1;
writerObj = VideoWriter('myVideo.avi');
writerObj.FrameRate = 50;
open(writerObj);
for t = 1:T
    for n = activeParticles
        torque(n) = CalculateTorque(xy{t},theta(n),passiveXY{t},n,T0,rC);
    end
    if modelChoice == 0
        dtheta = dt * torque + sqrt(2*Dr*dt) * randn(numActives,1);
        dx = dt * v .* cos(theta) + sqrt(2*Dt*dt) * randn(numActives,1);
        dy = dt * v .* sin(theta) + sqrt(2*Dt*dt) * randn(numActives,1);
    else
        dtheta = torque - eta/2 + 2*eta*rand(numActives,1)/2;
        dtheta = dt * dtheta;
        dx = dt * v .* cos(theta);
        dy = dt * v .* sin(theta);
    end
    if mod(t,50) == 0 || t == 1
        if numTrailsToPlot > 0
            if t < numTrailsToPlot
                lastTs = 1:t;
            else
                lastTs = (t-numTrailsToPlot+1):t;
            end
            posX = zeros(length(lastTs)*numActives,1);
            posY = posX;
            k = 1;
            for iT=1:length(lastTs)
                for j=activeParticles
                    posX(k) = xy{lastTs(iT)}(j,1);
                    posY(k) = xy{lastTs(iT)}(j,2);
                    k = k + 1;
                end
            end
            y = scatter(posX,posY,2,'b','filled','MarkerFaceAlpha',.002);
            hold on
            scat = [[xy{t}(:,1) xy{t}(:,2)]; [passiveXY{t}(:,1) passiveXY{t}(:,2)]];
            colors = [repmat([1 0 0],numActives,1); repmat(.5,numPassives,3)];
            h = scatter(scat(:,1),scat(:,2),1,colors,'filled');
            hold off
            set(gcf,'position',[200 500 900 800])
            set(h, 'SizeData', markerWidth^2)
            xlim([-environmentSize environmentSize])
            ylim([-environmentSize environmentSize])
            title(strcat('t=',num2str(t*dt),'s','   Timestep=',num2str(t)))
        else
            iBlues = GetClusteredIndices(xy{t},particleDiameter);
            iGrays = numActives:(numActives+numPassives);
            colors = [repmat([1 0 0],numActives,1); repmat(.5,numPassives,3)];
            colors(iBlues,:) = repmat([0 0 1],length(iBlues),1);
            allXY = [[xy{t}(:,1) xy{t}(:,2)]; [passiveXY]];
            h = scatter(allXY(:,1),allXY(:,2),1,colors,'filled');
            set(gcf,'position',[200 500 900 800])
            set(h, 'SizeData', markerWidth^2)
            xlim([-environmentSize environmentSize])
            ylim([-environmentSize environmentSize])
            title(strcat('t=',num2str(t*dt),'s','   Timestep=',num2str(t)))
        end
        if t == 1
            currentunits = get(gca,'Units');
            set(gca, 'Units', 'Points');
            axpos = get(gca,'Position');
            set(gca, 'Units', currentunits);
            markerWidth = particleDiameter/diff(xlim)*axpos(3);
        end
        frame = getframe(gcf);
        writeVideo(writerObj,frame);
    end
    
    if mod(t,T/100) == 0
        disp(strcat(num2str(100*round(t/T,2)),'%'));
    end
    [xy{t+1} passiveXY{t+1}] = UpdateXY(xy{t},passiveXY{t},dx,dy,environmentSize,particleDiameter);
    theta = theta + dtheta;
end
close(writerObj);