clear all
A = LoadSmallWorldExample();
G = graph(A);
% G = ErdosRenyi(10,.3);
% A = adjacency(G);
plot(G)
shortestPaths = A;
idx = (shortestPaths == 0);
numZeros = sum(idx(:));
i = 2;
while numZeros ~= 0
    tmp = (A^i) ~= 0;
    shortestPaths = shortestPaths + i * (tmp .* (shortestPaths == 0));
    i = i + 1;
    idx = (shortestPaths == 0);
    numZeros = sum(idx(:));
end
tmpShortestPaths = shortestPaths - diag(diag((shortestPaths)));
numNodes = size(A,1);
avgPath = sum(tmpShortestPaths(:)) / (numNodes * (numNodes - 1))
diameter = max(shortestPaths(:))