clear all
cla reset
p = 0.01;
f = .1;
treeDistribution = 0;
T = 500;
N = 128;

m = [];
k=1;
for N=[8 16 32 64 128 256 512]
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
    sortedFireSizes = sort(fireSizes,'descend');
    relativeFireSizes = sortedFireSizes ./ (N*N);
    cellRFS{k} = [relativeFireSizes' y'];
%     loglog(relativeFireSizes,y,'b.')
%     iX = relativeFireSizes < 0.2;
%     X = relativeFireSizes(iX);
%     Y = y(iX);
%     c = polyfit(log10(X),log10(Y),1);
%     m = [m c(1)];
    k=k+1;
end

t=[.37 .3 .288 .268 .256 .2 .2];
m=[];
for k=1:7
    subplot(4,3,k)
    loglog(cellRFS{k}(:,1),cellRFS{k}(:,2),'b.')
end
for k = 1:7
    n = size(cellRFS{k},1);
    iX = cellRFS{k}(:,1) < .7;
    X = cellRFS{k}(iX,1);
    y = (1:n)/n;
    Y = y(iX);
    c = polyfit(log10(X),log10(Y),1);
    m = [m 1-c(1)];
end
x = 1 ./ [8 16 32 64 128 256 512];
scatter(x,m,'bo')
xlim([0 .15])
ylim([1 2])

