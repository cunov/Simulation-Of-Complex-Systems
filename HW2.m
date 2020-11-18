clear all
cla reset
p = 0.01;
f = .1;
treeDistribution = 0;
T = 500;
N = 128;


forest = rand(N,N) < treeDistribution;
fireSizes = [];

numStrikes = 0;

while numStrikes < T
    strike = false;
    if rand < f
        strike = true;
    end
    for i = 1:N
        for j = 1:N
            if forest(i,j) == 0 && rand < p
                forest(i,j) = 1;
            end
        end
    end
    if strike == true
        toPropagate = [randi([1 N]) randi([1 N])];
        fireSize = 0;
        while ~isempty(toPropagate)
            [forest, toPropagate, fireSize] = Propagate(forest,toPropagate,fireSize);
        end
        if fireSize ~= 0
            numStrikes = numStrikes + 1;
            fireSizes = [fireSizes fireSize];
            if mod(numStrikes,100) == 0
                disp(numStrikes);
            end
        end
    end
end
n = length(fireSizes);
y = (1:n)./n;

subplot(1,2,1)
sortedFireSizes = sort(fireSizes,'descend');
relativeFireSizes = sortedFireSizes ./ (N*N);
loglog(relativeFireSizes,y,'b.')

hold on
iX = relativeFireSizes < 0.2;
X = relativeFireSizes(iX);
Y = y(iX);
c = polyfit(log10(X),log10(Y),1);
m = c(1);
b = c(2);

YBF = (10^b).*relativeFireSizes.^m;
loglog(relativeFireSizes,YBF,'b--','LineWidth',1);

legend('Simulation',strcat('Simulation LoBF, y = (10\^',num2str(b),') * (x\^',num2str(m),')'),'Location','Best')
xlabel('Relative fire size')
ylabel('cCDF')
title(strcat('p = ',num2str(p),'   f = ',num2str(f)))
hold off


subplot(1,2,2)
loglog(relativeFireSizes,y,'b.')
hold on
x_min = min(relativeFireSizes)*(N*N);
r = rand(1,T);
tau = 1-m;
A1 = 1-r;
A2 = power(A1,(-1/(tau-1)));
Xsyn=x_min*A2;
XsynNorm = sort(Xsyn)/(N*N);
Ysyn = linspace(0,1,T);
Ysyn = sort(Ysyn,'descend');

loglog(XynNorm,Ysyn,'r-')
legend('Simulation',strcat('Power Law (tau=',num2str(tau),')'),'Location','Best');
xlim([10^-4.2,10])
title(strcat('p = ',num2str(p),'   f = ',num2str(f)))
