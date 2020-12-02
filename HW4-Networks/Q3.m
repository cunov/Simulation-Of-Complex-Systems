clear all
N = 5;
m = 2;
p = .1;
timeSteps = 500;
gamma = 3;

noIsolated = false;
while noIsolated == false
    G = ErdosRenyi(N,.5);
    bins = conncomp(G);
    valFreq = tabulate(bins);
    noIsolated = sum(valFreq(:,2)>1) >= length(valFreq(:,2));
end

for t = 1:timeSteps
    numNodes = numnodes(G);
    G = addnode(G,num2str(numNodes+1));
    for i = 1:m
        edgeEnds = str2double(G.Edges{:,1}(:));
        numEnds = length(edgeEnds);
        randEdgeIndex = randi([1 numEnds]);
        randEdge = edgeEnds(randEdgeIndex);
        G = addedge(G,randEdge,numNodes+1,1);
    end
end
subplot(1,2,1)
plot(G)
title(strcat('Initial Graph: N0 = ',num2str(N),' --  m = ',num2str(m),',  TimeSteps = ',num2str(timeSteps)))

data = degree(G);
% data = sort(data,'ascend');
% tab = tabulate(data);
% iGood = tab(:,2) ~= 0;
% k = tab(iGood,1);
% y = tab(iGood,3)/100;
% y = sum(y(:)) - cumsum(y);


k = sort(data,'descend');
y = (1:length(k))/length(k);

subplot(1,2,2)
loglog(k,y,'.')
hold on
theorY = 2*m^2 * k .^(-gamma+1);

loglog(k,theorY)
hold off
legend('Data','Theoretical')
text(7,5,strcat('P(k) ~ 2 * (',num2str(m),'^2) * k\^',num2str(-gamma+1)))